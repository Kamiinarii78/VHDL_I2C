from pathlib import Path
from vunit import VUnit

root = Path(__file__).parent
vu = VUnit.from_argv(vhdl_standard="2008")
vu.add_osvvm()
lib = vu.add_library("lib")
lib.add_source_files(root.parent / "rtl" / "*.vhd")
lib.add_source_files(root / "*.vhd")
lib.add_source_files(root / "models" / "*.vhd")
vu.main()
