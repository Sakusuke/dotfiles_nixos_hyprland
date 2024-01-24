#!/bin/bash
export ZSH="/home/$USER/.oh-my-zsh"
export EDITOR="vim"

ZSH_THEME="eastwood"

source $ZSH/oh-my-zsh.sh
#source $HOME/.config/lf/icons

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec Hyprland
fi

export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

if [ ! -d /tmp/del ]; then
  mkdir -p /tmp/del
fi

alias c="clear"
alias v="vim"
alias n="sudo vim /etc/nixos/configuration.nix"
alias z='vim ~/.zshrc'
alias h="vim ~/.config/hypr/hyprland.conf"
alias en="LANG="en_US.UTF-8""
alias jp="LANG="ja_JP.UTF-8""
alias kill="sudo killall -KILL"
alias lsb="lsblk"
alias cp="cp -r"
alias pacman="sudo pacman"
alias pac="sudo pacman -S"
alias update="sudo pacman -Syu"
alias par="paru -S"
alias net="sudo nethogs"
alias umount="sudo umount"
alias mount="sudo mount"
alias m="sudo mount"
alias um="sudo umount"
alias eject="sudo eject"
alias pb="xclip -selection clipboard -out"
alias clip="xclip -selection clipboard"

alias pc="setsid &>/dev/null devour pcmanfm"
alias spc="sudo setsid &>/dev/null devour sudo pcmanfm"
alias sx="startx"

# sleep tight my sweet prince
#alias srm="sudo rm -rf"
alias rs="sudo pacman -Rsnc"
alias bck='cd "$OLDPWD"'
alias df='df -H'
alias mkdir='mkdir -p'
alias hist='vim ~/.zsh_history'
alias sxiv='sxiv -a'
alias t="trash"
alias c2f="clip2file"
alias ce="commandedit"
alias f="setsid &>/dev/null"
alias d="sleep 1 &&"
alias de="setsid &>/dev/null devour"
alias sv="sudo vim"
alias sys="sudo systemctl"
alias s="sudo"
alias sysyadm="sudo yadm --yadm-dir /etc/yadm --yadm-data /etc/yadm/data"
alias yt="ytfzf -t"
alias lf="LANG="en_US.UTF-8" lfrun"
alias lutris="LUTRIS_SKIP_INIT=true lutris"
alias mine="sudo chown -R $(whoami)"
alias up="cd ../"
alias bt="bluetoothctl"
alias gotosleep="sleep 30m && sudo systemctl poweroff"
alias try="nix-shell -p"

e() {
    setsid &>/dev/null "$@" && exit
}

pbl() {
    echo "$@"|xclip -r -selection clipboard
}

path() {
    readlink -f "$@"|xclip -r -selection clipboard
}

file2clip() {
  xclip -sel c < "$1"
}

clip2file() {
  xclip -sel c -o > "$1"
}

fullpath(){
  realpath $1 | xclip -sel c
}

mk() {
  mkdir -p "$1" && cd "$1" && clear
}

commandedit() {
  vim $(which $1)
}

subs() {
  ffprobe -v error -select_streams s -show_entries stream=index,codec_name:stream_tags=language -of csv=p=0 "$1"
}

mkscript() {
  nvim "$1" && chmod +x "$1"
}

7e() {
  7z x "$1" -o"$2"
}

7ze() {
  filename=$(basename -- "$1")
  7z x "$1" -o"${filename%.*}"
}

#nix-reboot
nr() {
echo --\> 'sudo nixos-rebuild build && cp /etc/nixos/configuration.nix $HOME/.config && sudo reboot'
#sleep 0.1
sudo nixos-rebuild build && cp /etc/nixos/configuration.nix $HOME/.config && sudo reboot
}

#nix-update
nu() {
echo --\> 'sudo nixos-rebuild switch && cp /etc/nixos/configuration.nix $HOME/.config '
sudo nixos-rebuild switch && cp /etc/nixos/configuration.nix $HOME/.config
}

#eval "$(atuin init zsh --disable-up-arrow)"
