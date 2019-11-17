----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2019 19:56:31
-- Design Name: 
-- Module Name: pwm - Behavioral
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

entity pwm is
port(
clk_12megas, in std_logic;
reset, in std_logic;
en_2_cycles: in std_logic;
sample_in: in std_logic_vector(sample_size-1 downto 0);
sample_request: out std_logic;
pwm_pulse: out std_logic
);
end pwm;


architecture Behavioral of pwm is

begin


end Behavioral;
