# DevOps-specific abbreviations and environment settings

# Kubernetes
abbr --add k kubectl
abbr --add kgp "kubectl get pods"
abbr --add kgs "kubectl get svc"
abbr --add kgn "kubectl get nodes"
abbr --add kgd "kubectl get deployments"
abbr --add kctx kubectx
abbr --add kns kubens
abbr --add ktop "kubectl top pods"
abbr --add kwatch "watch kubectl get pods"

# Docker
abbr --add d docker
abbr --add dc docker-compose
abbr --add dcup "docker-compose up -d"
abbr --add dcdown "docker-compose down"
abbr --add dcl "docker-compose logs -f"

# Terraform
abbr --add tfi "tf init"
abbr --add tfp "tf plan"
abbr --add tfa "tf apply"
abbr --add tfd "tf destroy"
abbr --add tfv "tf validate"
abbr --add tfo "tf output"

# AWS
abbr --add awsls "aws s3 ls"
abbr --add awscp "aws s3 cp"
abbr --add awswho "aws sts get-caller-identity"
abbr --add awsec2 "aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress,Tags[?Key==`Name`].Value]' --output table"

# Git DevOps
abbr --add gpr "git pull --rebase"
abbr --add gwip "git add -A && git commit -m 'WIP: Work in progress [skip ci]'"
abbr --add gcln "git clean -fd"

# SSH
abbr --add sshl "cat ~/.ssh/config | grep '^Host ' | cut -d ' ' -f 2"

# Ansible
abbr --add ap "ansible-playbook"
abbr --add agi "ansible-galaxy install"

# Monitoring 
abbr --add htopp "htop --sort-key=PERCENT_CPU"
abbr --add dfs "df -h | sort -k 5 -r"
abbr --add nsl "netstat -tulanp" 