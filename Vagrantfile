Vagrant.require_version ">= 2.0.0"
# https://app.vagrantup.com/bento/boxes/ubuntu-18.04
$VM_BOX = 'bento/ubuntu-18.04'

Vagrant.configure(2) do |config|
  config.vm.box = $VM_BOX
  config.vm.provision "shell", inline: "apt install --yes git python3-pip"

  # https://gist.github.com/jeethridge/b8319c113aa9efc9c657c3a81800cfe8
  # Enable X11 forwarding for graphical apps.
  # Make sure you have xquartz installed if using OSX host!  
  # $ sudo vim /etc/ssh/ssh_config
  #     ForwardAgent yes
  #     ForwardX11 yes
  #     ForwardX11Trusted yes
  # $ vagrant ssh-config
  #     User vagrant
  #     Port 2222
  #     IdentityFile /home/.../virtualbox/private_key
  #     ...
  #     ForwardX11 yes
  # $ ssh -X -p 2222 -i /home/.../virtualbox/private_key vagrant@localhost
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true
  config.vm.provision "shell", inline: "sudo apt-get install -y xauth"

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.verbose = "v"
    ansible.extra_vars = { ansible_ssh_user: 'vagrant', vagrant: true, zsh_user: 'vagrant', user_name: 'vagrant' }
    ansible.sudo = true
    ansible.playbook = 'laptop.yml'
    ansible.galaxy_role_file = "requirements.yml"
  end
end
