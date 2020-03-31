# Call Sign Morse Code Badge

This project is my wearable call sign badge. Its a PCB with my name and call
sign, with a small micro-controller that will send my call sign as Morse on an
LED.

_This is a work in progress, updates will be made once I receive the boards from
manufacturing and can assemble and test the badge._

## Hardware

The hardware schematic and PCB are designed in
[Diptrace](https://diptrace.com/), there is a free version available.

The design centres around a *PIC10LF322*, an 8-bit micro-controller from
Microchip. I use the 6 pin variant in an SOT-23-6 package. This is powered by a
CR2032 cell in a holder and has a minimum of additional components to flash the
LED.

There is a reset switch (to restart the sending sequence once it goes to sleep)
and a programming port on the back to allow the firmware to be updated.

I've also added a small prototyping section with all signals accessible for
hacking on additional circuits if desired.

## Firmware

This is a simple `Makefile` based assembly language project. I've implemented
it on Linux using the Microchip XC8 MPASM assembler.

The `Makefile` will need to be updated to point to the correct installation
locations for XC8 and MPLABX. (I used the MPLABX installation to drive my
PicKit3 for programming only, so it can be skipped).

The firmware will send a Morse code message (for instance a call sign)
repeatedly several time, then it will go back to sleep until the reset button
is pressed.

While sending the Morse code, the micro-controller will be asleep as much as
possible as well.

Once complete I'll add some power measurements to get an idea of how long a
cell can last powering this badge.


