# Compile

    Open .config file in vim.
    Search for CONFIG_SYSTEM_TRUSTED_KEYS and assign empty string to it (i.e, double quotes"")
    Search for CONFIG_SYSTEM_REVOCATION_KEYS and assign empty string to it (i.e, double quotes"")
yes '' | make oldconfig # be patience. It will take some time        
make kernelrelease
make -j $(nproc) bzImage # nproc prints the number of your system's cores. and by this command i am using all of my system's cores to make this process faster
make -j $(nproc) modules        
sudo make INSTALL_MOD_STRIP=1 modules_install
sudo make install        
grub-mkconfig -o /boot/grub/grub.cfg



# builder
Small shells to build img files on KVM
Es necearios inicair la vm con estos parametros

![image](https://github.com/khemir88/builder/assets/157767696/13125cd6-8b47-4b16-b377-96a0ba7f25b8)


