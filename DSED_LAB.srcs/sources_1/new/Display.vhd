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
signal sec_decenas, sec_unidades : unsigned (3 downto 0) := (others => '0');
signal lev_decenas, lev_unidades : unsigned (3 downto 0) := (others => '0');

signal toDisplay : unsigned (3 downto 0) := (others => '0');
signal display7 : STD_LOGIC_VECTOR (6 downto 0) := (others=>'0');
signal aux_AN   : STD_LOGIC_VECTOR (7 downto 0) := (others=> '1');

component BCD is
  Port (
    clk_12MHz : in std_logic;
    number : in unsigned (4 downto 0); 
    decenas : out unsigned (3 downto 0); 
    unidades : out unsigned (3 downto 0) 
   );
end component;
begin

SECONDS_BCD: BCD 
  Port MAP(
    clk_12MHz => clk_12MHz,--: in std_logic;
    number => seconds,--: in unsigned (4 downto 0); 
    decenas => sec_decenas,--: out unsigned (3 downto 0); 
    unidades => sec_unidades--: out unsigned (3 downto 0) 
   );
   
LEVEL_BCD: BCD 
     Port MAP(
       clk_12MHz => clk_12MHz,--: in std_logic;
       number => level,--: in unsigned (4 downto 0); 
       decenas => lev_decenas,--: out unsigned (3 downto 0); 
       unidades => lev_unidades--: out unsigned (3 downto 0) 
      );
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
process(counter,sec_decenas,sec_unidades, reset, lev_unidades,lev_decenas)
begin
    aux_AN <= x"FF";
    toDisplay <= (others => '1');
    next_counter <= counter + 1;
    if (reset = '0') then
    
        if (counter = "0000") then
            toDisplay <= sec_decenas;
            aux_AN <= "11111101";
        elsif (counter = "0100") then
            toDisplay<= sec_unidades;
            aux_AN <= "11111110";
            
        elsif (counter = "1000") then
                toDisplay<= lev_unidades;
                aux_AN <= "10111111"; 
                           
        elsif (counter = "1100") then
                    toDisplay<= lev_decenas;
                    aux_AN <= "01111111";            
        end if;
    end if;
end process;

-- Asignación de las señales de control del display

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