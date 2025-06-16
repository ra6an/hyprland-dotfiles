#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Pokretanje modernog prompta
eval "$(starship init bash)"

# ASCII art + sistem info
neofetch

# QT6CT
export QT_QPA_PLATFORMTHEME=qt6ct

alias wp='bash ~/.config/hypr/scripts/wallpaper-change.sh'
alias wp-crop='bash ~/.config/hypr/scripts/wallpaper-crop.sh'
alias icat='kitty +kitten icat'
alias ytdl='bash ~/.config/hypr/scripts/yt-downloader.sh'
