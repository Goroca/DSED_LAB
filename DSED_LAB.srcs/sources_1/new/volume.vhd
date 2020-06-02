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
           factor : out unsigned(8 downto 0);
           level : out unsigned(4 downto 0)
           );
end volume;

architecture Behavioral of volume is
constant MAX_LEVEL : unsigned(4 downto 0) := "10100"; -- 20
constant LOW_LEVEL : unsigned(4 downto 0) := "00000"; -- 0
constant START_LEVEL : unsigned(4 downto 0) := "01010";

signal last_SW15, last_SW14 : std_logic := '0';

signal aux_level, next_level : unsigned(4 downto 0) := "01010"; -- Start in 10


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

with aux_level select factor <= --Notacion <4,5> sin signo
"000000000"  when "00000",  --0 
"000000001"  when "00001",  --1    
"000000010"  when "00010",  --2    
"000000100"  when "00011",  --3    
"000000110"  when "00100",  --4    
"000001000"  when "00101",  --5    
"000001011"  when "00110",  --6    
"000001111"  when "00111",  --7    
"000010011"  when "01000",  --8    
"000011001"  when "01001",  --9    
"000100000"  when "01010",  --10    
"000101000"  when "01011",  --11    
"000110001"  when "01100",  --12   
"000111101"  when "01101",  --13   
"001001011"  when "01110",  --14   
"001011101"  when "01111",  --15   
"001110010"  when "10000",  --16   
"010001100"  when "10001",  --17   
"010101011"  when "10010",  --18   
"011010001"  when "10011",  --19   
"100000000"  when others;   --20  

level <= aux_level;
end Behavioral;
