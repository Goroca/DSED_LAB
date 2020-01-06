----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2019 18:30:09
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use work.package_dsed.all;

---- Uncomment the following library declaration if using
---- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx leaf cells in this code.
----library UNISIM;
----use UNISIM.VComponents.all;

--entity fir_filter is
--Port ( clk : in STD_LOGIC;
--Reset : in STD_LOGIC;
--Sample_In : in signed (sample_size-1 downto 0);
--Sample_In_enable : in STD_LOGIC;
--filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
--Sample_Out : out signed (sample_size-1 downto 0);
--Sample_Out_ready : out STD_LOGIC);
--end fir_filter;

--architecture Behavioral of fir_filter is

--signal aux_Sample_Out_ready : STD_LOGIC ;

--signal windows : STD_LOGIC ;
--signal count : unsigned (2 downto 0) := (others=> '0');

--signal c0,c1,c2,c3,c4 : signed (sample_size-1 downto 0);
--signal x0,x1,x2,x3,x4 : signed (sample_size-1 downto 0);
--signal next_x0,next_x1,next_x2,next_x3,next_x4 : signed (sample_size-1 downto 0);

--signal next_R1 :signed (sample_size-1 downto 0);
--signal R1 :signed (sample_size-1 downto 0);
--signal next_R2 :signed (sample_size-1 downto 0);
--signal R2 :signed (sample_size-1 downto 0);
--signal next_R3 :signed (sample_size-1 downto 0);
--signal R3 :signed (sample_size-1 downto 0);

--signal mul_in0 :signed (sample_size-1 downto 0);
--signal mul_in1 :signed (sample_size-1 downto 0);
--signal mul_out :signed (15 downto 0);


--signal sum_in0 :signed (sample_size-1 downto 0);
--signal sum_in1 :signed (sample_size-1 downto 0);
--signal sum_out :signed (sample_size-1 downto 0);

--begin

