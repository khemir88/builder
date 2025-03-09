#version=RHEL8
# Use graphical install
skipx
text
cdrom

%addon com_redhat_kdump --disable
%end
#url --url=https://mirrors.xmission.com/centos/8-stream/BaseOS/x86_64/os/
%packages
@^minimal-environment
squid
vim
words
kexec-tools
bash-completion
policycoreutils-python-utils
lsof
tar
dnsmasq
syslinux-nonlinux
python39
wget
grub2-efi-x64-modules
grub2-tools-extra
grub2-pc-modules
tree
git
unzip
shim-ia32
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




# Network information
network  --bootproto=dhcp --device=eth0 --noipv6 --activate
network  --bootproto=static --ip=172.22.100.200 --netmask=255.255.255.0 --device=eth1 --activate --noipv6
network  --hostname=fire-wazuh

firewall --enable 
firewall --ssh
firewall --service=dhcp,tftp,squid

services --disabled="kdump"
services --enable="dnsmasq,sshd,squid,fail2ban"

# Run the Setup Agent on first boot
firstboot --enable
# System bootloader configuration
bootloader --location=mbr --boot-drive=sda

# Clear all partitions on /dev/sda
clearpart --all --initlabel --drives=sda

# Disk partitioning information
reqpart --add-boot
part pv.01 --grow --size=1 --ondisk=sda
volgroup vg0 --pesize=4 pv.01
logvol / --fstype="xfs" --name=root --vgname=vg0 --size=8240 --grow
logvol swap --name=swap --vgname=vg0 --size=2048 --grow --maxsize=4096

# System timezone
timezone America/Mexico_City

# Root password
rootpw --iscrypted $6$S.5jyCIO/CGuIq3t$87TcYsQmxmnBvjoxcZfCwWF7KYI98LiLF8Dbpymdy8oBPfGi.G1GZSHGytd25ifjjpg/yFy.8LjFtXOrxUyeq/

%post --log=/root/ks-post.log 
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat > /etc/yum.repos.d/elastic.repo << EOF
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
dnf -y install elasticsearch-7.17.13
curl -so /etc/elasticsearch/elasticsearch.yml https://packages.wazuh.com/4.5/tpl/elastic-basic/elasticsearch_all_in_one.yml
curl -so /usr/share/elasticsearch/instances.yml https://packages.wazuh.com/4.5/tpl/elastic-basic/instances_aio.yml
/usr/share/elasticsearch/bin/elasticsearch-certutil cert ca --pem --in instances.yml --keep-ca-key --out ~/certs.zip
unzip ~/certs.zip -d ~/certs
mkdir /etc/elasticsearch/certs/ca -p
cp -R ~/certs/ca/ ~/certs/elasticsearch/* /etc/elasticsearch/certs/
chown -R elasticsearch: /etc/elasticsearch/certs
chmod -R 500 /etc/elasticsearch/certs
chmod 400 /etc/elasticsearch/certs/ca/ca.* /etc/elasticsearch/certs/elasticsearch.*
rm -rf ~/certs/ ~/certs.zip




dnf -y install epel-release 
dnf -y install fail2ban
#dnf makecache
#dnf update -y
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
server=192.168.1.254
server=8.8.8.8

# Log DHCP queries
log-dhcp
enable-tftp
tftp-root=/var/lib/tftpboot
dhcp-boot=boot/grub2/x86_64-efi/core.efi
EOF

mkdir -v /var/lib/tftpboot
chcon -t tftpdir_rw_t /var/lib/tftpboot
grub2-mknetdir --net-directory /var/lib/tftpboot/
wget http://192.168.1.68:8000/grub.cfg -P /var/lib/tftpboot/boot/grub2/
wget -r https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/os/images/pxeboot/{vmlinuz,initrd.img} -P /var/lib/tftpboot/centos9 -nd
restorecon -R /var/lib/tftpboot
#sed -i '8,15d;' /etc/squid/squid.conf
#echo "acl localnet src 172.16.100.0/24" >> /etc/squid/squid.conf
%end


%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
reboot --eject
