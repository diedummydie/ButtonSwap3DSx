# ButtonSwap3DSx

Swap **Nintendo 3DS** buttons with the layout of Xbox and PlayStation controllers

![swap A with B and X with Y](https://gitlab.com/aiden-vrenna/buttonswap3dsx/raw/master/meta/ABXY-Buttons-Red.jpg)

On Xbox and PlayStation consoles, the **Accept/Action** button is in the bottom position, and the button for **Back/Cancel** is to the right. Nintendo layout is the opposite. Nintendo was first on the scene with the NES released in 1983, but some may still prefer Xbox and PlayStation layout. This swaps A with B and X with Y, no other buttons affected. Remains in effect until you restart.

## How to Use

Download the latest build from Releases (link tbd), and install ButtonSwap.cia on your [unlocked (cfw)](https://3ds.hacks.guide) **Nintendo 3DS** using a CIA manager like FBI.

Launch the app, then press the Home button to get back to the normal 3DS menu and start a game. 

---

<span style="color:gray">

### About Mode3 Build

ButtonSwap-Mode3 is a special build for running ButtonSwap with extended memory games on old3DS. There is no need to install ButtonSwap-Mode3 on new3DS since the main edition works just fine.

### How to customize

ButtonSwap3DS(x) isn't really configurable unless you know how to write assembly language code for ARM processors. This project exists so that you don't have to compile it yourself.

If you do wish to customize, you will need a working setup of the [devkitARM](https://www.3dbrew.org/wiki/Setting_up_Development_Environment) toolchain for 3DS.

You will also need the [ScenicRoute](https://github.com/Stary2001/ScenicRoute) library by Stary2001. Clone it, then run make install in the ScenicRoute directory.

You may also need [bannertool](https://github.com/Steveice10/bannertool/releases) and [makerom](https://github.com/profi200/Project_CTR/releases), and either add them to your $PATH or install them somewhere already in your $PATH like /usr/local/bin.

Finally, clone this repository. If you would prefer to work with the upstream project, you may need to remove references to SeedDB in cia.rsf and cia_mode3.rsf as I did.

The instructions for each type of mapping are provided in source/injected.s.  Micahjc provided a Java app to generate the correct button masks and coordinate values. When you have saved your mappings into this file, you will need to compile it. To build, change to the ButtonSwap3DS directory in a terminal, then run make.

For example, this is the code for the ButtonSwap3DSx configuration which is included in the release here.

</span>

```asm
@ Swap A|B
ldr r4, =0x1
ldr r5, =0x2
bl .button
ldr r4, =0x2
ldr r5, =0x1
bl .button
@ Swap X|Y
ldr r4, =0x400
ldr r5, =0x800
bl .button
ldr r4, =0x800
ldr r5, =0x400
bl .button
```

### Acknowledgements

44670 for memory patching code from [BootNTR](https://github.com/44670/BootNTR)

Shinyquagsire23 for his writeup on [redirecting input over WiFi](http://douevenknow.us/post/139673444953/redirecting-3ds-input-over-wifi)

Stary2001 & Kazo for [InputRedirection](https://github.com/Stary2001/InputRedirection)

Mikahjc for [ButtonSwap3DS](https://github.com/mikahjc/ButtonSwap3DS), from which this project was forked

