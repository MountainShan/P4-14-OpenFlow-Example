action _drop() {
    drop();
}

action _nop() {
}

action setOutput (port) {
    modify_field(standard_metadata.egress_spec, port);
    modify_field(intrinsic_metadata.priority, 0);
}