--Count_process: process (clk)
--begin
-- if (Reset = '1') then
--   count <= (others=>'0');
--  elsif(clk'event and clk=SAMPLE_CLK_EDGE and windows = '1') then
--    count<= count +1;
--end if;
--end process;
--Sample_process: process (clk,Reset)
--begin
-- if (Reset = '1') then
--    x0 <= (others=>'0');
--    x1 <= (others=>'0');
--    x2 <= (others=>'0');
--    x3 <= (others=>'0');
--    x4 <= (others=>'0');

-- elsif (clk'event and clk=SAMPLE_CLK_EDGE ) then
--    if (Sample_In_enable='1') then
--        windows <= '1';
--        x0 <= next_x0;
--        x1 <= next_x1;
--        x2 <= next_x2;
--        x3 <= next_x3;
--        x4 <= next_x4;    
--    elsif(count = "101") then
--        aux_Sample_Out_ready <= '1';
--        windows <= '0';
--     else
--        aux_Sample_Out_ready <= '0';
--    end if;    
-- end if;
--end process;

--next_x4 <= x3;
--next_x3 <= x2;
--next_x2 <= x1;
--next_x1 <= x0;
--next_x0 <= Sample_In;

--process(filter_select)
--begin
--if (filter_select='0') then
--    c0 <= "00000101";
--    c4 <= "00000101";
--    c1 <= "00011111";
--    c3 <= "00011111";
--    c2 <= "00111001";
--else
--    c0 <= "11111111";
--    c4 <= "11111111";
--    c1 <= "11100110";
--    c3 <= "11100110";
--    c2 <= "01001101";
--end if;

--end process;

--process (clk,Reset)
--begin
--    if (Reset = '1') then
--        R1 <= (others=>'0');
--        R2 <= (others=>'0');
--        R3 <= (others=>'0');

--    elsif (clk'event and clk=SAMPLE_CLK_EDGE and windows ='1') then
--        R1 <= next_R1;
--        R2 <= next_R2;
--        R3 <= next_R3;
--    end if;
    
--end process;

--sum_out <= sum_in0 + sum_in1;
--mul_out <= to_signed ( to_integer(mul_in0) * to_integer(mul_in1) , mul_out'length);
--R3 <= mul_out (7 + sample_size - 1  downto sample_size-1); 

--with count(1 downto 0) select mul_in0 <=
--	C2 when "00",
--	C0 when "01",
--	C1 when "10",
--	(others=>'0') when others;
	
--with count(1 downto 0) select mul_in1 <=
--    x2 when "00",
--    R2 when "01",
--    R2 when "10",
--    (others=>'0') when others;
        
--with count select sum_in0 <=
--    x0 when "000",
--    x1 when "001",
--    R1 when "011",
--    R1 when "100",
--    (others=>'0') when others;
        
--with count select sum_in1 <=
--    x4 when "000",
--    x3 when "001",
--    R2 when "011",
--    R2 when "100",
--    (others=>'0') when others;
        
--with count select next_R2 <=
--    sum_out when "000",
--    sum_out when "001",
--    R3      when "010",
--    sum_out when "100",
--    sum_out when "101",
--    (others=>'0') when others;
        
--with count(0 downto 0) select next_R1 <=
--    R1 when "0",
--    sum_out when "1",
--    (others=>'0') when others;

--Sample_out <= R2;
--Sample_Out_ready <=aux_Sample_Out_ready;                      
                                                          
--end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;


entity fir_filter is
    Port ( 
       clk : in STD_LOGIC;
       Reset : in STD_LOGIC;
       Sample_In : in signed (sample_size-1 downto 0);
       Sample_In_enable : in STD_LOGIC;
       filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
       Sample_Out : out signed (sample_size-1 downto 0);
       Sample_Out_ready : out STD_LOGIC
    );
end fir_filter;

architecture Behavioral of fir_filter is

component fir_multiplicador
    Port (
        mul_in0 : in signed (sample_size-1 downto 0);
        mul_in1 : in signed (sample_size-1 downto 0);
        mul_out : out signed (15 downto 0)
    );
end component;

component fir_sumador
    Port (
        sum_in0 : in signed (sample_size-1 downto 0);
        sum_in1 : in signed (sample_size-1 downto 0);
        sum_out : out signed (sample_size-1 downto 0)
    );
end component;

component fir_controlador
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        filter_select : in STD_LOGIC;
        Sample_In : in signed (sample_size-1 downto 0);
        Sample_In_enable : in STD_LOGIC;
        sum_out : in signed (sample_size-1 downto 0);
        sum_in0 : out signed (sample_size-1 downto 0);
        sum_in1 : out signed (sample_size-1 downto 0);
        mul_out : in signed (15 downto 0);
        mul_in0 : out signed (sample_size-1 downto 0);
        mul_in1 : out signed (sample_size-1 downto 0);
        Sample_Out : out signed (sample_size-1 downto 0);
        Sample_Out_ready : out STD_LOGIC
    );
end component;

signal aux_mul_in0, aux_mul_in1 : signed (sample_size-1 downto 0);
signal aux_mul_out : signed (15 downto 0);
signal aux_sum_in0, aux_sum_in1, aux_sum_out : signed (sample_size-1 downto 0);

begin

mult: fir_multiplicador
    port map (
        mul_in0 => aux_mul_in0,
        mul_in1 => aux_mul_in1,
        mul_out => aux_mul_out
    );
    
sum: fir_sumador
    port map (
        sum_in0 => aux_sum_in0,
        sum_in1 => aux_sum_in1,
        sum_out => aux_sum_out
    );

controlador: fir_controlador
    port map ( 
        clk => clk,
        reset => Reset,
        filter_select => filter_select,
        Sample_In => Sample_In,
        Sample_In_enable => Sample_In_enable,
        sum_out => aux_sum_out,
        sum_in0 => aux_sum_in0,
        sum_in1 => aux_sum_in1,
        mul_out => aux_mul_out,
        mul_in0 => aux_mul_in0,
        mul_in1 => aux_mul_in1,
        Sample_Out => Sample_Out,
        Sample_Out_ready => Sample_Out_ready
    );
    
end Behavioral;