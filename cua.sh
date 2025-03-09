dic_file="/usr/share/dict/words"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install \
	--name $random_word --memory 3052 --disk $random_word.qcow,size=22.1 \
	--install kernel=94/vmlinuz,initrd=94/initrd.img \
	--os-variant rocky9.0 \
	--graphics none \
	--vide=vmvga \
	--extra-args 'console=ttyS0,115200n8' \
	--initrd-inject=MasterR94.ks \
	--extra-args inst.ks=file:MasterR94.ks \
	--location location=http://mirror.twds.com.tw/rockylinux/9.4/BaseOS/x86_64/os \
	--cpu host --extra-args ip=dhcp --network bridge=virbr0 --network bridge=virbr1
