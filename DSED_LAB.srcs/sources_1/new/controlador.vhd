----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2019 19:57:33
-- Design Name: 
-- Module Name: controlador - Behavioral
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

entity controlador is
Port (
clk_100Mhz : in std_logic;
reset: in std_logic;
--To/From the microphone
micro_clk : out STD_LOGIC;
micro_data : in STD_LOGIC;
micro_LR : out STD_LOGIC;
--To/From the mini-jack
jack_sd : out STD_LOGIC;
jack_pwm : out STD_LOGIC
);
end controlador;


architecture Behavioral of controlador is

begin


end Behavioral;
