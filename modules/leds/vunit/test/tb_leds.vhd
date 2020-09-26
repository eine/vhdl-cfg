library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_leds is
  generic ( runner_cfg : string );
end;

architecture arch of tb_leds is
  constant clk_period : time    := 20 ns;
  signal clk: std_logic := '0';
  signal led: std_logic_vector(4 downto 0);
begin

  clk <= not clk after clk_period/2;

  main: process
  begin
    test_runner_setup(runner, runner_cfg);
    info("Init test");
    wait for clk_period*5000;
    info("Test done");
    test_runner_cleanup(runner);
    wait;
  end process;

  uut: entity work.leds
  port map (
    clk => clk,
    led1 => led(0),
    led2 => led(1),
    led3 => led(2),
    led4 => led(3),
    led5 => led(4)
  );
end;