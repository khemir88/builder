dic_file="gr2.txt"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install \
	--name $random_word --memory 3052 --disk $random_word.qcow,size=12.1 \
	--install kernel=94/vmlinuz,initrd=94/initrd.img,bootdev=local2 \
	--os-variant rocky9.0 \
	--extra-args="console=ttyS0,115200n8 hostname=$random_word ip=dhcp" \
	--initrd-inject=cliente.ks \
	--extra-args inst.ks=file:cliente.ks \
	--cpu host \
	--autoconsole graphical \
	--pxe \
	--boot network \
       	--network network=local2,model=virtio 
