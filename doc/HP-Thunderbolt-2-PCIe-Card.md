# HP Thunderbolt 2 PCIe Card GPIO cable for HP Z440, Z640, and Z840 systems

The "GPIO" cable is the 5-conductor cable that connects the 5-pin, 5-position header on the Thunderbolt 2 PCIe card to the 7-pin, 8-position `TBT1` / `E72` header on the HP Zx40 motherboard.

This PCIe card can also be used with HP Zx20 and HP Z230 systems, but those require different GPIO cables.
Since I only have Zx40 systems to test with, this document will only describe the cable for those systems.

The PCIe card has HP part number 753732-001, and is marked with model number MS-4361 (MSI appears to have designed the card).
The same card is also sold by Dell under part number 7HMHP / 07HMHP.


## Cable description

> [!NOTE]
> In the following table, pins are numbered according to their PCB-side connector's pin numbering as described in the next section.
> Disregard the arrows on the cable connectors.

| Motherboard Connector Pin No. | Signal Description | TB Card Connector Pin No. |
| ---: | :--- | ---: |
| TBD | Force Power (Host to Card, Active High) | 1 |
| TBD | CIO Plug Event (Card to Host, Active Low) | 2 |
| TBD | Sleep S3 Indication (Host to Card, Active Low) | 3 |
| TBD | Sleep S5 Indication (Host to Card, Active Low) | 4 |
| 5 and 7 | Ground | 5 |


## Connector information

> [!NOTE]
> Connectors are described from the perspective of each PCB, not the cable.


### Motherboard connector

This connector is an unshrouded 8-position dual-row male pin header with 0.1" (2.54 mm) spacing.

Looking at the motherboard from above, with the connector oriented so that the arrow is pointing to the pin in the top left corner, the pins are numbered as follows:

```
  1   2
  3   4
  5   6
  7   8
```

Position 8 does not have a pin, since it is the position of the key.
Positions 6 and 8 (the key) are unconnected on the cable.

Pin functions:

- Pin 5: Card detect, active low.
  This pin is connected to ground by the GPIO cable to tell the system that the PCIe card is present.
- Pin 7: Ground


### Card connector

This connector is a shrouded 5-pin latching male connector with 0.1" (2.54 mm) spacing.

Looking at the PCB from above, with the PCIe bracket at the top, the PCIe edge connector on the left, and the pins of the right-angle shrouded header pointing to the right, the pins are numbered as follows:

```
 1
 2
 3
 4
 5
```
