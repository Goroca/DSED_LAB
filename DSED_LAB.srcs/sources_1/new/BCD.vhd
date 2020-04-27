----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.04.2020 21:09:21
-- Design Name: 
-- Module Name: BCD - Behavioral
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

entity BCD is
  Port (
    clk_12MHz : in std_logic;
    number : in unsigned (4 downto 0); 
    decenas : out unsigned (3 downto 0); 
    unidades : out unsigned (3 downto 0) 
   );
end BCD;

architecture Behavioral of BCD is

signal aux_decenas, next_decenas, aux_unidades : unsigned (4 downto 0) := (others => '0');
signal next_unidades : unsigned (9 downto 0) := (others => '0');

begin

process(clk_12MHz)
begin
    if(clk_12MHz'event and clk_12MHz = SAMPLE_CLK_EDGE) then
        aux_decenas <= next_decenas;
        aux_unidades <= next_unidades(4 downto 0);
    end if;
end process;

process(number, aux_decenas)
begin
next_decenas <= number/10;
next_unidades <= number - aux_decenas*10;
end process;

decenas <= aux_decenas(3 downto 0);
unidades <= aux_unidades(3 downto 0);

end Behavioral;
