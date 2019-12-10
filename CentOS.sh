#!/usr/bin/env bash
######################################################
# Title: Install Python3.7 and Web-Spider environment#
# Author: Etnous                                     #
# Update date: December 10, 2019                     #
######################################################
yum update -y
mkdir -p /usr/local/src
cd /usr/local/src
yum groupinstall -y "Development tools"
yum install -y gcc gcc-c++ make git freetype-devel fontconfig-devel sqlite-devel ncurses-libs zlib-devel mysql-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel openssl-devel zlib* libffi-devel
wget https://www.python.org/ftp/python/3.7.5/Python-3.7.5.tar.xz && tar xvJf Python-3.7.5.tar.xz
rm -rf xvJf Python-3.7.5.tar.gz
mv Python-3.7.5 /usr/local/python-3.7 && cd /usr/local/python-3.7/
./configure --prefix=/usr/local/sbin/python-3.7
make && make install
cd /root
rm -rf /usr/bin/python
ln -s /usr/local/sbin/python-3.7/bin/python3 /usr/bin/python
sed -i '1,1s/python/python2.7/g' /usr/bin/yum
sed -i '1,1s/python/python2.7/g' /usr/libexec/urlgrabber-ext-down

rm -rf /usr/bin/pip
ln -s /usr/local/sbin/python-3.7/bin/pip3 /usr/bin/pip

pip --version
python -V

printf '\nPreparing to install web-spider environment......\n'
sleep 2

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

printf "\nplease use 'mysql -u root -p' to change the password! "
printf "Successfully install the python3 and web-spider environment"


