#Ahora se supone que crea con PXE
dic_file="/usr/share/dict/words"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install \
	--name $random_word --memory 3052 --disk $random_word.qcow,size=12.1 \
	--install kernel=94/vmlinuz,initrd=94/initrd.img \
	--extra-args 'console=ttyS0,115200n8' \
	--os-variant rocky9.0 \
	--graphics none \
	--pxe \
	--cpu host --extra-args ip=dhcp --network bridge=virbr1
