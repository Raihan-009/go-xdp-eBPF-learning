#!/bin/bash

## Arguments
BUILD="build"
CLEAN="clean"

## Variables
NODENAME="node2"
VETH_HOST="veth2"
VETH_HOST_IP="192.168.0.5/24"
VETH_NS="veth3"
VETH_NS_IP="192.168.0.4/24"

## ENV Setup
if [ "$BUILD" = "$1" ]; then
	ip netns add "$NODENAME"
	ip link add "$VETH_HOST" type veth peer "$VETH_NS"
	ip link set "$VETH_NS" netns "$NODENAME"
	ip addr add "$VETH_HOST_IP" dev "$VETH_HOST"
	ip netns exec "$NODENAME" ip addr add "$VETH_NS_IP" dev "$VETH_NS"
	ip link set up dev "$VETH_HOST"
	ip netns exec "$NODENAME" ip link set up dev "$VETH_NS"
	ip netns exec "$NODENAME" ip link set up dev lo

elif [ "$CLEAN" = "$1" ]; then
	ip netns del "$NODENAME"
else
	echo "help:"
	echo "	build: build a network to test with netns"
	echo "	clean: clean up a network"
fi


