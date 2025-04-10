if status is-interactive
    # No greeting
    set -U fish_greeting
    
    # Language settings
    set -x LANG en_US.UTF-8
    
    # Path enhancements
    fish_add_path $HOME/.local/bin
    fish_add_path $HOME/.cargo/bin
    
    # Integrations
    fzf --fish | source
    zoxide init --cmd cd fish | source
    starship init fish | source
    
    # Atuin shell history
    atuin init fish | source
    
    # Syntax highlighting colors
    set -g fish_color_autosuggestion '555'  
    set -g fish_color_cancel -r
    set -g fish_color_command blue
    set -g fish_color_comment red
    set -g fish_color_cwd green
    set -g fish_color_cwd_root red
    set -g fish_color_end green
    set -g fish_color_error brred
    set -g fish_color_escape bryellow
    set -g fish_color_history_current --bold
    set -g fish_color_host normal
    set -g fish_color_match --background=brblue
    set -g fish_color_normal normal
    set -g fish_color_operator bryellow
    set -g fish_color_param cyan
    set -g fish_color_quote yellow
    set -g fish_color_redirection magenta
    set -g fish_color_search_match 'bryellow' '--background=brblack'
    set -g fish_color_selection 'white' '--bold' '--background=brblack'
    set -g fish_color_status red
    set -g fish_color_user brgreen
    set -g fish_color_valid_path --underline
    
    # Auto-suggestion settings
    set -g fish_pager_color_completion normal
    set -g fish_pager_color_description 'yellow' '--dim'
    set -g fish_pager_color_prefix 'white' '--bold' '--underline'
    set -g fish_pager_color_progress 'brwhite' '--background=cyan'
    
    # Modern CLI replacements
    abbr --add ls eza --color=always --icons=always
    abbr --add ll eza --color=always --icons=always --long
    abbr --add la eza --color=always --icons=always --long --all
    abbr --add lt eza --color=always --icons=always --tree
    
    # Configure bat (no paging by default)
    set -x BAT_STYLE "numbers,changes"
    set -x BAT_THEME "TwoDark"
    
    # Remove BAT_PAGER to prevent paging
    set -e BAT_PAGER
    
    # Override bat as 'cat' without paging
    abbr --add cat "bat --paging=never"
    
    # Add batp for when you do want paging
    abbr --add batp "bat --paging=always"
    
    abbr --add find fd
    abbr --add grep rg
    
    # Git abbreviations
    abbr --add g git
    abbr --add gs git status
    abbr --add ga git add
    abbr --add gc git commit
    abbr --add gp git push
    abbr --add gl git pull
    abbr --add gd git diff
    abbr --add gb git branch
    abbr --add gco git checkout
    abbr --add glog git log --oneline --decorate --graph
    
    # New tool abbreviations
    abbr --add lg lazygit
    abbr --add zj zellij
    abbr --add zja zellij attach
    abbr --add zjl zellij list-sessions
    
    # Directory navigation
    abbr --add .. cd ..
    abbr --add ... cd ../..
    abbr --add .... cd ../../..
    
    # Dev environment shortcuts
    abbr --add v nvim
    abbr --add c code
    abbr --add cu cursor
    
    # Editor setting
    set -x EDITOR nvim
    
    # Default pager for man, git, etc
    set -x PAGER less
    
    # FZF default theme - use wider results area
    set -x FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --preview 'bat --color=always --paging=never {}'"
    
    # History settings
    set -g fish_history_max_length 10000
    
    # Custom functions
    function mkcd
        mkdir -p $argv && cd $argv
    end
    
    function backup
        cp -r $argv $argv.bak
    end
    
    # Create a more powerful cat function that combines cat and bat
    function catp --description "Cat with pager for longer files"
        if test (count $argv) -eq 0
            echo "Usage: catp <file>"
            return 1
        end
        
        # Get the number of lines in the file
        set -l line_count (wc -l < $argv[1])
        set -l terminal_height (tput lines)
        
        # If the file is longer than the terminal height, use paging
        if test $line_count -gt $terminal_height
            bat --paging=always $argv
        else
            bat --paging=never $argv
        end
    end
    
    function extract
        if test -f $argv
            switch $argv
                case "*.tar.bz2"
                    tar xjf $argv
                case "*.tar.gz"
                    tar xzf $argv
                case "*.bz2"
                    bunzip2 $argv
                case "*.rar"
                    unrar x $argv
                case "*.gz"
                    gunzip $argv
                case "*.tar"
                    tar xf $argv
                case "*.tbz2"
                    tar xjf $argv
                case "*.tgz"
                    tar xzf $argv
                case "*.zip"
                    unzip $argv
                case "*.Z"
                    uncompress $argv
                case "*.7z"
                    7z x $argv
                case '*'
                    echo "'$argv' cannot be extracted via extract function"
            end
        else
            echo "'$argv' is not a valid file"
        end
    end
    
    # Clean up old repos function - useful for cleaning workspace
    function clean-repos
        set repos_dir $argv[1]
        if test -z "$repos_dir"
            set repos_dir "."
        end
        
        for dir in $repos_dir/*/
            if test -d "$dir/.git"
                echo "Cleaning $dir"
                cd $dir
                git clean -xdf
                cd - > /dev/null
            end
        end
    end
    
    # Start Zellij automatically if not already in a session
    if not set -q ZELLIJ
        if not set -q TMUX
            # Only autostart in interactive terminals that are not VS Code's integrated terminal
            if not set -q VSCODE_INJECTION
                # Start or attach to zellij session
                zellij attach -c default
            end
        end
    end
end
