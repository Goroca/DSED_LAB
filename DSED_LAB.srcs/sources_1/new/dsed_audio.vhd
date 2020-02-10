----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2020 15:34:20
-- Design Name: 
-- Module Name: dsed_audio - Behavioral
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

entity dsed_audio is
Port (
clk_100Mhz : in std_logic;
reset: in std_logic;
--Control ports
BTNL: in STD_LOGIC;
BTNC: in STD_LOGIC;
BTNR: in STD_LOGIC;

SW0: in STD_LOGIC;
SW1: in STD_LOGIC;
--To/From the microphone
micro_clk : out STD_LOGIC;
micro_data : in STD_LOGIC;
micro_LR : out STD_LOGIC;
--To/From the mini-jack
jack_sd : out STD_LOGIC;
jack_pwm : out STD_LOGIC
);
end dsed_audio;

architecture Behavioral of dsed_audio is
 signal   clk_system :  std_logic;

component clk_12MHz
    port (
        clk_in1 : in std_logic;
        clk_out1 : out std_logic
    );
end component;

component audio_interface
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           --Recording ports
           --To/From the controller
           record_enable: in STD_LOGIC;
           sample_out: out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready: out STD_LOGIC;
           --To/From the microphone
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           --Playing ports
           --To/From the controller
           play_enable: in STD_LOGIC;
           sample_in: in std_logic_vector(sample_size-1 downto 0);
           sample_request: out std_logic;
           --To/From the mini-jack
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC);
end component;

component blk_mem_gen_0 
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;

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
CLK: clk_12MHz
    port map(
        clk_in1 => clk_100Mhz,
        clk_out1 => clk_system
    );

audio: audio_interface
    Port Map( clk_12megas => clk_system,
           reset => reset,
           --Recording ports
           --To/From the controller
           record_enable => '0',             -- Cambiar
           sample_out => open,--: out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready => open,--: out STD_LOGIC;
           --To/From the microphone
           micro_clk => open, --: out STD_LOGIC;
           micro_data => micro_data,--: in STD_LOGIC;
           micro_LR => micro_LR,--: out STD_LOGIC;
           --Playing ports
           --To/From the controller
           play_enable => '0', --: in STD_LOGIC;
           sample_in => (others=>('0')), --: in std_logic_vector(sample_size-1 downto 0);
           sample_request => open, --: out std_logic;
           --To/From the mini-jack
           jack_sd => jack_sd,--: out STD_LOGIC;
           jack_pwm => jack_pwm --: out STD_LOGIC
           );

end Behavioral;
