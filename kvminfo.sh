#!/bin/bash

### Get CPU count and total RAM of the KVM host
cpu_count=$(virsh nodeinfo | awk '/CPU\(s\):/ {print $2}')
total_ram=$(free -h|grep Mem|awk '{print $2}'| cut -d 'i' -f 1)
host=$(hostname)

### Print information about the KVM host
#echo -e "KVM Host Information:"
#echo -e "KVM Host CPU Count: $cpu_count"
#echo -e "KVM Host Total RAM: $total_ram"

### Print table header
echo -e "Device\tKVM Host\tDomain Name\tState\tVirtual CPUs\tMax Memory (GB)"
echo -e "Host\t$host\t$host\tRunning\t$cpu_count\t$total_ram"

### Get a list of all running domains
domains=$(virsh list --name)

### Loop through each domain
for domain in $domains; do
    ### Get domain info
    info=$(virsh dominfo "$domain")

    ### Extract required fields
    name=$(echo "$info" | awk '/Name:/ {print $2}')
    state=$(echo "$info" | awk '/State:/ {print $2}')
    memory=$(echo "$info" | awk '/Max memory:/ {print $3 / (1024*1024)}')
    vcpus=$(echo "$info" | awk '/CPU\(s\):/ {print $2}')
    ### Print formatted output

    echo -e "GuestVM\t$host\t$name\t$state\t$vcpus\t$memory"
done

exit 0
