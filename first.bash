#!/bin/bash

# Update Kernel and updates
yum -y update kernel
yum -y update && yum -y upgrade


# install gui
sudo yum groupinstall "GNOME Desktop"

# set gui to default
sudo systemctl set-default graphical.target

#install packages

sudo yum -y install terminator gparted telnet links wget p7zip gcc nmap java rkhunter httpd php net-tools mariadb-server mariadb tomcat epel-release ntfs-3g vsftpd selinux-policy 


# be sure to configure vsftpd
# vi /etc/vsftpd/vsftpd.conf
#anonymous_enable=NO
#local_enable=YES
#write_enable=YES
#chroot_local_user=YES

#add community enterprise linux repo
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

# httpd & php final touches

firewall-cmd --add-service=http
firewall-cmd --reload
systemctl restart httpd.service
systemctl start httpd.service
systemctl enable httpd.service
systemctl restart httpd.service

#tomcat setup
systemctl start tomcat
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload

# install webmin
wget http://prdownloads.sourceforge.net/webadmin/webmin-1.740-1.noarch.rpm
rpm -ivh webmin-*.rpm

# change host name
sudo echo "MarltonComp" > /etc/hostname

# check after install
yum -y autoremove
yum -y update && yum -y upgrade

startx