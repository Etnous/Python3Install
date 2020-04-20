#!/usr/bin/env bash
#######################################################
# Title: Install Python3.7 and Web scraping frameworks#
# Author: Etnous                                      #
# Blog: https://lala.biz                              #
# Update date: December 11, 2019                      #
#######################################################

#================================
#==========Define color==========
Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Yellow_font_prefix="\033[1;33m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"


info=${Green_font_prefix}[Info]${Font_color_suffix}
error=${Red_font_prefix}[Error]${Font_color_suffix}
tip=${Red_font_prefix}[Tip]${Font_color_suffix}
#================================


#chek root
check_root(){
  [[ $EUID -ne 0 ]] && echo -e "${error}This script must be executed as root!" && exit 1
}

#check os
check_os(){
  osfile="/etc/os-release"
  if [ -e $osfile ] && [ $(uname -m) == "x86_64" ]; then
    source $osfile
    case "$ID" in
      centos)
        if [[ $VERSION_ID -ge "7" ]]; then
              os_version="centos"
              echo -e "${info}${Yellow_font_prefix}Your system is $ID$VERSION_ID.${Font_color_suffix}\n"
        else
              echo -e "${error}${Yellow_font_prefix}Wrong VERSION_ID!${Font_color_suffix}\n" && exit 1
        fi
      ;;
      debian)
        if [[ $VERSION_ID -ge "9" ]]; then
              os_version="debian"
              echo -e "${info}${Yellow_font_prefix}Your system is $ID$VERSION_ID.${Font_color_suffix}\n"
        else
              echo -e "${error}${Yellow_font_prefix}Wrong VERSION_ID!${Font_color_suffix}\n" && exit 1

        fi
      ;;
      ubuntu)
        if [[ $VERSION_ID == "16.04" ]] || [[ $VERSION_ID == "18.04" ]]; then
              os_version="ubuntu"
              echo -e "${info}${Yellow_font_prefix}Your system is $ID$VERSION_ID.${Font_color_suffix}\n"
        else
              echo -e "${error}${Yellow_font_prefix}Wrong VERSION_ID!${Font_color_suffix}\n" && exit 1
        fi
      ;;
      *)
        echo -e "Wrong ID" && exit 1
      ;;
    esac

  else
    echo -e "${error}${Yellow_font_prefix}This script doesn't support your system!${Font_color_suffix}\n"
  fi
}

#=======select source=======
select_area(){
  clear
  echo -e "
--Please select the region where your server is located.--
  ${Green_font_prefix}1.${Font_color_suffix}  International
  ${Green_font_prefix}2.${Font_color_suffix}  China
----------------------------------------------------------
  "
  read -e -p "--Please input your area[1-2]: " area
  case "$area" in
  1)
    echo -e 'nameserver 8.8.8.8\nnameserver 8.8.4.4'> /etc/resolv.conf
    install_python
    ;;
  2)
    if [[ $os_version == "centos" ]] && [[ $VERSION_ID == "7" ]]; then
      echo -e 'nameserver 114.114.114.114\nnameserver 114.114.115.115'> /etc/resolv.conf
      rm -rf /etc/yum.repos.d/CentOS-Base.repo
      wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo &>/dev/null
      sed -i "s/http:\/\/mirrors\.cloud\.aliyuncs\.com\/epel/http:\/\/mirrors\.aliyun\.com\/epel/g" /etc/yum.repos.d/epel.repo
      sed -i "s/http:\/\/mirrors\.cloud\.aliyuncs\.com\/centos/http:\/\/mirrors\.aliyun\.com\/centos/g" /etc/yum.repos.d/CentOS-Base.repo
      echo -e "${info}${Yellow_font_prefix}Successfully change the source!${Font_color_suffix}" && install_python

    elif [[ $os_version == "centos" ]] && [[ $VERSION_ID == "8" ]]; then
      echo -e 'nameserver 114.114.114.114\nnameserver 114.114.115.115'> /etc/resolv.conf
      rm -rf /etc/yum.repos.d/CentOS-Base.repo
      wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo &>/dev/null
      echo -e "${info}${Yellow_font_prefix}Successfully change the source!${Font_color_suffix}" && install_python

    elif [[ $os_version == "debian"  ]] && [[ $VERSION_ID == "9" ]]; then
      echo -e 'nameserver 114.114.114.114\nnameserver 114.114.115.115'> /etc/resolv.conf
      echo 'deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib
            deb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib
            deb http://mirrors.aliyun.com/debian-security stretch/updates main
            deb-src http://mirrors.aliyun.com/debian-security stretch/updates main
            deb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib
            deb-src http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib
            deb http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib
            deb-src http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib' > /etc/apt/sources.list
      echo -e "${info}${Yellow_font_prefix}Successfully change the source!${Font_color_suffix}" && install_python

    elif [[ $os_version == "debian" ]] && [[ $VERSION_ID == "10" ]]; then
      echo -e 'nameserver 114.114.114.114\nnameserver 114.114.115.115'> /etc/resolv.conf
      echo 'deb https://mirrors.aliyun.com/debian  stable main contrib non-free
            deb https://mirrors.aliyun.com/debian  stable-updates main contrib non-free' > /etc/apt/sources.list
      echo -e "${info}${Yellow_font_prefix}Successfully change the source!${Font_color_suffix}" && install_python

    elif [[ $os_version == "ubuntu" ]] && [[ $VERSION_ID == "16.04" ]]; then
      echo -e 'nameserver 114.114.114.114\nnameserver 114.114.115.115'> /etc/resolv.conf
      echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse' > /etc/apt/sources.list
      echo -e "${info}${Yellow_font_prefix}Successfully change the source!${Font_color_suffix}" && install_python

    elif [[ $os_version == "ubuntu" ]] && [[ $VERSION_ID == "18.04" ]]; then
      echo -e 'nameserver 114.114.114.114\nnameserver 114.114.115.115'> /etc/resolv.conf
      echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse' > /etc/apt/sources.list
      echo -e "${info}${Yellow_font_prefix}Successfully change the source!${Font_color_suffix}" && install_python
    fi
    ;;
  *)
    echo -e "${error}Please input the right num!" && exit 1
    ;;
  esac
}

