describe ("check flannel config") do
  describe file("/etc/sysconfig/flanneld") do
    its(:content) { should match /^FLANNEL_ETCD_ENDPOINTS="http:\/\/k8s-master:2379"$/ }
    its(:content) { should match /^FLANNEL_ETCD_PREFIX="\/kube-centos\/network"$/ }
  end
end
