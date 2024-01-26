dic_file="/usr/share/dict/words"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install \
	--name $random_word --memory 2048 --disk path=/mnt/mucho2/$random_word,size=7.1 \
	--os-variant centos-stream8 \
	--memory 4098 \
	--location location=https://nc-centos-mirror.iwebfusion.net/centos/8-stream/BaseOS/x86_64/os/ \
	--cpu host --extra-args ip=dhcp --network bridge=bridge0 
