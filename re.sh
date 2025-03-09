#!/bin/bash

# List all VMs and store their names in an array
vm_names=$(virsh list --all --name)

# Iterate through the array and delete each VM
for vm_name in "${vm_names[@]}"; do
    virsh destroy "$vm_name"  # Shut down the VM if it's running
    virsh undefine "$vm_name" --remove-all-storage  # Remove the VM and its storage
done

