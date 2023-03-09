# wgcf-docker
CloudFlare warp in docker

Note: net.ipv4.conf.all.src_valid_mark=1 [Learning about Linux fwmark masks](https://utcc.utoronto.ca/~cks/space/blog/linux/LinuxIpFwmarkMasks) Seems to work with it being 0 as well in some cases.

1. Run a single container:

```

docker run --rm -it \
    --name wgcf \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    --cap-add net_admin \
    -v $(pwd)/wgcf:/wgcf \
    neilpang/wgcf-docker



The above command will enable both ipv4 and ipv6, you can enable ipv4 or ipv6 only like following:


#enable ipv4 only:



docker run --rm -it \
    --name wgcf \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    --cap-add net_admin \
    -v $(pwd)/wgcf:/wgcf \
    neilpang/wgcf-docker  -4 



#enable ipv6 only:



docker run --rm -it \
    --name wgcf \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    --cap-add net_admin \
    -v $(pwd)/wgcf:/wgcf \
    neilpang/wgcf-docker  -6 



```

or:

```
docker run --rm -it \
    --name wgcf \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    --cap-add net_admin \
    -v $(pwd)/wgcf:/wgcf \
    neilpang/wgcf-docker:alpine





The above command will enable both ipv4 and ipv6, you can enable ipv4 or ipv6 only like following:


#enable ipv4 only:


docker run --rm -it \
    --name wgcf \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    --cap-add net_admin \
    -v $(pwd)/wgcf:/wgcf \
    neilpang/wgcf-docker:alpine  -4



#enable ipv6 only:


docker run --rm -it \
    --name wgcf \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    --cap-add net_admin \
    -v $(pwd)/wgcf:/wgcf \
    neilpang/wgcf-docker:alpine  -6




```




2. If aonther container needs to use the wgcf network, run it like:

```

docker run --rm  -it  --network container:wgcf  curlimages/curl curl ipinfo.io

```


3. Docker-compose example:

```
Enable both ipv4 and ipv6 by default:


version: "2.4"
services:
  wgcf:
    image: neilpang/wgcf-docker:latest
    volumes:
      - ./wgcf:/wgcf
      #- /lib/modules:/lib/modules #This seems unnecessary if modules are not loaded from within the container. [linuxserver/docker-wireguard](https://github.com/linuxserver/docker-wireguard) Also has it as optional.
    privileged: false
    sysctls:
      net.ipv6.conf.all.disable_ipv6: 0
      net.ipv4.conf.all.src_valid_mark: 1
    cap_add:
      - NET_ADMIN
    

  test:
    image: curlimages/curl
    network_mode: "service:wgcf"
    depends_on:
      - wgcf
    command: curl ipinfo.io




Enable ipv6 only:

version: "2.4"
services:
  wgcf:
    image: neilpang/wgcf-docker:latest
    volumes:
      - ./wgcf:/wgcf
      #- /lib/modules:/lib/modules #This seems unnecessary if modules are not loaded from within the container. [linuxserver/docker-wireguard](https://github.com/linuxserver/docker-wireguard) Also has it as optional.
    privileged: false
    sysctls:
      net.ipv6.conf.all.disable_ipv6: 0
      net.ipv4.conf.all.src_valid_mark: 1
    cap_add:
      - NET_ADMIN
    command: "-6"
    

  test:
    image: curlimages/curl
    network_mode: "service:wgcf"
    depends_on:
      - wgcf
    command: curl ipv6.ip.sb





Enable ipv4 only:



version: "2.4"
services:
  wgcf:
    image: neilpang/wgcf-docker:latest
    volumes:
      - ./wgcf:/wgcf
      #- /lib/modules:/lib/modules #This seems unnecessary if modules are not loaded from within the container. [linuxserver/docker-wireguard](https://github.com/linuxserver/docker-wireguard) Also has it as optional.
    privileged: false
    sysctls:
      net.ipv6.conf.all.disable_ipv6: 0
      net.ipv4.conf.all.src_valid_mark: 1
    cap_add:
      - NET_ADMIN
    command: "-4"
    

  test:
    image: curlimages/curl
    network_mode: "service:wgcf"
    depends_on:
      - wgcf
    command: curl ipinfo.io



```

or:

```

Enable both ipv4 and ipv6 by default:



version: "2.4"
services:
  wgcf:
    image: neilpang/wgcf-docker:alpine
    volumes:
      - ./wgcf:/wgcf
      #- /lib/modules:/lib/modules #This seems unnecessary if modules are not loaded from within the container. [linuxserver/docker-wireguard](https://github.com/linuxserver/docker-wireguard) Also has it as optional.
    privileged: false
    sysctls:
      net.ipv6.conf.all.disable_ipv6: 0
      net.ipv4.conf.all.src_valid_mark: 1
    cap_add:
      - NET_ADMIN
    

  test:
    image: curlimages/curl
    network_mode: "service:wgcf"
    depends_on:
      - wgcf
    command: curl ipinfo.io

    
    





Enable ipv6 only:



version: "2.4"
services:
  wgcf:
    image: neilpang/wgcf-docker:alpine
    volumes:
      - ./wgcf:/wgcf
      #- /lib/modules:/lib/modules #This seems unnecessary if modules are not loaded from within the container. [linuxserver/docker-wireguard](https://github.com/linuxserver/docker-wireguard) Also has it as optional.
    privileged: false
    sysctls:
      net.ipv6.conf.all.disable_ipv6: 0
      net.ipv4.conf.all.src_valid_mark: 1
    cap_add:
      - NET_ADMIN
    command: "-6"
    

  test:
    image: curlimages/curl
    network_mode: "service:wgcf"
    depends_on:
      - wgcf
    command: curl ipv6.ip.sb






Enable ipv4 only:



version: "2.4"
services:
  wgcf:
    image: neilpang/wgcf-docker:alpine
    volumes:
      - ./wgcf:/wgcf
      #- /lib/modules:/lib/modules #This seems unnecessary if modules are not loaded from within the container. [linuxserver/docker-wireguard](https://github.com/linuxserver/docker-wireguard) Also has it as optional.
    privileged: false
    sysctls:
      net.ipv6.conf.all.disable_ipv6: 0
      net.ipv4.conf.all.src_valid_mark: 1
    cap_add:
      - NET_ADMIN
    command: "-4"
    

  test:
    image: curlimages/curl
    network_mode: "service:wgcf"
    depends_on:
      - wgcf
    command: curl ipinfo.io





```
