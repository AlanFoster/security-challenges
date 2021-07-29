## Development workflow

```
docker-compose rm -f kong_database && docker-compose build --parallel && docker-compose up
```

## Debugging Kong

Enter interactive shell
```
docker-compose run --user="0" kong /bin/sh
```

## SSH

Viewing ssh config:
```
cat /etc/ssh/sshd_config
```

Debugging sshd issues:
```
/usr/sbin/sshd -D -ddd
```

Temporary container to test sshd with:
```
docker run -it --rm -p 2222:22 challenge_2_webservice /bin/sh -c "/usr/sbin/sshd -D -ddd"
```

SSH into temporary test containers and ignore `authorized_hosts`
```
ssh -o "StrictHostKeyChecking accept-new" -o "UserKnownHostsFile /dev/null" -o "IdentitiesOnly=yes" -p 2222 root@127.0.0.1 
ssh -d -o "StrictHostKeyChecking accept-new" -o "UserKnownHostsFile /dev/null" -o "IdentitiesOnly=yes" -p 2222 -L 9000:192.168.192.4:5432 root@127.0.0.1
```
