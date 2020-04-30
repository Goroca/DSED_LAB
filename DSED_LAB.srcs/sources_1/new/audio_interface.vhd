----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2019 19:58:24
-- Design Name: 
-- Module Name: audio_interface - Behavioral
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

entity audio_interface is
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
           micro_LR : out STD_LOGIC := '1';
           --Playing ports
   
           --To/From the controller
           play_enable: in STD_LOGIC;
           sample_in: in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_request: out STD_LOGIC;
           --To/From the mini-jack
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC;
           --VOLUMEN
           SW14 : in STD_LOGIC;
           SW15 : in STD_LOGIC;
           level : out unsigned(4 downto 0)         
           );
end audio_interface;

architecture Behavioral of audio_interface is

    
component en_4_cycles
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end component;

component FSMD_microphone
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC);
end component;

component pwm
    Port(  clk_12megas: in std_logic;
           reset: in std_logic;
           en_2_cycles: in std_logic;
           sample_in: in std_logic_vector(sample_size-1 downto 0);
           sample_request: out std_logic;
           pwm_pulse: out std_logic;
           --VOLUMEN
           factor : in unsigned(7 downto 0)
           );
end component;

component volume is
    Port (   
           clk_12MHz : in std_logic;
           reset : in std_logic;
           SW15 : in STD_LOGIC;
           SW14 : in STD_LOGIC;
           factor : out unsigned(7 downto 0);
           level : out unsigned(4 downto 0)
           );
end component;

-- señales auxiliares
signal aux_en_2_ciclos, aux_en_4_ciclos : STD_LOGIC;

--record
signal aux_sample_out:  STD_LOGIC_VECTOR (sample_size-1 downto 0);


signal enable_FSMD, enable_PWM : std_logic;        

signal factor : unsigned(7 downto 0);        


begin
  
-- Unities declaration
enable: en_4_cycles
    port map(
        clk_12megas => clk_12megas,
        reset => reset,
        clk_3megas => micro_clk,
        en_2_cycles => aux_en_2_ciclos,
        en_4_cycles => aux_en_4_ciclos);

microphone: FSMD_microphone
    port map(
        clk_12megas => clk_12megas,
        reset => reset,
        enable_4_cycles => enable_FSMD, 
        micro_data => micro_data,
        sample_out => aux_sample_out, 
        sample_out_ready => sample_out_ready);

audio: pwm
    port map(
        clk_12megas => clk_12megas,
        reset => reset,
        en_2_cycles => enable_PWM,
        sample_in => sample_in,
        sample_request => sample_request,
        pwm_pulse => jack_pwm,
        --VOLUMEN
        factor => factor -- in unsigned(7 downto 0)
        );
        
control_volume: volume 
    Port Map(   
        clk_12MHz => clk_12megas, --: in std_logic;
        reset => reset,  --: in std_logic;
        SW15 => SW15, --: in STD_LOGIC;
        SW14 =>SW14, --: in STD_LOGIC;
        factor => factor,--: out unsigned(7 downto 0)
        level => level --: out unsigned(4 downto 0)
        );
enable_FSMD <= aux_en_4_ciclos and record_enable;
enable_PWM <= aux_en_2_ciclos and play_enable;

sample_out <= aux_sample_out;
jack_sd <= AUDIO_OP_CONTROL;
end Behavioral;