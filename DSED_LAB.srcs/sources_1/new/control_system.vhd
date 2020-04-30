----------------------------------------------------------------------------------
-- Company: 
-- Engineer: CARLOS GÓMEZ and ALEJANDRO RAMOS
-- 
-- Create Date: 17.01.2020 12:34:18
-- Design Name: 
-- Module Name: control_system - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.package_dsed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity control_system is
    Port ( clk_12MHz : in STD_LOGIC;
           reset : in STD_LOGIC;
           
           SW0 : in STD_LOGIC;
           SW1 : in STD_LOGIC;
           
           BTNL : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNR : in STD_LOGIC;
                      
           play_en : out STD_LOGIC;
           record_en : out STD_LOGIC;
           
           --FILTER         
           filter_select      : out STD_LOGIC;
           filter_in          : out signed (sample_size-1 downto 0);
           filter_In_enable   : out STD_LOGIC;
           filter_out         : in signed (sample_size-1 downto 0);          
           --filter_Out_ready   : in STD_LOGIC;
           
           --RAM
           ADDR : out STD_LOGIC_VECTOR(18 DOWNTO 0);
           DATA_IN : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           DATA_OUT : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           reset_RAM : out STD_LOGIC;
           EN_RAM : out STD_LOGIC;
           ENW_RAM : out STD_LOGIC_VECTOR(0 downto 0);
           
           --PWM
           sample_in: out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_request: in STD_LOGIC;
           
           --FSMD
           sample_out: in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready: in STD_LOGIC;
           
           --LEDS
           led_record : out STD_LOGIC;
           led_play : out STD_LOGIC;
           
           --DISPLAY
           seconds_left : out UNSIGNED (4 downto 0));
end control_system;

architecture Behavioral of control_system is


constant IDLE : unsigned(2 downto 0) := "000";
constant RECORDING : unsigned(2 downto 0) := "001";
constant CLEAR : unsigned(2 downto 0) := "010";
constant PLAY : unsigned(2 downto 0) := "011";
constant PLAY_REVERSE : unsigned(2 downto 0) := "100";
constant PLAY_LPF : unsigned(2 downto 0) := "101";
constant PLAY_HPF : unsigned(2 downto 0) := "110";

-- HAY QUE INICIALIZAR
constant MAX_DIR : unsigned (18 downto 0) := (others =>'1');
signal state, next_state : unsigned(2 downto 0) := IDLE;

--RAM
signal aux_ADDR, last_ADDR : STD_LOGIC_VECTOR(18 DOWNTO 0) := (others => '0');
signal aux_DATA_IN, last_DATA_IN: STD_LOGIC_VECTOR (sample_size-1 downto 0) := (others => '0');
           
signal aux_reset_RAM : STD_LOGIC :='0';
signal aux_EN_RAM : STD_LOGIC :='0';
signal aux_ENW_RAM : STD_LOGIC_VECTOR(0 downto 0) := (others => '0');

--PWM
signal aux_sample_in, last_sample_in:  STD_LOGIC_VECTOR (sample_size-1 downto 0) := (others => '0');


signal aux_play_en, aux_record_en : STD_LOGIC :='0';


signal aux_filter_select : STD_LOGIC :='0';
signal aux_record_ADDR, aux_play_ADDR, aux_play_reverse_ADDR : unsigned(18 downto 0) := (others => '0');
signal next_record_ADDR, next_play_ADDR, next_play_reverse_ADDR : unsigned(18 downto 0) := (others => '0'); 


signal aux_filter_out, aux_filter_out_STD : std_logic_vector(sample_size-1 downto 0) := (others => '0');
signal aux_filter_in, filter_in_SIGNED, last_filter_in : std_logic_vector(sample_size-1 downto 0) := (others => '0');
signal start_play ,next_start_play  : STD_LOGIC :='0';
signal aux_filter_In_enable : STD_logic := '0';

signal samples_left : unsigned (18 downto 0) := (others => '0');
signal aux_seconds_left : unsigned (50 downto 0) := (others => '0');

signal count_tone_250us, next_count_tone_250us : unsigned (4 downto 0) := (others => '0');
signal count_tone_constant, next_count_tone_constant : unsigned (5 downto 0) := (others => '0');

begin



-- lógica de cambio de estado
process (clk_12MHz, reset)
begin

if (reset = '1') then
    state <= CLEAR;
    aux_play_ADDR <= (others=>'0');
    aux_record_ADDR <= (others=>'0');
    last_ADDR <= (others=>'0');
    last_DATA_IN <= (others=>'0');
    last_sample_in <= (others=>'0');
    aux_play_reverse_ADDR <= (others=>'0'); 
    start_play <= '0'; 
    last_filter_in <= (others=> '0');
    count_tone_250us <= (others => '0');
    count_tone_constant <= (others => '0');
