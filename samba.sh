#!/bin/bash
#
#	Author: Paulo Silva Piquera <paulo_piquera@hotmail.com>
#	Version: 2.7
#
echo -n Qual será o nome de usuário?
read usernameSamba
echo -n Qual será a senha?
read passwordSamba
echo -n Qual será o diretório a ser compartilhado?
read directorySamba

echo Iniciando instalação...
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
testparm
systemctl start smb
systemctl start nmb
systemctl enable smb
systemctl enable nmb
systemctl stop iptables
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
systemctl stop iptables
echo Instalação finalizada.