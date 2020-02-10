----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
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
          pwm_pulse: out std_logic);
end pwm;


architecture Behavioral of pwm is

signal last_sample_request : std_logic := '0';
signal r_reg : unsigned (sample_size downto 0) := (others => '0');
signal r_next : unsigned (sample_size downto 0) := (others => '0');
signal buff:  std_logic := '0';
signal next_buff:  std_logic := '0';
constant MAX_CUENTA : unsigned(sample_size downto 0) := "100101011";

begin

process(clk_12megas,reset)
begin
    if (reset ='1') then
        buff<='0';
        r_reg<= (others=>'0');
        sample_request <= '0';
    elsif(clk_12megas'event and clk_12megas=SAMPLE_CLK_EDGE) then
        if(en_2_cycles='1') then
            if (sample_in = "00000000") then
                r_reg <= (others=>'0');
                buff <= '0';
            else
                buff<=next_buff;
                r_reg<= r_next;
            end if;
        end if;
        
        if (r_reg = MAX_CUENTA and last_sample_request = '0') then
            sample_request <= '1';
            last_sample_request <= '1';
        else
            sample_request <= '0';
            last_sample_request <= '0';
        end if;
    end if;
end process;

process(r_reg)
begin
     if (r_reg = 299) then
         r_next<=(others=>'0');
     else
         r_next<=r_reg+1;
     end if;
end process;

next_buff <= 
    '1' when (r_reg<unsigned(sample_in) or sample_in="00000000") else
    '0';
    
pwm_pulse<= buff;

end Behavioral;