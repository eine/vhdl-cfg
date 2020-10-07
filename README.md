# VHDL project configuration

This repository is a playground for exploring and comparing how configuration is handled by different tools for development of (V)HDL projects. The main motivation is hopefully finding a universal format/procedure for reducing duplication. The repository is organised as follows:

- `constraints` ([hdl/constraints](https://github.com/hdl/constraints)): board constraint files (`*.lpf`, `*.pcf`, etc.), which can be reused by multiple designs.
- `prog`: each subdir contains helper resources for a different programming tool, which can be reused by multiple designs.
- `modules`: each subdir contains a different design and the corresponding specific sources for each of the tested tools.
  - `demo`: basic design with a counter for making a LED blink and an UART loopback (hard-wire), based on [antonblanchard/ghdl-yosys-blink: vhdl_blink.vhdl](https://github.com/antonblanchard/ghdl-yosys-blink).
  - `leds`: single entity and multiple architectures for generating patterns with 5 LEDs, based on [ghdl/ghdl-yosys-plugin: examples/icestick/leds](https://github.com/ghdl/ghdl-yosys-plugin/tree/master/examples/icestick/leds).
  - `full_adder`: full adder example from GHDL's [Quick Start Guide](https://ghdl.github.io/ghdl/quick_start/README.html) ([*Full adder* module and testbench](https://ghdl.github.io/ghdl/quick_start/adder/README.html))
  - `uart`: UART sender and receiver, based on [ghdl/ghdl-yosys-plugin: examples/icestick/uart](https://github.com/ghdl/ghdl-yosys-plugin/tree/master/examples/icestick/uart).
- `GHDLSynth`: naive adaptation of the Makefiles from [ghdl/ghdl-yosys-plugin](https://github.com/ghdl/ghdl-yosys-plugin) to a Python class.

## Tools/Toolchains

The following table shows which tool examples were contributed to this repository already. Some of them are used in some modules only (yet).

|   | demo | leds | full_adder | uart |
|---|---|---|---|---|
| GHDLSynth | | Yes *1 | | |
| [VUnit](https://github.com/VUnit/vunit) | Yes | | | |
| [pyFPGA](https://gitlab.com/rodrigomelo9/pyfpga) | Yes *2 | | | |
| | | | | |

- *1 Icestick only
- *2 Vivado and *generic* Yosys only

## Target boards and compatible/tested modules

Not all the modules were used in all the boards yet. The following list shows the combinations that are known to work:

- icestick, ice40hx8k
  - `leds/src/leds.vhdl leds/src/$arch` | for arch in blink fixed multi1 multi2 rotate1 rotate2 rotate3 rotate4 spin
- icestick
  - `uart/src/uart_tx.vhd uart/src/uart_tx.vhd uart/src/uart_top.vhd`
- ecp5-evn, orange-crab
  - `demo/src/demo.vhd`

## ToDo

- [GHDL](https://github.com/ghdl/ghdl)
  - [ghdl-language-server](https://github.com/ghdl/ghdl-language-server)
  - [ghdl-yosys-plugin](https://github.com/ghdl/ghdl-yosys-plugin)
  - [ghdl-cosim](https://github.com/ghdl/ghdl-cosim)
- [rust_hdl](https://github.com/kraigher/rust_hdl)
- [cocotb](https://github.com/cocotb/cocotb)
- [tsfpga](https://gitlab.com/truestream/tsfpga/tree/master)
- [pyIPCMI](https://github.com/Paebbels/pyIPCMI)
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
