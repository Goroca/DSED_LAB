----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.04.2020 19:47:40
-- Design Name: 
-- Module Name: volume - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity volume is
    Port (   
           clk_12MHz : in std_logic;
           reset : in std_logic;
           SW15 : in STD_LOGIC;
           SW14 : in STD_LOGIC;
           factor : out unsigned(7 downto 0);
           level : out unsigned(4 downto 0)
           );
end volume;

architecture Behavioral of volume is
constant MAX_LEVEL : unsigned(4 downto 0) := "10100"; -- 20
constant LOW_LEVEL : unsigned(4 downto 0) := "00000"; -- 0
constant START_LEVEL : unsigned(4 downto 0) := "01010";

signal last_SW15, last_SW14 : std_logic := '0';

signal aux_level, next_level : unsigned(4 downto 0) := "01010"; -- Start in 11


signal more, less : STD_LOGIC := '0';
begin

process(clk_12MHz,reset)
begin
    if (reset = '1') then
        aux_level <= START_LEVEL;
    elsif(clk_12MHz'event and clk_12MHz = SAMPLE_CLK_EDGE) then
    
        last_SW15 <= SW15;
        last_SW14 <= SW14;
        aux_level <= next_level;
    end if;
end process;

process(last_SW14, SW14, last_SW15, SW15)
begin
more <= '0';
less <= '0';
    if (last_SW14 = '0' and SW14 = '1') then
        less <= '1';
    end if;
    
    if (last_SW15 = '0' and SW15 = '1') then
        more <= '1';
    end if;   
    
end process;
process (aux_level, more, less)
begin
next_level <= aux_level;
if (aux_level < MAX_LEVEL and more = '1') then
    next_level <= aux_level + 1;
    
elsif (aux_level > LOW_LEVEL and less = '1') then
        next_level <= aux_level - 1;   
end if;
end process;

with aux_level select factor <=
"00000000"  when "00000",  --0 
"00000000"  when "00001",  --1    
"00000001"  when "00010",  --2    
"00000010"  when "00011",  --3    
"00000011"  when "00100",  --4    
"00000100"  when "00101",  --5    
"00000101"  when "00110",  --6    
"00000111"  when "00111",  --7    
"00001001"  when "01000",  --8    
"00001100"  when "01001",  --9    
"00010000"  when "01010",  --10    
"00010100"  when "01011",  --11    
"00011000"  when "01100",  --12   
"00011110"  when "01101",  --13   
"00100101"  when "01110",  --14   
"00101110"  when "01111",  --15   
"00111001"  when "10000",  --16   
"01000110"  when "10001",  --17   
"01010101"  when "10010",  --18   
"01101000"  when "10011",  --19   
"10000000"  when others;   --20  

level <= aux_level;
end Behavioral;
