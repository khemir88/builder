virt-install \
  --name pxe-vm \
  --memory 4096 \
  --vcpus 2 \
  --disk size=12.0 \
  --os-variant rocky9.0 \
  --boot uefi \
  --location http://rockylinux.anexia.at/9.5/BaseOS/x86_64/os/ \
  --network network=local2,model=virtio \
  --autoconsole graphical \
  --console pty,target_type=serial


