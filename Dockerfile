#Docker file for online exam test.
#All rights reserved linuxgeeks.in

FROM centos:latest
MAINTAINER Yogesh Gavhane <ygavhane91@gmail.com>

RUN yum -y update; yum clean all
RUN yum -y install openssh-server passwd  cronie perl; yum clean all
ADD ./start.sh /bin/start.sh
RUN chmod 755 /bin/start.sh
ADD ./allinone.sh /bin/allinone.sh
RUN chmod 755 /bin/allinone.sh
RUN mkdir /var/run/sshd
RUN echo 'root:12345678' | chpasswd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 
RUN systemctl set-default multi-user.target 
RUN chmod 755 /start.sh
RUN echo "export key=`df -h | grep mapper | awk '{print $1}' | awk -F - '{print $4}'`" >> /root/.bashrc
EXPOSE 22
RUN ./start.sh
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
