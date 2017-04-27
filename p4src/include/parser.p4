#define ETHERTYPE_IPV4 0x0800
#define ETHERTYPE_ARP 0x0806
#define ETHERTYPE_VLAN 0x8100
#define ARP_PROTOCOLTYPE_ARP_RARP_IPV4 0x0800
#define IP_PROT_TCP 0x06

header cpu_header_t cpu_header;
header ethernet_t ethernet;
header ipv4_t ipv4;
header tcp_t tcp;
header arp_rarp_t arp_rarp;
header arp_rarp_ipv4_t arp_rarp_ipv4;
header vlan_t vlan;
metadata intrinsic_metadata_t intrinsic_metadata;
metadata queueing_metadata_t queueing_metadata;
metadata meta_t meta;
metadata timestamp_t timestamp;


parser start {
    return select(current(0, 32)) {
        0x87654321 : parse_cpu_header;  // dummy transition
        default: parse_ethernet;
    }
}

parser parse_cpu_header {
    extract(cpu_header);
    set_metadata(meta.cpu_msgType, cpu_header.msgType);
    set_metadata(meta.cpu_deviceID, cpu_header.deviceID);
    set_metadata(meta.cpu_flag, cpu_header.flag);
    set_metadata(meta.cpu_portID, cpu_header.portID);
    return parse_ethernet;
}

parser parse_ethernet {
    extract(ethernet);
    set_metadata(meta.eth_srcAddr, ethernet.srcAddr);
	set_metadata(meta.eth_dstAddr, ethernet.dstAddr);
    return select(latest.etherType) {
        ETHERTYPE_IPV4 : parse_ipv4;
        ETHERTYPE_ARP : parse_arp_rarp;
        ETHERTYPE_VLAN : parse_vlan;
        default: ingress;
    }
}
parser parse_vlan {
    extract(vlan);
    return parse_ipv4;
}
parser parse_ipv4 {
    extract(ipv4);
    set_metadata(meta.tcpLength, ipv4.totalLen - 20);
    set_metadata(meta.ipv4_srcAddr, ipv4.srcAddr);
	set_metadata(meta.ipv4_dstAddr, ipv4.dstAddr);
    return select(ipv4.protocol) {
        IP_PROT_TCP : parse_tcp;
        default : ingress;
    }
}
field_list ipv4_checksum_list {
        ipv4.version;
        ipv4.ihl;
        ipv4.diffserv;
        ipv4.totalLen;
        ipv4.identification;
        ipv4.flags;
        ipv4.fragOffset;
        ipv4.ttl;
        ipv4.protocol;
        ipv4.srcAddr;
        ipv4.dstAddr;

}
field_list_calculation ipv4_checksum {
    input {
        ipv4_checksum_list;
    }
    algorithm : csum16;
    output_width : 16;
}
calculated_field ipv4.hdrChecksum  {
    verify ipv4_checksum;
    update ipv4_checksum;
}

parser parse_tcp {
    extract(tcp);
    set_metadata(meta.tcp_srcPort, tcp.srcPort);
    set_metadata(meta.tcp_dstPort, tcp.dstPort);
    set_metadata(meta.tcp_seqNo, tcp.seqNo);
    set_metadata(meta.tcp_ackNo, tcp.ackNo);
    return ingress;
}
field_list tcp_checksum_list {
        ipv4.srcAddr;
        ipv4.dstAddr;
        8'0;
        ipv4.protocol;
        meta.tcpLength;
        tcp.srcPort;
        tcp.dstPort;
        tcp.seqNo;
        tcp.ackNo;
        tcp.dataOffset;
        tcp.res;
        tcp.flags;
        tcp.window;
        tcp.urgentPtr;
        payload;
}
field_list_calculation tcp_checksum {
    input {
        tcp_checksum_list;
    }
    algorithm : csum16;
    output_width : 16;
}
calculated_field tcp.checksum {
    verify tcp_checksum if(valid(tcp));
    update tcp_checksum if(valid(tcp));
}

parser parse_arp_rarp {
    extract(arp_rarp);
    return select(latest.protoType) {
        ARP_PROTOCOLTYPE_ARP_RARP_IPV4: parse_arp_rarp_ipv4;
        default: ingress;
    }
}
parser parse_arp_rarp_ipv4 {
    extract(arp_rarp_ipv4);
    return ingress;
}
