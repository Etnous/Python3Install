#!/usr/bin/env bash
#######################################################
# Title: Install Python3.7 and Web scraping frameworks#
# Author:                                    #
# Update date: December 10, 2019                      #
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
#=================================
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

install_python(){
  if [[ $os_version == "centos" ]]; then
    centos_install_python
  elif [[ $os_version == "debian" ]]; then
    debian_install_python
  elif [[ $os_version == "ubuntu" ]]; then
    ubuntu_install_python
  fi
}

install_web_scraping_frameworks(){
  if [[ $os_version == "centos" ]]; then
    centos_install_web_scraping_frameworks
  elif [[ $os_version == "debian" ]]; then
    debian_install_web_scraping_frameworks
  elif [[ $os_version == "ubuntu" ]]; then
    ubuntu_install_web_scraping_frameworks
  fi
}

centos_install_python(){
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
}

centos_install_web_scraping_frameworks(){
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
}



echo -e "--Python Installation and Management Script--
 ${Green_font_prefix}1.${Font_color_suffix}  Install Python3.7.5
 ${Green_font_prefix}2.${Font_color_suffix}  Install Web Scraping Frameworks
-----------------------
 ${Green_font_prefix}3.${Font_color_suffix}  Python Version
"
echo && read -e -p "--Please input the num[1-3]: " num
case "$num" in
  1)
    check_os && install_python
  ;;
  2)
    check_os && install_web_scraping_frameworks
  ;;
  3)
    python -V
  ;;
  *)
    echo -e "${error}  Please input the right num![1-3]"
  ;;
esac