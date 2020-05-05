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
    number : in unsigned (4 downto 0); 
    decenas : out unsigned (3 downto 0); 
    unidades : out unsigned (3 downto 0) 
   );
end BCD;

architecture Behavioral of BCD is
begin

with number select decenas <=
"0000"  when "00000",  --0 
"0000"  when "00001",  --1    
"0000"  when "00010",  --2    
"0000"  when "00011",  --3    
"0000"  when "00100",  --4    
"0000"  when "00101",  --5    
"0000"  when "00110",  --6    
"0000"  when "00111",  --7    
"0000"  when "01000",  --8    
"0000"  when "01001",  --9    
"0001"  when "01010",  --10    
"0001"  when "01011",  --11    
"0001"  when "01100",  --12   
"0001"  when "01101",  --13   
"0001"  when "01110",  --14   
"0001"  when "01111",  --15   
"0001"  when "10000",  --16   
"0001"  when "10001",  --17   
"0001"  when "10010",  --18   
"0001"  when "10011",  --19   
"0010"  when "10100",  --20 
"1111"  when others;  

with number select unidades <=
"0000"  when "00000",  --0 
"0001"  when "00001",  --1    
"0010"  when "00010",  --2    
"0011"  when "00011",  --3    
"0100"  when "00100",  --4    
"0101"  when "00101",  --5    
"0110"  when "00110",  --6    
"0111"  when "00111",  --7    
"1000"  when "01000",  --8    
"1001"  when "01001",  --9    
"0000"  when "01010",  --10    
"0001"  when "01011",  --11    
"0010"  when "01100",  --12   
"0011"  when "01101",  --13   
"0100"  when "01110",  --14   
"0101"  when "01111",  --15   
"0110"  when "10000",  --16   
"0111"  when "10001",  --17   
"1000"  when "10010",  --18   
"1001"  when "10011",  --19   
"0000"  when "10100",  --20 
"1111"  when others;    

end Behavioral;
