----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2020 15:34:20
-- Design Name: 
-- Module Name: dsed_audio - Behavioral
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

entity dsed_audio is
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
end dsed_audio;

architecture Behavioral of dsed_audio is

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
begin

AUDIO: controlador 
    Port Map( clk_100Mhz => clk_100Mhz,
           reset => reset,
           --To/From the microphone
           micro_clk => micro_clk,
           micro_data => micro_data,
           micro_LR => micro_LR,
           --To/From the mini-jack
           jack_sd => jack_sd,
           jack_pwm => jack_pwm);

end Behavioral;
