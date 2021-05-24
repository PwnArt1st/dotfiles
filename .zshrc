zmodload zsh/datetime
start=$EPOCHREALTIME

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
EDITOR=micro
GIT_EDITOR=micro
RUSTC_WRAPPER=sccache
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export WINEESYNC=1
export WINEFSYNC=1
export PAGER='moar'
export SYSTEMD_LESS='FRSMK'
export SYSTEMD_PAGER='moar'
path+=('/usr/lib/ccache/bin/' '/home/pie/.local/bin')
export RBENV_SHELL=zsh
source '/usr/lib/rbenv/libexec/../completions/rbenv.zsh'
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

bindkey -e
setopt sharehistory autocd extendedglob append_history hist_ignore_dups hist_expire_dups_first hist_verify hist_ignore_space

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 
zstyle :compinstall filename '/home/pie/.zshrc'
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' menu select
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias ls='exa'
alias cp='cp --reflink=auto'
alias nano='micro'
alias cat=bat
alias tkg="bash $HOME/git/tkg/update.sh"
alias copy="xclip -selection c"
alias yay=paru

function mkcd(){
	mkdir -p -- "$1" &&
	cd -P -- "$1"
}

function paste() {
	socat - TCP:termsend.pl:1337
}

autoload edit-command-line
zle -N edit-command-line

bindkey '^X^e' edit-command-line
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

exit_zsh() { exit }
zle -N exit_zsh
bindkey '^D' exit_zsh

zshcache_time="$(date +%s%N)"


TRAPUSR1() {
  rehash
}

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

zle -N history-substring-search-up; zle -N history-substring-search-down

#source /opt/google-cloud-sdk/completion.zsh.inc
#source /opt/google-cloud-sdk/path.zsh.inc
source ~/git/fzf-tab/fzf-tab.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh_plug/yarn-autocompletions/yarn-autocompletions.plugin.zsh
#source /usr/share/doc/pkgfile/command-not-found.zsh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

dur=$(echo "$EPOCHREALTIME - $start" | bc)
echo "Execution time: $dur seconds"
