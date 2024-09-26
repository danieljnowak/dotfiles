function ckd
set servername $argv[1]
knife node delete $servername -y
knife client delete $servername -y
end
