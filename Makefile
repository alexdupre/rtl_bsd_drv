# $FreeBSD: src/sys/modules/re/Makefile,v 1.6 2000/01/28 11:26:34 bde Exp $

enable_fiber_support = n
enable_s5wol = n
enable_eee = n
enable_s0_magic_packet = n


.PATH:	${.CURDIR}/../../dev/re
KMOD	= if_re
SRCS	= if_re.c opt_bdg.h device_if.h bus_if.h pci_if.h

.if $(enable_fiber_support) == y
SRCS	+= if_fiber.c
CFLAGS	+= -DENABLE_FIBER_SUPPORT
.endif

.if $(enable_s5wol) == y
CFLAGS	+= -DENABLE_S5WOL
.endif

.if $(enable_eee) == y
CFLAGS	+= -DENABLE_EEE
.endif

.if $(enable_s0_magic_packet) == y
CFLAGS	+= -DENABLE_S0_MAGIC_PACKET
.endif

.include <bsd.kmod.mk>
