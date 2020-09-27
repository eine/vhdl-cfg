# GHDLSynth

GHDLSynth is a Python class that wraps GHDL + ghdl-yosys-plugin + Yosys + NextPNR + [icestorm | [trellis + openocd]]. Tools can be executed either natively or using containers (Docker or Podman).

This class is a naive conversion of the Makefiles available in [ghdl-yosys-plugin](https://github.com/ghdl/ghdl-yosys-plugin). It is not meant for production. Instead, it's a kicker for developers/maintainers of other Python projects which don't support this toolchain yet. More precisely, [tsfpga](https://gitlab.com/truestream/tsfpga/tree/master) and [PyFPGA](https://gitlab.com/rodrigomelo9/pyfpga) support synthesis with multiple *backends* but not with this specific set of tools (yet).

A job in the GitHub Actions workflow `test` generates bitstreams corresponding to module `leds` for the Icestick. See artifacts in [github.com/eine/vhdl-cfg/actions](https://github.com/eine/vhdl-cfg/actions).