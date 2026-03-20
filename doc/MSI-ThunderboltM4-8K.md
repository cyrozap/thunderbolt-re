# MSI ThunderboltM4 8K motherboard cable

The motherboard cable is the 15-conductor cable that connects the 15-pin, 16-position `JTBT1` header on the ThunderboltM4 8K to the 15-pin, 16-position `JTBT1` header on the motherboard.


## Cable description

> [!NOTE]
> In the following table, pins are numbered according to their PCB-side connector's pin numbering as described in the next section.
> Disregard the arrows on the cable connectors.

The cable is straight-through, so the connectors and pinouts are the same on both ends.

| Connector Pin No. | Signal Description |
| ---: | :--- |
| 1 | Force Power (Host to Card, Active High) |
| 3 | CIO Plug Event (Card to Host, Active Low) |
| 5 | Sleep S3 Indication (Host to Card, Active Low) |
| 7 | Sleep S5 Indication (Host to Card, Active Low) |
| 9 | Ground |
| 11 | `DG_PEWAKE#` |
| 13 | `TBT_RTD3_PWR_EN` |
| 15 | Card Detect (Card to Host, Active Low) |
| 2 | `TBT_S0IX_ENTRY_REQ` |
| 4 | `TBT_S0IX_ENTRY_ACK` |
| 6 | `TBT_PSON_OVERRIDE_N` |
| 10 | `SMBCLK_VSB` |
| 12 | `SMBDATA_VSB` |
| 14 | Ground |
| 16 | `PD_IRQ#` |


## Connector information

> [!NOTE]
> Connectors are described from the perspective of each PCB, not the cable.

The connector is the same on both the motherboard and the PCIe card.

This connector is an unshrouded 16-position dual-row male pin header with ?.?" (?.?? mm) spacing.

Looking at the connector from above, with the connector oriented so that missing pin is on the right, the pins are numbered as follows:

```
  1   2
  3   4
  5   6
  7   8
  9  10
 11  12
 13  14
 15  16
```

Position 8 does not have a pin, since it is the position of the key.

Pin 15 is tied to Ground on the card, to enable the motherboard to detect the presence of the PCIe card.
