----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.01.2020 00:45:46
-- Design Name: 
-- Module Name: fir_multiplicador - Behavioral
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


entity fir_multiplicador is
    Port (
        mul_in0 : in signed (sample_size-1 downto 0);
        mul_in1 : in signed (sample_size-1 downto 0);
        mul_out : out signed (15 downto 0)
    );
end fir_multiplicador;

architecture Behavioral of fir_multiplicador is

begin

mul_out <= to_signed ( to_integer(mul_in0) * to_integer(mul_in1) , mul_out'length);

end Behavioral;
