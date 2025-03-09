dic_file="/usr/share/dict/words"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install \
	--name $random_word --memory 2048 --disk path=/mnt/mucho2/$random_word,size=7.1 \
	--os-variant centos-stream8 \
	--memory 4098 \
	--vcpus 2 \
	--location location=/mnt/mucho2/CentOS-Stream-8-x86_64-latest-dvd1.iso \
	--cpu host \
	--network bridge=bridge0 \
	--extra-args ip=dhcp \
	--extra-args inst.singlelang \
	--extra-args "nameserver 8.8.8.8"
