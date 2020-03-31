# Ham Projects

This repository contains various electronics projects for Ham Radio that I have
created.

My call sign is _**VK4ASH**_, I hold an Advanced licence in Australia (equivalent to Extra in
the US). My interests are in home brew, and QRP (Low power) digital modes.


## [PSU Crowbar](psu-crowbar)

The [PSU Crowbar](psu-crowbar) is designed to protect a radio from over voltage damage. This
can occur if the series pass transistor of your 13.8V high current linear power
supply goes short circuit.

Often the power supplies we use don't contain any internal crowbar and so have
killed radios in the past.


## [Call Sign Morse Code Badge](badge)

A [Call Sign Badge](badge) that sends Morse code on an LED. This design is for
my call sign, but feel free to modify the design files to add yours.

The firmware uses a *PIC10LF322* and stores a fixed message which is easily
changed and rebuilt. The micro-controller is programmed to sleep as much as
possible to preserve the CR2032 cell as long as possible.


# Licensing

All hardware in this repository is licensed under the [CERN Open Hardware License v1.2](cern_ohl_v_1_2.txt)
and is Copyright (C) Ashley Roll.

All software in the repository is licensed under the [MIT License](LICENSE)
and is Copyright (C) Ashley Roll.
