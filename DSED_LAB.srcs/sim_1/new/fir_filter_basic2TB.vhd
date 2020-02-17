----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.01.2020 19:41:05
-- Design Name: 
-- Module Name: fir_filter_basic2TB - Behavioral
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

entity fir_filter_basic2TB is
--  Port ( );
end fir_filter_basic2TB;

architecture Behavioral of fir_filter_basic2TB is
constant clk_period : time := 83 ns;

       signal clk :  STD_LOGIC;
       signal Reset :  STD_LOGIC :='0';
       signal Sample_In :  signed (sample_size-1 downto 0) := (others=>'0');
       signal Sample_In_enable :  STD_LOGIC:= '0';
       signal filter_select:  STD_LOGIC :='0'; --0 lowpass, 1 highpass
       signal Sample_Out :  signed (sample_size-1 downto 0);
       signal Sample_Out_ready :  STD_LOGIC;





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
    
    
-- CLK process definition (50% duty cycle)
clk_process: process
begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
end process;

process
begin
wait for 83ns;
Sample_In <= "00000000";
Sample_In_enable <= '1';
wait for 83ns;
Sample_In_enable <= '0';
wait for 83*7ns;


Sample_In <= "01000000";
Sample_In_enable <= '1';
wait for 83ns;
Sample_In_enable <= '0';
wait for 83*7ns;


Sample_In <= "00000000";
Sample_In_enable <= '1';
wait for 83ns;
Sample_In_enable <= '0';
wait for 83*7ns;

--Sample_In <= "00010000";
Sample_In <= "00000000";
Sample_In_enable <= '1';
wait for 83ns;
Sample_In_enable <= '0';
wait for 83*7ns;

Sample_In <= "00000000";
Sample_In_enable <= '1';
wait for 83ns;
Sample_In_enable <= '0';
wait for 83*7ns;


Sample_In <= "00000000";
Sample_In_enable <= '1';
wait for 83ns;
Sample_In_enable <= '0';
wait for 83*7ns;


Sample_In <= "00000000";
Sample_In_enable <= '1';
wait for 83ns;
Sample_In_enable <= '0';
wait for 83*6ns;


Sample_In <= "00000000";
Sample_In_enable <= '1';
wait for 83ns;
Sample_In_enable <= '0';


wait for 20000ns;
end process;

end Behavioral;