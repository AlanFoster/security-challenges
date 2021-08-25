FROM ubuntu:20.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        curl \
        libgmp3-dev \
        libmpc-dev \
        libmpfr-dev \
        nasm \
        texinfo \
        python3 \
        python3-dev \
        python3-distutils \
        git \
        gdb \
        openssh-server \
        locales \
        vim

# set up server ssh keys, allow user password login, unlock the root account, set static user/pass
RUN ssh-keygen -A && \
  # Remove the default sshd_config file, as overriding values later in the file doesn't work
  echo '' > /etc/ssh/sshd_config && \
  # Allow access via password
  echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
  echo 'PubkeyAuthentication no' >> /etc/ssh/sshd_config && \
  ## Add the user
  useradd --create-home --shell /bin/bash user && \
  echo 'user:password' | chpasswd && \
  # Add the user/pass hint
  echo "Guest account - user:password" > /etc/issue.net && \
  echo 'Banner /etc/issue.net' >> /etc/ssh/sshd_config && \
  # Stop the ssh service as it will run by the CMD
  mkdir /var/run/sshd && \
  service ssh stop

# setup pwndbg
RUN cd /home/user && \
  git clone https://github.com/pwndbg/pwndbg && \
  cd pwndbg && \
  ./setup.sh && \
  echo "source /home/user/pwndbg/gdbinit.py" > /home/user/.gdbinit

RUN DEBIAN_FRONTEND=noninteractive apt install -y \
  gcc-multilib

RUN python3 -m pip install --upgrade pwntools

# Copy and compile the app files
WORKDIR /home/user/
COPY ./app ./app

# Compile and set ownership
RUN cd /home/user/app && \
    make && \
    chown user:user -R /home/user/app && \
    chown root secure_shell && \
    chmod +s secure_shell

# Flag
RUN tr -dc A-Za-z0-9 </dev/urandom | head -c 32 | awk '{ print "FLAG{"$1"}" }' > /root/root.txt

CMD /usr/sbin/sshd -D
