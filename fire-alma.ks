#version=RHEL9
# Use graphical install
skipx
text
cdrom

%addon com_redhat_kdump --disable
%end
url --url=https://mirror.grid.uchicago.edu/pub/linux/alma/9.4/BaseOS/x86_64/os
%packages
@^minimal-environment
squid
vim
net-tools
words
kexec-tools
bash-completion
policycoreutils-python-utils
lsof
tar
syslinux-nonlinux
python39
wget
grub2-efi-x64-modules
grub2-tools-extra
grub2-pc-modules
tree
git
rhel-system-roles
ansible-core
-aic94xx-firmware
-alsa-firmware
-alsa-lib
-alsa-tools-firmware
-ivtv-firmware
-iwl100-firmware
-iwl1000-firmware
-iwl105-firmware
-iwl135-firmware
-iwl2000-firmware
-iwl2030-firmware
-iwl3160-firmware
-iwl3945-firmware
-iwl4965-firmware
-iwl5000-firmware
-iwl5150-firmware
-iwl6000-firmware
-iwl6000g2a-firmware
-iwl6000g2b-firmware
-iwl6050-firmware
-iwl7260-firmware
-libertas-sd8686-firmware
-libertas-sd8787-firmware
-libertas-usb8388-firmware
-biosdevname
-iprutils
-plymouth
%end

eula --agreed
# Keyboard layouts
keyboard --xlayouts='us'
# System language
lang en_US.UTF-8

%pre --log=/root/ks-pre.log
dic_file="/usr/share/dict/words"
hostname=$(shuf -n 1 "$dic_file")
%end


# Network information
network  --bootproto=dhcp --device=eth0 --noipv6 --activate
network  --bootproto=static --ip=172.22.100.200 --netmask=255.255.255.0 --device=eth1 --activate --noipv6
network  --hostname=fire

firewall --enable 
firewall --ssh
firewall --service=dhcp,tftp,squid

services --disabled="kdump" 
#--enabled="dnsmasq,sshd,squid"

# Run the Setup Agent on first boot
firstboot --enable
# System bfire'ootloader configuration
bootloader --location=mbr --boot-drive=sda

# Clear all partitions on /dev/sda
clearpart --all --initlabel --drives=sda

# Disk partitioning information
reqpart --add-boot
part pv.01 --grow --size=1 --ondisk=sda
volgroup vg0 --pesize=4 pv.01
logvol / --fstype="xfs" --name=root --vgname=vg0 --size=8240 --grow
logvol swap --name=swap --vgname=vg0 --size=2048 --grow --maxsize=2048

# System timezone
timezone America/Mexico_City

# Root password
rootpw --iscrypted $6$S.5jyCIO/CGuIq3t$87TcYsQmxmnBvjoxcZfCwWF7KYI98LiLF8Dbpymdy8oBPfGi.G1GZSHGytd25ifjjpg/yFy.8LjFtXOrxUyeq/

%post --log=/root/ks-post.log 


dnf install epel-release -y

echo "My IP address: \4" >> /etc/issue
/usr/bin/firewall-offline-cmd --add-masquerade
cat <<-EOF > /etc/dnsmasq.d/mio.conf
# Set the DHCP range and lease time
interface=eth1
dhcp-range=172.22.100.201,172.22.100.210,2h

# Set the DNS server to be provided to clients
dhcp-option=6,192.168.1.254

# Set the gateway
dhcp-option=3,172.22.100.200

# Set the DNS server (optional)
server=8.8.8.8
server=8.8.4.4

# Log DHCP queries
log-dhcp
enable-tftp
tftp-root=/var/lib/tftpboot
dhcp-boot=boot/grub2/x86_64-efi/core.efi
EOF
rpm -Uvh https://repo.zabbix.com/zabbix/7.0/alma/9/x86_64/zabbix-release-7.0-2.el9.noarch.rpm
mkdir -v /var/lib/tftpboot
chcon -t tftpdir_rw_t /var/lib/tftpboot
grub2-mknetdir --net-directory /var/lib/tftpboot/
wget http://192.168.1.191:8000/grub.cfg -P /var/lib/tftpboot/boot/grub2/
wget -r https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/os/images/pxeboot/{vmlinuz,initrd.img} -P /var/lib/tftpboot/centos9 -nd
restorecon -R /var/lib/tftpboot
 sed -i '40c\PermitRootLogin yes' /etc/ssh/sshd_config
 sed --debug -i '8,15d;' /etc/squid/squid.conf
sed --debug -i '20c\acl localnet src 172.16.100.0/24' /etc/squid/squid.conf
%end



reboot --eject