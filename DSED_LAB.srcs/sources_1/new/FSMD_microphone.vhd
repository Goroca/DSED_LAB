----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2019 15:50:32
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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

entity FSMD_microphone is
Port ( clk_12megas : in STD_LOGIC;
reset : in STD_LOGIC;
enable_4_cycles : in STD_LOGIC;
micro_data : in STD_LOGIC;
sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is

type state_type is (S0,S1,S2,S3,S4);
signal state, next_state : state_type;

signal next_cicle : unsigned (8 downto 0):= to_unsigned(0,9);
signal cicle :      unsigned (8 downto 0):= to_unsigned(0,9);

--Numero unos
signal count1 : unsigned (sample_size-1 downto 0) := to_unsigned(0,sample_size);
signal count2 : unsigned (sample_size-1 downto 0) := to_unsigned(0,sample_size);
signal next_count1 : unsigned (sample_size-1 downto 0) := to_unsigned(0,sample_size);
signal next_count2 : unsigned (sample_size-1 downto 0) := to_unsigned(0,sample_size);
signal aux_count1 : unsigned (sample_size-1 downto 0) := to_unsigned(0,sample_size);
signal aux_count2 : unsigned (sample_size-1 downto 0) := to_unsigned(0,sample_size);
signal aux_micro_data : unsigned (0 downto 0);

signal aux_sample_out : STD_LOGIC_VECTOR (sample_size-1 downto 0);
signal aux_sample_out_ready : STD_LOGIC;

begin

process (clk_12megas,reset)
begin
if reset = '1' then
count1<= to_unsigned(0,sample_size);
count2<= to_unsigned(0,sample_size);
cicle<= to_unsigned(0,9);
state<=S0;
elsif (clk_12megas'event and clk_12megas=SAMPLE_CLK_EDGE) then
    if(enable_4_cycles='1') then
        count1<= next_count1+1;
        count2<= next_count2+1;
        state<=next_state;
        cicle<= next_cicle;      
    end if;
end if;
end process;

process(cicle)
begin
if(cicle = 299) then
next_cicle <= to_unsigned(0,9);
else 
next_cicle<= cicle +1;
end if;
end process;

NEXT_STATE_DECODE : process (state,cicle,reset)
begin
next_state <= S0;
    case(state) is
        when S0 =>
            if (reset='1') then
              next_state<=S0;
              aux_sample_out_ready<='0';
            else
              next_state<=S1;
              aux_sample_out_ready<='0';
            end if;
         when S1 =>
            if (reset='1') then
              next_state<=S0;
              aux_sample_out_ready<='0';
            elsif(cicle>105) then
              next_state<=S2;
              aux_sample_out_ready<='1';
            else
              next_state<=S1;
              aux_sample_out_ready<='0';
          end if;
          
          when S2=>
            if (reset='1') then
              next_state<=S0;
              aux_sample_out_ready<='0';
            elsif(cicle>149) then
              next_state<=S3;
              aux_sample_out_ready<='0';
            else
              next_state<=S2;
              aux_sample_out_ready<='0';
            end if;                
          
          when S3=>
            if (reset='1') then
              next_state<=S0;
              aux_sample_out_ready<='0';
            elsif(cicle>255) then
              next_state<=S4;
              aux_sample_out_ready<='1';
            else
              next_state<=S3;
              aux_sample_out_ready<='0';
            end if;
            
          when others => 
            if (reset='1') then
              next_state<=S0;
              aux_sample_out_ready<='0';
            elsif(cicle<255) then
              next_state<=S1;
              aux_sample_out_ready<='0';
            else
              next_state<=S4;
              aux_sample_out_ready<='0';              
            end if;
         end case;
end process;

    
OUTPUT_DECODE_MOORE : process (state, micro_data,count1,count2,aux_micro_data)
begin
    case (state) is
    when S0 =>
        aux_sample_out<=(others=>'0');
        
    when S1=>
        next_count1<=count1+aux_micro_data;
        next_count2<=count2+aux_micro_data;
        
    when S2=>
        next_count1<=count1+aux_micro_data;
        aux_sample_out<=std_logic_vector(count2);
        
    when S3=> 
        next_count1<=count1+aux_micro_data;
        next_count2<=count2+aux_micro_data;
           
    when S4 =>
        next_count2<=count2+aux_micro_data;
        aux_sample_out<=std_logic_vector(count1);
    end case;
end process;

aux_micro_data <= 
    to_unsigned(1,1) when (micro_data='1') else
    to_unsigned(0,1);

sample_out_ready<=aux_sample_out_ready;
sample_out<=aux_sample_out;
end Behavioral;
