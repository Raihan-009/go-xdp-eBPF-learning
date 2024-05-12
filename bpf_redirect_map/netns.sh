#!/bin/bash

BUILD="build"
CLEAN="clean"

NODE1="node1"
NODE2="node2"


if [ "$BUILD" = "$1" ]; then
	ip netns add "$NODE1"
	ip netns add "$NODE2"
	ip link add veth0 type veth peer veth1
	ip link add veth2 type veth peer veth3
	ip link set veth1 netns "$NODE1"
	ip link set veth2 netns "$NODE1"
	ip link set veth3 netns "$NODE2"
	ip addr add 192.168.0.3/24 dev veth0
	ip netns exec "$NODE1" ip addr add 192.168.0.2/24 dev veth1
	ip netns exec "$NODE1" ip addr add 192.168.1.4/24 dev veth2
	ip netns exec "$NODE2" ip addr add 192.168.1.5/24 dev veth3
	ip link set up dev veth0
	ip netns exec "$NODE1" ip link set up dev veth1
	ip netns exec "$NODE1" ip link set up dev veth2
	ip netns exec "$NODE1" ip link set up dev lo
	ip netns exec "$NODE2" ip link set up dev veth3
	ip netns exec "$NODE2" ip link set up dev lo
	ip netns exec "$NODE1" ip route add 192.168.1.0/24 via 192.168.1.4 dev veth2
	ip route add 192.168.1.0/24 via 192.168.0.2

elif [ "$CLEAN" = "$1" ]; then
	ip netns del "$NODE1"
	ip netns del "$NODE2"
else
	echo "help:"
	echo "	build: build a network to test with netns"
	echo "	clean: clean up a network"
fi


