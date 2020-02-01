# VHDL project configuration

This repository is a playground to explore and compare how configuration is handled by different tools for development of VHDL projects.

## Target boards and compatible/tested modules

- icestick, ice40hx8k
  - `leds/src/leds.vhdl leds/src/$arch` | for arch in blink fixed multi1 multi2 rotate1 rotate2 rotate3 rotate4 spin
- icestick
  - `uart/src/uart_tx.vhd uart/src/uart_tx.vhd uart/src/uart_top.vhd`
- ecp5-evn, orange-crab
  - `demo/src/demo.vhd`

## Tools/Toolchains

- GHDL + ghdlsynth-beta + Yosys + NextPNR + (icestorm | (trellis + openocd))
  - Python Class `GHDLSynth`

### ToDo

- VUnit + GHDL
- tsfpga
- cocotb
- rust_hdl
- pyVHDLParser
- ghdl-ls

## References

- [antonblanchard/ghdl-yosys-blink](https://github.com/antonblanchard/ghdl-yosys-blink)
- [tgingold/ghdlsynth-beta](https://github.com/tgingold/ghdlsynth-beta/tree/master/examples)
- [ghdl/ghdl](https://github.com/ghdl/ghdl/tree/master/doc/examples/quick_start)
