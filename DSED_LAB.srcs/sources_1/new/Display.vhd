----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2020 16:33:53
-- Design Name: 
-- Module Name: Display - Behavioral
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

entity Display is
 Port ( 
    clk_12MHz : in std_logic;
    reset : in std_logic;
    seconds : in unsigned (4 downto 0); --numero de segundos que quedan de grabación
    level : in unsigned(4 downto 0);
    CA  : out std_logic;
    CB  : out std_logic;
    CC  : out std_logic;
    CD  : out std_logic;
    CE  : out std_logic;
    CF  : out std_logic;
    CG  : out std_logic;
    AN  : out STD_LOGIC_VECTOR (7 downto 0);
    DP  : out std_logic
);
end Display;

architecture Behavioral of Display is
signal counter, next_counter : unsigned (3 downto 0) := x"0";
signal decenas, unidades : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal number : STD_LOGIC_VECTOR(4 downto 0);

signal toDisplay : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal display7 : STD_LOGIC_VECTOR (6 downto 0) := (others=>'0');
signal aux_AN   : STD_LOGIC_VECTOR (7 downto 0) := (others=> '1');

begin


with toDisplay select display7 <=
--Descodificacion de numeros
"1001111"  when "0001", -- 1
"0010010"  when "0010", -- 2
"0000110"  when "0011", -- 3
"1001100"  when "0100", -- 4
"0100100"  when "0101", -- 5
"0100000"  when "0110", -- 6
"0001111"  when "0111", -- 7
"0000000"  when "1000", -- 8
"0001100"  when "1001", -- 9
"0000001"  when "0000", -- 0
"1111111" when others; 

process(clk_12MHz)
begin
    if(clk_12MHz'event and clk_12MHz = SAMPLE_CLK_EDGE) then
        counter <= next_counter;
    end if;
end process;

-- Divide en decenas y unidades el valor de number

-- Activa en cada flanco de reloj el display con la cifra correspondiente a las decenas o unidades
process(counter, reset,decenas,unidades)
begin
    aux_AN <= x"FF";
    toDisplay <= (others => '1');
    next_counter <= counter + 1;
    number <= (others=>'0');
    if (reset = '0') then
    
        if (counter = "0000") then
            number <= std_logic_vector(seconds);
            toDisplay <= decenas;
            aux_AN <= "11111101";
        elsif (counter = "0100") then
            number <= std_logic_vector(seconds);
            toDisplay <= unidades;
            aux_AN <= "11111110";
            
        elsif (counter = "1000") then
            number <= std_logic_vector(level);
            toDisplay <= unidades;
            aux_AN <= "10111111"; 
                           
        elsif (counter = "1100") then
            number <= std_logic_vector(level);
            toDisplay <= decenas;
            aux_AN <= "01111111";            
        end if;
    end if;
end process;

--BCD
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
"0010"  when "10101",  --21 
"0010"  when "10110",  --22 
"0010"  when "10111",  --23 
"0010"  when "11000",  --24 
"0010"  when "11001",  --25 
"0010"  when "11010",  --26 
"0010"  when "11011",  --27 
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
"0001"  when "10101",  --21 
"0010"  when "10110",  --22 
"0011"  when "10111",  --23 
"0100"  when "11000",  --24 
"0101"  when "11001",  --25 
"0110"  when "11010",  --26 
"0111"  when "11011",  --27 
"1111"  when others;   



-- Asignación de las salidas
CA <= display7(6);
CB <= display7(5);
CC <= display7(4);
CD <= display7(3);
CE <= display7(2);
CF <= display7(1); 
CG <= display7(0);
AN <= aux_AN; 
DP <= '1';

end Behavioral;