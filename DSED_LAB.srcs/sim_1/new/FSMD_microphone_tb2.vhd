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
use IEEE.NUMERIC_STD.ALL;

use work.package_dsed.all;


entity FSMD_microphone_tb2 is
--  Port ( );
end FSMD_microphone_tb2;

architecture Behavioral of FSMD_microphone_tb2 is

component FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC);
end component;

-- signal definitions
signal clk_12megas : STD_LOGIC := '0';
signal reset : STD_LOGIC := '0';
signal enable_4_cycles : STD_LOGIC := '0';
signal micro_data : STD_LOGIC := '0';
signal sample_out : STD_LOGIC_VECTOR (sample_size-1 downto 0) := (others=>'0');
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
        sample_out_ready=> sample_out_ready
    );
        
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

data_process: process
begin

    wait for 4000 ns;   
    micro_data <= '1';  --3 1s
    wait for 1000 ns;   
    micro_data <= '0';  --12 0s

end process;
end Behavioral;
