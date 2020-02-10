----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2020 22:12:29
-- Design Name: 
-- Module Name: TB_FULL_SYSTEM - Behavioral
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

entity TB_FULL_SYSTEM is
--  Port ( );
end TB_FULL_SYSTEM;

architecture Behavioral of TB_FULL_SYSTEM is

component dsed_audio 
Port (
clk_100Mhz : in std_logic;
reset: in std_logic;
--Control ports
BTNL: in STD_LOGIC;
BTNC: in STD_LOGIC;
BTNR: in STD_LOGIC;

SW0: in STD_LOGIC;
SW1: in STD_LOGIC;
--To/From the microphone
micro_clk : out STD_LOGIC;
micro_data : in STD_LOGIC;
micro_LR : out STD_LOGIC;
--To/From the mini-jack
jack_sd : out STD_LOGIC;
jack_pwm : out STD_LOGIC
);
end component;

-- input signals declaration
signal clk_100Mhz, reset : std_logic := '0';
signal micro_data : std_logic := '0';

-- output signals declaration
signal micro_clk, micro_LR : std_logic;
signal jack_sd, jack_pwm : std_logic;

-- CLK period definition
constant CLK_PERIOD : time := 10 ns;

begin

-- UUT declaration
SYSTEM: dsed_audio 
Port Map(
clk_100Mhz => clk_100Mhz, --: in std_logic;
reset => reset, --: in std_logic;
--Control ports
BTNL => '0',--: in STD_LOGIC;
BTNC => '0',--: in STD_LOGIC;
BTNR => '0',--: in STD_LOGIC;

SW0 =>'0',--: in STD_LOGIC;
SW1 =>'0',--: in STD_LOGIC;
--To/From the microphone
micro_clk => micro_clk,--: out STD_LOGIC;
micro_data => micro_data,--: in STD_LOGIC;
micro_LR => micro_LR,--: out STD_LOGIC;
--To/From the mini-jack
jack_sd => jack_sd,--: out STD_LOGIC;
jack_pwm => jack_pwm--: out STD_LOGIC
);
        
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
    wait for 6 us;
    micro_data <= '1';
    wait;
end process;


end Behavioral;
