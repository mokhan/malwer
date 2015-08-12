# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = ENV["VAGRANT_BOX"] || "chef/centos-7.0"
  config.vm.provision :chef_apply do |chef|
    chef.recipe = File.read("config/chef_apply.rb")
  end
  config.ssh.forward_agent = true
  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = "2048"
    v.vmx["numvcpus"] = "2"
  end
end
