describe ("check services are started and enabled") do
  services = ["kube-proxy", "kubelet", "flanneld", "docker"]
  services.each do |srv|
    describe service(srv) do
      it { should be_running }
      it { should be_enabled }
    end
  end
end
