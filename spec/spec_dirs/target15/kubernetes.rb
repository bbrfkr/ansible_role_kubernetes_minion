describe ("check kubernetes common setting") do
  describe file("/etc/kubernetes/config") do
    its(:content) { should match /^KUBE_ALLOW_PRIV="--allow-privileged=true"$/ }
    its(:content) { should match /^KUBE_MASTER="--master=http:\/\/k8s-master:8080"$/ }
  end
end

describe ("check kubelet config") do
  describe file("/etc/kubernetes/kubelet") do
    its(:content) { should match /^#{ Regexp.escape("KUBELET_ADDRESS=\"--address=0.0.0.0\"") }$/ }
    its(:content) { should match /^KUBELET_PORT="--port=10250"$/ }
    its(:content) { should match /^KUBELET_HOSTNAME="--hostname-override=k8s-minion"$/ }
    its(:content) { should match /^KUBELET_API_SERVER="--api-servers=http:\/\/k8s-master:8080"$/ }
  end
end
