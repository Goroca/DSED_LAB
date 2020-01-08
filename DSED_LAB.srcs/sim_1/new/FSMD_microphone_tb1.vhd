----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2019 16:08:33
-- Design Name: 
-- Module Name: FSMD_microphone_tb1 - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSMD_microphone_tb1 is
--  Port ( );
end FSMD_microphone_tb1;

architecture Behavioral of FSMD_microphone_tb1 is

component FSMD_microphone is
Port ( clk_12megas : in STD_LOGIC;
reset : in STD_LOGIC;
enable_4_cycles : in STD_LOGIC;
micro_data : in STD_LOGIC;
sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
sample_out_ready : out STD_LOGIC);
end component;

signal clk_12megas : STD_LOGIC := '0';
signal reset : STD_LOGIC := '0';
signal enable_4_cycles : STD_LOGIC := '0';
signal micro_data : STD_LOGIC := '0';
signal sample_out : STD_LOGIC_VECTOR (sample_size-1 downto 0) := "00000000";
signal sample_out_ready : STD_LOGIC := '0';

-- CLK period definition
constant CLK_PERIOD : time := 83 ns;

begin

-- DUT declaration
UUT: FSMD_microphone
    port map(
        clk_12megas => clk_12megas,
        reset=> reset,
        enable_4_cycles=> enable_4_cycles,
        micro_data=> micro_data,
        sample_out=> sample_out,
        sample_out_ready=> sample_out_ready);
        
clk_process: process
begin
    clk_12megas <= '0';
    wait for CLK_PERIOD/2;
    clk_12megas <= '1';
    wait for CLK_PERIOD/2;
end process;

EN_process: process
begin
    enable_4_cycles <= '0';
    wait for CLK_PERIOD*3;
    enable_4_cycles <= '1';
    wait for CLK_PERIOD;

end process;

micro_data<='1';

end Behavioral;
