#!/usr/bin/env python

from os import getcwd
from pathlib import Path
from subprocess import check_call


class GHDLSynth(object):
    def __init__(
        self,
        workdir=getcwd(),
        device="hx1k",
        package="tq144",
        ghdl="ghdl",
        yosys="yosys",
        yosys_cmd="synth_ice40",
        nextpnr="nextpnr-ice40",
        pack="icepack",
        report="icetime",
        prog="iceprog",
        oci_engine="docker",
        oci_args=["run", "--rm", "-w", "/src/GHDLSynth"],
        oci_yosys=["ghdl/synth:beta"],
        oci_nextpnr=["ghdl/synth:nextpnr-ice40"],
        oci_pack=["ghdl/synth:icestorm"],
        oci_report=["ghdl/synth:icestorm"],
        oci_prog=["--device", "/dev/bus/usb", "ghdl/synth:prog"]
    ):
      self._workdir = workdir
      self._device = device
      self._package = package
      self._ghdl = ghdl
      self._yosys = yosys
      self._yosys_cmd = yosys_cmd
      self._nextpnr = nextpnr
      self._pack = pack
      self._prog = prog
      self._oci_engine = oci_engine
      self._oci_args = oci_args
      self._oci_yosys = oci_yosys
      self._oci_nextpnr = oci_nextpnr
      self._oci_pack = oci_pack
      self._oci_prog = oci_prog

    def _isECP5(self):
        return self._device.upper() == 'ECP5'

    def _check_if_oci_cmd(self, cmd, img):
        return (
            ([self._oci_engine] + self._oci_args + ["-v", str(Path(self._workdir).parent.resolve()) + ":/src"] + img)
            if self._oci_engine is not None else
            []
        ) + cmd

    @staticmethod
    def _exec(cmd):
        print(cmd)
        check_call(cmd)

    def synth(self, sources, top, output):
        cmd = self._check_if_oci_cmd([self._yosys], self._oci_yosys) + ["-m", "ghdl", "-p", ' '.join([self._ghdl, "--std=08"] + sources + ["-e", top + ';', self._yosys_cmd, "-json", output])]
        self._exec(cmd)

    def pnr(self, jsonin, pinout, output):
        cmd = self._check_if_oci_cmd([self._nextpnr], self._oci_nextpnr) + (
            ["--json", jsonin, "--package", self._package, "--lpf", pinout, "--textcfg", output]
            if self._isECP5() else
            ["--json", jsonin, "--package", self._package, "--" + self._device, "--pcf", pinout, "--asc", output]
        )
        self._exec(cmd)

    def pack(self, syn, bit, svf=None):
        cmd = self._check_if_oci_cmd([self._pack], self._oci_pack) + (
            (
                (["--svf", svf] if svf is not None else [])
                +
                [syn, bit]
            )
            if self._isECP5() else
            [syn, bit]
        )
        self._exec(cmd)

    def report(self, syn, device, rpt):
        cmd = self._check_if_oci_cmd([self._report], self._oci_report) + [
            ["-d", device, "-mtr", rpt, syn]
        ]
        self._exec(cmd)

    def prog(self, jtag_cfg, device_cfg, svf):
        cmd = self._check_if_oci_cmd([self._prog], self._oci_prog) + (
            ["-f", jtag_cfg, "-f", device_cfg, "-c", "transport select jtag; init; svf " + svf + "; exit"]
            if self._isECP5() else
            []
        )
        self._exec(cmd)


TOOLS_ICE40 = GHDLSynth()

TOOLS_ECP5 = GHDLSynth(
    yosys_cmd="synth_ecp5",
    nextpnr="nextpnr-ecp5",
    pack="ecppack",
    prog="openocd",
    oci_nextpnr=["ghdl/synth:nextpnr-ecp5"],
    oci_pack=["ghdl/synth:trellis"],
)

def ICE40(tools, output, pinout, srcs, entity, arch):
    o = str(output / ("%s" % arch))
    jnet = o + ".json"
    asc = o + ".asc"
    bit = o + ".bit"
    tools.synth(srcs, entity, jnet)
    tools.pnr(jnet, pinout, asc)
    tools.pack(asc, bit)
