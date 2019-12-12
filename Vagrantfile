Vagrant.require_version ">= 2.0.0"
$VM_BOX = 'bento/ubuntu-18.04'
# $VM_BOX = 'debian/stretch64'

Vagrant.configure('1') do |config|
  config.vm.box = $VM_BOX
  config.vm.provision "shell", inline: "apt install --yes git python3-pip"

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.verbose = "v"
    ansible.extra_vars = { ansible_ssh_user: 'vagrant', vagrant: true, zsh_user: 'vagrant' }
    ansible.sudo = true
    ansible.playbook = 'laptop.yml'
    ansible.galaxy_role_file = "requirements.yml"
  end
end
