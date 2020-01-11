----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.01.2020 19:38:24
-- Design Name: 
-- Module Name: datapath - Behavioral
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

entity datapath is
  Port (
       clk : in STD_LOGIC;
    Reset : in STD_LOGIC;
    Sample_In : in signed (sample_size-1 downto 0);
    state : in unsigned (2 downto 0);
    filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
    Sample_Out : out signed (sample_size-1 downto 0)
 );
end datapath;

architecture Behavioral of datapath is

signal R1, R2, R3 : signed (((sample_size-1)*2-1) downto 0) := (others => '0');
signal next_R1, next_R2 : signed (((sample_size-1)*2-1) downto 0);

signal c0, c1, c2, c3, c4 : signed (sample_size-1 downto 0) := (others=>'0');
signal x0, x1, x2, x3, x4 : signed (sample_size-1 downto 0) := (others=>'0');
signal next_x0, next_x1, next_x2, next_x3, next_x4 : signed (sample_size-1 downto 0);

signal aux_Sample_Out :  signed (sample_size-1 downto 0) := (others =>'0');
signal last_aux_Sample_Out :  signed (sample_size-1 downto 0) := (others =>'0');

signal        sum_in0,sum_in1,sum_out :  signed (((sample_size-1)*2-1) downto 0);
signal        mul_in0,mul_in1,mul_out :  signed (((sample_size-1)*2-1) downto 0);


begin

filterselect_process: process(filter_select)
begin
if (filter_select='0') then
    c0 <= "00000101";
    c4 <= "00000101";
    c1 <= "00011111";
    c3 <= "00011111";
    c2 <= "00111001";
else
    c0 <= "11111111";
    c4 <= "11111111";
    c1 <= "11100110";
    c3 <= "11100110";
    c2 <= "01001101";
end if;
end process;

process(clk, reset)
begin
if (reset = '1') then
    x0 <= (others=>'0');
    x1 <= (others=>'0');
    x2 <= (others=>'0');
    x3 <= (others=>'0');
    x4 <= (others=>'0');
    
    R1 <= (others => '0');
    R2 <= (others => '0');
    R3 <= (others => '0');
elsif (clk'event and clk='1') then
    if (state="001") then
        x0 <= next_x0;
        x1 <= next_x1;
        x2 <= next_x2;
        x3 <= next_x3;
        x4 <= next_x4;
        

    end if;
    R1 <= next_R1;
    R2 <= next_R2;
    R3 <= mul_out;
    last_aux_Sample_Out <= aux_Sample_Out;
end if;
end process;

next_x4 <= x3;
next_x3 <= x2;
next_x2 <= x1;
next_x1 <= x0;
next_x0 <= Sample_In;   

sum_out <= sum_in0 + sum_in1;
mul_out <= to_signed ( to_integer(mul_in0) * to_integer(mul_in1) , mul_out'length);


with state select mul_in0 <=
	(((sample_size-1)*2-1) downto sample_size => C2(sample_size-1)) & C2 when "010",
	(((sample_size-1)*2-1) downto sample_size => C0(sample_size-1)) & C0 when "011",
	(((sample_size-1)*2-1) downto sample_size => C1(sample_size-1)) & C1 when "100",
    (others=>'0') when others;

with state select mul_in1 <=
    (((sample_size-1)*2-1) downto sample_size => X2(sample_size-1)) & x2 when "010",
    R2 when "011",
    R2 when "100",
    (others=>'0') when others;

with state select sum_in0 <=
    (((sample_size-1)*2-1) downto sample_size => x0(sample_size-1)) & x0 when "010",
    (((sample_size-1)*2-1) downto sample_size => x1(sample_size-1)) & x1 when "011",
    R1 when "101",
    R1 when "110",
    (others=>'0') when others;
        
with state select sum_in1 <=
    (((sample_size-1)*2-1) downto sample_size => x4(sample_size-1)) & x4 when "010",
    (((sample_size-1)*2-1) downto sample_size => x3(sample_size-1)) & x3 when "011",
    R2 when "101",
    R2 when "110",
    (others=>'0') when others;

with state select aux_Sample_Out <=
    R2(((sample_size-1)*2-1) downto sample_size) when "111",                         
    last_aux_Sample_Out when others;

    
with state select next_R1 <=
    (others=>'0') when "000",
    R1 when "010",
    R3 when "011",
    R1 when "100",
    R3 when "101",
    R3 when "110",
    (others=>'0') when others;
       
with state select next_R2 <=
    (others=>'0') when "000",
    sum_out when "010",
    sum_out when "011",
    R3 when "100",
    sum_out when "101",
    sum_out when "110",
    (others=>'0') when others;
             

Sample_Out <= aux_Sample_Out;

end Behavioral;
