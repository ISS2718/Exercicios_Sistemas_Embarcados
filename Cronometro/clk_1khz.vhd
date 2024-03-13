library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 1KHz clock generation from 50MHz clock --
entity clk_1khz is
  Port (
    clk50Mhz : in std_logic ;
    clk1khz : out std_logic 
  );
end clk_1khz;

architecture Behavioral of clk_1hz is
  signal temp1: std_logic:= '0';
  signal counter1: INTEGER:= 0;
begin
  process(clk) begin
    if rising_edge(clk) then
      counter1<=counter1+1;
      -- 1KHz clock divide by 5000 --
      if (counter1 = 4999) then
        temp1<= NOT temp1;
        counter1<=0;
      end if;
    end if;
    clk1<=temp1;
  end process;
end Behavioral;