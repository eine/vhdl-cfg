library ieee;
use ieee.std_logic_1164.all;

entity demo is
  generic (
    COUNTER_MAX : positive := 50000000
  );
  port(
    CLK  : in  std_ulogic;
    RST  : in  std_ulogic;
    RXD  : in  std_ulogic;
    TXD  : out std_ulogic;
    LEDS : out std_ulogic_vector(2 downto 0)
  );
end;

architecture arch of demo is

  signal led     : std_ulogic := '0';
  signal counter : integer range 0 to COUNTER_MAX;

begin

  process (CLK)
  begin
    if rising_edge(CLK) then
      if RST = '1' then
        led <= '0';
        counter <= 0;
      else
        if counter = COUNTER_MAX then
          led <= not led;
          counter <= 0;
        else
          led <= led;
          counter <= counter + 1;
        end if;
      end if;
    end if;
  end process;

  LEDS(0) <= led;
  LEDS(1) <= not RXD;

  TXD <= RXD;

end;
