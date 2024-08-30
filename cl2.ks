#version=RHEL8
# Use graphical install
text

url --proxy=http://192.168.1.197:3128 --url=http://mirror.twds.com.tw/rockylinux/9.4/BaseOS/x86_64/os

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


%end
eula --agreed
# Keyboard layouts
keyboard --xlayouts='us'
# System language
lang en_US.UTF-8




# Network information
network  --hostname=cliente
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate

firstboot --enable
# Clear all partitions on the selected disk
clearpart --all --initlabel --drives=sda

# Create the EFI System Partition (200MB)
part /boot/efi --fstype="efi" --size=200 --asprimary --label=EFI

# Create the /boot partition (500MB)
part /boot --fstype="xfs" --size=1024 --asprimary --label=boot

# Create the root partition (9GB)
part / --fstype="xfs" --size=8692 --asprimary --label=root

# Create the swap partition (1.5GB)
part swap --size=1536 --label=swap

# Optional: Create a separate home partition with the remaining space (584MB)
part /home --fstype="xfs" --size=584 --asprimary --label=home
# System timezone
timezone America/Mexico_City

# Root password
rootpw --iscrypted $6$S.5jyCIO/CGuIq3t$87TcYsQmxmnBvjoxcZfCwWF7KYI98LiLF8Dbpymdy8oBPfGi.G1GZSHGytd25ifjjpg/yFy.8LjFtXOrxUyeq/
# Create user 'admin' with sudo privileges
user --name=cristian --password=password --groups=wheel --gecos="Administrator" --shell=/bin/bash

%post --interpreter=/usr/bin/bash --logfile=/root/ks-post.log
echo "proxy=http://172.22.100.200:3128" >> /etc/dnf/dnf.conf
dnf -y install epel-release
echo "Ahora vamos por los paquetes cool2"
dnf -y install neofetch bpytop
echo "My IP address: \4" >> /etc/issue
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

%end

reboot