dic_file="/usr/share/dict/words"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"


virt-builder ubuntu-20.04 -o /mnt/mucho2/$random_word.img \
	--hostname $random_word --install vim,dnsmasq \
	--root-password password:password 


echo now try run:
echo virt-install --name $random_word --disk /mnt/mucho2/$random_word.img --import --memory 2048 --cpu host --graphics none \
echo              --network bridge=bridge0

