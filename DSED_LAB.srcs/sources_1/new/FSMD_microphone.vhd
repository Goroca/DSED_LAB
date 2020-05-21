----------------------------------------------------------------------------------
-- Company: 
-- Engineer: CARLOS GÓMEZ and ALEJANDRO RAMOS
-- 
-- Create Date: 16.11.2019 15:50:32
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is

type state_type is (S0,S1,S2,S3,S4);
signal state, next_state : state_type;

-- Sacar el "dato 2" o no
signal first_cycle, next_first_cycle : std_logic := '0';

-- Contador de número de ciclos 
signal cycle,next_cycle : unsigned (8 downto 0):= (others=>'0');

-- Contador de número de unos
signal count1,next_count1 : unsigned (sample_size-1 downto 0) := (others=>'0');
signal count2,next_count2 : unsigned (sample_size-1 downto 0) := (others=>'0');

-- Señal auxiliar para convertir micro_data a unsigned
signal aux_micro_data : unsigned (0 downto 0);

signal aux_sample_out, last_sample_out : STD_LOGIC_VECTOR (sample_size-1 downto 0) := (others=>'0');
signal aux_sample_out_ready : STD_LOGIC := '0';

-- Señal auxiliar para activar sample_out_ready durante 1 ciclo de reloj
signal lock,next_lock : STD_LOGIC := '0';

begin

-- lógica de entrada
process (clk_12megas,reset)
begin
if (reset = '1') then
    count1 <= (others=>'0');
    count2 <= (others=>'0');
    cycle <= (others => '0');
    lock <= '0';
    state <= S0;
    last_sample_out <= (others => '0'); 
elsif (clk_12megas'event and clk_12megas=SAMPLE_CLK_EDGE) then
    lock <= next_lock;
    if (enable_4_cycles='1') then
        count1<= next_count1;
        count2<= next_count2;
        state<=next_state;
        cycle<= next_cycle;
        first_cycle <= next_first_cycle;
        last_sample_out <= aux_sample_out; 
    end if;      
end if;
end process;


process(state,cycle,count1,count2,aux_micro_data,lock,first_cycle,last_sample_out)
begin
aux_sample_out <=last_sample_out ; 
next_state <= state;
next_cycle <= cycle + 1;
next_count1 <= count1;
next_count2 <= count2;

next_first_cycle <= first_cycle;
aux_sample_out_ready <= '0';
next_lock <= lock;

case (state) is
    when S0 =>      --Reset
        next_state <= S1;
        aux_sample_out <= (others => '0'); 
        next_first_cycle <= '0';
   
    when S1 =>          -- 0 to 105
        next_lock <= '0';
        next_count1 <= count1 + aux_micro_data;
        if (cycle <= 105) then
        next_count2 <= count2 + aux_micro_data;
        end if;
        
        if (cycle = 105) then
            next_state <= S2;
        else
            next_state <= S1;
        end if;
        
    when S2 =>          --106 to 149
        next_count1 <= count1 + aux_micro_data;    
        if (cycle = 106 and first_cycle = '1') then
            aux_sample_out <= std_logic_vector(count2);
            next_count2 <= (others => '0');        
            if (lock = '0') then
                aux_sample_out_ready <= '1';
                next_lock <= '1';
            else
                aux_sample_out_ready <= '0';
            end if;
        end if;        
        if (cycle = 149) then
            next_state <= S3;
        else
            next_state <= S2;
        end if; 
        
    when S3 =>          --150 to 255
        next_lock <= '0';
        if(cycle <= 255) then
            next_count1 <= count1 + aux_micro_data;
        end if;
            next_count2 <= count2 + aux_micro_data;
        if (cycle = 255) then
            next_state <= S4;
        else
            next_state <= S3;
        end if;
        
    when others =>          -- 256 to 299  
        next_count2 <= count2 + aux_micro_data;
        if (cycle = 256) then
            aux_sample_out <= std_logic_vector(count1); 
            next_count1 <=(others => '0');
            if (lock = '0') then
                aux_sample_out_ready <= '1';
                next_lock <= '1';
            else
                aux_sample_out_ready <= '0';
            end if;
        end if;    
        if (cycle = 299) then
            next_state <= S1;
            next_cycle <= (others => '0');
            next_first_cycle <= '1';
        else
            next_state <= S4;
        end if; 
    end case;
end process;


-- lógica de salida
aux_micro_data <= 
    "1" when (micro_data='1') else
    "0";
    
sample_out_ready <= aux_sample_out_ready;
sample_out <= aux_sample_out;

end Behavioral;
