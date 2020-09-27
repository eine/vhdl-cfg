# Notes about PyFPGA

These are some notes that were taken while using PyFPGA for the first time. Many of them are probably explained somewhere in the docs, or will be enhancent soon. Therefore, readers should expect these notes to change or to be removed.

- The recommended installation procedure in [Installation](https://gitlab.com/rodrigomelo9/pyfpga/-/tree/master#installation) uses `pìp install -e`. That is a default for developers, rather than users of the tool. I'd suggest not using `-e` in *Installation* but adding either a section or a note for *Development*.
- HDL sources and constraint files are added using the same API (`prj.add_files()`). However, those files belong to filesets of different nature. It would be desirable to have `prj.add_impl_files` or a similar method for adding constraint files.
- The code example in the main [README](https://gitlab.com/rodrigomelo9/pyfpga/-/blob/master/README.md) adds an `*.xdc` file without further comment. Many users who know the open source toolchains only are not familiar with specific vendor formats. It'd be desirable to add a comment making it explicit that this is a file with implementation constraints.
- In the [Basic usage](https://gitlab.com/rodrigomelo9/pyfpga/-/blob/master/doc/user_guide.md#basic-usage) guide:
  - The first code block includes `prj.set_outdir('../temp')`, which is an optional feature. I would split it to a second code block, after the comment listing the supported tool names.
  - I'd show the tool names as a list, in order to provide a brief description (one-liner). That would help understand which are the currently supported workflows.
  - Setting the part, adding the files and setting the top unit are three different tasks that can be done in any order. Therefore, I'd show them in three separated code blocks. Moreover, I think that `set_part` deserves a paragraph explaining which are the supported and tested identifiers. For instance, it is currently not possible to specify Lattice parts, and the part names for Xilinx must be the ones expected by the backend.
  - Adding constraints files is not explained in the basic usage guide; however, it is required for generating a usable bitstream. I'd suggest adding a very short reference about how to add constraints (`*.xdc`, `*.lpf`, `*.pcf`, etc.).
- In the example `pyfpga.py` script in this same subdir, sources need to be added twice because the type of the project is specified when the object is created. Would it be possible to make it in different steps? For example:

```py
srcs = FileSet('examples')
srcs.add_files(str(ROOT.parent / 'src' / '*.vhd'))

tasks = {
    'my-vivado-task': {
        'toolchain': 'vivado',
        'impl': {
            'impl0': {
                'top': 'demo',
                'part': 'xc7z020clg400-1',
                'srcs': FileSet('implementation', 'path/to.xdc')
            },
            'impl1': {
                'top': 'demo',
                'part': 'xc7k160t-3-fbg484',
                'srcs': FileSet('implementation', 'path/to.xdc')
            }
        },
    },
    'my-yosys-task': {
        'toolchain': 'yosys-nextpnr-icestorm',
        'impl': {
            'impl0': {
                'top': 'demo',
                'part': 'hx1k-tq144',
                'srcs': FileSet('implementation', 'path/to.pcf')
            }
        }
    }
}

for key, val in tasks.enumerate():
    for impl in val['impl']:
        prj = Project(val['toolchain'], 'vhdl-cfg_%s' % key)
        prj.add_fileset(srcs)
        prj.add_fileset(impl['srcs'])
        prj.set_top(impl['top'])
        prj.set_part(impl['part'])
        try:
            prj.generate()
        except Exception as e:
            print('{} ({})'.format(type(e).__name__, e))
```

So, the proposal is to manage multiple toolchains and/or multiple boards in the same script (for the same HDL design). However, each `Project` has a single target toolchain, part, top unit, etc. That is, most of PyFPGA is kept untouched. The concept of `add_fileset` is introduced only.

- There is no easy to find reference to which Block Design is used in Vivado by default. It would be handy to know how to provide a custom block design, where the HDL design is to be added.
