# Etaoin's dotfiles

Some of my dotfiles for expidited setup.

## Usage

```bash
# install git
sudo apt update
sudo apt install git -y
# or
sudo dnf install git -y
# install yadm
git clone https://github.com/TheLocehiliosan/yadm.git ~/.yadm-project
mkdir -p ~/.local/bin
ln -s ~/.yadm-project/yadm ~/.local/bin/yadm
# clone dotfiles
yadm clone https://github.com/EtaoinWu/.dotfiles.yadm.git
# bootstrap
export UPGRADE_PACKAGES=true
export INSTALL_DOCKER=true
  # if you want to connect to tailscale:
  export TAILSCALE_AUTHKEY=your-tailscale-authkey
  # if you want to connect to a specific tailscale network:
  export TAILSCALE_SERVER=https://your-tailnet-coordinator.example.com
yadm bootstrap
```
