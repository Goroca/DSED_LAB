----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.12.2019 21:34:29
-- Design Name: 
-- Module Name: controlador_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlador_tb is
--  Port ( );
end controlador_tb;

architecture Behavioral of controlador_tb is

component controlador
    Port ( clk_100Mhz : in std_logic;
           reset: in std_logic;
           --To/From the microphone
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           --To/From the mini-jack
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC);
end component;

-- input signals declaration
signal clk_100Mhz, reset : std_logic := '0';
signal micro_data : std_logic := '0';

-- output signals declaration
signal micro_clk, micro_LR : std_logic := '0';
signal jack_sd, jack_pwm : std_logic := '0';

-- CLK period definition
constant CLK_PERIOD : time := 10 ns;

begin

-- UUT declaration
UUT: controlador
    port map (
        clk_100Mhz => clk_100Mhz,
        reset => reset,
        micro_clk => micro_clk,
        micro_data => micro_data,
        micro_LR => micro_LR,
        jack_sd => jack_sd,
        jack_pwm => jack_pwm);
        
clk_process: process
begin
    clk_100Mhz <= '0';
    wait for CLK_PERIOD/2;
    clk_100Mhz <= '1';
    wait for CLK_PERIOD/2;
end process;

stim_process: process
begin
    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait for 50 us;
    micro_data <= '1';
    wait;
end process;

end Behavioral;