#=====WELCOME=====
install_figlet(){

  man figlet &>/dev/null
  if [[ $? -ne 0 ]]; then
    if [[ $os_version == "centos" ]]; then
      echo -e "${Yellow_font_prefix}Preparing to start, please wait...${Font_color_suffix}\n"
      yum update -y &>/dev/null
      yum install -y figlet &>/dev/null
     else
      echo -e "${Yellow_font_prefix}Preparing to start, please wait...${Font_color_suffix}\n"
      apt update -y &>/dev/null
      apt install -y figlet &>/dev/null
    fi
  else
    return
  fi
}

#==Choose python version======
choose_python_verison(){
  clear
  echo -e "
--Please choose python version--
  ${Green_font_prefix}1.${Font_color_suffix}  3.6.9
  ${Green_font_prefix}2.${Font_color_suffix}  3.7.2
  ${Green_font_prefix}3.${Font_color_suffix}  3.7.3
  ${Green_font_prefix}4.${Font_color_suffix}  3.7.4
  ${Green_font_prefix}5.${Font_color_suffix}  3.7.5
---------------------------------
"
read -e -p "Please input the num[1-5]:" ver_num
case $ver_num in
  1)
    py_v="3.6.9" && check_python_exist
  ;;
  2)
    py_v="3.7.2" && check_python_exist
  ;;
  3)
    py_v="3.7.3" && check_python_exist
  ;;
  4)
    py_v="3.7.4" && check_python_exist
  ;;
  5)
    py_v="3.7.5" && check_python_exist
  ;;
  *)
    echo -e "${error}Please input the right num!" && exit 1
  ;;
esac
}


install_python(){
  if [[ $os_version == "centos" ]]; then
    centos_install_python
  elif [[ $os_version == "debian" ]]; then
    debian_install_python
  elif [[ $os_version == "ubuntu" ]]; then
    debian_install_python
  fi
}

install_web_scraping_frameworks(){
  python -V &>/dev/null
  if [[ $? -eq 0 ]]; then
      if [[ $os_version == "centos" ]]; then
          centos_install_web_scraping_frameworks
      elif [[ $os_version == "debian" ]]; then
          debian_install_web_scraping_frameworks
      elif [[ $os_version == "ubuntu" ]]; then
          debian_install_web_scraping_frameworks
      fi
  else
    echo -e "${error}${Yellow_font_prefix}You haven't install python yet!${Font_color_suffix}\n" && exit 1
  fi
}




centos_install_python(){
  echo -e "${Green_font_prefix}Preparing to install python, please wait...${Font_color_suffix}\n"
  sleep 5
  yum update -y
  mkdir -p /usr/local/src
  cd /usr/local/src
  yum groupinstall -y "Development tools"
  yum install -y gcc gcc-c++ make git freetype-devel fontconfig-devel sqlite-devel ncurses-libs zlib-devel mysql-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel openssl-devel zlib* libffi-devel
  wget https://www.python.org/ftp/python/$py_v/Python-$py_v.tar.xz && tar xJf Python-$py_v.tar.xz
  rm -rf Python-$py_v.tar.xz
  mv Python-$py_v /usr/local/python-$py_v && cd /usr/local/python-$py_v/
  yum install -y libffi-devel 
  ./configure --prefix=/usr/local/sbin/python-$py_v && make && make install
  cd /root
  rm -rf /usr/bin/python
  ln -s /usr/local/sbin/python-$py_v/bin/python3 /usr/bin/python
  sed -i '1c #!/usr/bin/python2.7' /usr/bin/yum
  sed -i '1c #! /usr/bin/python2.7' /usr/libexec/urlgrabber-ext-down
  rm -rf /usr/bin/pip && ln -s /usr/local/sbin/python-$py_v/bin/pip3 /usr/bin/pip
  if [[ $(python -V) == "Python $py_v" ]]; then
    echo -e "${info}${Yellow_font_prefix}Successfully installed python!${Font_color_suffix}" && exit 0
  else
    echo -e "${error}${Red_font_prefix}Failed to install python.${Font_color_suffix}\n" && exit 1
  fi
}

