#!/bin/bash
# vim /etc/apt/sources.list
# :%s/us.archive/cn.archive/g
# developer env init script for ubuntu
# author <tigerbcode@gmail.com>
# blog <TIGERB.cn>
# version <0.1.0>

# -------------------- params check ------------------------

# define user name
shell_username="$1"

if [ "$shell_username" == "" ];
then
  echo -e "\033[41;37m Please input the username which you want create! \033[0m"
  echo -e "example, bash ./init-dev.sh deploy"
  exit 1
fi

# -------------------- zsh ------------------------

echo -e "\033[36m Install zsh oh-my-zsh [→] \033[0m"

sudo apt-get install zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# -------------------- git ------------------------
git config --global alias.plom "pull origin master"
git config --global alias.plod "pull origin develop"

# -------------------- nginx ------------------------

echo -e "\033[36m Install nginx [→] \033[0m"

sudo apt-get install nginx

cp -r ./sites-available /etc/nginx/sites-available

# -------------------- php ------------------------

echo -e "\033[36m Install php [→] \033[0m"

sudo apt-get install php

echo -e "\033[36m Install php-lib, php-redis, php-gd, php-mongo, composer [→] \033[0m"

sudo apt-get install php7.0-common php-redis php-mongodb php-gd composer

# -------------------- mysql/redis/mongodb ------------------------

echo -e "\033[36m Install mysql [→] \033[0m"

sudo apt-get install mysql-server

echo -e "\033[36m Install redis [→] \033[0m"

sudo apt-get install redis-server

echo -e "\033[36m Install mongodb [→] \033[0m"

sudo apt-get install mongodb

# -------------------- node/yarn ------------------------

echo -e "\033[36m Install node,yarn [→] \033[0m"

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo npm install -g yarn

# -------------------- htop/mycli/ab ------------------------

echo -e "\033[36m Install htop, mycli [→] \033[0m"

sudo apt-get install htop mycli apache2-utils tmux

# -------------------- Treri-dotfiles ------------------------

# Treri dotfiles·
git clone git@github.com:Treri/dotfiles.git && cd dotfiles

./install.sh tmux
./install.sh vim_rc
./install.sh vim_plugins
./install.sh vim_plugins_fcitx
./install.sh vim_plugins_matchtag
./install.sh vim_plugins_snippets
./install.sh vim_plugins_ycm
./install.sh zsh_rc
./install.sh zsh_plugins_fasd
./install.sh zsh_plugins_fzf
./install.sh zsh_plugins_thefuck

# -------------------- golang ------------------------

# install golang
echo -e "\033[36m Install golang version:1.9.2 [→] \033[0m"

GOVERSION="1.9.2"
OS="linux"
ARCH="amd64"

wget "https://studygolang.com/dl/golang/go$GOVERSION.$OS-$ARCH.tar.gz"

tar -C /usr/local -xzf go$GOVERSION.$OS-$ARCH.tar.gz

echo -e "export PATH=$PATH:/usr/local/go/bin" >> "$HOME/.profile" && source ~/.profile

sudo add-apt-repository ppa:masterminds/glide && sudo apt-get update
sudo apt-get install glide

go get github.com/beego/bee

# install supervisor
echo -e "\033[36m Install supervisor [→] \033[0m"
sudo apt-get install supervisor && cd /etc/supervisor/conf.d

cat <<EOF
[program:projectname]
command = 
autostart = true
autorestart = true
user = $shell_username
stdout_logfile = 
EOF
>> ./demo.conf

# -------------------- user ------------------------

# create user
echo -e "\033[36m Add user: $shell_username [→] \033[0m"
useradd -g ubuntu -G sudo -d /home/"$shell_username" -m "$shell_username"

# use zsh
sudo chsh -s /bin/zsh "$shell_username" && zsh
