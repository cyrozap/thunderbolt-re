# ASUS ThunderboltEX 3 system-link cable

The "system-link" or "TB header" cable is the 5-conductor cable that connects the 9-pin, 10-position `TB_HEADER` header on the ThunderboltEX 3 to the 5-pin, 5-position `TB_HEADER` header on the motherboard.


## Cable description

> [!NOTE]
> In the following table, pins are numbered according to their PCB-side connector's pin numbering as described in the next section.
> Disregard the arrows on the cable connectors.

| Wire Color | Motherboard Connector Pin No. | Signal Description | TB Card Connector Pin No. |
| :--- | ---: | :--- | ---: |
| Black | 1 | Force Power (Host to Card, Active High) | 6 |
| Brown | 2 | CIO Plug Event (Card to Host, Active Low) | 7 |
| Red | 3 | Sleep S3 Indication (Host to Card, Active Low) | 9 |
| Orange | 4 | Sleep S5 Indication (Host to Card, Active Low) | 10 |
| Yellow | 5 | Ground | 2 |


## Connector information

> [!NOTE]
> Connectors are described from the perspective of each PCB, not the cable.


### Motherboard connector

Looking at the motherboard from above, with the connector oriented so that the latch on the left, the pins are numbered as follows:

```
 1
 2
 3
 4
 5
```


### Card connector

Looking at the PCB from above, with the PCIe bracket at the bottom, the PCIe edge connector on the right, and the pins of the right-angle dual-row header pointing to the left, the pins are numbered as follows:

```
  1   2
  3   4
  5   6
  7   8
  9  10
```

Position 5 does not have a pin, since it is the position of the key.
Positions 1, 3, 4, 5 (the key), and 8 are unconnected on the cable.

Pull-ups and pull-downs on the card:

- Pin 6 (Force Power): Pulled low via 100k resistor.
- Pin 7 (CIO Plug Event): Pulled high to 3V3 (PCIe standby power) via 8k37 resistor.
