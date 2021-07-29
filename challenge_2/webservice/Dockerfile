FROM ruby:2.7.3-alpine

ENV APP_ENV production

## Set up SSH
RUN apk add --no-cache openssh

# set up server ssh keys, allow root password login, unlock the root account, set static user/pass
RUN ssh-keygen -A && \
  # Remove the default sshd_config file, as overriding values later in the file doesn't work
  echo '' > /etc/ssh/sshd_config && \
  # Allow root access via password
  echo 'PermitRootLogin yes'  >> /etc/ssh/sshd_config && \
  echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
  echo 'PubkeyAuthentication no' >> /etc/ssh/sshd_config && \
  # Allow LocalForward
  echo 'AllowTcpForwarding yes' >> /etc/ssh/sshd_config && \
  echo 'UseDNS no' >> /etc/ssh/sshd_config && \
  echo 'PermitOpen any' >> /etc/ssh/sshd_config && \
  echo 'MaxSessions 100' >> /etc/ssh/sshd_config && \
  passwd -u root && \
  echo 'root:admin' | chpasswd && \
  # Remove the welcome message
  rm /etc/motd

# Web app
WORKDIR /app
COPY ./ ./
CMD /usr/sbin/sshd && \
    ruby -rwebrick -e'WEBrick::HTTPServer.new(Port: 8000, DocumentRoot: File.join(Dir.pwd, "static")).start'
