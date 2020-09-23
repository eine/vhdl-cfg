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

- GHDL + ghdl-yosys-plugin + Yosys + NextPNR + (icestorm | (trellis + openocd))
  - Python Class `GHDLSynth`

### ToDo

- [GHDL](https://github.com/ghdl/ghdl)
  - [ghdl-language-server](https://github.com/ghdl/ghdl-language-server)
  - [ghdl-yosys-plugin](https://github.com/ghdl/ghdl-yosys-plugin)
  - [ghdl-cosim](https://github.com/ghdl/ghdl-cosim)
- [rust_hdl](https://github.com/kraigher/rust_hdl)
- [VUnit](https://github.com/VUnit/vunit)
- [cocotb](https://github.com/cocotb/cocotb)
- [tsfpga](https://gitlab.com/truestream/tsfpga/tree/master)
- [pyFPGA](https://gitlab.com/rodrigomelo9/pyfpga)
- [fusesoc](https://github.com/olofk/fusesoc) | [FuseSoc Verification Automation](https://github.com/m-kru/fsva)
- [edalize](https://github.com/olofk/edalize)
- [hdl-make](https://ohwr.org/projects/hdl-make)
- [duh](https://github.com/sifive/duh)
- [hdl-component-manager](https://github.com/jeremiah-c-leary/hdl-component-manager)
- [pyVHDLParser](https://github.com/Paebbels/pyVHDLParser)
- [SigasiProjectCreator](https://github.com/sigasi/SigasiProjectCreator)

## References

- [antonblanchard/ghdl-yosys-blink](https://github.com/antonblanchard/ghdl-yosys-blink)
- [fosshdl-dist](https://github.com/hipolitoguzman/fosshdl-dist/blob/master/Makefile)
- [ZipCPU/autofpga](https://github.com/ZipCPU/autofpga)
