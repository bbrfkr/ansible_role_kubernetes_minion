# ansible_role_kubernetes_minion

This is an Ansible role. This role executes Kubernetes setting of minion node.

## Processing
This role executes the following settings.

* Kubernetes setting
  * put common config 
  * put kubelet config
* flannel setting
  * put config
  * start and enable service
* docker setting
  * start and enable service

## Caution!!
* This role assumpts a part of network settings (nics, default gateway and dns server) is completed.
* This role assumpts NetworkManager service is disabled and stopped.

## Support OS

| OS | version |
|----|---------|
|CentOS|7|

## Role variables
```
kubernetes_minion:
  hostname: k8s-minion                   # hostname of target
  kubelet_port: 10250                    # listen port of kubelet
  allow_privileged: true                 # whether allow to create privileged container
  master:
    hostname: k8s-master                 # hostname of master node
    api_port: 8080                       # listen port of api server
    etcd_mgmt_dir: /kube-centos/network  # management directory of etcd
```

## Dependencies
- [bbrfkr.kubernetes_common](https://galaxy.ansible.com/bbrfkr/kubernetes_common/)

## Build status
|branch|status|
|------|------|
|master|[![Build Status](http://jenkins.bbrfkr.mydns.jp:8088/job/ansible_role_kubernetes_minion_master/badge/icon)](http://jenkins.bbrfkr.mydns.jp:8088/job/ansible_role_kubernetes_minion_master/)|
|v.0.1 |[![Build Status](http://jenkins.bbrfkr.mydns.jp:8088/job/ansible_role_kubernetes_minion_v.0.1/badge/icon)](http://jenkins.bbrfkr.mydns.jp:8088/job/ansible_role_kubernetes_minion_v.0.1/)|

## Retest
This role is tested by serverspec, then its test codes are included in repository. Users can retest this role by using the test codes. To retest this role, follow the steps described below.

1. Prepare 2 targets (Here, targets ip are X.X.X.X, Y.Y.Y.Y)
2. Install serverspec in local machine
3. Modify spec/inventory.yml
```
---
- conn_name: target15  # never change!
  conn_host: X.X.X.X   # target ip
  conn_port: 22        # target's ssh port
  conn_user: vagrant   # user to connect
  conn_pass: vagrant   # password of user
  conn_idkey:          # path of identity key 
                       # (absolute path or relative path from the location of Rakefile)
  sudo_pass:           # sudo password of user

- conn_name: target16  # never change!
  conn_host: Y.Y.Y.Y   # target ip
  conn_port: 22        # target's ssh port
  conn_user: vagrant   # user to connect
  conn_pass: vagrant   # password of user
  conn_idkey:          # path of identity key 
                       # (absolute path or relative path from the location of Rakefile)
  sudo_pass:           # sudo password of user
```

4. Modify targets ips in any files of `spec` dir
```
$ sed -i 's/192\.168\.1\.115/X.X.X.X/g' `find spec -type f`
$ sed -i 's/192\.168\.1\.116/X.X.X.X/g' `find spec -type f`
```

5. Run `rake`

## License
MIT

## Author
Name: bbrfkr  
MAIL: bbrfkr@gmail.com

