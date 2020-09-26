from shutil import which
from pathlib import Path
from fpga.project import Project


ROOT = Path(__file__).parent.resolve()


def build(prj):
    prj.add_files(str(ROOT.parent / 'src' / '*.vhd'), 'examples')
    prj.set_top('demo')
    try:
        prj.generate()
        #prj.transfer()
    except Exception as e:
        print('{} ({})'.format(type(e).__name__, e))


for toolchain in ['vivado', 'yosys']:
    if toolchain == 'vivado' and which('vivado'):
      prj = Project('vivado', 'vhdl-cfg_vivado')
      prj.set_outdir(str(ROOT / 'build' / 'vivado'))

      prj.set_part('xc7z020clg400-1') # PYNQ-Z1

      #! TODO I/O constraints file is missing

      build(prj)

      continue

    if toolchain == 'yosys' and which('yosys'):
      prj = Project('yosys', 'vhdl-cfg_yosys')
      prj.set_outdir(str(ROOT / 'build' / 'yosys'))

      #! TODO Is this the expected part format for Lattice devices?
      prj.set_part('hx1k-tq144') # Icestick

      #! TODO I/O constraints file is missing
      # ROOT.parent.parent.parent / 'impl' / 'icestick.pcf'

      build(prj)

      continue
