dic_file="/root/rancho.txt"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install \
	--name $random_word --memory 2048 \
	--disk path=/mnt/mucho2/$random_word,size=6.1 \
	--os-variant centos-stream8 \
	--memory 4098 \
	--vcpus 2 \
	--graphics none \
	--location location=/mnt/mucho2/CentOS-Stream-8-x86_64-latest-dvd1.iso \
	--extra-args 'console=ttyS0,115200n8 serial' \
	--initrd-inject=/root/ksc8.cfg \
	--extra-args inst.ks=file:ksc8.cfg \
	--cpu host \
	--network bridge=bridge0 \
	--network bridge=bridge10 \
	--extra-args inst.singlelang 
