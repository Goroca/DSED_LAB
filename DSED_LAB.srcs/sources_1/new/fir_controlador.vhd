----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2020 17:00:09
-- Design Name: 
-- Module Name: fir_controlador - Behavioral
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


entity fir_controlador is
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
end fir_controlador;

architecture Behavioral of fir_controlador is

signal state, next_state : unsigned (2 downto 0) := (others=>'0');
signal R1, R2, R3 : signed (sample_size-1 downto 0) := (others => '0');
signal next_R1, next_R2, next_R3 : signed (sample_size-1 downto 0) := (others => '0');

signal c0, c1, c2, c3, c4 : signed (sample_size-1 downto 0) := (others=>'0');
signal x0, x1, x2, x3, x4 : signed (sample_size-1 downto 0) := (others=>'0');
signal next_x0, next_x1, next_x2, next_x3, next_x4 : signed (sample_size-1 downto 0) := (others=>'0');

signal windows : STD_LOGIC := '0';
signal first_cycle : STD_LOGIC := '1';
signal aux_Sample_Out_ready : STD_LOGIC := '0';

begin

-- lógica de entrada
process(clk, reset)
begin
if (reset = '1') then
    first_cycle <= '1';
    x0 <= (others=>'0');
    x1 <= (others=>'0');
    x2 <= (others=>'0');
    x3 <= (others=>'0');
    x4 <= (others=>'0');
elsif (clk'event and clk='1') then
    if (Sample_In_enable='1') then
        first_cycle <= '0';
        windows <= '1';
        x0 <= next_x0;
        x1 <= next_x1;
        x2 <= next_x2;
        x3 <= next_x3;
        x4 <= next_x4;
    end if;
    
    if (state = "101") then
        aux_Sample_Out_ready <= '1';
        windows <= '0';
    else
        aux_Sample_Out_ready <= '0';
    end if;
    
end if;
end process;

process(clk, reset)
begin
if (reset = '1') then
    R1 <= (others => '0');
    R2 <= (others => '0');
    R3 <= (others => '0');
    
    state <= (others => '0');
    
elsif (clk'event and clk='1' and windows='1') then
        
    state <= next_state;
    
    R1 <= next_R1;
    R2 <= next_R2;
    R3 <= next_R3;
end if;
end process;

process(filter_select)
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

-- lógica de cambio de estado
process(Sample_In)
begin
    if (first_cycle='1') then
        next_x4 <= x4;
        next_x3 <= x3;
        next_x2 <= x2;
        next_x1 <= x1;
        next_x0 <= x0;
    else
        next_x4 <= x3;
        next_x3 <= x2;
        next_x2 <= x1;
        next_x1 <= x0;
        next_x0 <= Sample_In;
    end if;
end process;

process(reset,state,windows,state,R1,R2,R3)
begin
if (reset = '1') then
    next_state <= (others=>'0');
    next_R1 <= (others=>'0');
    next_R2 <= (others=>'0');
    next_R3 <= (others=>'0');
elsif (windows = '1') then

    next_state <= state + 1;

    next_R3 <= mul_out (7 + sample_size - 1  downto sample_size-1);

    case(state) is
        when "000" =>
            next_R1 <= R1;
            next_R2 <= sum_out;
            if (first_cycle='1') then
                next_R2 <= (others=>'0');
                next_R3 <= (others=>'0');
            end if;
        when "001" =>
            next_R1 <= R3;
            next_R2 <= sum_out;     
        when "010" =>
            next_R1 <= R1;   
            next_R2 <= R3;
        when "011" =>
            next_R1 <= R3;
            next_R2 <= sum_out;
        when "100" =>
            next_R2 <= sum_out;
        when "101" =>
            next_R1 <= R3;
            next_R2 <= sum_out;
            next_state <= (others => '0');
        when others =>
            next_R1 <= (others=>'0');
            next_R2 <= (others=>'0');  
    end case;
end if;
end process;

-- lógica de salida
Sample_Out <= R2;
Sample_Out_ready <= aux_Sample_Out_ready;

with state select mul_in0 <=
	C2 when "000",
	C0 when "001",
	C1 when "010",
    (others=>'0') when others;

with state select mul_in1 <=
    x2 when "000",
    R2 when "001",
    R2 when "010",
    (others=>'0') when others;

with state select sum_in0 <=
    x0 when "000",
    x1 when "001",
    R1 when "011",
    R1 when "100",
    (others=>'0') when others;
        
with state select sum_in1 <=
    x4 when "000",
    x3 when "001",
    R2 when "011",
    R2 when "100",
    (others=>'0') when others;

end Behavioral;
