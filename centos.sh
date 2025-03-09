dic_file="/root/rancho.txt"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install \
	--name $random_word --memory 2048 \
	--disk $random_word,size=6.1 \
	--os-variant centos7.0 \
	--memory 4098 \
	--vcpus 2 \
	--graphics none \
	--location location=/mnt/mucho2/CentOS-Stream-8-x86_64-latest-dvd1.iso \
	--extra-args 'console=ttyS0,115200n8 serial' \
	--initrd-inject=centos7.cfg \
	--extra-args inst.ks=file:centos7.cfg \
	--cpu host \
	--extra-args inst.singlelang 
