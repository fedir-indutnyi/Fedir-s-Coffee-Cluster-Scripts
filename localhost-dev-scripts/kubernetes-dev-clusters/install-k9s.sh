#!/bin/bash
curl -sS https://webinstall.dev/k9s | bash
source ~/.config/envman/PATH.env
echo 'source ~/.config/envman/PATH.env' >> ~/.bash_profile
k9s version

