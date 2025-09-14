#Base Image
FROM debian

#chooses default setting
ENV DEBIAN_FRONTEND=noninteractive 

#Install basic tools
RUN apt-get update && \
    apt-get install -y \
        bash \
        coreutils && \
    rm -rf /var/lib/apt/lists/*

#create a non-root user
RUN useradd -ms /bin/bash sandboxuser
USER sandboxuser

#set working directory
WORKDIR /home/sandboxuser

#default command
CMD [ "bash" ]