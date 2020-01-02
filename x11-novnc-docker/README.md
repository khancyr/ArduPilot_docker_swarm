# To build

```` bash
docker build . -t mavproxy-vnc 
````

# To launch

```` bash
docker run -p 8083:8083 -ti mavproxy-vnc
````

or with `--network=host` to use multicast

```` bash
docker run --rm -ti --network=host mavproxy-vnc
````

# Tips
Use DISPLAY 1 to prevent collision with host
