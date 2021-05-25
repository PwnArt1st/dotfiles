zmodload zsh/datetime
start=$EPOCHREALTIME

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


#
# Exports
#

export HISTFILE=~/.histfile
export HISTSIZE=1000
export SAVEHIST=1000
export EDITOR=micro
export GIT_EDITOR=micro
export RUSTC_WRAPPER=sccache
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export WINEESYNC=1
export WINEFSYNC=1
export PAGER='moar'
export SYSTEMD_LESS='FRSMK'
export SYSTEMD_PAGER='moar'
export RBENV_SHELL=zsh


#
# Path
#

path+=('/usr/lib/ccache/bin/' '/home/pie/.local/bin')


#
# Options
#

bindkey -e
setopt sharehistory autocd extendedglob append_history hist_ignore_dups hist_expire_dups_first hist_verify hist_ignore_space

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

autoload -Uz compinit
compinit

autoload edit-command-line
zle -N edit-command-line

exit_zsh() { exit }
zle -N exit_zsh

zle -N history-substring-search-up
zle -N history-substring-search-down


#
# Sources
#

source '/usr/lib/rbenv/completions/rbenv.zsh'
source "$HOME/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.config/zsh/fzf-tab/fzf-tab.plugin.zsh"
source "$HOME/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "$HOME/.config/zsh/powerlevel10k/powerlevel10k.zsh-theme"


#
# Aliases
#

alias ls='exa'
alias cp='cp --reflink=auto'
alias nano='micro'
alias cat=bat
alias tkg="bash $HOME/git/tkg/update.sh"
alias copy="xclip -selection c"
alias yay=paru


#
# Functions
#

function mkcd(){
	mkdir -p -- "$1" &&
	cd -P -- "$1"
}

function paste() {
	socat - TCP:termsend.pl:1337
}


#
# Bindings
#

bindkey '^X^e' edit-command-line
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^D' exit_zsh

zshcache_time="$(date +%s%N)"
TRAPUSR1() {
  rehash
}


#
# rbenv
#

eval "$(rbenv init -)"
command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}


#
# Terminal title hooks
#

autoload -Uz add-zsh-hook

function xterm_title_precmd () {
	print -Pn -- '\e]2;%n@%m %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (alacritty*|gnome*|konsole*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi



[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

dur=$(echo "$EPOCHREALTIME - $start" | bc)
echo "Execution time: $dur seconds"
