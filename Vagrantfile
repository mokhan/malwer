# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = ENV["VAGRANT_BOX"] || "chef/centos-7.0"
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 15672, host: 15672
  config.vm.provision :chef_apply do |chef|
    chef.recipe = File.read("config/chef_apply.rb")
  end
  config.ssh.forward_agent = true
  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = "4096"
    v.vmx["numvcpus"] = "2"
  end
end
