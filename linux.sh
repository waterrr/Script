#!/bin/bash
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
	bit=`uname -m`
}

ubt2004(){
check_sys
[[ ${release} != "ubuntu" ]] || [[ $(lsb_release -r --short) != "20.04" ]] && echo -e "${Error} 本脚本不支持当前系统 ${release} $(lsb_release -r --short) !" && exit 1
sudo echo "
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
">/root/tmp
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo rm /etc/apt/sources.list
sudo cp /root/tmp /etc/apt/sources.list
sudo rm /root/tmp
sudo echo "已经替换源为阿里源，默认源备份在【/etc/apt/sources.list.bak】"
sudo echo "请尝试执行【apt update&apt upgrade】查看是否生效"
}

ubt1804(){
check_sys
[[ ${release} != "ubuntu" ]] || [[ $(lsb_release -r --short) != "18.04" ]] && echo -e "${Error} 本脚本不支持当前系统 ${release} $(lsb_release -r --short) !" && exit 1
sudo echo "
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
">/root/tmp
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo rm /etc/apt/sources.list
sudo cp /root/tmp /etc/apt/sources.list
sudo rm /root/tmp
sudo echo "已经替换源为阿里源，默认源备份在【/etc/apt/sources.list.bak】"
sudo echo "请尝试执行【apt update&apt upgrade】查看是否生效"
}

ubt1604(){
check_sys
[[ ${release} != "ubuntu" ]] || [[ $(lsb_release -r --short) != "16.04" ]] && echo -e "${Error} 本脚本不支持当前系统 ${release} $(lsb_release -r --short) !" && exit 1
sudo echo "
deb http://mirrors.aliyun.com/ubuntu/ xenial main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main

deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main

deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates universe

deb http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security universe
">/root/tmp
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo rm /etc/apt/sources.list
sudo cp /root/tmp /etc/apt/sources.list
sudo rm /root/tmp
sudo echo "已经替换源为阿里源，默认源备份在【/etc/apt/sources.list.bak】"
sudo echo "请尝试执行【apt update&apt upgrade】查看是否生效"
}

PyPI(){
if [ ! -d "/root/.pip" ]; then
  sudo mkdir /root/.pip
fi
sudo echo "
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
">/root/.pip/pip.conf
sudo echo "已经更换PyPI默认源为阿里镜像源，请尝试执行【pip install --upgrade pip】查看是否生效"
}

Docker(){
echo "正在安装Docker"
echo `curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh --mirror Aliyun`
echo "Docker完毕"
echo `rm get-docker.sh`
}

Docker_Compose(){
echo "正在安装DockerCompose"
echo `curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose`
echo "DockerCompose安装完毕"
}

Docker_Hub(){
sudo echo "{
  \"registry-mirrors\": [
    \"https://hub-mirror.c.163.com\",
    \"https://docker.mirrors.ustc.edu.cn\"
  ]
}">/root/tmp
mkdir /etc/docker/
#sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.bak
#sudo rm /etc/docker/daemon.json
sudo cp /root/tmp /etc/docker/daemon.json
sudo rm /root/tmp
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo echo "已经替换DockerHub为国内阿里/中科大源"
}

Superbench(){
    while [ ! -f ./superbench2.sh ]; do
            wget -N -P ./ --no-check-certificate https://cdn.jsdelivr.net/gh/waterrr/Script/superbench2.sh
    done
    sudo bash ./superbench2.sh
    sudo rm ./superbench2.sh
    break
}

Netflix_check(){
	while [ ! -f ./superbench2.sh ]; do
        wget -N -P ./ --no-check-certificate https://cdn.jsdelivr.net/gh/waterrr/Script/netflix_check.sh
    done
chmod +x netflix_check.sh
bash netflix_check.sh
}

echo -e "  Linux服务器常见一键脚本 ${Red_font_prefix}[0.2]${Font_color_suffix}
  ----Upgrade in 2021-02-25 ----
  ---- W4ter | https://github.com/waterrr  ----
  ---- iriszero | https://github.com/iriszero48  ----

  ${Green_font_prefix}1.${Font_color_suffix} 更换Ubuntu20.04(focal)默认源为阿里源
  ${Green_font_prefix}2.${Font_color_suffix} 更换Ubuntu18.04(bionic)默认源为阿里源
  ${Green_font_prefix}3.${Font_color_suffix} 更换Ubuntu16.04默认源为阿里源
  ${Green_font_prefix}4.${Font_color_suffix} 更换PyPI默认源为阿里镜像源
————————————
  ${Green_font_prefix}5.${Font_color_suffix} 一键安装Docker【国内镜像】
  ${Green_font_prefix}6.${Font_color_suffix} 一键安装Docker Compose【国内镜像】
  ${Green_font_prefix}7.${Font_color_suffix} 一键加速DockerHub镜像【阿里/中科大源】
————————————
  ${Green_font_prefix}8.${Font_color_suffix} 一键测试服务器性能/网速 | Superbench修复版
  ${Green_font_prefix}9.${Font_color_suffix} 一键测试服务器是否能看Netflix和解锁区域
————————————
  ${Green_font_prefix}0.${Font_color_suffix} ${Red_font_prefix}EXIT${Font_color_suffix}
 "
	echo && read -e -p "请输入数字 [0-8]：" num
case "$num" in
	0)
	exit 0
	;;
	1)
	ubt2004
	;;
	2)
	ubt1804
	;;
	3)
	ubt1604
	;;
	4)
	PyPI
	;;
	5)
	Docker
	;;
	6)
	Docker_Compose
	;;
	7)
	Docker_Hub
	;;
	8)
	Superbench
	;;
	9)
	Netflix_check
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [0-9]"
	;;
esac
