## Challenge

Find the exploit, and get a shell.

### Running

With docker-compose:

```
docker-compose build
docker-compose up
```

Or with Docker directly:

```
docker build -t challenge .
docker run -it -p 2222:22 -p 8000:8000 challenge
```

Visit http://localhost:8000 to start the challenge
