### useful kubectl aliases  

```
cat << EOK >> ~/.bashrc
########## Kubernetes alias - start ##########
alias k='kubectl'
source <(kubectl completion bash) 
source <(kubectl completion bash|sed "s/kubectl/k/g")

alias kd='k describe '
alias kdp='k describe pod '
alias kdd='k describe deploy '
alias kds='k describe svc '

alias kg='k get '
alias kgp='k get pod '
alias kgd='k get deploy '
alias kgs='k get svc '
alias kgn='k get no '

alias ke='k edit '
alias ka='k apply -f '
alias kc='k create '

#delete operations - *be careful*
alias kdl='k delete --force '
alias kdlf='k delete --force -f '

#kubeconfig
alias kcv='k config view '
alias kgc='k config get-contexts '
alias kcc='k config current-context '
alias ksn='k config set-context  --current  --namespace ' 
alias kuc='k config use-context '
alias ksc='k config set-context '

# for troubleshooting
alias kl='k logs '
alias kwget='k run busy-wget --image=busybox:1.28.4 --restart=Never --rm -it -- wget -O- -T 2 -t 2  '
alias kns='k run busy-nslookup --image=busybox:1.28.4 --restart=Never --rm -it -- nslookup  '

#export variables
export do="--dry-run=client -oyaml"
export VISUAL='vi'   #default editor program
export EDITOR='vi'   #default editor program
export PS1="[\u@\h \T  \W]\\$ "   #to set time in the command prompt
########## Kubernetes alias - end ##########
EOK
```

# load bash profile
```
source ~/.bashrc
```

### VIM config file

```
cat << EOV >> ~/.vimrc
set ts=2 sts=2 sw=2 expandtab ruler
set backspace=indent,eol,start
EOV
```

### **TMUX commands**
```
tmux     # start new
tmux new -s myname    #start new with session name:
tmux a                        #  (or at, or attach)
tmux a -t myname    #attach to named:
tmux ls                      # list sessions:
tmux kill-session -t myname  #kill session
tmux ls | grep : | cut -d. -f1 | awk '{print substr($1, 0, length($1)-1)}' | xargs kill # Kill all the tmux sessions:
```

### TMUX conf file (replacing bind-key with Ctl+a)
```
cat << EOT > ~/.tmux.conf
set-option -g prefix C-a
unbind-key C-a
bind-key C-a send-prefix
set -g base-index 1
set-window-option -g automatic-rename on
set-option -g set-titles on
set -g status-keys vi
set -g history-limit 10000
setw -g mode-keys vi
setw -g monitor-activity on
bind-key v split-window -h
bind-key s split-window -v
#synchronize-panes
bind-key x set-window-option synchronize-panes\; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"
EOT
```


### **Tips**
```
# set the labels and selector before creating a deployment/service pair.
kubectl create service clusterip my-svc --clusterip="None" -o yaml --dry-run=client | kubectl set  selector --local -f 'environment=qa' -o yaml | kubectl create -f - 

kubectl create deployment my-dep -o yaml --dry-run=client | kubectl label --local -f -  environment=qa -o yaml | kubectl create -f -

#List users in kube conbfig
kubectl config view -o jsonpath='{range .users[*]}{.name}{"\n"}{end}'

#List all pods that are Running
kubectl get pods --field-selector=status.phase=Running

#Display all the resources in the namespace
kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind 2>/dev/null 


#override spec like imagePullSecrets
kubectl run hello --restart=Never --image=nginx  --overrides='{ "apiVersion": "v1", "spec": { "imagePullSecrets": [{"name": "your-registry-secret"}] } }' --dry-run=client -oyaml

#patch a deployment with port
kubectl  patch deployments  apple -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx","ports":[{"protocol":"TCP","containerPort":80,"name":"nginxport"}]}]}}}}'
```



###  **systemctl** 
```
sudo systemctl list-unit-files --type service --all | grep -v enabled
sudo systemctl list-unit-files --type service --all | grep -v running
sudo systemctl cat nginx.service  # To see the full contents of a unit file
sudo systemctl show nginx.service #see the low-level details of the unit’s settings on the system
sudo systemctl edit nginx.service #add a unit file snippet  to append or override settings in the default unit file
sudo systemctl edit --full nginx.service #modify the entire content of the unit file
```

###  **apt** 
```
sudo apt-get install --only-upgrade kubeadm=1.17.0-00

sudo apt-mark hold kubelet kubectl    #   Mark a package as held back
sudo apt-mark unhold kubelet kubectl   #   Unset a package as held back

sudo apt-cache madison docker # List of available packages
sudo apt-cache policy docker-ce

sudo apt-cache pkgnames  # List available packages
sudo apt-cache pkgnames docker-ce # List down all the packages starting with ‘vsftpd
sudo apt-cache search vsftpd  # Find Out Package Name and Description of Software
sudo apt-cache showpkg vsftpd # Check Dependencies for Specific Packages



sudo apt-get check                     # Check Broken Dependencies
sudo apt-get build-dep netcat   # Search and Build Dependencies

sudo apt-get update # to resynchronize the package index files from the their sources specified in /etc/apt/sources.list file
sudo apt-get upgrade #upgrade all the currently installed software packages on the system

sudo apt-get download nethogs # Download package without installing
sudo apt-get --download-only source vsftpd  #To download only source code of particular package
sudo apt-get source vsftpd         # Download and Unpack a Package
sudo apt-get --compile source goaccess  #  download, unpack and compile the source code

sudo apt-get clean                    #Clean Up Disk Space (clean .deb files downloaded)
sudo apt-get remove vsftpd     # Remove Packages Without Configuration
sudo apt-get purge vsftpd       # Completely remove packages
sudo apt-get remove --purge vsftpd  # do both 



```
