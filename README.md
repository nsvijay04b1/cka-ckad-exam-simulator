# CKA / CKAD Practice Exam Simulator

# the original repos(only support CKA )

* `arush-sal/cka-practice-environment` , it's awesome! but hard to use it. only support visit the CKA practice environment with URL http://localhost or http://127.0.0.1, that's TOO BAD, cause this constraint, you can only use MacBook or CentOS/Ubuntu Desktop verison, if you wanna use a VM on a Cloud, and visit the environment from your local browser, there is no way for you.

* `satomic/cka-practice-environment` fixed it, you can provision the CKA practice environment on a Cloud VM, than visit it with its PUBLIC IP from your local browser, that's cool, BUT you have only CKA option not CKAD too, i want to have both options in single platform.

# With my repo, i support both CKA & CKAD in same browser and more features.

* With my repo `nsvijay04b1/cka-ckad-exam-simulator`, i want to make the test available for both CKA & CKAD. From any browser with http://<PUBLIC_IP>, you can select the test CKA or CKAD and start the test, CKA test timer is 3hrs and CKAD test timer is 2 hrs.

* questions folder is a volume mount  , in case you want to attempt different set of questions, replace all questions from 1.html to 24.html for CKA( 1.html to 19.html for CKAD) in fodlers `ckadquestions` & `ckaquestions` and then you have new test runtime go for it.
   ```
       volumes:
       - /users/kube/LAB/cka-lab/ckaquestions:/etc/nginx/html/ckaquestions:rw 
       - /users/kube/LAB/cka-lab/ckadquestions:/etc/nginx/html/ckadquestions:rw
   ```    

* you have the option to tag the image you build ( `image` in file `docker-compose-builder.yaml` )
   ```
    gatone:
     build: ./gateone
     image: cka-ckad-exam-gateone:latest
    lab:
     build: ./lab
     image: cka-ckad-exam-lab:latest
   ``` 

* you have the option to chose the DNS settings which will be updated in containers as /etc/resolv.conf ( update `dns_search` and `dns` in file  `docker-compose-builder.yaml` ) 
   ```
      dns_search:
      - corp.example.com
      - example.com
      dns:
      - 10.100.102.1
      - 10.100.102.2
   ```

* file `docker-compose-builder.yaml` 

```
version: "3"

services:

  gateone:
    build: ./gateone
    image: cka-ckad-exam-gateone:latest
    ports:
    - "9080:8000"
    hostname: kubectl
    networks:
    - frontend
    volumes:
    - ssh_key:/root/.ssh/
    - /users/kube/.kube/:/root/.kube/
    dns_search:
    - corp.example.com
    - example.com
    dns:
    - 10.100.102.1
    - 10.100.102.2

  lab:
    build: ./lab
    image: cka-ckad-exam-lab:latest
    entrypoint: /opt/entry.bash
    ports:
    - "80:80"
    hostname: exam
    networks:
    - frontend
    volumes:
    - /users/kube/LAB/cka-lab/ckaquestions:/etc/nginx/html/ckaquestions:rw 
    - /users/kube/LAB/cka-lab/ckadquestions:/etc/nginx/html/ckadquestions:rw  
    environment:
      GATEONE_HTTP_SERVER: "gateone:8000"
    dns_search:
    - corp.example.com
    - example.com
    dns:
    - 10.232.217.1
    - 10.232.217.2

networks:
  frontend: {}
volumes:
  ssh_key: {}
  ```
  
![Home](/images/cka-ckad-home.png)
![CKA](/images/cka.jpg)
![CKAD](/images/ckad.jpg)
![FINISH](/images/cka-finish.jpg)



# Step by step adoption 
**you must install docker before do this**. just copy and paste these shells from the two steps, then visit it from your local browser

### Step 1: Install docker-compose 

Make sure that you have docker-compose installed([installation instructions](https://docs.docker.com/compose/install/)). Or you can run the `install-docker-compose.sh` shell scripts.
```
sh install-docker-compose.sh
```

```cat install-docker-compose.sh
# install docker-compose 
wget https://www.cnrancher.com/download/compose/v1.23.2-docker-compose-Linux-x86_64
mv v1.23.2-docker-compose-Linux-x86_64 docker-compose
chmod +x docker-compose
mv docker-compose /usr/local/bin/
docker-compose -v
```

### Step 2: Git clone repo

```
git clone https://github.com/nsvijay04b1/cka-ckad-exam-simulator.git 
```

### Step 3: update docker-compose-builder.yaml

* volumes of `gateone` service 
   -  Replace `/users/kube/.kube/` with path of KUBECONFIG file of your k8s cluster.

* volumes of `lab` service 
  -  Replace `/users/kube/LAB/cka-lab` with path of ckad/cka questions folder of yours. 
  -  All questions are names like 1.html till 24.html for CKA and 1.html till 19.html and copied to respective folders `ckaquestions` and `ckaquestions` at path you would replace `/users/kube/LAB/cka-lab`  with.

```
services:
  gateone:
    volumes:
    - ssh_key:/root/.ssh/
    - /users/kube/.kube/:/root/.kube/
  lab:
    volumes:
    - /users/kube/LAB/cka-lab/ckaquestions:/etc/nginx/html/ckaquestions:rw 
    - /users/kube/LAB/cka-lab/ckadquestions:/etc/nginx/html/ckadquestions:rw 
  ```
 
* Update DNS values ( refer `/etc/resolv.conf` of you machine) 

  -   `nameserver` in `/etc/resolv.conf ` should go to `dns` 
  -   `search` in `/etc/resolv.conf ` should go to `dns_search` 
  
   ```
    dns_search:
    - corp.example.com
    - example.com
    dns:
    - 10.232.217.1
    - 10.232.217.2
    ```

### Step 4: run docker-compose build

* Run docker-compose
```
docker-compose -f docker-compose-builder.yaml up -d --build
```

* docker images that are build 
```
cka-ckad-exam-lab                                                latest              249d378ed8cf        2 hours ago         182MB
cka-ckad-exam-gateone                                            latest              f86157a11b2a        2 hours ago         1.16GB
```
* docker containers running 
```
[kube@eaasrt cka-ckad-exam-simulator]$ docker ps | grep cka
aa7d3b03f8e9        cka-ckad-exam-gateone:latest                 "gateone --log_file_…"   2 hours ago         Up 2 hours          0.0.0.0:9080->8000/tcp                         cka-lab_gateone_1
1dc478bda507        cka-ckad-exam-lab:latest                     "/opt/entry.bash"        2 hours ago         Up 2 hours          0.0.0.0:80->80/tcp                             cka-lab_lab_1
```

### Step 4: Accessing the application

In the bowser launch the application with  http://<HOSTNAME> or http://<IP> , where HOSTNAME/IP is from where docker-compose is run.
   
   

### Creation of kubernetes cluster in case you didnt had one

**if you already have Kubernetes Cluster**, just copy your `kubeconfig.yaml` file contents to the `/users/kube/.kube/config` file in the host for his CKA Practice Environment.
```
# maybe some command like
cp /pathto_your_existed/kubeconfig.yaml /users/kube/.kube/config
```

otherwise you can use [Rancher k3s](https://k3s.io/) to provision a mini Kubernetes to use.
```
# provision k8s (k3s)
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" sh -

# check it
kubectl get node

# copy kubeconfig to /root/.kube/config
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
sed -i "s/localhost/$(echo $PRIVATE_IP)/g" /root/.kube/config

kubectl --kubeconfig /root/.kube/config get node
```



## Uninstall
```
docker-compose -f docker-compose-builder.yaml down
/usr/local/bin/k3s-uninstall.sh
```
