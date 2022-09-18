Dragon Experiments
==================

This repository is a collection of small assembler programs for the Dragon series of home computers.


Running
-------

All programs can be compiled by running `make`.

```powershell
make
```

Then run a specific program in XRoar.

```powershell
.\Start-Program bin\hello-world.bin
```


Dependencies
------------

Building and using the programs in this repository requires a small number of software components to be installed and available on the default program search path.

*   [XRoar](https://www.6809.org.uk/xroar/)
*   [Asm6809](https://www.6809.org.uk/asm6809/)
*   Make

Under Windows 10 and later `make` can be installed by running `winget install gnuwin32.make`.
