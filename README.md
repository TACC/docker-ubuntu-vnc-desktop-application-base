docker-ubuntu-vnc-desktop-application-base
=========================

Base docker image (HTML5 VNC interface to access Ubuntu 16.04 LXDE desktop environment) for applications.

Fork of https://github.com/fcwu/docker-ubuntu-vnc-desktop
(see [that readme file ](README_original.md) for general information)

Build base image
-------------------------

docker build -t taccaci/docker-ubuntu-vnc-desktop-application-base:latest .

Run docker container on designsafe-exec-01
--------------------------------

Run the docker container and access with https://designsafe-exec-01.tacc.utexas.edu:$port/#/ 
(note comand has env variables: port, AGAVE_JOB_OWNER

```
docker run -i --rm -p $port:6080 -e SSL_PORT=6080 -v "/corral-repl/tacc/NHERI/shared/${AGAVE_JOB_OWNER}":"/home/ubuntu/mydata" -e VNC_PASSWORD=1234 -e RESOLUTION="1080x720" --name "base_image_test_${AGAVE_JOB_OWNER}"   -v /etc/pki/tls/certs/designsafe-exec-01.tacc.utexas.edu.cer:/etc/nginx/ssl/designsafe-exec-01.tacc.utexas.edu.cer -v /etc/pki/tls/private/designsafe-exec-01.tacc.utexas.edu.key:/etc/nginx/ssl/designsafe-exec-01.tacc.utexas.edu.key taccaci/docker-ubuntu-vnc-desktop_application_base:latest
docker run -p 6080:80 -v /dev/shm:/dev/shm dorowu/ubuntu-desktop-lxde-vnc
```

DISPLAY_SCREEN_DEPTH (i.e.`-e DISPLAY_SCREEN_DEPTH=24`) can be used to change the color depth which defaults to 16
Browse http://127.0.0.1:6080/

Dockerhub
---------
https://hub.docker.com/r/taccaci/docker-ubuntu-vnc-desktop-application-base
