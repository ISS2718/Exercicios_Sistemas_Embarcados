library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

-- 60 min miliseconds clock_counter --
entity clock_counter is
  Port (
    clk1khz: in std_logic;
    reset: in std_logic;
    start: in std_logic;
    pause: in std_logic;

    digit_uni_miliseconds : out std_logic_vector   (3 downto 0);
    digit_dec_miliseconds : out std_logic_vector   (3 downto 0);
    digit_hun_miliseconds : out std_logic_vector   (3 downto 0);
    digit_uni_seconds : out std_logic_vector   (3 downto 0);
    digit_dec_seconds : out std_logic_vector   (3 downto 0);
    digit_uni_minutes : out std_logic_vector   (3 downto 0);
    digit_dec_minutes : out std_logic_vector   (3 downto 0)
  );
end clock_counter;

architecture Behavioral of clock_counter is
  signal miliseconds: INTEGER := 0;
  signal running: std_logic := '0';

  type int_to_bin is array (0 to 9) of std_logic_vector (3 downto 0);
  constant int_bin : int_to_bin :=
    ("0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000", "1001");
begin
  process (clk1, reset, start, pause, miliseconds) begin
    -- Counter 60 minutes in miliseconds --
    if (reset = '1' OR miliseconds = 3599999) then
      miliseconds <= 0;
      running <= '0';
    elsif start = '1' then
      running <= '1';
    elsif pause = '1' then
      running <= '0';
    elsif rising_edge(clk1) then
      if running = '1' then
        miliseconds <= miliseconds + 1;
      end if;
  end process;
  
  -- REPENSAR A LÓGICA DE CONVERSÃO --
  digit_uni_miliseconds <= int_bin(((miliseconds mod 3600000) mod 60) mod 10);
  digit_dec_miliseconds <= int_bin(((miliseconds mod 3600000) mod 60) / 10);
  digit_hun_miliseconds <= int_bin(((miliseconds mod 3600000) / 60) mod 10);
  digit_uni_seconds <= int_bin(((miliseconds mod 3600) / 60) / 10);
  digit_dec_seconds <= int_bin((miliseconds / 3600) mod 10);
  digit_uni_minute <= int_bin((miliseconds / 3600) / 10); 
  digit_dec_minute <= int_bin((miliseconds / 3600) / 10); 
end Behavioral;