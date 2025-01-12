#Utiliza virt-install para crear una VM
dic_file="/usr/share/dict/words"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install --install kernel=c8/vmlinuz,initrd=c8/initrd.img \
	--name $random_word --memory 2048 --disk path=/mnt/mucho2/$random_word,size=7.1 \
	--os-variant centos8 --cdrom /mnt/mucho2/CentOS-Stream-8-x86_64-latest-boot.iso \
#	--location location=/mnt/mucho2/CentOS-Stream-8-x86_64-latest-boot.iso \
	--cpu host --extra-args ip=dhcp --network bridge=bridge0 \
	--dry-run
