library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

entity tb_demo is
  generic (
    runner_cfg : string
  );
end;

architecture arch of tb_demo is

  constant clk_period     : time    := 20 ns;
  constant baud_rate      : integer := 115200; -- bits / s
  constant cycles_per_bit : integer := 50 * 10**6 / baud_rate;
  constant counter_max    : natural := 15;

  constant uart_m : uart_master_t := new_uart_master(initial_baud_rate => baud_rate);
  constant uart_m_stream : stream_master_t := as_stream(uart_m);

  constant uart_s : uart_slave_t  := new_uart_slave(initial_baud_rate => baud_rate);
  constant uart_s_stream : stream_slave_t  := as_stream(uart_s);

  signal rx, tx: std_logic;

  signal clk  : std_logic := '0';
  signal rst  : std_logic := '0';
  signal leds : std_logic_vector(2 downto 0);

begin

  clk <= not clk after clk_period/2;

  main: process
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop

      if run("test_counter") then

        rst <= '1';
        wait for clk_period * 5;
        rst <= '0';

        check_equal(leds(0), '0');
        wait for clk_period * counter_max;
        check_equal(leds(0), '0');
        wait for clk_period;
        check_equal(leds(0), '1');

      elsif run("test_uart_loopback") then

        push_stream(net, uart_m_stream, x"77");
        push_stream(net, uart_m_stream, x"55");
        push_stream(net, uart_m_stream, x"AA");

        check_stream(net, uart_s_stream, x"77");
        check_stream(net, uart_s_stream, x"55");
        check_stream(net, uart_s_stream, x"AA");

      end if;
    end loop;

    test_runner_cleanup(runner);
    wait;
  end process;
  test_runner_watchdog(runner, 10 ms);

  vc_uart_m : entity vunit_lib.uart_master
    generic map ( uart => uart_m )
    port map ( tx => rx );

  vc_uart_s : entity vunit_lib.uart_slave
    generic map ( uart => uart_s )
    port map ( rx => tx );

  uut: entity work.demo
    generic map (
      COUNTER_MAX => counter_max
    )
    port map (
      CLK  => clk,
      RST  => rst,
      RXD  => rx,
      TXD  => tx,
      LEDS => leds
    );

end;
