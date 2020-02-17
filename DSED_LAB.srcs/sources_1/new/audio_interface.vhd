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
           micro_LR : out STD_LOGIC := '0';
           --Playing ports
   
           --To/From the controller
           play_enable: in STD_LOGIC;
           sample_in: in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_request: out STD_LOGIC;
           --To/From the mini-jack
           jack_sd : out STD_LOGIC := '1';
           jack_pwm : out STD_LOGIC);
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
           pwm_pulse: out std_logic);
end component;

-- señales auxiliares
signal aux_en_2_ciclos, aux_en_4_ciclos : STD_LOGIC;


--record
signal aux_sample_out:  STD_LOGIC_VECTOR (sample_size-1 downto 0);
signal aux_sample_out_ready:  STD_LOGIC;

--play
signal aux_sample_request : STD_LOGIC;
signal aux_sample_in : std_logic_vector(sample_size-1 downto 0);

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
        enable_4_cycles => aux_en_4_ciclos,
        micro_data => micro_data,
        sample_out => aux_sample_out, 
        sample_out_ready => aux_sample_out_ready);

audio: pwm
    port map(
        clk_12megas => clk_12megas,
        reset => reset,
        en_2_cycles => aux_en_2_ciclos,
        sample_in => aux_sample_in, 
        sample_request => aux_sample_request,
        pwm_pulse => jack_pwm);
        
        
process (record_enable,play_enable,aux_sample_out,sample_in,aux_sample_request)
begin

  if (record_enable ='0') then
    sample_out <= (others => '0');
    sample_out_ready <= '0'; 
  else
    sample_out_ready <= aux_sample_out_ready;
    sample_out <= aux_sample_out;   
  end if;

  if(play_enable='0') then
    aux_sample_in <= aux_sample_out; --Para desabilitar poner: (others=>'0')
    sample_request <= '0';     
  else
    aux_sample_in <= sample_in;
    sample_request <= aux_sample_request;      
  end if;
  
end process;


end Behavioral;