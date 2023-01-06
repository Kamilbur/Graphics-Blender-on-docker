# Graphics-Blender-on-docker

Add your ssh pub key to docker.pub

Build image:
```
$ docker build -t blenda-image .
```
```
$ docker run -p <port number>:10000 -it blenda-image 
```
In another terminal
```
$ ssh -i <path to docker private key> -X -p <port number> root@localhost
```
