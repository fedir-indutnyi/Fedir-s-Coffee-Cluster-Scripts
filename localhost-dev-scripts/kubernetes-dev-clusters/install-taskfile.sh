echo 'Install Brew - to be able to install Task'
cd ~
sudo apt update
sudo apt upgrade
sudo apt-get install build-essential
sudo apt install mc
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/$USER/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew doctor
echo 'Install Taskfile utility: (similar like ansible)'
brew install go-task
task --version