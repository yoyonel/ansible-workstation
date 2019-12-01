  #!/bin/bash

echo "1. Installation des packages (essentiels) pour l'host"
sudo apt-get install -y             \
  htop iotop bmon                   \
  mesa-utils                        \
  apt-file                          \
  usbutils                          \
  dconf-cli                         \
  zsh                               \
  git                               \
  vim-nox                           \
  curl exuberant-ctags git ack-grep \
  python-pip                        \
  cmake libevent-dev                \
  libncurses5-dev                   \
  automake                          \
  xclip                             \
  pkg-config bc                
     
echo "2. Mise en place des outils SHELL"
#
echo "2.a ZSH + Oh My Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "-> Plugins installation ..."
# Plugin: Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# Plugin: AutoSuggestion
git clone http://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# Powerline9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
GIST_FOR_POWERLEVEL9K=https://gist.github.com/yoyonel/bd468e2850c87e486e771e0f928f4624/raw
wget $GIST_FOR_POWERLEVEL9K -O ~/.powerlevel9k

# https://askubuntu.com/questions/324725/getting-command-not-found-working-under-zsh
sudo apt install -y command-not-found

GIST_FOR_ZSHRC=https://gist.github.com/yoyonel/eed6a17b1e3474dfd3e4d31042c3cc14/raw
wget $GIST_FOR_ZSHRC -O ~/.zshrc

echo "Il faut rajouter/modifier dans .zshrc:
  export TERM=\"xterm-256color\"
  
  source ~/.powerlevel9k
  ZSH_THEME=\"powerlevel9k/powerlevel9k\"
 
  plugins=(.. zsh-syntax-highlighting zsh-autosuggestions ...)
  "
echo "  (TODO: Automatiser cette édition du fichier .zshrc)"

echo "Vérifier la config pour .zshrc (en particulier les clés SSH)"
echo "Presser: ENTER pour poursuivre"
read

vim $(realpath ~/.zshrc)
 
echo "2.b Font"
# On récupère la font (patchée)
wget https://github.com/yoyonel/bad-ass-terminal/raw/master/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf
# On la copie
mkdir -p ~/.fonts/.
mv SourceCodePro+Powerline+Awesome+Regular.ttf ~/.fonts/.
# On l'install
sudo fc-cache -fv 
echo "2.b Il faut setter (manuellement) la font 'SourceCodePro+Powerline+Aweseome+Regular' dans le terminal utilisé (surement 'mate-terminal')"
echo "  (TODO: utiliser dconf pour configurer automatique l'utilisation de la font)"

echo "3. VIM"
echo "3.a Fisa-vim-config"
wget https://raw.github.com/fisadev/fisa-vim-config/master/.vimrc -O ~/.vimrc
vim

echo "4. TMUX"
echo "4.a Build from source (github)"
pushd /tmp
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make -j
sudo make install
rm -rf /tmp/tmux
popd
popd

echo "4.b Installation du plugin manager pour TMUX: TMP"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "4.c Récupération d'une configuration pour tmux (.tmux.conf)"
GIST_FOR_TMUXCONF=https://gist.github.com/yoyonel/b30ace494263c553ac69103847b52471/raw
wget $GIST_FOR_TMUXCONF -O ~/.tmux.conf

echo "4.d Plugin: TMuxP"
sudo -EH pip install tmuxp

echo
echo "Mettre en place un nouveau raccourci clavier pour lancer le terminal avec le programme 'tmux' au lancement"
echo "Une fois sous l'environnement TMUX -> Presser: Prefix + I pour mettre à jour/installer les plugins pour TMUX"
echo "Presser: ENTER pour poursuivre"
read

echo "5. Installation de FuzzyFinder"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install

echo "6. Installation de Enpass"
# https://www.enpass.io/kb/how-to-install-on-linux/
sudo echo "deb http://repo.sinew.in/ stable main" > /etc/apt/sources.list.d/enpass.list
sudo wget -O - https://dl.sinew.in/keys/enpass-linux.key | apt-key add -
sudo apt-get update && apt install enpass

echo "7. Pigmentize Colors"
#http://pygments.org/download/
sudo apt install -y python-pygments

echo "8. VirtualEnvWrapper"
pip install virtualenvwrapper
sudo apt install -y virtualenvwrapper