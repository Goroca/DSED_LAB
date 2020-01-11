----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.01.2020 19:53:14
-- Design Name: 
-- Module Name: control - Behavioral
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

entity control is
Port ( 
       clk : in STD_LOGIC;
       Reset : in STD_LOGIC;
       Sample_In_enable : in STD_LOGIC;
       state:       out unsigned (2 downto 0);
       Sample_Out_ready : out STD_LOGIC
);
end control;

architecture Behavioral of control is

signal aux_state  :     unsigned (2 downto 0) := "000";
signal next_aux_state :unsigned (2 downto 0);
signal aux_Sample_Out_ready :  STD_LOGIC;

signal sum :unsigned (2 downto 0);


begin

process(clk,Reset)
begin
if (Reset = '1') then

    aux_state <= (others => '0');
    
elsif (clk'event and clk=SAMPLE_CLK_EDGE) then
        
    aux_state <= next_aux_state;
    

end if;
end process;


process(aux_state,sum,Sample_In_enable)
begin
    
    if    (aux_state="000") then
        if(Sample_In_enable='1')then
            next_aux_state <= sum;
        else
        next_aux_state <= aux_state;
        end if;
        aux_Sample_Out_ready <= '0';
        
     elsif (aux_state="111") then
        next_aux_state <= sum;
        aux_Sample_Out_ready <= '1';    
               
    else
        next_aux_state <= sum;
        aux_Sample_Out_ready <= '0';
    end if;



end process;

sum <= aux_state + 1;
state <= aux_state;
Sample_Out_ready <= aux_Sample_Out_ready;
end Behavioral;
