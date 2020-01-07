----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.01.2020 17:08:23
-- Design Name: 
-- Module Name: fir_filter_tb - Behavioral
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
use STD.TEXTIO.ALL;
use work.package_dsed.all;

entity fir_filter_tb is
--  Port ( );
end fir_filter_tb;

architecture Behavioral of fir_filter_tb is

-- Clk signal declaration
signal clk : std_logic := '0';

-- Declaration of the reading signal
signal Sample_In : signed (sample_size-1 downto 0);

-- Declaration of the writing signal
signal Sample_Out : signed (sample_size-1 downto 0);
signal int_Sample_Out : integer;

signal Reset : std_logic := '0';
signal filter_select : std_logic := '0';
signal Sample_In_enable : std_logic := '1';
signal Sample_Out_ready : std_logic;

-- Clk period definition
constant clk_period : time := 83 ns;

component fir_filter
    Port ( 
       clk : in STD_LOGIC;
       Reset : in STD_LOGIC;
       Sample_In : in signed (sample_size-1 downto 0);
       Sample_In_enable : in STD_LOGIC;
       filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
       Sample_Out : out signed (sample_size-1 downto 0);
       Sample_Out_ready : out STD_LOGIC
    );
end component;

begin

-- Clock statement
clk <= not clk after clk_period/2;

UUT: fir_filter
    port map (
        clk => clk,
        Reset => Reset,
        Sample_In => Sample_In,
        Sample_In_enable => Sample_In_enable,
        filter_select => filter_select,
        Sample_Out => Sample_Out,
        Sample_Out_ready => Sample_Out_ready
    );

--reset_process: process
--begin
--    Reset <= '1';
--    wait for 50 ns;
--    Reset <= '0';
--    wait;
--end process;

read_process: process(clk)
    file in_file : text open read_mode is "C:\Users\usuario\DSED_LAB\sample_in.dat";
    variable in_line : line;
    variable in_int : integer;
    variable in_read_ok : boolean;
begin
    if (clk'event and clk='1') then
        if not endfile(in_file) then
            ReadLine(in_file, in_line);
            Read(in_line, in_int, in_read_ok);
            Sample_In <= to_signed(in_int, 8); -- 8 = the word width
        else
            assert false report "Simulation finished" severity failure;
        end if;
    end if;
end process;

write_process: process(clk, Sample_Out)
    file out_file : text open write_mode is "sample_out.dat";
    variable out_line : line;
begin
    int_Sample_Out <= to_integer(Sample_Out);
    if (clk'event and clk='0') then   
        Write(out_line, int_Sample_Out);
        WriteLine(out_file, out_line);
    end if;
end process;    

end Behavioral;
