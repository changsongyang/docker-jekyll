FROM ubuntu
 
RUN echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list && \
    echo 'deb http://archive.ubuntu.com/ubuntu precise-updates universe' >> /etc/apt/sources.list && \
    apt-get update

#Runit
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y runit 
CMD /usr/sbin/runsvdir-start

#SSHD
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server &&	mkdir -p /var/run/sshd && \
    echo 'root:root' |chpasswd

#Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat tree htop unzip sudo

#Requirements
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ruby1.9.1-dev rubygems
RUN gem install json --no-ri --no-rdoc

#Jekyll
RUN gem install jekyll --no-ri --no-rdoc

#Configuration
ADD . /docker

#Runit Automatically setup all services in the sv directory
RUN for dir in /docker/sv/*; do echo $dir; chmod +x $dir/run $dir/log/run; ln -s $dir /etc/service/; done

ENV HOME /root
WORKDIR /root
EXPOSE 22
