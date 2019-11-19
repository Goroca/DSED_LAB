----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.11.2019 09:31:47
-- Design Name: 
-- Module Name: audio_interface_tb - Behavioral
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

entity audio_interface_tb is
--  Port ( );
end audio_interface_tb;

architecture Behavioral of audio_interface_tb is

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

-- señales de testing de entrada
signal clk_12megas, reset : STD_LOGIC := '0';
signal record_enable : STD_LOGIC := '0';
signal micro_data : STD_LOGIC := '0';
signal play_enable : STD_LOGIC := '0';
signal sample_in : STD_LOGIC_VECTOR(sample_size-1 downto 0) := (others => '0');

-- señales de testing de salida
signal sample_out : STD_LOGIC_VECTOR (sample_size-1 downto 0);
signal sample_out_ready : STD_LOGIC;
signal micro_clk, micro_LR : STD_LOGIC;
signal sample_request : STD_LOGIC;
signal jack_sd, jack_pwm : STD_LOGIC;

-- CLK period definition
constant CLK_PERIOD : time := 83 ns;

begin

-- UUT declaration
UUT: audio_interface
    port map(
        clk_12megas => clk_12megas,
        reset => reset,
        record_enable => record_enable,
        sample_out => sample_out,
        sample_out_ready => sample_out_ready,
        micro_clk => micro_clk,
        micro_data => micro_data,
        micro_LR => micro_LR,
        play_enable => play_enable,
        sample_in => sample_in,
        sample_request => sample_request,
        jack_sd => jack_sd,
        jack_pwm => jack_pwm);
        
-- CLK process definition (50% duty cycle)
clk_process: process
begin
    clk_12megas <= '0';
    wait for CLK_PERIOD/2;
    clk_12megas <= '1';
    wait for CLK_PERIOD/2;
end process;
        
-- Stimulus process
stim_process: process
begin
    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait;
end process;


end Behavioral;
