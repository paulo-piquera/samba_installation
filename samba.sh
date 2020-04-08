#!/bin/bash
#
#	Author: Paulo Silva Piquera <paulo_piquera@hotmail.com>
#	Version: 2.7
#
echo -n Samba user: 
read usernameSamba
echo -n Samba password: 
read passwordSamba
echo -n Samba directory: 
read directorySamba

echo Starting installation...
yum install dnf -y
sudo dnf install samba samba-common samba-client -y
sudo mv /etc/samba/smb.conf /etc/samba/smb.con.bak
sudo chcon -t samba_share_t $directorySamba
touch /etc/samba/smb.conf
echo [global] >> /etc/samba/smb.conf
echo workgroup = WORKGROUP >> /etc/samba/smb.conf
echo server string = Samba Server %v >> /etc/samba/smb.conf
echo netbios name = centos-8 >> /etc/samba/smb.conf
echo security = user >> /etc/samba/smb.conf
echo map to guest = bad user >> /etc/samba/smb.conf
echo dns proxy = no >> /etc/samba/smb.conf
echo " " >> /etc/samba/smb.conf
echo [Secure] >> /etc/samba/smb.conf
echo path = $directorySamba >> /etc/samba/smb.conf
echo valid users = @secure_group >> /etc/samba/smb.conf
echo guest ok = no >> /etc/samba/smb.conf
echo browsable =yes >> /etc/samba/smb.conf
echo writable = yes >> /etc/samba/smb.conf
echo read only = no >> /etc/samba/smb.conf
firewall-cmd --permanent --zone=public --add-service=samba
firewall-cmd --reload
testparm
systemctl start smb
systemctl start nmb
systemctl enable smb
systemctl enable nmb
iptables -A INPUT -p udp --dport 389 -j ACCEPT
iptables -A INPUT -p tcp --dport 389 -j ACCEPT
iptables -I INPUT -p tcp --dport 389 -j ACCEPT
iptables -A INPUT -p udp --dport 445 -j ACCEPT
iptables -A INPUT -p tcp --dport 445 -j ACCEPT
iptables -I INPUT -p tcp --dport 445 -j ACCEPT
iptables -A INPUT -p udp --dport 901 -j ACCEPT
iptables -A INPUT -p tcp --dport 901 -j ACCEPT
iptables -I INPUT -p tcp --dport 901 -j ACCEPT
service iptables save
sudo groupadd secure_group
sudo useradd -g secure_group $usernameSamba
chown -R $usernameSamba:secure_group $directorySamba
echo -ne "$passwordSamba\n$passwordSamba\n" | smbpasswd -a $usernameSamba
chmod 777 $directorySamba
gpasswd -a $usernameSamba root
testparm
systemctl restart smb
systemctl restart nmb
systemctl restart iptables
echo Installation completed.
