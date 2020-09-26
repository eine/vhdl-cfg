from pathlib import Path
from vunit import VUnit

VU = VUnit.from_argv(vhdl_standard="2008")
VU.add_verification_components()

ROOT = Path(__file__).parent.resolve()

VU.add_library("lib").add_source_files([
  ROOT.parent / "src" / "*.vhd",
  ROOT / "test" / "*.vhd"
])

VU.main()