debian_install_python(){
  echo -e "${info}${Yellow_font_prefix}Preparing to install python, please wait...${Font_color_suffix}\n"
  sleep 5
  apt update -y
  mkdir -p /usr/local/src
  cd /usr/local/src
  apt install -y gcc g++ git make build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev
  wget https://www.python.org/ftp/python/$py_v/Python-$py_v.tar.xz && tar xJf Python-$py_v.tar.xz
  rm -rf Python-$py_v.tar.xz
  mv Python-$py_v /usr/local/python-$py_v && cd /usr/local/python-$py_v/
  apt install libffi-dev -y
  ./configure --prefix=/usr/local/sbin/python-$py_v && make && make install
  rm -rf /usr/bin/python
  ln -s /usr/local/sbin/python-$py_v/bin/python3 /usr/bin/python
  rm -rf /usr/bin/pip
  ln -s /usr/local/sbin/python-$py_v/bin/pip3 /usr/bin/pip
  if [[ $(python -V) == "Python $py_v" ]]; then
    echo -e "${info}${Yellow_font_prefix}Successfully installed python!${Font_color_suffix}" && exit 0
  else
    echo -e "${error}${Red_font_prefix}Failed to install python.${Font_color_suffix}\n" && exit 1
  fi
}

select_python_version(){
  clear
  echo -e "
--Please choose the version you want to change--
  ${Green_font_prefix}1.${Font_color_suffix}  3.6.9
  ${Green_font_prefix}2.${Font_color_suffix}  3.7.2
  ${Green_font_prefix}3.${Font_color_suffix}  3.7.3
  ${Green_font_prefix}4.${Font_color_suffix}  3.7.4
  ${Green_font_prefix}5.${Font_color_suffix}  3.7.5
------------------------------------------------
"
  read -e -p "Please input num[1-5]: " chver_num
  case $chver_num in
    1)
      p_ver="python-3.6.9" && check_python_version_exist
    ;;
    2)
      p_ver="python-3.7.2" && check_python_version_exist
    ;;
    3)
      p_ver="python-3.7.3" && check_python_version_exist
    ;;
    4)
      p_ver="python-3.7.4" && check_python_version_exist
    ;;
    5)
      p_ver="python-3.7.5" && check_python_version_exist
    ;;
    *)
      echo -e "${error}Please input the right num!"
    ;;
  esac
}

check_python_exist(){
  ls /usr/local/sbin/ > /root/version
  for exist_py in $(cat /root/version)
  do
    if [[ "python-$py_v" == $exist_py ]];then
      read -e -p "The version already exist, do you want to reinstall it?[Y/N]: " yny
      case $yny in
        Y|y)
            rm -rf version && select_area
        ;;
        N|n)
            rm -rf version
            echo -e "${Red_font_prefix}Cancelled!${Font_color_suffix}\n" && exit 1
        ;;
        *)
            rm -rf version && echo -e "${error}Wrong Num!\n" && exit 1
        ;;
      esac
    else
      continue
    fi
  done
  rm -rf version
  select_area
}

check_python_version_exist(){
  ls /usr/local/sbin/ > /root/version
  for exist_ver in $(cat /root/version)
  do
    if [[ $p_ver == $exist_ver ]]; then
      read -e -p "Are you sure?[Y/N]: " yn
      case $yn in
        Y|y)
            rm -rf /usr/bin/python && ln -s /usr/local/sbin/$exist_ver/bin/python3 /usr/bin/python
            rm -rf /usr/bin/pip && ln -s /usr/local/sbin/$exist_ver/bin/pip3 /usr/bin/pip
            echo -e "${Green_font_prefix}Successfully changed!${Font_color_suffix}\n" && rm -rf version && exit 0
        ;;
        N|n)
            echo -e "${Red_font_prefix}Cancelled!${Font_color_suffix}\n" && rm -rf version && exit 1
        ;;
        *)
            echo -e "${Red_font_prefix}Wrong num!${Font_color_suffix}\n" && rm -rf version && exit 1
      esac
    else
      continue
    fi
  done
  read -e -p "Version doesn't exist, Do you want to install it?[Y/N]" yny
  case $yny in
    Y|y)
        rm -rf version && choose_python_verison
    ;;
    N|n)
        echo -e "${Red_font_prefix}Cancelled!${Font_color_suffix}\n" && rm -rf version && exit 1
    ;;
    *)
        echo -e "${Red_font_prefix}Wrong num!${Font_color_suffix}\n" && rm -rf version && exit 1
    ;;
  esac
}



