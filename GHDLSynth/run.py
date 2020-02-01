from pathlib import Path
from vunit import VUnit

from GHDLSynth import ICE40, TOOLS_ICE40

VU = VUnit.from_argv(vhdl_standard="2008")
#VU.add_verification_components()

ROOT = Path(__file__).parent.resolve().parent
OUT_DIR = ROOT / "synth_out"
SRC_PATH = ROOT / "modules" / "leds" / "src"

VU.add_library("lib").add_source_files([SRC_PATH / "*.vhd"])


def sim():
    VU.main()


def build():
    srcs = [Path(sfile.name).name[0:-4] for sfile in VU.get_source_files(SRC_PATH / "**.vhd")]
    srcs.remove('leds')
    srcs = {
      sname: [ifile.name for ifile in VU.get_implementation_subset(VU.get_source_files(SRC_PATH /     ("%s.vhd" % sname)))] for sname in srcs
    }

    print(srcs)

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    for key, val in srcs.items():
        ICE40(
            TOOLS_ICE40,
            Path("/src/synth_out"),
            Path("/src/impl/icestick.pcf"),
            val,
            "leds",
            key
        )

build()


# OrangeCrab with ECP85
#GHDLARGS=-gCLK_FREQUENCY=50000000
#LPF=constraints/orange-crab.lpf
#PACKAGE=CSFBGA285
#NEXTPNR_FLAGS=--um5g-85k --freq 50
#OPENOCD_JTAG_CONFIG=openocd/olimex-arm-usb-tiny-h.cfg
#OPENOCD_DEVICE_CONFIG=openocd/LFE5UM5G-85F.cfg

# ECP5-EVN
#GHDL_GENERICS=-gCLK_FREQUENCY=12000000
#LPF=constraints/ecp5-evn.lpf
#PACKAGE=CABGA381
#NEXTPNR_FLAGS=--um5g-85k --freq 12
#OPENOCD_JTAG_CONFIG=openocd/ecp5-evn.cfg
#OPENOCD_DEVICE_CONFIG=openocd/LFE5UM5G-85F.cfg
