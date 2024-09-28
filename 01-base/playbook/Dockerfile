FROM ubuntu:20.04
# Python3.8 install for Ubuntu
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install -y python3.8 python3-pip
# # Update symlink to point to latest
# RUN rm /usr/bin/python3 && ln -s /usr/bin/python3.8 /usr/bin/python3
# RUN python3 --version
# RUN pip3 --versiondocker 