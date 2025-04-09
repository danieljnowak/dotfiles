if status is-interactive
    set -U fish_greeting
    set -x LANG en_US.UTF-8
    fzf --fish | source
    zoxide init --cmd cd fish | source
    starship init fish | source
    abbr --add ls eza --color=always --icons=always
    abbr --add ll eza --color=always --icons=always --long
end
