## Hide welcome message
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Source .profile to apply its values
source ~/.profile

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Starship prompt
source ("/usr/bin/starship" init fish --print-full-init | psub)

# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

## Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

## Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
	set from (echo $argv[1] | trim-right /)
	set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

## Import colorscheme from 'wal' asynchronously
if type "wal" >> /dev/null 2>&1
   cat ~/.cache/wal/sequences
end

## Run paleofetch if session is interactive
if status --is-interactive
   paleofetch
end

# Replace cat w with, yay with paru
[ ! -x /usr/bin/bat ] && [ -x /usr/bin/cat ] && alias cat='bat'
[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

# Replace ls with exa
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias wget='wget -c '
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias hw='hwinfo --short'										# hardware info
alias dir='dir --color=auto'									# lis directory contents
alias vdir='vdir --color=auto'									# list directory contents & info
alias grep='grep --color=auto'
alias l.='exa -a | egrep '^\.''									# list hidden
alias grubup="sudo update-grub"									# update grub
alias jctl='journalctl -p 3 -xb'								# logged error messages
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias psmem='ps auxf | sort -nr -k 4'							# list programs in memory
alias big='expac -H M '%m\t%n' | sort -h | nl'					# Sort installed packages by size
alias fixpacman='sudo rm /var/lib/pacman/db.lck'				# unlock pacman
alias cleanup='sudo pacman -Rnsv (pacman -Qtdq)'				# remove orphaned packages
alias psmem10='ps auxf | sort -nr -k 4 | head -10'				# top 10 programs in memory
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'				# List amount of -git packages
alias la='exa -a --color=always --group-directories-first'		# all files and dirs
alias ll='exa -l --color=always --group-directories-first'		# long format
alias ls='exa -al --color=always --group-directories-first'		# preferred listing

# .dotfiles git config
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Recent Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# preview changes to sddm's sugar-candy theme
alias prevulogin='sddm-greeter --test-mode --theme /usr/share/sddm/themes/sugar-candy'

# update system
alias Syyu='sudo reflector --latest 10 --age 2 --fastest 10 --country 'ca,us' --protocol https --sort rate --verbose --info --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist && powerpill -Syyuv && fish_update_completions && sudo updatedb'

# Get fastest mirrors 
alias mirrors="sudo reflector -f 50 -l 50 --age 2 --country 'ca,us' --number 20 --protocol https --sort rate --info --verbose --save /etc/pacman.d/mirrorlist"
