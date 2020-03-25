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
jack_pwm : out STD_LOGIC;
--LEDS
led_record : out STD_LOGIC;
led_play : out STD_LOGIC
);
end dsed_audio;

architecture Behavioral of dsed_audio is


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
    rsta : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
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

component control_system
    Port ( clk_12MHz : in STD_LOGIC;
           reset : in STD_LOGIC;
           
           SW0 : in STD_LOGIC;
           SW1 : in STD_LOGIC;
           
           BTNL : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNR : in STD_LOGIC;
                      
           play_en : out STD_LOGIC;
           record_en : out STD_LOGIC;
           
           --FILTER         
           filter_select      : out STD_LOGIC;
           filter_in          : out signed (sample_size-1 downto 0);
           filter_In_enable   : out STD_LOGIC;
           filter_out         : in signed (sample_size-1 downto 0);          
           filter_Out_ready   : in STD_LOGIC;
           
           --RAM
           ADDR : out STD_LOGIC_VECTOR(18 DOWNTO 0);
           DATA_IN : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           DATA_OUT : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           reset_RAM : out STD_LOGIC;
           EN_RAM : out STD_LOGIC;
           ENW_RAM : out STD_LOGIC_VECTOR (0 downto 0);
           
           --PWM
           sample_in: out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_request: in STD_LOGIC;
           
           --FSMD
           sample_out: in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready: in STD_LOGIC;
           
           --LEDS
           led_record : out STD_LOGIC;
           led_play : out STD_LOGIC);
end component;


  signal   clk_system :  std_logic;
  signal   rst_RAM :  std_logic;
  signal   aux_DATA_IN, aux_DATA_OUT: std_logic_vector(sample_size-1 downto 0);
  signal   aux_ADDR : std_logic_vector(18 downto 0);
  signal   aux_EN_RAM  : std_logic;
  signal   aux_ENW_RAM : std_logic_vector(0 downto 0);
  signal   aux_play_en, aux_record_en : std_logic;
  
  signal   aux_sample_in, aux_sample_out : std_logic_vector(sample_size-1 downto 0);
  signal   aux_sample_request, aux_sample_out_ready : std_logic;
  
  --FILTER
  signal filter_select      :  STD_LOGIC;
  signal filter_in          :  signed (sample_size-1 downto 0);
  signal filter_In_enable   :  STD_LOGIC;
  signal filter_out         :  signed (sample_size-1 downto 0);     
  signal filter_Out_ready   :  STD_LOGIC;

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
           record_enable => aux_record_en,--aux_record_en,          
           sample_out => aux_sample_out,--: out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready => aux_sample_out_ready,--: out STD_LOGIC;
           --To/From the microphone
           micro_clk => micro_clk, --: out STD_LOGIC;
           micro_data => micro_data,--: in STD_LOGIC;
           micro_LR => micro_LR,--: out STD_LOGIC;
           --Playing ports
           --To/From the controller
           play_enable => aux_play_en,--aux_play_en, --: in STD_LOGIC;
           sample_in => aux_sample_in, --: in std_logic_vector(sample_size-1 downto 0);
           sample_request => aux_sample_request, --: out std_logic;
           --To/From the mini-jack
           jack_sd => jack_sd,--: out STD_LOGIC;
           jack_pwm => jack_pwm --: out STD_LOGIC
           );

FILTER: fir_filter 
    Port Map( 
   clk                =>  clk_system,--: in STD_LOGIC;
   Reset              =>  reset,--: in STD_LOGIC;
   Sample_In          =>  filter_in,--: in signed (sample_size-1 downto 0);
   Sample_In_enable   =>  filter_In_enable,--: in STD_LOGIC;
   filter_select      =>  filter_select,--: in STD_LOGIC; --0 lowpass, 1 highpass
   Sample_Out         =>  filter_out,--: out signed (sample_size-1 downto 0);
   Sample_Out_ready   =>  filter_Out_ready--: out STD_LOGIC
);

MEMORY:  blk_mem_gen_0
  PORT Map(
    clka   => clk_system,    --: IN STD_LOGIC;
    rsta   => rst_RAM,--: IN STD_LOGIC;
    ena    => aux_EN_RAM,     --: IN STD_LOGIC;
    wea    => aux_ENW_RAM,     --: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra  => aux_ADDR,     --: IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    dina   => aux_DATA_IN,     --: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta  => aux_DATA_OUT     --: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
  
 controller: control_system
      Port Map ( clk_12MHz => clk_system,           --: in STD_LOGIC;
             reset => reset,                     --: in STD_LOGIC;
             
             SW0 => SW0,                       --: in STD_LOGIC;
             SW1 => SW1,                       --: in STD_LOGIC;
             
             BTNL => BTNL,                      --: in STD_LOGIC;
             BTNC => BTNC,                      --: in STD_LOGIC;
             BTNR => BTNR,                      --: in STD_LOGIC;
                        
             play_en => aux_play_en,                   --: out STD_LOGIC;
             record_en => aux_record_en,                 --: out STD_LOGIC;
             
             --FILTER         
             filter_select => filter_select,             --: out STD_LOGIC;
             filter_in => filter_in,                 --: out signed (sample_size-1 downto 0);
             filter_In_enable => filter_In_enable ,                  --: out STD_LOGIC;
             filter_out => filter_out,                --: in signed (sample_size-1 downto 0);          
             filter_Out_ready  => filter_Out_ready   ,              --: in STD_LOGIC;
           
             --RAM
             ADDR => aux_ADDR,                      --: out STD_LOGIC_VECTOR(18 DOWNTO 0);
             DATA_IN => aux_DATA_IN,                   --: out STD_LOGIC_VECTOR (sample_size-1 downto 0);
             DATA_OUT => aux_DATA_OUT,                  --: in STD_LOGIC_VECTOR (sample_size-1 downto 0);
             reset_RAM => rst_RAM,                 --: out STD_LOGIC;
             EN_RAM => aux_EN_RAM,                    --: out STD_LOGIC;
             ENW_RAM => aux_ENW_RAM,                   --: out STD_LOGIC_VECTOR (0 downto 0);
             
             --PWM
             sample_in => aux_sample_in,                 --: out STD_LOGIC_VECTOR (sample_size-1 downto 0);
             sample_request => aux_sample_request,            --: in STD_LOGIC;
             
             --FSMD
             sample_out => aux_sample_out,                --: in STD_LOGIC_VECTOR (sample_size-1 downto 0);
             sample_out_ready => aux_sample_out_ready,          --: in STD_LOGIC);
             --LEDS
             led_record => led_record,--: out STD_LOGIC;
             led_play => led_play); --: out STD_LOGIC); 
 end Behavioral;
