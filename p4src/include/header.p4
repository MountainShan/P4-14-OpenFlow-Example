header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}

header_type ipv4_t {
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        totalLen : 16;
        identification : 16;
        flags : 3;
        fragOffset : 13;
        ttl : 8;
        protocol : 8;
        hdrChecksum : 16;
        srcAddr : 32;
        dstAddr: 32;
    }
}

header_type tcp_t {
    fields {
        srcPort : 16;
        dstPort : 16;
        seqNo : 32;
        ackNo : 32;
        dataOffset : 4;
        res : 4;
        flags : 8;
        window : 16;
        checksum : 16;
        urgentPtr : 16;
    }
}

header_type arp_rarp_t {
    fields {
        hwtype: 16;
        protoType: 16;
        hwAddrLen: 8;
        protoAddrLen: 8;
        opcode: 16;
    }
}

header_type arp_rarp_ipv4_t {
    fields {
        srcHwAddr : 48;
        srcProtoAddr : 32;
        dstHwAddr : 48;
        dstProtoAddr : 32;
    }
}

header_type intrinsic_metadata_t {
	fields {
		ingress_global_timestamp : 48;
		mcast_grp : 4;
		egress_rid : 4;
		mcast_hash : 16;
		lf_field_list: 32;
		resubmit_flag : 16;
		priority : 8;
	}
}
header_type queueing_metadata_t {
	fields {
		enq_timestamp : 48;
		enq_qdepth : 16;
		deq_timedelta : 32;
		deq_qdepth : 16;
	}
}

header_type meta_t {
    fields {
        tcpLength : 16;
        cpu_msgType: 8;
        cpu_deviceID: 8;
        cpu_flag: 8;
        cpu_portID: 8;
        eth_srcAddr: 48;
        eth_dstAddr: 48;
        ipv4_srcAddr: 32;
        ipv4_dstAddr: 32;
        tcp_srcPort: 16;
        tcp_dstPort: 16;
        tcp_seqNo: 32;
        tcp_ackNo: 32;
        seqNo: 32;
        ackNo: 32;
        idx: 32;
		currentPathID: 32;
		count: 32;
		count_temp:32;
		pathCount: 32;
        rttFlag: 32;
        packet_length: 32;
        vid: 32;
    }
}

header_type timestamp_t {
    fields {
		portStartTimestamp: 48;
		currentTimestamp: 48;
		MAXtimestamp: 48;
		resultTimestamp: 48;
		MAXTimestamp: 48;
    }
}

header_type cpu_header_t {
    fields {
        identifier: 32;
        msgType: 8;
        deviceID: 8;
        flag: 8;
        portID: 8;
    }
}

header_type vlan_t {
    fields {
        pcp : 3;
	    cfi : 1;
	    vid : 12;
	    ethType : 16;
    }
}
