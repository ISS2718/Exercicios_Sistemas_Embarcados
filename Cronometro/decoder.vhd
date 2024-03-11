library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity decoder is
  Port (  digit1,digit2,digit3,digit4,digit5,digit6: in std_logic_vector   (3 downto 0);
  WhichDisplay : in std_logic_vector (2 downto 0);
  segments: out std_logic_vector (7 downto 0)
 );
end decoder;

architecture Behavioral of decoder is

type display is array (0 to 9) of std_logic_vector (7 downto 0);
constant converter : display :=
		("11000000","11111001","10100100","10110000","10011001","10010010","10000010","11111000",
		 "10000000","10010000");

signal temp : std_logic_vector (7 downto 0);
begin
process(WhichDisplay ,temp)
begin
if WhichDisplay = "000" then
temp<= converter(to_integer(unsigned(digit1)));
elsif WhichDisplay = "001" then
temp<= converter(to_integer(unsigned(digit2)));
elsif WhichDisplay = "010" then
temp<= converter(to_integer(unsigned(digit3)));
elsif WhichDisplay = "011" then
temp<= converter(to_integer(unsigned(digit4)));
elsif WhichDisplay = "100" then
temp<= converter(to_integer(unsigned(digit5)));
elsif WhichDisplay = "101" then
temp<= converter(to_integer(unsigned(digit6)));
end if;

end process;

segments<=temp;

end Behavioral;