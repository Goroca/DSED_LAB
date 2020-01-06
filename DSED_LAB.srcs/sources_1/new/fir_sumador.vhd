----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.01.2020 00:45:46
-- Design Name: 
-- Module Name: fir_sumador - Behavioral
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


entity fir_sumador is
    Port (
        sum_in0 : in signed (sample_size-1 downto 0);
        sum_in1 : in signed (sample_size-1 downto 0);
        sum_out : out signed (sample_size-1 downto 0)
    );
end fir_sumador;

architecture Behavioral of fir_sumador is

begin

sum_out <= sum_in0 + sum_in1;

end Behavioral;
