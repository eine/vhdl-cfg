library ieee;
use ieee.std_logic_1164.all;

entity uart_top is
  generic (
    C_LOOPBACK    : boolean := '0';
    C_BITS        : integer := 8;
    C_QUARTZ_FREQ : integer := 12000000; -- Hz
    C_BAUDRATE    : integer := 115200    -- words / s
  );
  port (
    clk     : in std_logic;
    uart_rx : in std_logic;
    uart_tx : out std_logic;
    ready_o : out std_logic
  );
end uart_top;

architecture arch of uart_top is
  constant C_CYCLES_PER_BIT : integer := C_QUARTZ_FREQ / C_BAUDRATE;

  signal rx  : std_logic := '0';
  signal txv : std_logic_vector(C_BITS-1 downto 0) := (others => '0');
begin
  gen_loop: if C_LOOPBACK = '1' generate
    data_o <= data_i;
  else
    i_uart_rx: entity work.uart_rx
    generic map (
      C_BITS => C_BITS,
      C_CYCLES_PER_BIT => C_CYCLES_PER_BIT
    )
    port map (
      clk     => clk,
      data_i  => data_i,
      data_o  => txv,
      valid_o => rx
    );

    i_uart_tx: entity work.uart_tx
    generic map (
      C_BITS => C_BITS,
      C_CYCLES_PER_BIT => C_CYCLES_PER_BIT
    )
    port map (
      clk     => clk,
      valid_i => rx,
      datav_i => txv,
      datav_o => data_o,
      ready_o => ready_o
    );
  end generate;
end arch;