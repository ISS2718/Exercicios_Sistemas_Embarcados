library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clk_1hz is
  Port (
    clk : in std_logic ;
    clk1 : out std_logic 
  );
end clk_1hz;

architecture Behavioral of clk_1hz is
  signal temp1: std_logic:= '0';
  signal counter1: INTEGER:= 0;
begin
  process(clk) begin
    if rising_edge(clk) then
      counter1<=counter1+1;
      if (counter1 = 49999999) then
        temp1<= NOT temp1;
        counter1<=0;
      end if;
    end if;
    clk1<=temp1;
  end process;
end Behavioral;