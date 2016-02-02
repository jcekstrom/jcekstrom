#!/bin/bash

sudo route add -host 139.85.4.125 gw $1 metric 50 tun0
