#Utiliza virt-install para crear una VM
dic_file="/usr/share/dict/words"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install --install kernel=94/vmlinuz,initrd=94/initrd.img \
	--name $random_word --memory 2048 --disk $random_word,size=12.1 \
	--cpu host --extra-args ip=dhcp \
	--osinfo rocky9 \
	--network network=default 
