#!/bin/bash

# ----------------------------------
# Colors
# ----------------------------------
NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'

sleep 1
echo "-------------------------------------"
echo "AAPanel Installer By WebersMitra     "
echo "Author: Webers Mitra Solution        "
echo "Copyright: GNU General Public License"
echo "Supported OS: Ubuntu /18/20/22       "
echo "Version: 1.1.2.0                     "
echo "Release Date: 4 December 2023        "
echo "Credits: Github                      "
echo "Website: https://webersmitra.com     "
echo "-------------------------------------"
sleep 1

echo ""
if ping -q -c 1 -W 1 google.com >/dev/null; then
echo -e "${GREEN}Internet Connection Successful...${NC}"
else
  echo ""
  echo -e "${RED}Seems like Network has some problems, Trying Auto-Fix${NC}"
  if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  echo -e "${GREEN}Network is OK, DNS Got some Problems...${NC}"
  echo "nameserver 8.8.8.8" >> /etc/resolv.conf
  echo "nameserver 8.8.4.4" >> /etc/resolv.conf
  echo "nameserver 1.1.1.1" >> /etc/resolv.conf
  echo -e "${GREEN}Fixed DNS,Retrying Network Check...${NC}"
  echo ""
  if ping -q -c 1 -W 1 google.com >/dev/null; then
  echo -e "${GREEN}Network Connection Successful${NC}"
  else
  echo -e "${RED}Network is Offline. We have tried a Fix from our side${NC}"
  echo -e "${RED}but didn't work. Please Check the Network!${NC}"
  exit 1
  fi
  else
  echo -e "${RED}Network is Offline. Troubleshooting Network!${NC}"
  sudo mv /etc/netplan/*.yaml  /etc/netplan/01-netcfg.yaml >/dev/null
  echo "network:" >> /etc/netplan/01-netcfg.yaml
  echo "  version: 2" >> /etc/netplan/01-netcfg.yaml
  echo "  renderer: networkd" >> /etc/netplan/01-netcfg.yaml
  echo "  ethernets:" >> /etc/netplan/01-netcfg.yaml
  network_interface=`ls /sys/class/net | grep enp`
  echo "    $network_interface:" >> /etc/netplan/01-netcfg.yaml
  echo "      dhcp4: true" >> /etc/netplan/01-netcfg.yaml
  sudo netplan generate >/dev/null
  sudo netplan apply >/dev/null
  sudo ifdown -a >/dev/null && sudo ifup -a >/dev/null
  sudo dhclient -v > /dev/null
  echo -e "${GREEN}Fixed Network, Retrying Network Check${NC}"
  echo ""
  if ping -q -c 1 -W 1 google.com >/dev/null; then
  echo -e "${GREEN}Network Connection Successful${NC}"
  else
  echo -e "${RED}Network is Offline. We have tried a Fix from our side${NC}"
  echo -e "${RED}but didn't work. Please Check the Network!${NC}"
  exit 1
  fi
  fi
fi

echo ""
echo -e "${YELLOW}Updating System${NC}"
yum update -y && yum upgrade

echo ""
if [ $? != 0 ]; 
then
echo -e "${RED}Seems like APT is experiencing Error. No Worries,${NC}"
echo -e "${RED}Trying a Fix${NC}"
rm /var/lib/apt/lists/* -vf > /dev/null 2>&1
yum cleanup > /dev/null 2>&1
sudo apt-get -f -y install > /dev/null 2>&1
echo ""
echo -e "${YELLOW}Trying System Update Again${NC}"
yum update -y && yum install wget curl perl
fi

echo ""
echo -e "${YELLOW}Installing AAPAnel On This Server${NC}"
wget -O install.sh https://raw.githubusercontent.com/WebManagerSSH/aaPanel/main/script/install_6.0_en.sh && bash install.sh github

echo ""
echo -e "${GREEN}Installation Completed, All Done...Goodbye!${NC}"
exit 1
