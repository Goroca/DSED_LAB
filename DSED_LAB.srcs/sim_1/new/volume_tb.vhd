----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.05.2020 19:32:11
-- Design Name: 
-- Module Name: volume_tb - Behavioral
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

entity volume_tb is
--  Port ( );
end volume_tb;

architecture Behavioral of volume_tb is

component pwm 
    port( clk_12megas: in std_logic;
          reset: in std_logic;
          en_2_cycles: in std_logic;
          sample_in: in std_logic_vector(sample_size-1 downto 0);
          sample_request: out std_logic;
          pwm_pulse: out std_logic;
          --VOLUMEN
          factor : in unsigned(8 downto 0)
          );
end component;

signal clk_12megas:  std_logic;
signal reset:  std_logic := '0';
signal en_2_cycles:  std_logic;
signal sample_in:  std_logic_vector(sample_size-1 downto 0) :=x"CB";
signal sample_request:  std_logic;
signal pwm_pulse:  std_logic;
          --VOLUMEN
signal factor :  unsigned(8 downto 0) := "000000000";

constant CLK_PERIOD : time := 83 ns;

begin
 UUT: pwm  port map (
      clk_12megas => clk_12megas,--: in std_logic;
      reset => reset,--: in std_logic;
      en_2_cycles => en_2_cycles,--: in std_logic;
      sample_in => sample_in,--: in std_logic_vector(sample_size-1 downto 0);
      sample_request => sample_request,--: out std_logic;
      pwm_pulse => pwm_pulse,--: out std_logic;
      --VOLUMEN
      factor => factor --: in unsigned(8 downto 0)
      );
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

process
begin
factor <= "000000000";--0
wait for 500 ns;
factor <= "000000001"; -- 1
wait for 500 ns;
factor <= "000000010"; -- 2
wait for 500 ns;
factor <= "000000100"; --3
wait for 500 ns;
factor <= "000000110";--4
wait for 500 ns;    
factor <= "000001000"; --5
wait for 500 ns;
factor <= "000001011";  --6
wait for 500 ns; 
factor <= "000001111";  --7
wait for 500 ns; 
factor <= "000010011"; --8
wait for 500 ns;
factor <= "000011001"; --9
wait for 500 ns;
factor <= "000100000"; -- 10
wait for 500 ns;
factor <= "000101000";--   11
wait for 500 ns;
factor <= "000110001";--12
wait for 500 ns;
factor <= "000111101"; -- 13
wait for 500 ns;
factor <= "001001011";--14
wait for 500 ns;
factor <= "001100000"; --15
wait for 500 ns;
factor <= "001110010";--16
wait for 500 ns;
factor <= "010001100"; --17
wait for 500 ns;
factor <= "010101011"; --18
wait for 500 ns;
factor <= "011010001";  --19  
wait for 500 ns; 
factor <= "100000000";   --20  
wait for 20000 ns;
end process;
end Behavioral;
