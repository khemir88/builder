dic_file="nombres.txt"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install \
	--name $random_word --memory 3052 --disk /mnt/vms/$random_word.qcow,size=12.1 \
	--os-variant rocky9.0 \
	--graphics none \
	--extra-args="console=ttyS0,115200n8 hostname=$random_word ip=dhcp" \
	--initrd-inject=RF.ks \
	--extra-args inst.ks=file:RF.ks \
	--location /home/cristian/builder/Rocky-9.5-x86_64-dvd/Rocky-9.5-x86_64-dvd.iso \
	--cpu host \
	--vcpus 'sockets=1,cores=2' \
       	--network network=default --network network=local2 
