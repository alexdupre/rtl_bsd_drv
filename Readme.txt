=================================================================================
=  Realtek 8169S/8169SB/8169SC/8168B/8168C/8168CP/8168D/8168DP/8168E/8168F      =
=  8168FB/8168G/818GU/8168H/8168EP/8411/8168FP                                  =
=  8101E/8102E/8103E/8401/8105E/8106E/8402                                      =
=  8125/8126 Driver                                                             =
=  for FreeBSD v4.x/5.x/6.x/7.x/8.x/9.x/10.x/11.x/12.x/13.x/14.x                =
=================================================================================

This is the official FreeBSD driver from Realtek Semiconductor corp. with a few
patches to improve stability and performance under high load.

The main issue is the unconditional use of the 9k jumbo clusters regardless of
the configured MTU. After sufficient fragmentation of the physical memory, new
allocations are impossible and the machine hangs in contigmalloc() looping for
rx ring mbuf refill, and other processes get stuck in a lock cascade for the
`re` driver lock. This patched driver adds the `hw.re.max_rx_mbuf_sz` tunable
to decrease the rx mbuf size.

The link speed and duplexmode can be changed by using following command.
	1. For auto negotiation,
		#ifconfig re<device_num> media autoselect

	2. For 10Mbps half-duplex,
		#ifconfig re<device_num> media 10baseT/UTP -mediaopt full-duplex

	3. For 10Mbps full-duplex,
		#ifconfig re<device_num> media 10baseT/UTP mediaopt full-duplex

	4. For 100Mbps half-duplex,
		#ifconfig re<device_num> media 100baseTX -mediaopt full-duplex

	5. For 100Mbps full-duplex,
		#ifconfig re<device_num> media 100baseTX mediaopt full-duplex

	6. For 1000Mbps full-duplex,
		#ifconfig re<device_num> media 1000baseTX mediaopt full-duplex

	7. For 2500Mbps full-duplex,
		#ifconfig re<device_num> media 2500Base-T mediaopt full-duplex

	8. For 5000Mbps full-duplex,
		#ifconfig re<device_num> media 5000Base-T mediaopt full-duplex

The checksum offload can be changed by using following command.
	1.For enable checksum offload
		# ifconfig re<device_num> rxcsum rxcsum6
		# ifconfig re<device_num> txcsum txcsum6

	2.For disable checksum offload
		# ifconfig re<device_num> -rxcsum -rxcsum6
		# ifconfig re<device_num> -txcsum -txcsum6

The tso offload can be changed by using following command.
	1.For enable tso offload
		# ifconfig re<device_num> tso
		or
		# ifconfig re<device_num> tso4 tso6

	2.For disable tso offload
		# ifconfig re<device_num> -tso
		or
		# ifconfig re<device_num> -tso4 -tso6

Dump statistics.
	# sysctl dev.re.<interface_num>.stats=1
	# dmesg

Dump mac io.
	# sysctl dev.re.<interface_num>.registers=1
	# dmesg

Dump pcie phy.
	# sysctl dev.re.<interface_num>.pcie_phy=1
	# dmesg

Dump ethernet phy.
	# sysctl dev.re.<interface_num>.eth_phy=1
	# dmesg

Dump extended registers.
	# sysctl dev.re.<interface_num>.ext_regs=1
	# dmesg

Dump pci registers.
	# sysctl dev.re.<interface_num>.pci_regs=1
	# dmesg

Dump tx/rx descriptors.
	# sysctl dev.re.<interface_num>.tx_desc=1
	# sysctl dev.re.<interface_num>.rx_desc=1
	# dmesg

Dump msix table.
	# sysctl dev.re.<interface_num>.msix_tbl=1
	# dmesg

Dump driver variables.
	# sysctl dev.re.<interface_num>.driver_var=1
	# dmesg
