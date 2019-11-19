library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package package_dsed is

-- AUDIO INTERFACE CONSTANTS
constant sample_size: integer := 8;
constant AUDIO_OP_CONTROL : STD_LOGIC := '1'; -- info de control para los operacionales de la etapa de audio mono
constant SAMPLE_CLK_EDGE : STD_LOGIC := '1';  -- determina que el muestreo se realiza en los flancos de subida del reloj

end package_dsed;
