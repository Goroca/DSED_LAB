----------------------------------------------------------------------------------
-- Company: 
-- Engineer: CARLOS GÓMEZ and ALEJANDRO RAMOS
-- 
-- Create Date: 17.11.2019 19:56:31
-- Design Name: 
-- Module Name: pwm - Behavioral
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

entity pwm is
    port( clk_12megas: in std_logic;
          reset: in std_logic;
          en_2_cycles: in std_logic;
          sample_in: in std_logic_vector(sample_size-1 downto 0);
          sample_request: out std_logic;
          pwm_pulse: out std_logic;
          --VOLUMEN
          factor : in unsigned(8 downto 0) --<4,5>
          );
end pwm;


architecture Behavioral of pwm is
signal vol : unsigned (7 downto 0) := (others=>'0');
signal vol_aux : unsigned (16 downto 0) := (others=>'0');
signal r_reg : unsigned (sample_size downto 0) := (others => '0');
signal r_next : unsigned (sample_size downto 0);
signal aux_sample_request : std_logic := '0';
signal unsigned_sample_in : unsigned(sample_size-1 downto 0);
signal factor_div8 : unsigned(8 downto 0);

begin

process(clk_12megas,reset)
begin
    if (reset ='1') then
        r_reg <= (others=>'0');
    elsif(clk_12megas'event and clk_12megas = SAMPLE_CLK_EDGE) then
        if(en_2_cycles='1') then
             r_reg<= r_next;
        end if;
    end if;
end process;

process(r_reg)
begin
     if (r_reg >= MAX_PWM) then
         r_next<=(others=>'0');
     else
         r_next<=r_reg+1;
     end if;
end process;


unsigned_sample_in <= unsigned(sample_in);
vol_aux <= unsigned_sample_in*factor; --<8,0> * <4,5> = <12,5>   (vol_aux=sample_in*factor)

process(vol_aux)
begin
if(vol_aux > "1111111100000") then --255 in <7,5>
vol <= "11111111";
else
vol <= vol_aux(12 downto 5); --vol esta en <8,0> 
end if;
end process;

pwm_pulse <= '1' when(( r_reg < vol or sample_in="00000000") and reset ='0') else '0';

with r_reg select aux_sample_request <=
    en_2_cycles when MAX_PWM,
    '0' when others;

sample_request <= aux_sample_request;

end Behavioral;