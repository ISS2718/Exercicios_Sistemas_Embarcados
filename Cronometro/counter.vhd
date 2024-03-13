library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

-- 60 min counter --
entity counter is
  Port (
    -- 1KHz Clock --
    clk1Khz: in std_logic;

    -- Control Buttons --
    reset : in std_logic;
    start : in std_logic;
    pause : in std_logic;

    -- Timer Digits --
    digit_uni_miliseconds : out std_logic_vector   (3 downto 0);
    digit_dec_miliseconds : out std_logic_vector   (3 downto 0);
    digit_hun_miliseconds : out std_logic_vector   (3 downto 0);
    digit_uni_seconds : out std_logic_vector   (3 downto 0);
    digit_dec_seconds : out std_logic_vector   (3 downto 0);
    digit_uni_minutes : out std_logic_vector   (3 downto 0);
    digit_dec_minutes : out std_logic_vector   (3 downto 0)
  );
end counter;

architecture Behavioral of counter is
  signal miliseconds: integer range 0 to 999 := 0;
  signal seconds : integer range 0 to 59 := 0;
  signal minutes : integer range 0 to 59 := 0;
  signal running: std_logic := '0';

  type int_to_bin is array (0 to 9) of std_logic_vector (3 downto 0);
  constant int_bin : int_to_bin :=
    ("0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000", "1001");
begin
  process (clk1Khz, reset, start, pause) begin
    -- Counter 60 minutes in miliseconds --
    if reset = '0' then
      miliseconds <= 0;
      seconds <= 0;
      minutes <= 0;
      running <= '0';
    elsif start = '0' then
      running <= '1';
    elsif pause = '0' then
      running <= '0';
    elsif rising_edge(clk1Khz) then
      if running = '1' then
        if miliseconds = 999 then
          miliseconds <= 0;
          if seconds = 59 then
            seconds <= 0;
            if minutes = 59 then
              minutes <= 0;
            else
              minutes <= minutes + 1;
            end if;
          else
            seconds <= seconds + 1;
          end if;
        else
          miliseconds <= miliseconds + 1;
        end if;
      end if;
    end if;
  end process;
  
  -- Convert integer to binary --
  digit_uni_miliseconds <= int_bin(miliseconds mod 10);
  digit_dec_miliseconds <= int_bin((miliseconds mod 100) / 10);
  digit_hun_miliseconds <= int_bin(miliseconds / 100);
  digit_uni_seconds <= int_bin(seconds mod 10);
  digit_dec_seconds <= int_bin(seconds / 10);
  digit_uni_minutes <= int_bin(minutes mod 10);
  digit_dec_minutes <= int_bin(minutes / 10);
end Behavioral; 
