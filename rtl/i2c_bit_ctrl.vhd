library ieee;
use ieee.std_logic_1164.all;
use work.i2c_pkg.all;

entity i2c_bit_ctrl is
  port (
    clk, rst     : in  std_logic;
    tick         : in  std_logic;
    stall        : out std_logic;
    cmd_valid    : in  std_logic;
    cmd_ready    : out std_logic;
    cmd          : in  bit_cmd_t;
    cmd_din      : in  std_logic;
    rsp_valid    : out std_logic;
    rsp_dout     : out std_logic;
    rsp_arb_lost : out std_logic;
    scl_i, sda_i : in  std_logic;
    scl_oe       : out std_logic;
    sda_oe       : out std_logic
  );
end entity;

architecture rtl of i2c_bit_ctrl is
  type state_t is (S_IDLE, S_RUN);

  signal state,    state_n    : state_t;
  signal cmd_r,    cmd_n      : bit_cmd_t;
  signal din_r,    din_n      : std_logic;
  signal step,     step_n     : integer range 0 to 5;
  signal scl_oe_r, scl_oe_n   : std_logic;
  signal sda_oe_r, sda_oe_n   : std_logic;
  signal dout_r,   dout_n     : std_logic;
  signal arb_r,    arb_n      : std_logic;
  signal done_r,   done_n     : std_logic;
  signal advance, stalled     : std_logic;
begin
  scl_oe       <= scl_oe_r;
  sda_oe       <= sda_oe_r;
  rsp_dout     <= dout_r;
  rsp_arb_lost <= arb_r;
  rsp_valid    <= done_r;
  cmd_ready    <= '1' when state = S_IDLE else '0';

  stalled <= '1' when state = S_RUN and scl_oe_r = '0' and scl_i = '0' else '0';
  stall   <= stalled;
  advance <= tick and not stalled;

  p_reg : process (clk)
  begin
    if rising_edge(clk) then
      cmd_r  <= cmd_n;
      din_r  <= din_n;
      step   <= step_n;
      dout_r <= dout_n;
  
      if rst = '1' then
        state    <= S_IDLE;
        scl_oe_r <= '0';
        sda_oe_r <= '0';
        done_r   <= '0';
        arb_r    <= '0';
      else
        state    <= state_n;
        scl_oe_r <= scl_oe_n;
        sda_oe_r <= sda_oe_n;
        done_r   <= done_n;
        arb_r    <= arb_n;
      end if;
    end if;
  end process;

  p_comb : process (all)
  begin

    state_n <= state;
    cmd_n <= cmd_r;
    din_n <= din_r;
    step_n <= step;
    scl_oe_n <= scl_oe_r;
    sda_oe_n <= sda_oe_r;
    dout_n <= dout_r;
    arb_n <= arb_r;
    done_n <= '0';

    case state is
      when S_IDLE =>
        null;  -- TODO

      when S_RUN =>
        if advance = '1' then
          null;  -- TODO
        end if;
    end case;
  end process;
end architecture;
