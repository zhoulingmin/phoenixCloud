yum install gcc
useradd -s /sbin/nologin tomcat
chown -R tomcat:tomcat /usr/local/tomcat

tar -xzvf commons-daemon-native.tar.gz
cd commons-daemon-1.0.15-native-src/unix 
./configure
make
cp jsvc ../..
cd ../..
cp daemon.sh  /etc/init.d/tomcat
chmod 755  /etc/init.d/tomcat
chkconfig --add tomcat
chkconfig tomcat on
chkconfig --list tomcat

service tomcat start
