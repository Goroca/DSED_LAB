----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.01.2020 21:09:18
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
signal state : unsigned (2 downto 0);

component datapath is
  Port (
       clk : in STD_LOGIC;
    Reset : in STD_LOGIC;
    Sample_In : in signed (sample_size-1 downto 0);
    state : in unsigned (2 downto 0);
    filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
    Sample_Out : out signed (sample_size-1 downto 0)
 );
end component;

component control is
Port ( 
       clk : in STD_LOGIC;
       Reset : in STD_LOGIC;
       Sample_In_enable : in STD_LOGIC;
       state:       out unsigned (2 downto 0);
       Sample_Out_ready : out STD_LOGIC
);
end component;

begin

 datos: datapath 
  Port Map(
       clk => clk,
    Reset => Reset,
    Sample_In => Sample_In,
    state => state,
    filter_select => filter_select,
    Sample_Out => Sample_Out
 );

ctr: control 
Port Map( 
       clk => clk,
       Reset => Reset,
       Sample_In_enable => Sample_In_enable,
       state => state,
       Sample_Out_ready => Sample_Out_ready
);

end Behavioral;
