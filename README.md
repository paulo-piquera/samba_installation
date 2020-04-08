# Samba Installation Script 2.7

Description: A simple way to install samba with secure folder.


# Steps:
1 - Download and change the script permission:
* wget https://raw.githubusercontent.com/paulo-piquera/samba_installation/master/samba.sh -O samba.sh && chmod +x samba.sh && sed -i -e 's/\r$//' samba.sh

2 - Run the script:
* ./samba.sh <br>
or
* sh samba.sh

3 - You will be asked for the user, password and directory for the script to perform the configuration.

4 - After running the script, to connect to windows, it will be necessary to copy the IP or Hostname of the linux machine where the samba was installed and on the Windows machine, press the WIN + R keys and add in the field that will be shown the path, as shown below:
* \\\IP_ADDRESS\ <br>
or
* \\\HOSTNAME\

PS: The script was based on the _CentOS 7_ operating system, and may have errors in other Linux distributions.
