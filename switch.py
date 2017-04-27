# Copyright (C) 2011 Nippon Telegraph and Telephone Corporation.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_3
from ryu.lib.packet import packet
from ryu.lib.packet import ethernet
from ryu.lib.packet import ether_types

import os, time

class SimpleSwitch13(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super(SimpleSwitch13, self).__init__(*args, **kwargs)
        os.system("./9090.sh < 9090.txt")
        os.system("./9091.sh < 9091.txt")

    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        datapath = ev.msg.datapath
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        if datapath.id == 0x1:
            match = parser.OFPMatch(eth_type = 0x0800, ipv4_src = "10.0.0.10", ipv4_dst = "10.0.0.11")
            actions = [parser.OFPActionOutput(2)]
            self.add_flow(datapath, 10, match, actions)
            match = parser.OFPMatch(eth_type = 0x0800, ipv4_src = "10.0.0.11", ipv4_dst = "10.0.0.10")
            actions = [parser.OFPActionOutput(1)]
            self.add_flow(datapath, 10, match, actions)
            match = parser.OFPMatch(eth_type = 0x0806, in_port=1)
            actions = [parser.OFPActionOutput(2)]
            self.add_flow(datapath, 10, match, actions)
            match = parser.OFPMatch(eth_type = 0x0806, in_port=2)
            actions = [parser.OFPActionOutput(1)]
            self.add_flow(datapath, 10, match, actions)
        if datapath.id == 0x2:
            match = parser.OFPMatch(eth_type = 0x0800, ipv4_src = "10.0.0.10", ipv4_dst = "10.0.0.11")
            actions = [parser.OFPActionOutput(1)]
            self.add_flow(datapath, 10, match, actions)
            match = parser.OFPMatch(eth_type = 0x0800, ipv4_src = "10.0.0.11", ipv4_dst = "10.0.0.10")
            actions = [parser.OFPActionOutput(2)]
            self.add_flow(datapath, 10, match, actions)
            match = parser.OFPMatch(eth_type = 0x0806, in_port=1)
            actions = [parser.OFPActionOutput(2)]
            self.add_flow(datapath, 10, match, actions)
            match = parser.OFPMatch(eth_type = 0x0806, in_port=2)
            actions = [parser.OFPActionOutput(1)]
            self.add_flow(datapath, 10, match, actions)

    def add_flow(self, datapath, priority, match, actions, buffer_id=None):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        inst = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS,actions)]
        mod = parser.OFPFlowMod(datapath=datapath, priority=priority, match=match, instructions=inst)
        datapath.send_msg(mod)