elsif (clk_12MHz'event and clk_12MHz = SAMPLE_CLK_EDGE) then
    state <= next_state;
    aux_play_ADDR <= next_play_ADDR;
    aux_record_ADDR <= next_record_ADDR;
    last_ADDR <= aux_ADDR;
    last_DATA_IN <= aux_DATA_IN;
    last_sample_in <= aux_sample_in;
    aux_play_reverse_ADDR <= next_play_reverse_ADDR;
    start_play <= next_start_play;
    last_filter_in <= aux_filter_in;
    count_tone_250us <= next_count_tone_250us;
    count_tone_constant <= next_count_tone_constant;
end if;

end process;

-- lógica de estado siguiente
process(state,BTNC, BTNL, BTNR, SW0, SW1, aux_record_ADDR, aux_play_reverse_ADDR,last_sample_in,last_filter_in, sample_out_ready, sample_out, aux_play_ADDR, sample_request, DATA_OUT,start_play,last_ADDR,last_DATA_IN,aux_filter_out,count_tone_250us,count_tone_constant)

begin
samples_left <= (others => '0');
aux_play_en <= '0';
aux_record_en <= '0';
aux_reset_RAM <= '0';

next_state <= state;
next_play_ADDR <= aux_play_ADDR;
next_record_ADDR <= aux_record_ADDR;
next_play_reverse_ADDR <= aux_play_reverse_ADDR;

aux_EN_RAM <= '0';
aux_ENW_RAM <= "0";
aux_ADDR <= last_ADDR;
aux_DATA_IN <= last_DATA_IN;

aux_sample_in <= last_sample_in;
led_record <= '0';
led_play <= '0';
next_start_play <= '0';

--FILTER
aux_filter_select <= '0';
aux_filter_In_enable <= '0';
aux_filter_in <= last_filter_in;

-- TONE OUTPUT WHEN RECORDING
next_count_tone_250us <= count_tone_250us;
next_count_tone_constant <= count_tone_constant;

case(state) is
    when IDLE =>
        aux_play_en <= '0';
        aux_record_en <= '0';
        aux_reset_RAM <= '0';        
        next_play_ADDR <= (others => '0');
        next_play_reverse_ADDR <= aux_record_ADDR;
        if (BTNC = '1' ) then
            next_state <= CLEAR;
        elsif (BTNL = '1') then
            next_state <= RECORDING;
        elsif (BTNR = '1') then
            next_start_play <= '1';
            if (SW0 = '0' and SW1 = '0') then
                next_state <= PLAY;
            elsif (SW0 = '1' and SW1 = '0') then
                next_state <= PLAY_REVERSE;
            elsif (SW0 = '0' and SW1 = '1') then
                next_state <= PLAY_LPF;
            else
                next_state <= PLAY_HPF;    
            end if;
        else
            next_state <= IDLE;
        end if;
        
    when CLEAR =>
        next_state <= IDLE;
        aux_reset_RAM <= '1';
        next_record_ADDR <= (others => '0');
        next_play_ADDR <= (others => '0');
        next_play_reverse_ADDR <= (others => '0');
        next_count_tone_250us <= (others => '0');
        
    when RECORDING =>
        aux_record_en <= '1';
        led_record <= '1';
        aux_EN_RAM <= '1';
        aux_ENW_RAM <= "1";
        samples_left <= MAX_DIR - aux_record_ADDR;
        if (BTNL = '1')then 
            next_state <= RECORDING;
            if (samples_left <= 60000 and count_tone_250us < 5) then
                aux_play_en <= '1';
                aux_sample_in <= x"3F"; -- pitido continuo: 1/4 del periodo a 1 (63/255)
                if (sample_request = '1') then
                    next_count_tone_250us <= count_tone_250us + 1;
                end if;
            else
                aux_sample_in <= x"00"; -- tiempo de pitido excedido: tras 250 us
            end if;
            
            if(aux_record_ADDR = MAX_DIR) then
                aux_play_en <= '1';
                
                if(sample_request = '1' and count_tone_constant < 40) then
                    next_count_tone_constant <= count_tone_constant + 1;
                else
                    next_count_tone_constant <= (others => '0');
                end if;
                
                aux_sample_in <= x"FF";
                if (sample_request = '1' and count_tone_constant >= 20) then
                    aux_sample_in <= x"00";
                end if;    
                
            end if;
            
            if (sample_out_ready='1' and ( aux_record_ADDR < MAX_DIR)) then
                next_record_ADDR <= aux_record_ADDR + 1;
                aux_ADDR <= std_logic_vector(aux_record_ADDR);
                aux_DATA_IN <= sample_out;
            end if;
            
        else
            next_state <= IDLE;
        end if;
        
    when PLAY =>
        aux_play_en <= '1';
        aux_record_en <= '0';
        aux_EN_RAM <= '1';
        aux_ENW_RAM <= "0";
        led_play <= '1';
        samples_left <= aux_record_ADDR - aux_play_ADDR;
        if (sample_request='1' or start_play= '1') then
            next_play_ADDR <= aux_play_ADDR + 1;
        end if;
        
        if (aux_play_ADDR >= aux_record_ADDR) then
            next_state <= IDLE;
            next_play_ADDR <= (others => '0');
        else
            next_state <= PLAY;
            aux_ADDR <= std_logic_vector(aux_play_ADDR);
            aux_sample_in <= DATA_OUT;
        end if;
    
    
    when PLAY_REVERSE =>
        samples_left <= aux_play_reverse_ADDR;
        aux_play_en <= '1';
        aux_record_en <= '0';
        aux_EN_RAM <= '1';
        aux_ENW_RAM <= "0";
        led_play <= '1';        
        led_record <= '1';
        aux_filter_select <= '0' ;      
        if (sample_request='1' or start_play= '1') then
            next_play_reverse_ADDR <= aux_play_reverse_ADDR -1;
        end if;
                
        if (aux_play_reverse_ADDR = "0000000000000000000") then
            next_state <= IDLE;
        else
            next_state <= PLAY_REVERSE;
            aux_ADDR <= std_logic_vector(aux_play_reverse_ADDR);
            aux_sample_in <= DATA_OUT;
        end if;
        
    when PLAY_LPF =>
        samples_left <= aux_record_ADDR - aux_play_ADDR;
        aux_play_en <= '1';
        aux_record_en <= '0';
        aux_EN_RAM <= '1';
        aux_ENW_RAM <= "0";
        led_play <= '1';
        aux_filter_select <= '1';
        if (sample_request='1' or start_play= '1') then
            next_play_ADDR <= aux_play_ADDR + 1;
            aux_filter_In_enable <= '1';
            aux_sample_in <= aux_filter_out;            
            aux_filter_in <= DATA_OUT;   
        end if;
    
        if (aux_play_ADDR >= aux_record_ADDR) then
            next_state <= IDLE;
        else
            next_state <= PLAY_LPF;
            aux_ADDR <= std_logic_vector(aux_play_ADDR);
        end if;
        
    when PLAY_HPF =>
        samples_left <= aux_record_ADDR - aux_play_ADDR;
        aux_play_en <= '1';
        aux_record_en <= '0';
        aux_EN_RAM <= '1';
        aux_ENW_RAM <= "0";
        led_play <= '1';

        if (sample_request='1' or start_play= '1') then
            next_play_ADDR <= aux_play_ADDR + 1;
            aux_filter_In_enable <= '1';
            aux_sample_in <= aux_filter_out;            
            aux_filter_in <= DATA_OUT;   
        end if;

        if (aux_play_ADDR >= aux_record_ADDR) then
            next_state <= IDLE;
        else
            next_state <= PLAY_HPF;
            aux_ADDR <= std_logic_vector(aux_play_ADDR);
        end if;

    when others => 
        next_state <= IDLE;
    end case;
end process;

--Display
process(samples_left)
begin
aux_seconds_left <= samples_left*PERIOD;
end process;

seconds_left <= aux_seconds_left(36 downto 32);

--RAM
ADDR <= aux_ADDR;
DATA_IN <= aux_DATA_IN;
           
reset_RAM <= aux_reset_RAM;
EN_RAM <= aux_EN_RAM;
ENW_RAM <= aux_ENW_RAM;

--PWM
sample_in <= aux_sample_in;

-- lógica de salida
play_en <= aux_play_en;
record_en <= aux_record_en;


--FILTER
filter_select <= aux_filter_select;
filter_In_enable <=aux_filter_In_enable;
aux_filter_out_STD <= std_logic_vector(filter_out);
aux_filter_out <= not (aux_filter_out_STD(sample_size-1)) & aux_filter_out_STD(sample_size-2 downto 0);

filter_in_SIGNED <= not (aux_filter_in(sample_size-1)) & aux_filter_in(sample_size-2 downto 0);
filter_in <= signed(filter_in_SIGNED);
end Behavioral;
