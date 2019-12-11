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
osfile="/etc/os-release"

#check os
check_os(){
  if [ -e $osfile ]; then
    source $osfile
    case "$ID" in
      centos)
        if [[ $VERSION_ID == "7" ]] || [[ $VERSION_ID == "8" ]]; then
              os_version="centos"
              echo -e "${info}${Yellow_font_prefix}Your system is $ID$VERSION_ID.${Font_color_suffix}\n"
        else
              echo -e "${error}${Yellow_font_prefix}Wrong VERSION_ID!${Font_color_suffix}\n" && exit 1
        fi
      ;;
      debian)
        if [[ $VERSION_ID == "9" ]] || [[ $VERSION_ID == "10" ]]; then
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
    install_python
    ;;
  2)
    if [[ $os_version == "centos" ]] && [[ $VERSION_ID == "7" ]]; then
      rm -rf /etc/yum.repos.d/CentOS-Base.repo
      wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
      echo -e "${info}${Yellow_font_prefix}Successfully change the source!${Font_color_suffix}" && install_python

    elif [[ $os_version == "centos" ]] && [[ $VERSION_ID == "8" ]]; then
      rm -rf /etc/yum.repos.d/CentOS-Base.repo
      wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo
      echo -e "${info}${Yellow_font_prefix}Successfully change the source!${Font_color_suffix}" && install_python

    elif [[ $os_version == "debian"  ]] && [[ $VERSION_ID == "9" ]]; then
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
      echo 'deb https://mirrors.aliyun.com/debian  stable main contrib non-free
            deb https://mirrors.aliyun.com/debian  stable-updates main contrib non-free' > /etc/apt/sources.list
      echo -e "${info}${Yellow_font_prefix}Successfully change the source!${Font_color_suffix}" && install_python

    elif [[ $os_version == "ubuntu" ]] && [[ $VERSION_ID == "16.04" ]]; then
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
  (man figlet) >& figlet_status
  result=$(awk -F " " 'NR==1{ print $1 }' figlet_status)
  if [[ $result == "No" ]]; then
    if [[ $os_version == "centos" ]]; then
      echo -e "${Yellow_font_prefix}Preparing to start, please wait...${Font_color_suffix}\n"
      yum install -y figlet &>/dev/null
     else
      echo -e "${Yellow_font_prefix}Preparing to start, please wait...${Font_color_suffix}\n"
      apt install -y figlet &>/dev/null
    fi
  else
    return
  fi
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
  if [[ $(python -V) == "Python 3.7.5" ]]; then
      if [[ $os_version == "centos" ]]; then
          centos_install_web_scraping_frameworks
      elif [[ $os_version == "debian" ]]; then
          debian_install_web_scraping_frameworks
      elif [[ $os_version == "ubuntu" ]]; then
          debian_install_web_scraping_frameworks
      fi
  else
    echo -e "${error}${Yellow_font_prefix}You haven't install python yet!${Font_color_suffix}\n"
  
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
  wget https://www.python.org/ftp/python/3.7.5/Python-3.7.5.tar.xz && tar xvJf Python-3.7.5.tar.xz
  rm -rf xvJf Python-3.7.5.tar.gz
  mv Python-3.7.5 /usr/local/python-3.7 && cd /usr/local/python-3.7/
  ./configure --prefix=/usr/local/sbin/python-3.7 && make && make install
  cd /root
  rm -rf /usr/bin/python
  ln -s /usr/local/sbin/python-3.7/bin/python3 /usr/bin/python
  sed -i '1,1s/python/python2.7/g' /usr/bin/yum
  sed -i '1,1s/python/python2.7/g' /usr/libexec/urlgrabber-ext-down
  rm -rf /usr/bin/pip
  ln -s /usr/local/sbin/python-3.7/bin/pip3 /usr/bin/pip
  if [[ $(python -V) == "Python 3.7.5" ]]; then
    echo -e "${info}${Yellow_font_prefix}Successfully installed python!${Font_color_suffix}"
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
  wget https://www.python.org/ftp/python/3.7.5/Python-3.7.5.tar.xz && tar xvJf Python-3.7.5.tar.xz
  rm -rf xvJf Python-3.7.5.tar.gz
  mv Python-3.7.5 /usr/local/python-3.7 && cd /usr/local/python-3.7/
  ./configure --prefix=/usr/local/sbin/python-3.7 && make && make install
  rm -rf /usr/bin/python
  ln -s /usr/local/sbin/python-3.7/bin/python3 /usr/bin/python
  rm -rf /usr/bin/pip
  ln -s /usr/local/sbin/python-3.7/bin/pip3 /usr/bin/pip
  if [[ $(python -V) == "Python 3.7.5" ]]; then
    echo -e "${info}${Yellow_font_prefix}Successfully installed python!${Font_color_suffix}"
  else
    echo -e "${error}${Red_font_prefix}Failed to install python.${Font_color_suffix}\n" && exit 1
  fi
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


#=====MAIN=====
clear
check_os
install_figlet
figlet WELCOME
echo -e "
=============================================
Author: Etnous
Blog: https://lala.biz
Update date: Dec 11, 2019
=============================================

--Python Installation and Management Script--
 ${Green_font_prefix}1.${Font_color_suffix}  Install Python3.7.5
 ${Green_font_prefix}2.${Font_color_suffix}  Install Web Scraping Frameworks
-----------------------
 ${Green_font_prefix}3.${Font_color_suffix}  Python Version
"
echo && read -e -p "--Please input the num[1-3]: " num
case "$num" in
  1)
    select_area
  ;;
  2)
    install_web_scraping_frameworks
  ;;
  3)
    python -V
  ;;
  *)
    echo -e "${error}Please input the right num![1-3]"
  ;;
esac