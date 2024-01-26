dic_file="/usr/share/dict/words"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

	virt-install --name $random_word --memory 2048 \
	--os-variant freedos1.2 \
	--disk path=/mnt/mucho2/$random_word,size=1.1,format=raw \
	--cdrom /mnt/mucho2/FD13LIVE.iso \
	--cpu host \
	--debug 
