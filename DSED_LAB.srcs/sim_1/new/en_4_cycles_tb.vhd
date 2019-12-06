----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2019 18:24:44
-- Design Name: 
-- Module Name: en_4_cycles_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity en_4_cycles_tb is
--  Port ( );
end en_4_cycles_tb;

architecture Behavioral of en_4_cycles_tb is

component en_4_cycles
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end component;

-- input signals declaration
signal reset, clk_12megas : STD_LOGIC := '0';

-- output signals declaration
signal clk_3megas, en_2_ciclos, en_4_ciclos : STD_LOGIC;

-- CLK period definition
constant CLK_PERIOD : time := 83 ns;

begin

-- DUT declaration
UUT: en_4_cycles
    port map(
        clk_12megas => clk_12megas,
        reset => reset,
        clk_3megas => clk_3megas,
        en_2_cycles => en_2_ciclos,
        en_4_cycles => en_4_ciclos);

-- CLK process definition (50% duty cycle)
clk_process: process
begin
    clk_12megas <= '0';
    wait for CLK_PERIOD/2;
    clk_12megas <= '1';
    wait for CLK_PERIOD/2;
end process;

-- Stimulus process
stim_process: process
begin
    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait;
end process;

end Behavioral;
