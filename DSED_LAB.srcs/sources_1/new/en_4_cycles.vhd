----------------------------------------------------------------------------------
-- 
-- Engineer: CARLOS GÓMEZ and ALEJANDRO RAMOS
-- 
-- Create Date: 08.11.2019 14:34:59
-- Module Name: en_4_cycles - Behavioral
-- Project Name: DSED_LAB 
-- 
-- Description: 
-- Módulo generador del reloj del micrófono a 3 MHz y de las señales de enable
-- utilizadas para temporizar el resto de módulos de la interfaz de audio.
-- 
-- Revision: v.0.1
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

entity en_4_cycles is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;       
           clk_3megas : out STD_LOGIC; 
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end en_4_cycles;

architecture Behavioral of en_4_cycles is

-- declaración de señales auxiliares: contadores


signal count : unsigned (1 downto 0) := "00";
signal next_count : unsigned (1 downto 0);

-- declaración de señales auxiliares: cambio de estado

signal aux_clk_3megas,aux_en_4_cycles : STD_LOGIC := '0';

begin

-- lógica secuencial de entrada: contadores

process(clk_12megas, reset)
begin

if (reset = '1') then
    count <= to_unsigned(0, 2);
        
elsif (clk_12megas'event and clk_12megas=SAMPLE_CLK_EDGE) then
    count <= next_count;
end if;
end process;

-- lógica de estado siguiente
process(count)
begin
aux_en_4_cycles <= '0';
aux_clk_3megas <= '0';

if (count > 1) then
    aux_clk_3megas <= '1';
end if;

if (count=2) then
    aux_en_4_cycles <= '1';
end if;

end process;


next_count <= count +1;
-- actualización de las salidas
en_2_cycles <= std_logic(count(0));

en_4_cycles <= aux_en_4_cycles;
clk_3megas <= aux_clk_3megas;
end Behavioral;