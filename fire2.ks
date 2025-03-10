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
vim
words
kexec-tools
bash-completion
policycoreutils-python-utils
lsof
squid
dnsmasq
syslinux-nonlinux
python39
wget
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
network  --bootproto=dhcp --device=enp1s0 --noipv6 --activate
network  --bootproto=static --ip=172.22.100.200 --netmask=255.255.255.0 --device=enp2s0 --activate --noipv6
network  --hostname=fire

firewall --enable 
firewall --ssh
firewall --service=dhcp
firewall --service=squid

services --disabled="kdump" --enabled="dnsmasq,sshd,squid"

# Run the Setup Agent on first boot
firstboot --enable

ignoredisk --only-use=sda
autopart
# Partition clearing information
clearpart --all --initlabel

# System timezone
timezone America/Mexico_City

# Root password
rootpw --iscrypted $6$S.5jyCIO/CGuIq3t$87TcYsQmxmnBvjoxcZfCwWF7KYI98LiLF8Dbpymdy8oBPfGi.G1GZSHGytd25ifjjpg/yFy.8LjFtXOrxUyeq/

%post --log=/root/ks-post.log 
echo "Currently mounted partitions"
df -Th

echo "=============================="
echo "Available memory"
free -m
echo "=============================="
echo "Kickstart post install script completed at: `date`"
echo "=============================="

dnf makecache
echo "My IP address: \4" >> /etc/issue
/usr/bin/firewall-offline-cmd --add-masquerade
cp /root/priv.con /root/mios.conf
cat <<-EOF > /etc/dnsmasq.d/mio.conf
# Set the DHCP range and lease time
interface=enp2s0
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
EOF
%end


%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
reboot