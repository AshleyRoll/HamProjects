# PSU Crowbar

The PSU Crowbar is designed to protect a radio from over voltage damage. This
can occur if the series pass transistor of your 13.8V high current linear power
supply goes short circuit.

Often the power supplies we use don't contain any internal crowbar and so have
killed radios in the past.

- [Schematic (pdf)](pdf/crobar-revA-schematic.pdf)
- [PCB Overlay (pdf)](pdf/crobar-revA-pcb-overlay.pdf)
- [Diptrace Design Files](design)

A crowbar is a feature in higher end bench power supplies and often the over-voltage
protection level is configurable. However, it is not normally fitted to simple
battery eliminator type supplies designed to replace SLA batteries.

These power supplies are generally capable of delivering tens of amps at 13.8V to
our radios.

This design is suitable to a power supply up to **30 Amps** at 13.8V, and is designed
for standard linear supplies.

Operation on a switch-mode supply has not been verified.

**IT IS CRITICAL THAT THE POWER SUPPLY HAS A CORRECTY RATED FUSE FITTED FOR SAFE OPERATION**

**ALWAYS HAVE A SUITABLE FUSE ON THE OUTPUT OF THE POWER SUPPLY BEFORE THE CROWBAR**

## Theory of operation

The circuit consists of a pretty hefty SCR, D1 placed across the supply rails. If this
device is trigged it is capable of handling a hefty current for a short period.

We arrange a voltage sense circuit so that we can trigger the SCR if the rail voltage
goes over a threshold. Once triggered, it will continue to conduct and short the rails
until voltage is removed (by blowing the fuse on the power supply output, or by the operator
turning off the supply).

The circuit is not designed to constantly handle the full rated current, it is designed to
rapidly clear the fuse and disable the supply.

**WARNING: Do not operate this device without the correctly rated fuse in the power supply output.**

U1 (TL431) is a precision voltage reference and in this design is configured as a voltage
switch. When the voltage at the reference input (pin 1) exceeds 2.495V, it will turn on hard
pulling the base of the PNP transistor Q1 down.

When Q1 turns on, it will pull the SCR's gate high, delivering enough current to trigger it
via R7.

The threshold voltage used to switch U1 on is set by the voltage divider R1, R2 and R3.
The values provided allow the trigger range to be adjusted between approximately
13.8V to 25.4V. See the calibration section below. C1 provides a small time constant
to prevent noise from triggering the crowbar. C2 provides some general noise filtering/decoupling.

R8 is used to pull the gate low to prevent noise from triggering the SCR, and R6 is used
to strongly pull the base of Q1 high to prevent it turning on during the short startup
transient current draw of U1.

## Assembly

The PCB is designed to be mounted into a section of 30mm x 15mm x 2mm (wall thickness)
aluminium square tubing. This is
[available from Bunnings](https://www.bunnings.com.au/metal-mate-30-x-15-x-2mm-x-1m-aluminium-rectangle-tube_p1130544)
in Australia, and I'm sure similar hardware stores elsewhere.

Most parts are mounted directly to the PCB. Resistors and capacitors are straight
forward, if you follow the board markings and [BOM](pdf/bill-of-materials.txt).

The internal height of the tube is not enough to allow TO-92 packages to be mounted
vertically and so I have indicated on the overlay they need to be laid back. The flat side
is up, so you can read the markings. Bend the centre lead down close to the body,
then the two outside legs are bent down to match the holes on the PCB. Try the keep the legs
short as you can to ensure the case doesn't fowl any other parts. I used some tweezers to 
make the bends.

The caps should be carefully positioned low. The LED is best mounted to so the it rests
against the edge of the PCB and the lead run back along the board to the pads. This way
it will shine out the tube end.

The SCR, D1 is a large package **WITH AN ISOLATED TAB**, the tab is used as one mounting
point, with the legs bent up approximately 3mm from the body (where the legs narrow).
The legs are then fed through the slots, soldered to the PCB and trimmed off.

If you are substituting a different SCR, you will need to deal with tab isolation and mounting
but remember, there can be substantial current when it fires, so keep the leads short!

The crowbar circuit is designed to be connected by 2 stout wires which are connected
**AFTER** the DC fuse and before the radio, so it can short the radio end of the fuse
to clear it.

These leads are soldered directly to the large pads and if possible this solder is extended back
to the SCR leads. This is the high current path so care should be taken to minimised lead
resistance.

**TODO:** Photos coming soon of the assembly

Once you complete calibration (see below), the assembly can be mounted into the
pre-drilled tube. Two M3 bolts are used to secure the SCR and the PCB. A small
insulating spacer (perhaps some PCB scraps with a 3.5mm hole drilled) will be needed
to raise the PCB off the tubing. It is also recommended that a plastic sleeve is
placed above and below the PCB, to prevent shorts.

## Calibration

To calibrate the device, access to a bench power supply with current limiting is
required.

### Setup

1. Set the power supply to the desired trigger voltage, 16V is a reasonable value
   (13.8V +15%) or 16.6V (13.8V + 20%). However I recommend reading the datasheet
   for your radio to determine a safe value.
2. Set the current limit on the supply to 200mA (0.2A)
3. Set R2 fully clockwise. This will be the maximum trigger voltage.

### Procedure

Connect the PSU Crowbar to the output of the power supply, turn it on. The power supply
should remain in constant-voltage (CV) mode. If not, check your assembly of the PCB and
that the power supply is set for less than 20V

Slowly turn R2 anti-clockwise until the power supply enters constant-current
mode (CC).

Turn off the supply output or disconnect the crowbar. Back the supply voltage back down
to 13.8V. Do not adjust the current limit!

Reconnect the crowbar to the supply and turn on. It should remain in CV mode. If not,
you may have overshot the setting or have an assembly fault.

Now slowly raise the power supply voltage until the crowbar triggers. Remove the crowbar again
and check the trigger voltage. You may need to tweak R2 slightly and re-test.

If you don't trust the voltage reading of the power supply, I'd suggest you put a meter
across the output and use that for voltage readings.

**Note:** setting R2 fully anti-clockwise will likely cause it to trip at the
nominal 13.8V level of most of the battery eliminator supplies.

## Modifications

It is possible to adjust R1 and R3 so the threshold voltage can be moved to suit
different supply rails. For instance a 24V supply.

**DO NOT EXCEED a 30V supply or a 30A max current**

## What do I do if it triggers?

1. Turn off the supply as soon as possible and remove mains power.
2. Fix or replace the supply, you likely have a shorted pass transistor in the regulator
   **It is critical the the fuse is replaced with the correct value, and any new PSU's fuse is also inspected prior to service**
3. Disassemble and inspect the crowbar circuit and discard if there is any damage
4. Re-test the crowbar using the calibration procedure

## Validation

I assembled the circuit and connected it to a bench power supply set for 13.8V and a current limit of 500mA.

The Crobar in this test is configured to fire at just over 16V.

The power supply allows me to enter a new voltage setting and apply it, so the voltage step
occurs quickly.


The 4 channels of my 'scope where connected to the circuit:
1. Input Voltage (yellow trace)
2. SCR Gate (blue trace)
3. Output of U1, R4 and R5. (purple trace)
4. U1 Reference Pin (green trace)

![Scope Capture](test/test01.png?raw=true)

Note the time scale is 20us a division.

We see channel 1 (input voltage, yellow) steady at 13.8V for approximately 2.5 divisions, then it starts
to ramp up. Channel 3 (U1 output, purple) follows the voltage up (note it is 5V a division).

We can clearly see when U1 begings to turn on and when the SCR fires killing the input voltage.

This time is approximately 17us.






