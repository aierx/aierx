export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh
source ~/.bash_profile
export HOMEBREW_GITHUB_API_TOKEN=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
export HOMEBREW_NO_AUTO_UPDATE=true

___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh



pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
