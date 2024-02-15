dic_file="/usr/share/dict/words"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install \
	--name $random_word --memory 2048 --disk path=/mnt/mucho2/$random_word,size=8.1 \
	--os-variant centos-stream8 \
	--vcpus 2 \
	--cpu host \
	--network bridge=bridge10 \
	--boot network \
	--pxe 
