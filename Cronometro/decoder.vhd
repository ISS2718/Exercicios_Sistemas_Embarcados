library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

-- 7 segment display decoder for 7 digits display --
entity decoder is
  Port (
    -- Digits to be displayed --
    digit_uni_miliseconds : in std_logic_vector   (3 downto 0);
    digit_dec_miliseconds : in std_logic_vector   (3 downto 0);
    digit_hun_miliseconds : in std_logic_vector   (3 downto 0);
    digit_uni_seconds : in std_logic_vector   (3 downto 0);
    digit_dec_seconds : in std_logic_vector   (3 downto 0);
    digit_uni_minutes : in std_logic_vector   (3 downto 0);
    digit_dec_minutes : in std_logic_vector   (3 downto 0);

    -- Display 7 seg outputs --
    disp_uni_miliseconds : out std_logic_vector (6 downto 0);
    disp_dec_miliseconds : out std_logic_vector (6 downto 0);
    disp_hun_miliseconds : out std_logic_vector (6 downto 0);
    disp_uni_seconds : out std_logic_vector (6 downto 0);
    disp_dec_seconds : out std_logic_vector (6 downto 0);
    disp_uni_minutes : out std_logic_vector (6 downto 0);
    disp_dec_minutes : out std_logic_vector (6 downto 0)
  );
end decoder;

architecture Behavioral of decoder is
  type display is array (0 to 9) of std_logic_vector (6 downto 0);
  constant converter : display :=
		("1000000","1111001","0100100","0110000","0011001","0010010","0000010","1111000",
		 "0000000","0010000");
begin
  process (
    digit_uni_miliseconds,
    digit_dec_miliseconds,
    digit_hun_miliseconds,
    digit_uni_seconds,
    digit_dec_seconds,
    digit_uni_minutes,
    digit_dec_minutes
  ) begin
    disp_uni_miliseconds <= converter(to_integer(unsigned(digit_uni_miliseconds)));
    disp_dec_miliseconds <= converter(to_integer(unsigned(digit_dec_miliseconds)));
    disp_hun_miliseconds <= converter(to_integer(unsigned(digit_hun_miliseconds)));
    disp_uni_seconds <= converter(to_integer(unsigned(digit_uni_seconds)));
    disp_dec_seconds <= converter(to_integer(unsigned(digit_dec_seconds)));
    disp_uni_minutes <= converter(to_integer(unsigned(digit_uni_minutes)));
    disp_dec_minutes <= converter(to_integer(unsigned(digit_dec_minutes)));
  end process;
end Behavioral;