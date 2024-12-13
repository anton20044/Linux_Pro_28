# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :master => {
        :box_name => "centos7",
        :ip_addr => '192.168.56.150',
        :provision => "server.sh"

  },
  :slave => {
        :box_name => "centos7",
        :ip_addr => '192.168.56.151',
	:provision => "slave.sh"
  }
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

      config.vm.define boxname do |box|

          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxname.to_s

          #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset

          box.vm.network "private_network", ip: boxconfig[:ip_addr]

          box.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", "1024"]
            # Подключаем дополнительные диски
            #vb.customize ['createhd', '--filename', second_disk, '--format', 'VDI', '--size', 5 * 1024]
            #vb.customize ['storageattach', :id, '--storagectl', 'IDE', '--port', 0, '--device', 1, '--type', 'hdd', '--medium', second_disk]
          end

          #box.vm.provision :shell do |s|
          #   s.inline = 'mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh'
	  #   s.inline = "sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*"
	  #   s.inline = "sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*"
	  #   s.inline = "yum install nano -y"
          #   s.inline = " yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm -y"
             #percona-release setup ps57 -y
             #yum install Percona-Server-server-57 -y
          #end

        box.vm.provision "shell", inline: <<-SHELL
          mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
          sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
          sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
          sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config
          systemctl restart sshd.service
          yum install nano -y
          yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm -y
          percona-release setup ps57 -y
          yum install Percona-Server-server-57 -y
          cp /vagrant/conf/conf.d/* /etc/my.cnf.d/
          systemctl start mysql
        SHELL

        box.vm.provision "shell", path: boxconfig[:provision]

      end
  end
end
