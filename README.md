# DokuWiki in docker
DokuWiki 2020-07-29. No updates planned.

Docker hub: https://hub.docker.com/r/evgeniydoctor/doku

## Run
```
docker run -d \
--name doku \
-p 8080:80 \
-v /path/conf:/var/www/html/dokuwiki/conf \
-v /path/data:/var/www/html/dokuwiki/data \
-v /path/lib:/var/www/html/dokuwiki/lib \
-v /path/Tutorials/YT:/var/www/html/dokuwiki/files/tutorials:ro \
evgeniydoctor/doku:latest
```

As you can see in the example, you can mount a directory with some files and they will be available in the container. Files from the example (video tutorials) can be accessible like this:
```
<a href='/files/tutorials/filename.ext'>file!</a>
```
