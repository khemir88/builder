dic_file="/usr/share/dict/words"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install \
	--name $random_word --memory 2048 --disk path=/mnt/mucho2/$random_word,size=7.1 \
	--os-variant centos-stream8 \
	--memory 2048 \
	--graphics none \
	--vcpus 2 \
	--location location=/mnt/mucho2/CentOS-Stream-8-x86_64-latest-dvd1.iso \
	--extra-args 'console=ttyS0,115200n8 serial' \
	--initrd-inject=/root/cli.cfg \
	--extra-args inst.ks=file:cli.cfg \
	--cpu host \
	--network bridge=bridge10 \
	--extra-args inst.singlelang 
