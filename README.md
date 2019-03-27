# ButtonSwap3DS
Swap Nintendo 3DS button layout to match Xbox and PlayStation controllers.

![swap A with B and X with
Y](https://gitlab.com/aiden-vrenna/buttonswap3dsx/raw/master/meta/ABXY-Buttons-Red.jpg)

On both Xbox and PlayStation, the Accept/Action button is in the 6 o'clock 
(bottom) position, and the button for Back/Cancel is at 3 o'clock (right). 
Similarly in gameplay, the bottom button is often Attack/Interact, while the 
right button cancels attacks or performs some supplemental, non-primary 
function. Nintendo layout is the opposite.

Nintendo's B-A layout came first, with the release of the NES in 1983, so 
if anyone is 'backwards', it's technically Xbox and PlayStation. But if you 
prefer the layout of those systems, this is your fix.

## Credits
Memory patching code from BootNTR

Shinyquagsire for his writeup on redirecting input over WiFi.

Stary & Kazo for InputRedirector, upon which almost all of this is based.

## How to Use
Install the ButtonSwapNTR cia on your 3ds.

Not really configurable right now, but can be changed if you know ASM.

You will need a working setup of the devkitARM toolchain for 3DS, follow [this guide](https://www.3dbrew.org/wiki/Setting_up_Development_Environment) for help.

You will also need the [ScenicRoute](https://github.com/Stary2001/ScenicRoute) library by Stary2001.  Clone it, then run make install in the ScenicRoute directory.
Finally, clone this repository.

The instructions for each type of mapping are provided in [source/injected.s](../master/source/injected.s).  I've provided a Java program to generate the correct button masks and coordinate values.  When you have saved your mappings into this file, you will need to compile it.  To build, change to the ButtonSwap3DS directory in a terminal, then run make.
### Each data field, and how to get it
#### Button Masks
This is the data that defines which buttons will activate the remapping and which buttons will be pressed.  Either use the provided program, or manually calculate the mask using [this table](https://www.3dbrew.org/wiki/HID_Shared_Memory#PAD_State).
For example, this code would swap A and B:
```asm
ldr r4, =0x1
ldr r5, =0x2
bl .button
ldr r4, =0x2
ldr r5, =0x1
bl .button
```
##### The next two data fields are six digit numbers.  The first 3 digits are the Y coordinate data, and the last 3 digits are the X coordinate data.
#### Touchscreen Data
The data that will be sent as the touchscreen.  Use the provided tool to generate this data.
#### C-pad Data
Data that will be sent as the c-pad.  This data is a bit harder to calculate.  The default value for the C-pad is ```0x800800```.  To calculate this value, you will need to use the developer mode on your calculator.  Xor ```0x800800``` by the value you want the C-pad to have.  For example, if you want to have the C-pad pushed to the right, you would xor ```0x800800``` by ```0x800FFF```, giving you ```0x7FF```.  Pad this with 3 zeroes in front (```0x0007FF```), and you have your data!
