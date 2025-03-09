dic_file="gr2.txt"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install \
	--name $random_word --memory 3052 --disk $random_word.qcow,size=12.1 \
	--install kernel=94/vmlinuz,initrd=94/initrd.img \
	--os-variant rocky9.0 \
	--graphics none \
	--video=vmvga \
	--extra-args="console=ttyS0,115200n8 hostname=$random_word quiet ip=dhcp" \
	--initrd-inject=ho.ks \
	--extra-args inst.ks=file:ho.ks \
	--location location=http://mirror.twds.com.tw/rockylinux/9.4/BaseOS/x86_64/os \
	--cpu host \
       	--network network=local2 
