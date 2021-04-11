# Set values
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

# Environment Setup
source ~/.profile

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end

# Starship prompt
if status --is-interactive
   source ("/usr/bin/starship" init fish --print-full-init | psub)
end

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

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
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

# Import colorscheme from 'wal' asynchronously
if type "wal" >> /dev/null 2>&1
   cat ~/.cache/wal/sequences
end

# Run paleofetch if session is interactive
if status --is-interactive
   paleofetch
end

# Replace cat w with, yay with paru
alias cat='bat --style header --style rules --style snip --style changes --style header'
[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

# Replace ls with exa
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias big='expac -H M '%m\t%n' | sort -h | nl'					# Sort installed packages by size
alias cleanup='sudo pacman -Rnsv (pacman -Qtdq)'				# remove orphaned packages
alias dfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dir='dir --color=auto '									# lis directory contents
alias egrep='egrep --color=auto '
alias fgrep='fgrep --color=auto '
alias fixpacman='sudo rm /var/lib/pacman/db.lck'				# unlock pacman
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'				# List amount of -git packages
alias grep='grep --color=auto '
alias grubup='sudo update-grub'									# update grub
alias helpme='cht.sh --shell'
alias hw='hwinfo --short'										# hardware info
alias jctl='journalctl -p 3 -xb'								# logged error messages
alias la='exa -a --color=always --group-directories-first'		# all files and dirs
alias ll='exa -l --color=always --group-directories-first'		# long format
alias ls='exa -al --color=always --group-directories-first'		# preferred listing
alias l.='exa -a | egrep '^\.''									# list hidden
alias prevusddm='sddm-greeter --test-mode --theme /usr/share/sddm/themes/sugar-candy'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'				# top 10 programs in memory
alias pQs='paru -Qsv '
alias pQii='paru -Qiiv '
alias pQl='paru -Qlv '
alias pSs='paru -Ssv '
alias pS='paru -Sv '
alias pRsn='paru -Rsnv '
alias psmem='ps auxf | sort -nr -k 4'							# list programs in memory
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias vdir='vdir --color=auto '									# list directory contents & info
alias wget='wget -c '

# Get fastest mirrors 
alias mirrors='sudo reflector --latest 30 --fastest 30 --country 'ca,us' --number 10 --protocol https --verbose --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist'

# update system
alias Syyu='sudo reflector --latest 5 --age 2 --fastest 5 --country 'ca,us' --protocol https --sort rate --info --verbose --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist && paru -Syyuv && fish_update_completions && sudo updatedb'
