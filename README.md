Legend of Zelda Spirit Tracks D-Pad Patch
===============
This patch implements non-touchscreen controls for essential actions in *The Legend of Zelda: Spirit Tracks*.

Control Bindings:
-------------
* D-Pad = Run
* Y + D-Pad = Walk
* B = Wide Slash
* B + D-Pad = Long slash
* Y + B = Spin Attack
* A = Interact
* A + D-Pad = Roll

Compiling
-------------
Compiling these sources requires:

* [Python 3.7+](https://www.python.org/)
* [armips](https://github.com/Kingcom/armips) by Kingcom
* [blz](https://www.romhacking.net/utilities/826/) by CUE
* [ndstool](https://github.com/devkitPro/installer/releases) by DarkFader (*this is included in a devkitPro installation in (**devkitPro install folder**)\tools\bin*)
* *The Legend of Zelda: Spirit Tracks* ROM

After obtaining the required tools:
1. Copy `armips`, `blz`, and `ndstool` to parent directory, with `compile.bat`.
1. Copy a **US** or **EU** copy of *The Legend of Zelda: Spirit Tracks* to the `unpack` directory and name it `input.nds`.
1. Run `compile.bat`.

Compatibility
-------------
This patch has only been tested with the **US** and **EU** release of *The Legend of Zelda: Spirit Tracks*. Support for other regions hasn't been tested so it may or may not work.
