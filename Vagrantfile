Vagrant.configure("2") do |zoo_lab|
    zoo_lab.vm.define "zoo1" do |zoo1|
		zoo1.vm.provider "vmware_desktop" do |v|
			v.cpus = 2
			v.memory = 2048
			v.allowlist_verified = true
		end
		zoo1.vm.box = "generic/rocky8"
		zoo1.vm.hostname = "zoo1"
		zoo1.vm.network "private_network", ip: "192.168.204.156"
		zoo1.vm.provision "shell", path: "setup.sh", args: "zoo1"
		end
    zoo_lab.vm.define "zoo2" do |zoo2|
		zoo2.vm.provider "vmware_desktop" do |v|
			v.cpus = 2
			v.memory = 2048
			v.allowlist_verified = true
		end
		zoo2.vm.box = "generic/rocky8"
		zoo2.vm.hostname = "zoo2"
		zoo2.vm.network "private_network", ip: "192.168.204.157"
		zoo2.vm.provision "shell", path: "setup.sh", args: "zoo2"
		end
    zoo_lab.vm.define "zoo3" do |zoo3|
		zoo3.vm.provider "vmware_desktop" do |v|
			v.cpus = 2
			v.memory = 2048
			v.allowlist_verified = true
		end
		zoo3.vm.box = "generic/rocky8"
		zoo3.vm.hostname = "zoo3"
		zoo3.vm.network "private_network", ip: "192.168.204.158"
		zoo3.vm.provision "shell", path: "setup.sh", args: "zoo3"
		end
end