# Generated by Anaconda 34.25.4.9
# Generated by pykickstart v3.32
#version=RHEL9
# Use text mode install
text
url --url=http://mirror.twds.com.tw/rockylinux/9.4/BaseOS/x86_64/os
# System language
lang en_US.UTF-8

%packages
@^minimal-environment
vim
net-tools
dns-utils
bc
tcpdump
bind-chroot
vim-enhanced
bash-compl*
-a*firmware*
-dracut-config-rescue
-gawk-all-langpacks
-i*firmware*
-langpacks-*
-lib*firmware*
-linux-firmware
-n*firmware*
-NetworkManager-team
NetworkManager-tui
-parted
-plymouth
-rhc*
-sqlite
-sssd*
%end
eula --agreed
# Keyboard layouts
keyboard --xlayouts='us'
# System language
lang en_US.UTF-8
# Run the Setup Agent on first boot
firstboot --enable
# Do not configure the X Window System
skipx

firewall --enable 
firewall --ssh

services --disabled="kdump"
services --enable="sshd"

# Run the Setup Agent on first boot
firstboot --enable
# System bootloader configuration
bootloader --location=mbr --boot-drive=vda
ignoredisk --only-use=vda
clearpart --all --initlabel --drives=vda

# Disk partitioning information
reqpart --add-boot
part pv.01 --grow --size=1 --ondisk=vda
volgroup vg0 --pesize=4 pv.01
logvol / --fstype="xfs" --name=root --vgname=vg0 --size=8240 --grow
logvol swap --name=swap --vgname=vg0 --size=2048 --grow --maxsize=4096


#autopart --nohome

%pre
#!/bin/bash

# Default hostname
echo "network --device enp1s0 --bootproto dhcp --hostname localhost.localdomain" > /tmp/network-include
# Search for hostname parameter, if found update the network ks
for args in `cat /proc/cmdline`; do
        case $args in hostname*)
            eval $args
            sed -i "s/localhost.localdomain/$hostname/g" /tmp/network-include
            ;;
        esac;
    done
%end
%include /tmp/network-include

# System timezone
timezone America/Mexico_City

# Root password
rootpw --iscrypted $6$UEYoS7LAC21pbjS.$PCnTHOqoJupnIrD0O93Smj/1fqBrtavd.xCCIIMv.PIkAO4WpuI0PdzUX7VWjv8z1BcOQF.wj1JsZYH050pkl/

%post --log=/root/post.log
echo "proxy=http://192.168.1.198:3128" >> /etc/dnf/dnf.conf
echo "My IP address: \4" >> /etc/issue

%end

reboot
