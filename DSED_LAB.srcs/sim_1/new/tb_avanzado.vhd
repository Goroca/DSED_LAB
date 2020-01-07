----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.01.2020 23:54:07
-- Design Name: 
-- Module Name: tb_avanzado - Behavioral
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


entity tb_avanzado is
--  Port ( );
end tb_avanzado;

architecture Behavioral of tb_avanzado is

-- Clk signal declaration
signal clk : std_logic := '0';

-- Declaration of the reading signal
signal sample_in : signed (sample_size-1 downto 0);

-- Declaration of the writing signal
signal sample_out : integer;

-- Clk period definition
constant clk_period : time := 83 ns;

begin

-- Clock statement
clk <= not clk after clk_period/2;

read_process: process(clk)
    file in_file : text open read_mode is "C:\Users\usuario\DSED_LAB\DSED_LAB.srcs\sim_1\sample_in.dat";
    variable in_line : line;
    variable in_int : integer;
    variable in_read_ok : boolean;
begin
    if (clk'event and clk='1') then
        if not endfile(in_file) then
            ReadLine(in_file, in_line);
            Read(in_line, in_int, in_read_ok);
            sample_in <= to_signed(in_int, 8); -- 8 = the word width
        else
            assert false report "Simulation finished" severity failure;
        end if;
    end if;
end process;

write_process: process(clk, sample_in)
    file out_file : text open write_mode is "sample_out.dat";
    variable out_line : line;
begin
    sample_out <= to_integer(sample_in);
    if (clk'event and clk='0') then   
        Write(out_line, sample_out);
        WriteLine(out_file, out_line);
    end if;
end process;


end Behavioral;
