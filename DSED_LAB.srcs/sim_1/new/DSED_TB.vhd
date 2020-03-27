----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2020 21:54:44
-- Design Name: 
-- Module Name: DSED_TB - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DSED_TB is
--  Port ( );
end DSED_TB;

architecture Behavioral of DSED_TB is

component dsed_audio 
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
end component;

signal clk_100Mhz : std_logic :='0';
signal reset: std_logic :='0';
--Control ports
signal BTNL: STD_LOGIC :='0';
signal BTNC: STD_LOGIC :='0';
signal BTNR: STD_LOGIC :='0';

signal SW0: STD_LOGIC :='0';
signal SW1: STD_LOGIC :='0';
--To/From the microphone
signal micro_clk : STD_LOGIC :='0';
signal micro_data : STD_LOGIC :='0';
signal micro_LR : STD_LOGIC :='0';
--To/From the mini-jack
signal jack_sd : STD_LOGIC :='0';
signal jack_pwm : STD_LOGIC :='0';
--LEDS
signal led_record : STD_LOGIC :='0';
signal led_play : STD_LOGIC :='0';

constant CLK_PERIOD : time := 10 ns;

begin

MODULE: dsed_audio 
Port Map(
clk_100Mhz => clk_100Mhz, --: in std_logic;
reset => reset,--: in std_logic;
--Control ports
BTNL => BTNL,--: in STD_LOGIC;
BTNC => BTNC,--: in STD_LOGIC;
BTNR => BTNR,--: in STD_LOGIC;

SW0 => SW0,--: in STD_LOGIC;
SW1 => SW1,--: in STD_LOGIC;
--To/From the microphone
micro_clk => micro_clk, --: out STD_LOGIC;
micro_data => micro_data, --: in STD_LOGIC;
micro_LR => micro_LR, --: out STD_LOGIC;
--To/From the mini-jack
jack_sd => jack_sd, --: out STD_LOGIC;
jack_pwm => jack_pwm, --: out STD_LOGIC;
--LEDS
led_record => led_record, --: out STD_LOGIC;
led_play => led_play--: out STD_LOGIC
);

clk_process: process
begin
    clk_100Mhz <= '0';
    wait for CLK_PERIOD/2;
    clk_100Mhz <= '1';
    wait for CLK_PERIOD/2;
end process;

process
begin
    
    BTNL <= '1';
    for i in 0 to 40 loop
    wait for 200 us;
    micro_data <= '1';
    wait for 200 us;
    micro_data <= '0';
    wait for 200 us;
    micro_data <= '1';
    wait for 200 us;
    micro_data <= '1';
    wait for 200 us;
    micro_data <= '0';
    wait for 200 us;
    micro_data <=  '1';
    wait for 200 us;
    micro_data <=  '1';
    wait for 200 us;
    micro_data <= '0';
    wait for 200 us;
    micro_data <=  '1';
    wait for 200 us;
    micro_data <= '0';
    wait for 200 us;
    micro_data <= '0';
    wait for 200 us;
    micro_data <=  '1';
            
    END LOOP;        
        
    
    
    BTNL <= '0'; 
    SW0 <= '1';
    SW1 <= '1';
    wait for 10 ms;
    BTNR <= '1';
    wait for 15 ms;
    BTNR <= '0';   
    wait;           
    
    
    
end process;

end Behavioral;
