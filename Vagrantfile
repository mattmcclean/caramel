# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Configure the Salt Master VM
  config.vm.define :saltmaster do |saltmaster_config|
    # Configure the host name
    saltmaster_config.vm.host_name = "saltmaster.example.com"
    # Configure the box
    saltmaster_config.vm.box = "logstash-salt"
    # Setup the network
    saltmaster_config.vm.network :hostonly, "192.168.1.10"
    # Setup the script provisioner
    saltmaster_config.vm.provision :shell, :path => "bin/master_setup.sh"
  end

  # Configure the Webserver
  config.vm.define :webserver do |webserver_config|
    # Configure the host name
    webserver_config.vm.host_name = "webserver.example.com"
    # Configure the box
    webserver_config.vm.box = "logstash-salt"
    # Setup the network
    webserver_config.vm.network :hostonly, "192.168.1.11"
    # Set the port forwarding for the webserver
    webserver_config.vm.forward_port 80, 8080
    # Setup the script provisioner
    webserver_config.vm.provision :shell do |shell|
      shell.path = "bin/minion_setup.sh"
      shell.args = "192.168.1.10"
    end
  end

  # Configure the Log Indexer
  config.vm.define :logindex do |logindex_config|
    # Configure the host name
    logindex_config.vm.host_name = "logindex.example.com"
    # Configure the box
    logindex_config.vm.box = "logstash-salt"
    # Set the memory
    logindex_config.vm.customize [
      "modifyvm", :id,
      "--memory", "1024"
    ]
    # Setup the network
    logindex_config.vm.network :hostonly, "192.168.1.12"
    # Set the port forwarding for the index server
    logindex_config.vm.forward_port 9292, 9292
    # Set the port forwarding for the Kibana webserver
    logindex_config.vm.forward_port 80, 8081
    # Setup the script provisioner
    logindex_config.vm.provision :shell do |shell|
      shell.path = "bin/minion_setup.sh"
      shell.args = "192.168.1.10"
    end
  end

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  # config.vm.network :hostonly, "33.33.33.10"

  # Assign this VM to a bridged network, allowing you to connect directly to a
  # network using the host's network device. This makes the VM appear as another
  # physical device on your network.
  # config.vm.network :bridged

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  # config.vm.forward_port 80, 8080

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file oneiric32_salt096.pp in the manifests_path directory.
  #
  # An example Puppet manifest to provision the message of the day:
  #
  # # group { "puppet":
  # #   ensure => "present",
  # # }
  # #
  # # File { owner => 0, group => 0, mode => 0644 }
  # #
  # # file { '/etc/motd':
  # #   content => "Welcome to your Vagrant-built virtual machine!
  # #               Managed by Puppet.\n"
  # # }
  #
  # config.vm.provision :puppet do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "oneiric32_salt096.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path (relative
  # to this Vagrantfile), and adding some recipes and/or roles.
  #
  # config.vm.provision :chef_solo do |chef|
  #   chef.cookbooks_path = "cookbooks"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision :chef_client do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # IF you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
