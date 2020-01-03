----------------------------------------------------------------------------------
-- 
-- Engineers: Carlos Gómez Rodríguez, Alejandro Ramos Martín
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
signal count_3megas : unsigned (1 downto 0) := "00";
signal count_en_4_cycles : unsigned (1 downto 0) := "10";
signal next_count_3megas : unsigned (1 downto 0);
signal next_count_en_4_cycles : unsigned (1 downto 0);

-- declaración de señales auxiliares
signal clk_3megas_aux, next_clk_3megas_aux : STD_LOGIC := '0';
signal aux_en_4_cycles, next_aux_en_4_cycles : STD_LOGIC := '0';
signal aux_en_2_cycles, next_aux_en_2_cycles : STD_LOGIC := '0';

begin

-- lógica secuencial de entrada: contadores

process(clk_12megas, reset)
begin

if (reset = '1') then
    count_3megas <= "00";
    count_en_4_cycles <= "10";
    clk_3megas_aux <= '0';
    aux_en_4_cycles <= '0';
    aux_en_2_cycles <= '0';
elsif (clk_12megas'event and clk_12megas=SAMPLE_CLK_EDGE) then
    count_3megas <= next_count_3megas;
    count_en_4_cycles <= next_count_en_4_cycles;
    clk_3megas_aux <= next_clk_3megas_aux;
    aux_en_4_cycles <= next_aux_en_4_cycles;
    aux_en_2_cycles <= next_aux_en_2_cycles;
end if;

end process;

-- lógica combinacional
process(aux_en_2_cycles,count_3megas, count_en_4_cycles)
begin
    next_aux_en_2_cycles <= not aux_en_2_cycles;
  
    if (count_3megas = 1 or count_3megas = 2) then
        next_clk_3megas_aux <= '1';
    else
        next_clk_3megas_aux <= '0';

    end if;
    
    if (count_en_4_cycles = 3) then
        next_aux_en_4_cycles <= '1';
    else 
        next_aux_en_4_cycles <= '0';
    end if;
end process;

    next_count_3megas <= count_3megas + 1;
    next_count_en_4_cycles <=  count_en_4_cycles + 1;

-- actualización de las salidas
clk_3megas <= clk_3megas_aux;
en_4_cycles <= aux_en_4_cycles;
en_2_cycles <= aux_en_2_cycles;


end Behavioral;
