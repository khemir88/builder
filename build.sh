dic_file="/usr/share/dict/words"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"


virt-builder $1 -o /mnt/mucho2/$random_word.img \
	--hostname $random_word \
	--root-password password:password \
	--smp 2 \
	--install vim \
	--copy /root/builder/priv.conf:/etc/dnsmasq.d/

echo now try run:
echo virt-install --name $random_word --disk /mnt/mucho2/$random_word.img --import --memory 2048 --cpu host --graphics none --os-variant $1 --network bridge=bridge0


