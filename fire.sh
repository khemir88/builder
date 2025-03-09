dic_file="gr2.txt"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install \
	--name $random_word --memory 3052 --disk /mnt/vms/$random_word.qcow,size=12.1 \
	--install kernel=94/vmlinuz,initrd=94/initrd.img,bootdev=default \
	--os-variant rocky9.0 \
	--graphics none \
	--extra-args="console=ttyS0,115200n8 hostname=$random_word ip=dhcp" \
	--initrd-inject=fire.ks \
	--extra-args inst.ks=file:fire.ks \
	--location location=http://mirror.aarnet.edu.au/pub/rocky/9.4/BaseOS/x86_64/os \
	--cpu host \
	--vcpus 'sockets=1,cores=2' \
       	--network network=default --network network=local2
