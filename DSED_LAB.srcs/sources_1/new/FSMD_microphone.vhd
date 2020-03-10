----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
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

signal first_cycle, next_first_cycle : std_logic := '0'; 
signal next_cycle : unsigned (8 downto 0):= (others=>'0');
signal cycle :      unsigned (8 downto 0):= (others=>'0');

--Numero unos
signal count1 : unsigned (sample_size-1 downto 0) := (others=>'0');
signal count2 : unsigned (sample_size-1 downto 0) := (others=>'0');
signal next_count1 : unsigned (sample_size-1 downto 0) := (others=>'0');
signal next_count2 : unsigned (sample_size-1 downto 0) := (others=>'0');
signal aux_micro_data : unsigned (0 downto 0);

signal aux_sample_out, next_sample_out : STD_LOGIC_VECTOR (sample_size-1 downto 0) := (others=>'0');
signal aux_sample_out_ready : STD_LOGIC;

begin

-- lógica de entrada
process (clk_12megas,reset)
begin
if (reset = '1') then
    count1<= (others=>'0');
    count2<= (others=>'0');
    cycle<= (others => '0');
    state<=S0;
    first_cycle<='0';
    aux_sample_out <= (others => '0');
elsif (clk_12megas'event and clk_12megas=SAMPLE_CLK_EDGE) then
    aux_sample_out <= next_sample_out;

    if (enable_4_cycles='1') then
        count1<= next_count1;
        count2<= next_count2;
        state<=next_state;
        cycle<= next_cycle;
        first_cycle <= next_first_cycle;
    end if;      
end if;
end process;

-- lógica de estado siguiente
process(cycle,state,reset,aux_micro_data,count1,count2,micro_data,enable_4_cycles)
begin

case (state) is
    when S0 =>
        aux_sample_out_ready <= '0';
        next_cycle <= cycle;
        
        if (reset = '1') then
            next_state <= S0;
        else
            next_state <= S1;
            next_cycle <= cycle + 1;
            next_count1 <= count1 + aux_micro_data;
        end if;
        
    when S1 =>
        next_cycle <= cycle + 1;
        next_count1 <= count1 + aux_micro_data;
        if (first_cycle = '1') then
            next_count2 <= count2 + aux_micro_data;
            if (cycle = 105) then
                next_state <= S2;
                next_sample_out <= std_logic_vector(count2);
            end if;
        elsif (cycle = 149) then
            next_state <= S3;
        else
            next_state <= S1;
        end if;
        
    when S2 =>
        next_cycle <= cycle + 1;        
        next_count1 <= count1 + aux_micro_data;
        
        if (cycle = 106) then
            aux_sample_out_ready <= '1';
        else
            aux_sample_out_ready <= '0';
        end if;
        
        if (cycle = 149) then
            next_state <= S3;
            next_count2 <= (others => '0');
        else
            next_state <= S2;
        end if;
        
    when S3 =>
        next_cycle <= cycle + 1;
        next_count1 <= count1 + aux_micro_data;
        next_count2 <= count2 + aux_micro_data;
        
        if (cycle = 255) then
            next_state <= S4;
            next_sample_out <= std_logic_vector(count1);
        else
            next_state <= S3;
        end if;
        
    when S4 =>
        next_cycle <= cycle + 1;
        next_count2 <= count2 + aux_micro_data;
        if (cycle = 256) then
            aux_sample_out_ready <= '1';
        else
            aux_sample_out_ready <= '0';
        end if;
        
        if (cycle = 299) then
            next_state <= S1;
            next_cycle <= (others => '0');
            next_count1 <= (others => '0');
            next_first_cycle <= '1';
        else
            next_state <= S4;
        end if;
         
end case;
end process;

-- lógica de salida
aux_micro_data <= 
    to_unsigned(1,1) when (micro_data='1') else
    to_unsigned(0,1);
sample_out_ready<=aux_sample_out_ready;
sample_out<=aux_sample_out;

end Behavioral;