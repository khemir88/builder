#!/bin/bash

# Function to list all VMs
list_vms() {
    echo "Listing all VMs:"
    virsh list --all
}

# Function to destroy and remove each VM
destroy_and_remove_vms() {
    for vm in $(virsh list --all --name); do
        echo "Destroying VM: $vm"
        virsh destroy "$vm"

        echo "Undefining VM: $vm"
        virsh undefine "$vm"

        # Remove storage associated with the VM
        # Assuming the storage is defined in a specific path; adjust if necessary
        storage_path="/home/cristian/builder/$vm.qcow"
        if [ -f "$storage_path" ]; then
            echo "Removing storage: $storage_path"
            rm -f "$storage_path"
        else
            echo "Storage not found: $storage_path"
        fi
    done
}

# Main script execution
list_vms
destroy_and_remove_vms

