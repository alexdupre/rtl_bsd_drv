=================================================================================
=  Realtek 8169S/8169SB/8169SC/8168B/8168C/8168CP/8168D/8168DP/8168E/8168F      =
=  8168FB/8168G/818GU/8168H/8168EP/8411/8168FP                                  =
=  8101E/8102E/8103E/8401/8105E/8106E/8402                                      =
=  8125/8126 Driver                                                             =
=  for FreeBSD v4.x/5.x/6.x/7.x/8.x/9.x/10.x/11.x/12.x/13.x                     =
=================================================================================

This driver is modified by Realtek Semiconductor corp. and it has been tested OK
on FreeBSD v5.4, FreeBSD v6.4, FreeBSD v7.3, FreeBSD v8.0, and FreeBSD v9.0. To
update the driver, you may use method 1. If method 1 failed, you must use method 2
which is more complex.

Method 1:
	1.Copy if_re.ko in "modules" directory to "/modules" directory and overwrite
	  the existing file.
	2.Modify the file "/boot/defaults/loader.conf" and set "if_re_load" in "Network
	  drivers" section to "Yes"
	3.Reboot.

Method 2:
	Because the FreeBSD kernel has default drivers to support RTL8139C and RTL8169S.
	To use the RTL8139C+, RTL8169SB, RTL8169SC, RTL8168B, and RTL8101E, you need to
	update your NIC driver by recompiling your FreeBSD kernel.

	The main steps you have to do:(FreeBSDSrcDir means the directory of FreeBSD source code
	and it may be "/usr/src/sys")

		1. keep the original driver source code:
			# cd /usr/src/sys/dev/re
			# cp if_re.c if_re.c.org

			# cd /usr/src/sys/modules
			# cp Makefile Makefile.org

			# cd /usr/src/sys/modules/re
			# cp Makefile Makefile.org

			# cd /usr/src/sys/<ARCH>/conf/
			# cp GENERIC GENERIC.org

		2. recompile your kernel (you must install your FreeBSD source code first !!)
			# vi /usr/src/sys/<ARCH>/conf/GENERIC and delete re
			# vi /usr/src/sys/modules/Makefile and delete re
			# cd /usr/src/sys/<ARCH>/conf
			# /usr/sbin/config GENERIC

			(for FreeBSD 5.x/6.x/7.x/8.x/9.x)
			# cd ../compile/GENERIC
			(for FreeBSD 4.x)
			# cd ../../compile/GENERIC

			# make clean
			# make depend
			# make
			# make install
			# reboot

		3. update the driver source code:
		    Copy the driver source code( if_re.c and if_rereg.h) into /usr/src/sys/dev/re
		    Copy the Makefile into /usr/src/sys/modules/re

		4. build the driver:
			# cd /usr/src/sys/modules/re
			# make clean
			# make

		5. install the driver
			(for FreeBSD 12 or later)
			# cd /usr/obj/usr/src/<arch>.<arch>/sys/modules
			# kldload ./if_re.ko
			(for FreeBSD 11 or earlier)
			# cd /usr/src/sys/modules/re

			# kldload ./if_re.ko

		6. configurate the static IP address
			# ifconfig re0 xxx.xxx.xxx.xxx netmask yyy.yyy.yyy.yyy

		7. configurate the IP address by DHCP
			# /sbin/dhclient re0

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
