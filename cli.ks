#version=RHEL8
# Use graphical install
text
cdrom

%addon com_redhat_kdump --disable
%end

%packages
@^minimal-environment
vim
words
kexec-tools
net-tools
wget
python39
tcpdump
setools-console
setroubleshoot-server
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

%pre
dic_file="/usr/share/dict/words"
hostname=$(shuf -n 1 "$dic_file")
%end


# Network information
network  --hostname=cliente2
network  --bootproto=dhcp --device=enp1s0 --ipv6=auto --activate

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


%post --interpreter=/usr/bin/bash --logfile=/root/ks-post.log
echo "proxy=http://172.22.100.200:3128" >> /etc/dnf/dnf.conf
dnf -y install epel-release
echo "Ahora vamos por los paquetes cool2"
dnf -y install neofetch bpytop
echo "My IP address: \4" >> /etc/issue
# Create a new user
echo "Creating user..."
useradd -m -s /bin/bash cristian
echo "password" | passwd --stdin cristian

# Add user to a group
echo "Adding user to group..."
usermod -aG groupname cristian

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
reboot