register count {
    width:32;
    static: packetCounter;
    instance_count: 16384;
}
register pathCount {
    width: 32;
    static: packetCounter;
    instance_count: 16384;
}
register currentPathID {
    width: 32;
    static: pathUpdate;
    instance_count: 16384;
}
// RTT Calculation register
register portStartTimestamp {
	width: 48;
	static: recordENQTimestamp;
	instance_count: 16384;
}
register portReturnTimestamp1 {
	width: 48;
	static: calRTTviaPacketCapture;
	instance_count: 16384;
}
register portReturnTimestamp2 {
	width: 48;
	static: calRTTviaPacketCapture;
	instance_count: 16384;
}
