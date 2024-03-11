library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity anode_picker is
  Port (WhichDisplay: in std_logic_vector (2 downto 0);
  anode: out std_logic_vector (7 downto 0) );
end anode_picker;

architecture Behavioral of anode_picker is

signal temp : std_logic_vector (7 downto 0);		 

begin
process(WhichDisplay , temp)
begin
if WhichDisplay = "000" then
temp <="01111111";
elsif WhichDisplay ="001" then
temp<= "10111111";
elsif WhichDisplay ="010" then
temp<= "11011111";
elsif WhichDisplay ="011" then
temp<= "11101111";
elsif WhichDisplay ="100" then
temp<= "11110111";
elsif WhichDisplay ="101" then
temp<= "11111011";
end if;
end process;

anode<=temp;

end Behavioral;