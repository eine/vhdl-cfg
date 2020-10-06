library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--  Icestick
--
--  I      D3
--  r
--  D  D2  D5  D4
--  A
--         D1

entity leds is
  port (CLK : in std_logic;
        LED1, LED2, LED3, LED4, LED5 : out std_logic);
end leds;
