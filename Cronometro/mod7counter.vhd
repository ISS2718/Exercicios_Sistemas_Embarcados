library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mod7counter is
  Port (
    clk2: in std_logic;
    WhichDisplay: out std_logic_vector (2 downto 0) 
  );
end mod6counter;

architecture Behavioral of mod6counter is
  signal temp : std_logic_vector(2 downto 0);
begin
  process(clk2, temp) begin
    if rising_edge(clk2) then
      temp<=temp+1;
      if temp="111" then
        temp<="000";
      end if;
    end if;
  end process;

  WhichDisplay <= temp;

end Behavioral;