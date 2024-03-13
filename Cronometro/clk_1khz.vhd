library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 1KHz clock generation from 50MHz clock --
entity clk_1khz is
  Port (
    clk50Mhz : in std_logic ;
    clk1Khz : out std_logic 
  );
end clk_1khz;

architecture Behavioral of clk_1khz is
  signal temp: std_logic:= '0';
  signal counter: INTEGER:= 0;
begin
  process(clk50Mhz) begin
    if rising_edge(clk50Mhz) then
      counter<=counter+1;
      -- 1KHz clock divide by 5000 --
      if (counter = 4999) then
        temp<= NOT temp;
        counter<=0;
      end if;
    end if;
    clk1Khz<=temp;
  end process;
end Behavioral;