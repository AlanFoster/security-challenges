FROM ruby:3.0.1-alpine

## Set up SSH
RUN apk add --no-cache openssh

# set up server ssh keys, allow root password login, unlock the root account, set static user/pass
RUN ssh-keygen -A && \
  echo 'PermitRootLogin yes'  >> /etc/ssh/sshd_config && \
  echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
  echo 'PubkeyAuthentication no' >> /etc/ssh/sshd_config && \
  passwd -u root && \
  echo 'root:admin' | chpasswd && \
  # Remove the welcome message
  rm /etc/motd

CMD /usr/sbin/sshd -D
