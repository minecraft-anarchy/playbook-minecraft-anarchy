# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
	config.ssh.shell="bash"

	config.vm.provider "virtualbox" do |vb|
		vb.gui = false
		vb.memory = 4096
		vb.cpus = 4
		vb.linked_clone = true
		vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
	end

	################
	### Cache ###
	################

	if Vagrant.has_plugin?("vagrant-cachier")
		config.cache.scope = :box
		config.cache.auto_detect = false
    # Disabled to prevent W: chown to _apt:root of directory /var/cache/apt/archives/partial failed - SetupAPTPartialDirectory (1: Operation not permitted)
		#config.cache.enable :apt
		#config.cache.enable :apt_lists
		config.cache.enable :composer
		# Npm funktioniert nicht, da "irgendwie" ein falscher Symlink gesetzt wird.
		# Daher wir ein Generic Cache genutzt: http://fgrehm.viewdocs.io/vagrant-cachier/buckets/generic/
		#config.cache.enable :npm
		config.cache.enable :generic, { :cache_dir => "/tmp/vagrant-cache/npm" }

		config.cache.synced_folder_opts = {
            type: :nfs,
            # The nolock option can be useful for an NFSv3 client that wants to avoid the
            # NLM sideband protocol. Without this option, apt-get might hang if it tries
            # to lock files needed for /var/cache/* operations. All of this can be avoided
            # by using NFSv4 everywhere. Please note that the tcp option is not the default.
            mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
          }
	end

	################
	### SSH KEYS ###
	################

	# Create ~/.ssh for root.
	config.vm.provision "shell" do |s|
		s.inline = <<-SHELL
		  mkdir -p /root/.ssh
		  chmod 750 /root/.ssh
		SHELL
	end

	# Deploy all configured keys.
	config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/developer.pub"
	config.vm.provision "shell", inline: "cat /home/vagrant/.ssh/developer.pub >> /home/vagrant/.ssh/authorized_keys"
	config.vm.provision "shell", inline: "sudo cat /home/vagrant/.ssh/authorized_keys >> /root/.ssh/authorized_keys"

	# Hostmanager Plugin Configuration
	config.hostmanager.enabled = true
	config.hostmanager.manage_host = true
	config.hostmanager.manage_guest = true
	config.hostmanager.ignore_private_ip = false
	config.hostmanager.include_offline = true

	#####################
	### Vagrant Boxes ###
	#####################

	config.vm.define "minecraft-anarchy" do |box|
		box.vm.box = "bento/ubuntu-18.04"
		box.vm.hostname = "minecraft-anarchy"
		box.vm.network "private_network", ip: "10.255.255.5"
		# HTTP and HTTPS for Webssite
		# box.vm.network "forwarded_port", guest: 80, host: 88080, auto_correct: true
		# box.vm.network "forwarded_port", guest: 443, host: 88443, auto_correct: true
		# box.vm.synced_folder ".", "/vagrant"

		# BindFs for performance and user on MacOS
		# https://github.com/gael-ian/vagrant-bindfs
    sync_folders = {}
    # "/var/www" => "/var/www/htdocs"
		# }

    sync_folders.map do |sync_src,sync_dest|
  		box.vm.synced_folder sync_src, "/srv/#{sync_dest}", :create=>true, :nfs=>true, :nfs_version=>3, :nfs_udp=>false
    		box.bindfs.debug = true
    		box.bindfs.bind_folder "/srv/#{sync_dest}", sync_dest,
    			perms: "u=rwx:g=rwx:o=rx",
    			force_user:   "www-data",
    			force_group:  "www-data",
    			after: :provision
    end

		box.hostmanager.aliases = %w(minecraft-anarchy.org www.minecraft-anarchy.org)

	end
end
