=================================================================================
=  Realtek 8169S/8169SB/8169SC/8168B/8168C/8168CP/8168D/8168DP/8168E/8168F      =
=  8168FB/8168G/818GU/8168H/8168EP/8411/8168FP                                  =
=  8101E/8102E/8103E/8401/8105E/8106E/8402                                      =
=  8125 Driver                                                                  =
=  for FreeBSD v4.x/5.x/6.x/7.x/8.x/9.x/10.x/11.x/12.x/13.x                     =
=================================================================================

This is the official FreeBSD driver from Realtek Semiconductor corp. with a few
patches to improve stability and performance under high load.

The first issue is the unconditional use of the 9k jumbo clusters regardless of
the configured MTU. After sufficient fragmentation of the physical memory, new
allocations are impossible and the machine hangs in contigmalloc() looping for
rx ring mbuf refill, and other processes get stuck in a lock cascade for the
`re` driver lock. This patched driver adds the `hw.re.max_rx_mbuf_sz` tunable
to decrease the rx mbuf size.

The second issue is that multiple `re` devices share the same task queue for
processing interrupts, and the interrupt handler always sync the device's TX/RX
buffers, regardless of whether the corresponding interrupt bit is set. This
patched driver creates a new task queue per device and checks the set bits.
