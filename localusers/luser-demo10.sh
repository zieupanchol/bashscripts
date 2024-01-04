#!/bin/bash

# This script show open network ports on a system.
# Use -4 as an argumentto limit ports output to IPV4. 

 netstat -nutl ${1} | grep ':' | awk '{print $4}'| awk -F ':' '{print $2}'
