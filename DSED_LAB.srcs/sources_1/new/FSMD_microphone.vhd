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
sample_out : out STD_LOGIC_VECTOR (8-1 downto 0);
sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is
--Counter
signal next_cicle : integer :=0;
signal cicle : integer :=0;

signal sample_size : integer := 8;

--Numero unos
signal count1 : integer :=0;
signal count2 : integer :=0;
signal next_count1 : integer :=0;
signal next_count2 : integer :=0;
signal aux_count1 : integer :=0;
signal aux_count2 : integer :=0;
signal aux_micro_data : integer :=0;

signal aux_sample_out : STD_LOGIC_VECTOR (8-1 downto 0);
signal aux_sample_out_ready : STD_LOGIC;

signal flag : STD_LOGIC :='0';
begin

process (enable_4_cycles,reset)
begin
if reset = '1' then
cicle<=0;
else
 if rising_edge(enable_4_cycles) then
    cicle<= next_cicle;
 end if;
end if;
end process;

process(cicle,reset)
begin
if reset = '1' then
next_cicle<=0;
else
if(cicle = 299) then
next_cicle <= 0;
else 
next_cicle<= cicle +1;
end if;
end if;
end process;

process(enable_4_cycles,reset)
begin
if reset ='1' then
  count1<=0;
  count2<=0;
else  
  count1<=next_count1;
  count2<=next_count2;  
end if;
end process;

process(cicle,reset)
begin
    if (micro_data='1') then 
    aux_micro_data<=1;
    else
    aux_micro_data<=0;
    end if;


    
    if(reset='1') then
    aux_sample_out<="00000000";
    next_count1<=0;
    next_count2<=0;
    else
    
    if(cicle<256) then
    if (count1<255) then
        next_count1<= count1 + aux_micro_data;
    end if;
    elsif (cicle =257) then
        next_count1<=0;
    end if;
    if (cicle>149 or cicle <106) then
    if (count2<255) then
       next_count2<= count2 + aux_micro_data;
    end if;
    elsif (cicle =107) then
        next_count2<=0;
    end if;
    
    if (cicle =106) then 
        aux_sample_out <= std_logic_vector(to_unsigned(count2,sample_size));
    elsif (cicle= 256) then
        aux_sample_out <= std_logic_vector(to_unsigned(count1,sample_size));
    end if;
    end if;
end process;

process(clk_12megas, reset)
begin
if (reset='1') then
aux_sample_out_ready<='0';
else
  if (cicle=105 or cicle = 255) then
  flag <='1';
  end if;
  
  if rising_edge(clk_12megas) then
    if (cicle = 106 or cicle = 256) then
        if(flag='1') then
        flag<='0';
        aux_sample_out_ready<='1';
        else
        aux_sample_out_ready<='0';
        end if;
    else
        aux_sample_out_ready<='0';
   end if;
    end if;
end if;
end process;
sample_out_ready<=aux_sample_out_ready;
sample_out<=aux_sample_out;
end Behavioral;
