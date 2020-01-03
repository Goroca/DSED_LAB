----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.01.2020 22:23:10
-- Design Name: 
-- Module Name: Memory_tb - Behavioral
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

entity Memory_tb is
--  Port ( );
end Memory_tb;

architecture Behavioral of Memory_tb is

component blk_mem_gen_0 IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
  END component;

  signal clka  : STD_LOGIC;
  signal ena   :  STD_LOGIC;
  signal wea   :  STD_LOGIC_VECTOR(0 DOWNTO 0);
  signal addra :  STD_LOGIC_VECTOR(15 DOWNTO 0);
  signal dina  :  STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal douta :  STD_LOGIC_VECTOR(7 DOWNTO 0);

-- CLK period definition
constant CLK_PERIOD : time := 83 ns;
begin

UUT: blk_mem_gen_0
  PORT MAP(
    clka => clka,
    ena  => ena,
    wea  => wea,
    addra => addra,
    dina  => dina,
    douta => douta
  );
  
  
  CLK: process
  begin
      clka <= '0';
      wait for CLK_PERIOD/2;
      clka <= '1';
      wait for CLK_PERIOD/2;
  end process;
end Behavioral;
