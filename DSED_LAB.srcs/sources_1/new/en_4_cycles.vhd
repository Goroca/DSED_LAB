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


entity en_4_cycles is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_ciclos : out STD_LOGIC;
           en_4_ciclos : out STD_LOGIC);
end en_4_cycles;

architecture Behavioral of en_4_cycles is

-- declaración de señales auxiliares: contadores
signal count_3megas : integer := 0;
signal count_en_4_ciclos : integer := 2;
signal next_count_3megas : integer := 0;
signal next_count_en_4_ciclos : integer := 0;
-- declaración de señales auxiliares: cambio de estado
signal current_state_clk_3megas, next_state_clk_3megas : STD_LOGIC := '0';
signal current_state_en_4_ciclos, next_state_en_4_ciclos : STD_LOGIC := '0';
signal current_state_en_2_ciclos, next_state_en_2_ciclos : STD_LOGIC := '0';

begin

-- lógica secuencial de entrada: contadores

process(reset, count_3megas, count_en_4_ciclos)
begin

if (reset = '1') then
    next_count_3megas <= 0;
    next_count_en_4_ciclos <= 0;
else
    next_count_3megas <= count_3megas + 1;
    next_count_en_4_ciclos <=  count_en_4_ciclos + 1;

    if (count_3megas = 1) then
        next_count_3megas <= 0;
    end if;
    
    if (count_en_4_ciclos = 3) then
        next_count_en_4_ciclos <= 0;
    end if;
end if;

end process;

process(clk_12megas, reset)
begin

if (reset = '1') then
    count_3megas <= 0;
    count_en_4_ciclos <= 2;
elsif (rising_edge(clk_12megas)) then
    count_3megas <= next_count_3megas;
    count_en_4_ciclos <= next_count_en_4_ciclos;
end if;

end process;

-- lógica de estado siguiente
process(reset, current_state_en_2_ciclos, current_state_clk_3megas, count_en_4_ciclos)
begin

if (reset = '1') then
    
    next_state_clk_3megas <= '0';
    next_state_en_4_ciclos <= '0';
    next_state_en_2_ciclos <= '0';
    
else    
    next_state_en_2_ciclos <= not current_state_en_2_ciclos;
  
    if (count_3megas = 1) then
        next_state_clk_3megas <= not current_state_clk_3megas;
    end if;
    
    if (count_en_4_ciclos = 3) then
        next_state_en_4_ciclos <= '1';
    else 
        next_state_en_4_ciclos <= '0';
    end if;
end if;

end process;

-- lógica de cambio de estado
process(reset, clk_12megas)
begin
    
    if (reset = '1') then  
    current_state_clk_3megas <= '0';
    current_state_en_4_ciclos <= '0';
    current_state_en_2_ciclos <= '0';
    else
        if (rising_edge(clk_12megas)) then
    current_state_clk_3megas <= next_state_clk_3megas;
    current_state_en_4_ciclos <= next_state_en_4_ciclos;
    current_state_en_2_ciclos <= next_state_en_2_ciclos;
        end if;
    end if;
    
end process;

-- actualización de las salidas
clk_3megas <= current_state_clk_3megas;
en_4_ciclos <= current_state_en_4_ciclos;
en_2_ciclos <= current_state_en_2_ciclos;


end Behavioral;
