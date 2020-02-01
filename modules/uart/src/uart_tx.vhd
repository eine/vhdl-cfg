library ieee;
use ieee.std_logic_1164.all;

entity uart_tx is
  generic (
    -- TODO: range in submodules is not yet supported by synthesis
    --       it would be useful to limit between 5 to 8
    C_BITS           : integer := 8;
    C_CYCLES_PER_BIT : integer := 104
  );
  port (
    clk     : in std_logic;
    valid_i : in std_logic;
    datav_i : in std_logic_vector(C_BITS-1 downto 0);
    ready_o : out std_logic;
    data_o  : out std_logic
  );
end entity uart_tx;

architecture rtl of uart_tx is
  signal int_cycle_cnt : integer range 0 to C_CYCLES_PER_BIT-1 := 0;
  signal int_bit_cnt : integer range 0 to C_BITS+2 := 0;

  signal slv_data : std_logic_vector(C_BITS downto 0) := (others => '0');

  type t_state is (IDLE, INIT, SEND);
  signal state : t_state;
begin
  process(clk)
  begin
    if rising_edge(clk) then
      case state is
        when IDLE =>
          if valid_i = '1' then
            state <= INIT;
          end if;

        when INIT =>
          int_cycle_cnt <= 0;
          int_bit_cnt <= 0;
          slv_data <= datav_i & '1';
          state <= SEND;

        when SEND =>
          if int_cycle_cnt < C_CYCLES_PER_BIT-1 then
            int_cycle_cnt <= int_cycle_cnt+1;
          elsif int_bit_cnt < C_BITS+1 then
            int_cycle_cnt <= 0;
            int_bit_cnt <= int_bit_cnt+1;
            slv_data <= '0' & slv_data(slv_data'LEFT downto 1);
          else
            state <= IDLE;
          end if;

      end case;
    end if;
  end process;

  ready_o <= '1' when state = IDLE else '0';
  data_o <= not slv_data(0); -- low active
end architecture rtl;