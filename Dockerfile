# Builder
FROM ruby:3.0.1-alpine as builder

ENV BUNDLE_WITHOUT development:test
WORKDIR /app

RUN apk add --no-cache \
  build-base

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Final image
FROM ruby:3.0.1-alpine

ENV APP_ENV production

## Set up SSH
RUN apk add --no-cache openssh
# set up server ssh keys, set up root ssh keys, only allow ssh keys, unlock the root account
RUN ssh-keygen -A && \
  ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -q -N "" && \
  cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
  echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config && \
  echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config && \
  passwd -u root

## Copy from the builder
WORKDIR /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app /app

CMD /usr/sbin/sshd && \
  thin start --address 0.0.0.0 --port 8000 -R app.rb
