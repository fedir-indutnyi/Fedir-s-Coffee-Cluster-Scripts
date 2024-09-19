#!/bin/bash
echo "======== Install brew (needed for k9s) (please wait) =================="
cd ~
# sudo apt update
# sudo apt upgrade
sudo apt-get install build-essential
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/$USER/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew doctor

echo "======== Install k9s (please wait) =================="
        echo "======== Installing k9s =================="
         # Via LinuxBrew
        brew install derailed/k9s/k9s
        echo "======== Installing k9s Completed =================="       

echo "======== Prerequisites were installed successfully! =================="



New:
curl -sS https://webinstall.dev/k9s | bash
source ~/.config/envman/PATH.env

