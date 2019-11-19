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
use work.package_dsed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm is
port(clk_12megas: in std_logic;
reset: in std_logic;
en_2_cycles: in std_logic;
sample_in: in std_logic_vector(sample_size-1 downto 0);
sample_request: out std_logic;
pwm_pulse: out std_logic
);
end pwm;


architecture Behavioral of pwm is
signal r_reg : unsigned (sample_size-1 downto 0);
signal r_next : unsigned (sample_size-1 downto 0);
signal buff:  std_logic;
signal next_buff:  std_logic;

begin

process(clk_12megas,reset)
begin
    if (reset ='1') then
        buff<='0';
        r_reg<= (others=>'0');
    elsif(clk_12megas'event and clk_12megas=SAMPLE_CLK_EDGE) then
        buff<=next_buff;
        r_reg<= r_next;
    end if;
end process;

r_next<=r_reg+1;

next_buff <= 
    '1' when (r_reg<unsigned(sample_in) or sample_in="0000000") else
    '0';
    
pwm_pulse<= buff;

end Behavioral;
