library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity timer is
    Port ( 
        -- 50MHz Clock --
        clk50Mhz : in  STD_LOGIC;

        -- Control Buttons --
        reset: in std_logic;
        start: in std_logic;
        pause: in std_logic;

        -- Display 7 seg outputs --
        disp_uni_miliseconds : out std_logic_vector (6 downto 0);
        disp_dec_miliseconds : out std_logic_vector (6 downto 0);
        disp_hun_miliseconds : out std_logic_vector (6 downto 0);
        disp_uni_seconds : out std_logic_vector (6 downto 0);
        disp_dec_seconds : out std_logic_vector (6 downto 0);
        disp_uni_minutes : out std_logic_vector (6 downto 0);
        disp_dec_minutes : out std_logic_vector (6 downto 0)
    );
end timer;

architecture timer of timer is
    component clk_1khz 
        port(
            -- 50MHz Clock --
            clk50Mhz: in std_logic ;

            -- 1KHz Clock --
            clk1Khz: out std_logic 
        );
    end component;

    component counter
        port(
            -- 1KHz Clock --
            clk1Khz: in std_logic;

            -- Control Buttons --
            reset: in std_logic;
            start: in std_logic;
            pause: in std_logic;

            -- Timer Digits --
            digit_uni_miliseconds : out std_logic_vector   (3 downto 0);
            digit_dec_miliseconds : out std_logic_vector   (3 downto 0);
            digit_hun_miliseconds : out std_logic_vector   (3 downto 0);
            digit_uni_seconds : out std_logic_vector   (3 downto 0);
            digit_dec_seconds : out std_logic_vector   (3 downto 0);
            digit_uni_minutes : out std_logic_vector   (3 downto 0);
            digit_dec_minutes : out std_logic_vector   (3 downto 0)
        );
    end component;

    component decoder
        port ( 
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
    end component;

    signal 	clk1Khz : std_logic := '0';
    signal digit_uni_miliseconds :  std_logic_vector   (3 downto 0);
    signal digit_dec_miliseconds :  std_logic_vector   (3 downto 0);
    signal digit_hun_miliseconds :  std_logic_vector   (3 downto 0);
    signal digit_uni_seconds :  std_logic_vector   (3 downto 0);
    signal digit_dec_seconds :  std_logic_vector   (3 downto 0);
    signal digit_uni_minutes :  std_logic_vector   (3 downto 0);
    signal digit_dec_minutes :  std_logic_vector   (3 downto 0);
begin
    comp1:clk_1khz PORT MAP(clk50Mhz, clk1Khz);

    comp2: counter PORT MAP(
        clk1Khz,
        reset,
        start, 
        pause,
        digit_uni_miliseconds,
        digit_dec_miliseconds,
        digit_hun_miliseconds,
        digit_uni_seconds,
        digit_dec_seconds,
        digit_uni_minutes,
        digit_dec_minutes
    );

    comp3: decoder PORT MAP(
        digit_uni_miliseconds,
        digit_dec_miliseconds,
        digit_hun_miliseconds,
        digit_uni_seconds,
        digit_dec_seconds,
        digit_uni_minutes,
        digit_dec_minutes,

        disp_uni_miliseconds,
        disp_dec_miliseconds,
        disp_hun_miliseconds,
        disp_uni_seconds,
        disp_dec_seconds,
        disp_uni_minutes,
        disp_dec_minutes
    );

end timer;
