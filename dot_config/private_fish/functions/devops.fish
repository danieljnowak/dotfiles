# DevOps utility functions

# AWS profile switcher
function awsp
    if test -e ~/.aws/config
        set -l profiles (grep -E '^\[profile' ~/.aws/config | sed -E 's/\[profile (.*)\]/\1/')
        set -l selected_profile (printf "%s\n" $profiles | fzf --height 30% --border --prompt="Switch AWS profile: ")
        if test -n "$selected_profile"
            set -gx AWS_PROFILE $selected_profile
            echo "Switched to AWS profile: $selected_profile"
        end
    else
        echo "AWS config not found at ~/.aws/config"
    end
end

# Docker container shell
function dsh
    if test (count $argv) -eq 0
        set -l containers (docker ps --format "{{.Names}}")
        set -l selected_container (printf "%s\n" $containers | fzf --height 30% --border --prompt="Select container: ")
        if test -n "$selected_container"
            docker exec -it $selected_container sh
        end
    else
        docker exec -it $argv[1] sh
    end
end

# Docker container logs
function dlogs
    if test (count $argv) -eq 0
        set -l containers (docker ps --format "{{.Names}}")
        set -l selected_container (printf "%s\n" $containers | fzf --height 30% --border --prompt="Select container: ")
        if test -n "$selected_container"
            docker logs -f $selected_container
        end
    else
        docker logs -f $argv[1]
    end
end

# Clean up Docker resources
function dclean
    echo "Cleaning Docker resources..."
    
    echo "Removing stopped containers..."
    docker container prune -f
    
    echo "Removing dangling images..."
    docker image prune -f
    
    echo "Removing unused networks..."
    docker network prune -f
    
    echo "Removing unused volumes..."
    docker volume prune -f
    
    echo "Docker cleanup complete!"
end

# Run Terraform with appropriate options
function tf
    switch $argv[1]
        case 'init'
            terraform init -upgrade
        case 'plan'
            terraform plan -out=tfplan.out
        case 'apply'
            if test -e tfplan.out
                terraform apply tfplan.out
            else
                terraform apply
            end
        case 'destroy'
            terraform destroy
        case 'output'
            terraform output
        case 'fmt'
            terraform fmt -recursive
        case 'state'
            terraform state $argv[2..-1]
        case 'validate'
            terraform validate
        case 'graph'
            terraform graph | dot -Tsvg > terraform-graph.svg
        case '*'
            terraform $argv
    end
end

# SSH helper with favorite hosts
function sssh
    if test (count $argv) -eq 0
        if test -e ~/.ssh/config
            set -l hosts (grep -E '^Host ' ~/.ssh/config | awk '{print $2}' | grep -v "*")
            set -l selected_host (printf "%s\n" $hosts | fzf --height 30% --border --prompt="SSH to host: ")
            if test -n "$selected_host"
                ssh $selected_host
            end
        else
            echo "SSH config not found at ~/.ssh/config"
        end
    else
        ssh $argv
    end
end

# Load or create environment variables from a .env file
function loadenv
    set -l env_file ".env"
    
    if test (count $argv) -gt 0
        set env_file $argv[1]
    end
    
    if test -f $env_file
        echo "Loading environment variables from $env_file"
        for line in (cat $env_file | grep -v '^#' | grep -v '^\s*$')
            set -l var (echo $line | cut -d= -f1)
            set -l val (echo $line | cut -d= -f2-)
            set -gx $var $val
            echo "Set $var"
        end
    else
        echo "Environment file $env_file not found"
    end
end

# SSL certificate checker
function check-cert
    if test (count $argv) -eq 0
        echo "Usage: check-cert <domain:port>"
        return 1
    end
    
    echo | openssl s_client -servername $argv[1] -connect $argv[1] 2>/dev/null | openssl x509 -noout -dates -subject -issuer
end 