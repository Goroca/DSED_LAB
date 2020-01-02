----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2019 19:57:33
-- Design Name: 
-- Module Name: controlador - Behavioral
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

entity controlador is
    Port ( clk_100Mhz : in std_logic;
           reset: in std_logic;
           --To/From the microphone
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           --To/From the mini-jack
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC);
end controlador;


architecture Behavioral of controlador is

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


component clk_12MHz
    port (
        clk_in1 : in std_logic;
        clk_out1 : out std_logic
    );
end component;

signal aux_clk_12MHz, aux_ready : STD_LOGIC;
signal aux_sample : STD_LOGIC_VECTOR(sample_size-1 downto 0);
signal aux_sample_out_ready, aux_sample_request : STD_LOGIC;

begin

U1: clk_12MHz
    port map (
        clk_in1 => clk_100Mhz,
        clk_out1 => aux_clk_12MHz
    );
    
U2: audio_interface
    port map ( 
        clk_12megas => aux_clk_12MHz,
        reset => reset,
        --Recording ports
        --To/From the controller
        record_enable => '1',
        sample_out => aux_sample,
        sample_out_ready => OPEN,
        --To/From the microphone
        micro_clk => micro_clk,
        micro_data => micro_data,
        micro_LR => micro_LR,
        --Playing ports
        --To/From the controller
        play_enable => '1',
        sample_in => aux_sample,
        sample_request => OPEN,
        --To/From the mini-jack
        jack_sd => jack_sd,
        jack_pwm => jack_pwm
    );
     
end Behavioral;
