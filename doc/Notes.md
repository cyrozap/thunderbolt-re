# Reverse engineering notes


## Card initialization by platform firmware

For Alpine Ridge cards and earlier, due to quirks of the Thunderbolt host controller the way that the platform needs to probe for and initialize it is a bit strange.
Specifically, the card starts in a sleep state, and in that sleep state the PCI VID:DID pair is `FFFF:FFFF`, which per the PCI spec is invalid and may indicate a bus fault.
To get the card out of that state, the platform firmware needs to send a wake command to a mailbox register called `PCIE2TBT` in the Thunderbolt host controller's PCI configuration space.

Unfortunately, the firmware doesn't know that a device is a Thunderbolt host controller since it will otherwise appear to the system as just an ordinary PCI bridge with invalid IDs.
To know for certain whether or not a bridge that was found is a Thunderbolt host controller, the platform firmware needs to access the configuration registers of the potential Thunderbolt host controller's downstream-facing port.
To do this, platform firmware must initialize the found bridge's primary, secondary, and subordinate buses.
Performing a full bus allocation isn't necessary--only function zero of device zero on the secondary bus needs to be accessed.

After initializing the buses, reading the downstream-facing port's VID:PID pair, and confirming that the pair matches that of a known Thunderbolt host controller's PCI bridge, the platform firmware can bring the Thunderbolt host controller out of sleep mode.
To do this, perform the following steps:

1. Read the Thunderbolt host controller's `TBT2PCIE` register, `0x548`.
2. If bit zero ("Done") is set, wait for 100ms or some other tolerable amount of time for whatever transaction was happening to complete.
   Otherwise, proceed.
3. Write the value `0x00000009` (`Sx_Exit_TBT_Connected` command with "Valid" bit set) to the `PCIE2TBT` register, `0x54c`.
4. Repeatedly read `TBT2PCIE` until bit zero of that register is set.
5. Clear the `PCIE2TBT` register.

With that process complete, the upstream-facing port of the Thunderbolt host controller will have valid PCI IDs, and initialization of the bridge can continue mostly as normal.
The only exception to normal PCI bridge bus and memory allocation is that enough buses and memory should be allocated to the Thunderbolt PCI bridge to enable it to work with any device or combination of devices that may later be connected to it.


## Prior work


### Firmware RE

- [Thunderbolt 3 Fix (Part 3)](https://osy.gitbook.io/hac-mini-guide/details/thunderbolt-3-fix-part-3)
- [Thunderbolt Controller Firmware Patcher](https://github.com/BjornRuytenberg/tcfp)


### Hardware RE

- [Funderbolt: Adventures in Thunderbolt DMA Attacks](https://media.blackhat.com/us-13/US-13-Sevinsky-Funderbolt-Adventures-in-Thunderbolt-DMA-Attacks-Slides.pdf)
