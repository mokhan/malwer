execute "yum-update" do
  command "yum update -y"
end

execute "yum-upgrade" do
  command "yum upgrade -y"
end

execute "yum-groupinstall" do
  command "yum groupinstall -y 'Development Tools'"
end

package "epel-release" do
  action :install
end

bash "install_rabbitmq" do
  user "root"
  cwd "/tmp"
  not_if { ::File.exist?("/etc/init.d/rabbitmq-server") }
  code <<-EOH
    wget https://www.rabbitmq.com/releases/erlang/erlang-17.4-1.el6.x86_64.rpm
    wget https://github.com/rabbitmq/rabbitmq-server/releases/download/rabbitmq_v3_5_3/rabbitmq-server-3.5.3-1.noarch.rpm
    rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
    yum install -y erlang-17.4-1.el6.x86_64.rpm rabbitmq-server-3.5.3-1.noarch.rpm
  EOH
end

bash "install_cassandra" do
  user 'root'
  not_if { ::File.exist?("/etc/yum.repos.d/datastax.repo") }
  code <<-SCRIPT
  echo "[datastax]\nname=DataStax Repo for Apache Cassandra\nbaseurl=http://rpm.datastax.com/community\nenabled=1\ngpgcheck=0" > /etc/yum.repos.d/datastax.repo
  SCRIPT
end

execute "yum-clean" do
  command "yum clean all"
end

packages = %w{
  dsc21
  git
  java-1.8.0-openjdk
}

package packages do
  action :install
end

git "/usr/local/rbenv" do
  repository "https://github.com/sstephenson/rbenv.git"
  action :sync
end

bash "install_rbenv" do
  user "root"
  cwd "/tmp"
  not_if { ::File.exist?("/etc/profile.d/rbenv.sh") }
  code <<-EOH
    echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile.d/rbenv.sh
    echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> /etc/profile.d/rbenv.sh
    echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
  EOH
end

directory "/usr/local/rbenv/plugins" do
  action :create
end

git "/usr/local/rbenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  action :sync
end

bash "install_ruby" do
  user "root"
  not_if { ::File.exist?("/usr/local/rbenv/shims/ruby") }
  code <<-EOH
    source /etc/profile.d/rbenv.sh
    rbenv install 2.2.2
    rbenv global 2.2.2
  EOH
end

bash "install_bundler" do
  code <<-EOH
    source /etc/profile.d/rbenv.sh
    gem install bundler --no-ri --no-rdoc
  EOH
end

service "rabbitmq-server" do
  action [:start, :enable]
end

service "cassandra" do
  action [:start, :enable]
end
