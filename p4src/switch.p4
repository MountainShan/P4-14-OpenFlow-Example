// include p4 dependencies
#include "include/header.p4"
#include "include/parser.p4"
#include "include/default_actions.p4"

//Tables and actions
table ARPRouting {
	reads {
		arp_rarp_ipv4.srcProtoAddr: exact;
		arp_rarp_ipv4.dstProtoAddr: exact;
	}
	actions {
		setOutput;
		_drop;
	}
}

table IPv4Routing {
	reads {
		ipv4.srcAddr: exact;
		ipv4.dstAddr: exact;
	}
	actions {
		setOutput;
		_drop;
	}
}

// Control Schedules
control ingress {
	if (valid(arp_rarp_ipv4)){ 	//ARP Packet
		apply(ARPRouting);
	}
	if (valid(ipv4)) { // IPv4 Packet
		apply(IPv4Routing);
    }
}
