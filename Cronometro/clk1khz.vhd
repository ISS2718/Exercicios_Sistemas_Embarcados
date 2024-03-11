library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clk_1khz is
  Port (clk: in std_logic;
  clk2: out std_logic   );
end clk_1khz;

architecture Behavioral of clk_1khz is

signal temp2: std_logic :='0';
signal counter2: INTEGER :=0;

begin
process(clk)
begin
if rising_edge (clk) then
counter2<=counter2+1;
if (counter2=49999) then
temp2<= NOT temp2;
counter2<=0;
end if;
end if;
clk2<=temp2;
end process;

end Behavioral;