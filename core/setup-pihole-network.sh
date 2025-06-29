#!/bin/bash

# Create macvlan interface for Pi-hole communication
ip link add macvlan0 link enp2s0 type macvlan mode bridge
ip addr add 192.168.100.88/32 dev macvlan0
ip link set macvlan0 up
ip route add 192.168.100.149/32 dev macvlan0
