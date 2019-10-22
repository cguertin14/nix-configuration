{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "gitfast"
        "history"
        "sudo"
	"kubectl"
	"docker"
	"helm"
      ];
      theme = "gentoo";
    };

    # /etc/zsh/zprofile
    loginShellInit = ''
      export XDG_CONFIG_HOME=''${XDG_CONFIG_HOME:-$HOME/.config}
      export XDG_DATA_HOME=''${XDG_DATA_HOME:-$HOME/.local/share}
      export XDG_CACHE_HOME=''${XDG_CACHE_HOME:-$HOME/.cache}
      #export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_HOME/flatpak/exports/share:$PATH"
      
      export ZDOTDIR=''${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
      export HISTFILE="$XDG_DATA_HOME/zsh/history"
      
      autoload -Uz compinit
      compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
    '';

    # /etc/zsh/zshrc
    interactiveShellInit = ''
function ks {
   case "$1" in
     d)
         export KUBECONFIG=~/.kube/config
         ;;
     s)
	 export KUBECONFIG=~/Documents/Work/Infra/config/cluster/k8s-artifex-cluster-staging-kubeconfig.yaml
	 ;;
     p)
         export KUBECONFIG=~/Documents/Work/Infra/config/cluster/k8s-artifex-cluster-kubeconfig.yaml
         ;;
     *)
         echo "Utilisation: $0 {d|s|p}"
         ;;
   esac
}
function goto {
   case "$1" in
     work)
         cd ~/Documents/Work
         ;;
     infra)
         cd ~/Documents/Work/Infra
         ;;
     ets)
	 cd ~/Documents/ETS
	 ;;
     perso)
	 cd ~/Documents/Perso
	 ;;
     *)
         echo "Utilisation: $0 {work|infra|ets|perso}"
         ;;
   esac
}
#export GOPATH=$HOME/go
export KUBECONFIG=~/.kube/config
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
emulate sh -c 'source /etc/profile'
source <(kubectl completion zsh)
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
# ------------------------------------
# Docker alias and function
# ------------------------------------
# Get latest container ID
alias dl="docker ps -l -q"
# Get container process
alias dps="docker ps"
# Get process included stop container
alias dpa="docker ps -a"
# Get images
alias di="docker images"
# Get container IP
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="docker run -d -P"
# Run interactive container, e.g., $dki base /bin/bash
alias dki="docker run -i -t -P"
# Execute interactive container, e.g., $dex base /bin/bash
alias dex="docker exec -i -t"
# Stop all containers
dstop() { docker stop $(docker ps -a -q); }
# Remove all containers
drm() { docker rm $(docker ps -a -q); }
# Stop and Remove all containers
alias drmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'
# Remove all images
dri() { docker rmi $(docker images -q); }
# Dockerfile build, e.g., $dbu tcnksm/test 
dbu() { docker build -t=$1 .; }
# Show all alias related docker
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }
# Bash into running container
dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }
unset ZLE_RPROMPT_INDENT
#export ANDROID_HOME=$HOME/Android/Sdk
#export PATH=$PATH:$ANDROID_HOME/emulator
#export PATH=$PATH:$ANDROID_HOME/tools
#export PATH=$PATH:$ANDROID_HOME/tools/bin
#export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="$PWD/node_modules/.bin/:$PATH"
    '';
  };
}