centos_install_web_scraping_frameworks(){
  echo -e "${Green_font_prefix}Preparing to install web scraping frameworks, please wait...${Font_color_suffix}\n"
  sleep 5
  pip install requests selenium lxml beautifulsoup4 pyquery

  ###Install phantomjs
  cd /usr/local/src
  wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
  tar xjf phantomjs-2.1.1-linux-x86_64.tar.bz2 && rm -rf phantomjs-2.1.1-linux-x86_64.tar.bz2
  mv phantomjs-2.1.1-linux-x86_64/ /usr/local/src/phantomjs
  ln -sf /usr/local/src/phantomjs/bin/phantomjs /usr/local/bin/phantomjs

  ###Install tesseract
  yum install -y tesseract
  git clone https://github.com/tesseract-ocr/tessdata.git
  mkdir -p /usr/share/tesseract/tessdata
  mv -f tessdata/* /usr/share/tesseract/tessdata
  #tesseract --list-langs
  yum install -y tesseract-devel
  pip install tesserocr pillow

  ###Install mysql
  wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
  rpm -ivh mysql-community-release-el7-5.noarch.rpm
  yum install -y mysql mysql-server
  rm -rf mysql-community-release-el7-5.noarch.rpm
  systemctl start mysqld && systemctl enable mysqld


  ###Install pymysql
  pip install pymysql
  echo -e "${info}Successfully installed web scraping frameworks!${Font_color_suffix}"
}

debian_install_web_scraping_frameworks(){
  echo -e "${Green_font_prefix}Preparing to install web scraping frameworks, please wait...${Font_color_suffix}\n"
  sleep 5
  pip install requests selenium lxml beautifulsoup4 pyquery

  ###Install phantomjs
  wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
  tar xjf phantomjs-2.1.1-linux-x86_64.tar.bz2 && rm -rf phantomjs-2.1.1-linux-x86_64.tar.bz2
  mv phantomjs-2.1.1-linux-x86_64/ /usr/local/src/phantomjs
  ln -sf /usr/local/src/phantomjs/bin/phantomjs /usr/local/bin/phantomjs

  ###Install tesseract
  apt install -y libleptonica-dev libtesseract-dev tesseract-ocr
  git clone https://github.com/tesseract-ocr/tessdata.git
  mkdir -p /usr/share/tesseract/tessdata
  mv -f mv tessdata/* /usr/share/tesseract-ocr/tessdata
  pip install tesserocr pillow

  ###Install mysql
  apt install -y mysql-server mysql-client
  systemctl start mysqld
  systemctl enable mysqld

  ###Install pymysql
  pip install pymysql
  echo -e "${info}Successfully installed web scraping frameworks!${Font_color_suffix}"
}

check_python_status(){
  py_ver=$(python --version)
  if [[ ! $py_ver ]]; then
      python --version 2> python_version
      if [ $? -ne 0 ]; then
        echo -e "Current Default Version: ${Red_font_prefix}Not installed${Font_color_suffix}"
        rm -rf python_version
      else
        py_ver=$(cat python_version)
        echo -e "Current Default Version: ${Green_font_prefix}$py_ver${Font_color_suffix}"
        rm -rf python_version
      fi
  else
      echo -e "Current Default Version: ${Green_font_prefix}$py_ver${Font_color_suffix}"
  fi
}



#=====MAIN=====
clear
check_root
echo -e "${info}${Yellow_font_prefix}}This script only support CentOS 7/8 Debian 9/10 Ubuntu 16.04/18.04 with 64bit.${Font_color_suffix}\n"
check_os
#install_figlet # useless
#figlet WELCOME # useless
echo -e "
=============================================
Author: Etnous
Blog: https://lala.biz
Update date: Dec 11, 2019
=============================================

--Python Installation and Management Script--
 ${Green_font_prefix}1.${Font_color_suffix}  Install Python
 ${Green_font_prefix}2.${Font_color_suffix}  Change Python Version
 ${Green_font_prefix}3.${Font_color_suffix}  Install Basic Web Scraping Frameworks
---------------------------------------------
"
check_python_status
echo && read -e -p "--Please input the num[1-2]: " num
case "$num" in
  1)
    choose_python_verison
  ;;
  2)
    select_python_version
  ;;
  3)
    install_web_scraping_frameworks
  ;;
  *)
    echo -e "${error}Please input the right num![1-2]"
  ;;
esac
