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
echo `curl -sSL https://get.daocloud.io/docker | sh`
echo "Docker完毕"
}

Docker_Compose(){
echo "正在安装DockerCompose"
echo `curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose`
echo "DockerCompose安装完毕"
}

Docker_Hub(){
echo `curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s https://dockerhub.azk8s.cn`
echo "DockerHub加速安装完毕"
}

echo -e "  Linux服务器常见一键脚本 ${Red_font_prefix}[0.1]${Font_color_suffix}
  ---- W4ter | https://github.com/waterrr  ----

  ${Green_font_prefix}1.${Font_color_suffix} 更换Ubuntu18.04(bionic)默认源为阿里源
  ${Green_font_prefix}2.${Font_color_suffix} 更换Ubuntu16.04默认源为阿里源
  ${Green_font_prefix}3.${Font_color_suffix} 更换PyPI默认源为阿里镜像源
————————————
  ${Green_font_prefix}4.${Font_color_suffix} 一键安装Docker【国内镜像】
  ${Green_font_prefix}5.${Font_color_suffix} 一键安装Docker Compose【国内镜像】
  ${Green_font_prefix}6.${Font_color_suffix} 一键加速DockerHub镜像【Azure国内镜像】
————————————
  ${Green_font_prefix}0.${Font_color_suffix} ${Red_font_prefix}EXIT${Font_color_suffix}
 "
	echo && read -e -p "请输入数字 [0-6]：" num
case "$num" in
	0)
	exit 0
	;;
	1)
	ubt1804
	;;
	2)
	ubt1604
	;;
	3)
	PyPI
	;;
	4)
	Docker
	;;
	5)
	Docker_Compose
	;;
	6)
	Docker_Hub
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [0-6]"
	;;
esac
