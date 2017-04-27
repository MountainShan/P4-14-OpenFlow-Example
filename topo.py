#!/usr/bin/python

# Copyright 2013-present Barefoot Networks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from mininet.net import Mininet
from mininet.topo import Topo
from mininet.log import setLogLevel, info
from mininet.cli import CLI
from mininet.link import TCLink, Intf
from mininet.node import RemoteController, OVSSwitch
from p4_mininet import P4Switch, P4Host

import argparse
import os, sys, time
import subprocess
import random

parser = argparse.ArgumentParser(description="Mininet demo")
parser.add_argument("--behavioral-exe", help="Path to behavioral executable", type=str, action="store", required=True)
parser.add_argument("--json", help="Path to JSON config file", type=str, action="store", required=True)
parser.add_argument("--msg", help="odPairConfig", type=str, action="store", required=False)
args = parser.parse_args()

def main():
	P4SwitchList = []
	OFSwitchList = []
	HostList = []
	BackgroundHostList = []
	net = Mininet(controller = None, link = TCLink)
	Controller = RemoteController( 'Controller', ip='127.0.0.1', port=6633)

	for i in xrange(2):
		OFSwitchList.append(net.addSwitch("o%s"%str(i+1), cls = OVSSwitch))

	for i in xrange(2):
		P4SwitchList.append(net.addSwitch("p%s"%str(i+1), cls = P4Switch, sw_path=args.behavioral_exe, json_path=args.json, thrift_port=(9090+i)))

	for i in xrange(2):
		HostList.append(net.addHost("h%s"%str(i+1), cls = P4Host, ip = "10.0.0.%s/24"%str(i+10), mac = "00:04:00:00:00:%s"%str(i+1)))

	net.addLink(HostList[0], P4SwitchList[0])
	net.addLink(HostList[1], P4SwitchList[1])

	net.addLink(OFSwitchList[0], P4SwitchList[0])
	net.addLink(OFSwitchList[1], P4SwitchList[1])

	net.addLink(OFSwitchList[0], OFSwitchList[1])

	net.start()
	for x in xrange(2):
		net.get("o%s"%str(x+1)).start([Controller])
	CLI(net)
	net.stop()

if __name__ == "__main__":
	setLogLevel( "info" )
	main()
