----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2019 21:28:04
-- Design Name: 
-- Module Name: pwm_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm_tb is
--  Port ( );
end pwm_tb;

architecture Behavioral of pwm_tb is

component pwm
    port( clk_12megas: in std_logic;
          reset: in std_logic;
          en_2_cycles: in std_logic;
          sample_in: in std_logic_vector(sample_size-1 downto 0);
          sample_request: out std_logic;
          pwm_pulse: out std_logic;
          --VOLUMEN
          factor : in unsigned(7 downto 0));
end component;

-- input signals declaration
signal clk_12megas, reset, en_2_cycles : STD_LOGIC := '0';
signal sample_in : STD_LOGIC_VECTOR(sample_size-1 downto 0) := (others => '0');
signal factor : unsigned(7 downto 0) := "00000001";

-- output signals declaration
signal sample_request, pwm_pulse : STD_LOGIC;

-- CLK period definition
constant CLK_PERIOD : time := 83 ns;

begin

-- UUT declaration
UUT: pwm
    port map(
        clk_12megas => clk_12megas,
        reset => reset,
        en_2_cycles => en_2_cycles,
        sample_in => sample_in,
        sample_request => sample_request,
        pwm_pulse => pwm_pulse,
        factor => factor);

-- CLK and en_2_cycles process definition (50% duty cycle)
clk_process: process
begin
    clk_12megas <= '0';
    wait for CLK_PERIOD/2;
    clk_12megas <= '1';
    wait for CLK_PERIOD/2;
end process;

EN: process
begin
    en_2_cycles <= '0';
    wait for CLK_PERIOD;
    en_2_cycles <= '1';
    wait for CLK_PERIOD;
end process;
-- Stimulus process
stim_process: process
begin
    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    sample_in <= "00000100";
    wait for 49751 ns;
    sample_in <= "01001001";
    wait for 49751 ns;
    sample_in <= "10111010";
    wait for 49851 ns;
    sample_in <= "00000000";
    wait for 49851 ns;
    sample_in <= "11111111";
    wait;
end process;

end Behavioral;


