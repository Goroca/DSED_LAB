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
signal Sample_In : signed (sample_size-1 downto 0) := (others=>'0');

-- Declaration of the writing signal
signal Sample_Out : signed (sample_size-1 downto 0);
signal int_Sample_Out : integer;

signal Reset : std_logic := '0';
signal filter_select : std_logic := '0';
signal Sample_In_enable : std_logic := '0';
signal Sample_Out_ready : std_logic;

signal start : std_logic := '1';
signal end_file : std_logic := '0';
signal end_count : unsigned(2 downto 0) := "000";

-- Clk period definition
constant CLK_PERIOD : time := 83 ns;

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

clk_process: process
begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
end process;



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

read_process: process(clk)
    file in_file : text open read_mode is "C:\Users\usuario\DSED_LAB\sample_in.dat";
    --file in_file : text open read_mode is "C:\Users\Carlos\Vivado-Workspace\DSED_LAB\sample_in.dat";

    variable in_line : line;
    variable in_int : integer;
    variable in_read_ok : boolean;
begin
    if (clk'event and clk=SAMPLE_CLK_EDGE) then
        if (not endfile(in_file) )then
            if(Sample_Out_ready='1'  or start ='1') then
            start<='0';
            ReadLine(in_file, in_line);
            Read(in_line, in_int, in_read_ok);
            Sample_In <= to_signed(in_int, sample_size); -- sample_size = the word width
            Sample_In_enable <= '1';
            
            else
                Sample_In_enable<='0';
            end if;
        else
            end_file <= '1';
        end if;
    end if;
end process;

end_process: process(clk, end_file)
begin
    if (clk'event and clk='1') then
        if (end_file = '1') then
            end_count <= end_count + 1;
        end if;
    end if;
    
end process;


write_process: process(clk, Sample_Out)
    file out_file : text open write_mode is "sample_out.dat";
    variable out_line : line;
begin
    int_Sample_Out <= to_integer(Sample_Out);
    if (clk'event and clk=SAMPLE_CLK_EDGE) then
        if (Sample_Out_Ready = '1') then   
            Write(out_line, int_Sample_Out);
            WriteLine(out_file, out_line);
            if (end_count = "110") then             -- La simulación termina cuando se ha procesado la última muestra (5 ciclos después de su lectura en sample_in.dat)
                assert false report "Simulation finished" severity failure;
            end if;
        end if;
    end if;
end process;    

end Behavioral;
