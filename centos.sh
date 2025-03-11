dic_file="gr2.txt"
random_word=$(shuf -n 1 "$dic_file")
echo "$random_word"

virt-install \
	--name $random_word \
	--disk /mnt/vms/$random_word.qcow,size=13.1 \
	--os-variant centos7.0 \
	--memory 4098 \
	--vcpus 2 \
	--graphics none \
	--location location=../isos/CentOS-7-x86_64-DVD-2207-02.iso \
	--extra-args 'console=ttyS0,115200n8 serial' \
	--initrd-inject=centos7.cfg \
	--extra-args inst.ks=file:centos7.cfg \
	--cpu host \
	--extra-args inst.singlelang 
