# you can use <uname> with flags to identify the shell evironment
# and also you can use whoami


# Get the name 
export BASH_SILENCE_DEPRECATION_WARNING=1
source ~/.bashrc
function rt {
	# check if an argument has been passed
	if [ $# -eq 0 ]; then
		echo "using the default (sundev9)"
  		socat tcp-listen:28663,forever,reuseaddr,keepalive,fork tcp:10.122.102.209:28663 &
		socat tcp-listen:28588,forever,reuseaddr,keepalive,fork tcp:10.122.102.209:28588 &
		socat tcp-listen:10799,forever,reuseaddr,keepalive,fork tcp:10.122.102.209:10799 &
	else
		devMachine=$1
		echo "using the $devMachine ip `host $devMachine | rev | cut -d ' ' -f1 | rev`"
  		socat tcp-listen:28663,forever,reuseaddr,keepalive,fork tcp:$devMachine:28663 &
		socat tcp-listen:28588,forever,reuseaddr,keepalive,fork tcp:$devMachine:28588 &
		socat tcp-listen:10799,forever,reuseaddr,keepalive,fork tcp:$devMachine:10799 &
	fi

}

function reroute_bass() {
    local machine_name=$1
    local destination_ip=`host -4 $machine_name | rev | cut -d ' ' -f1 | rev`
    socat tcp-listen:28588,reuseaddr,fork tcp:$destination_ip:28588 &
    socat tcp-listen:28663,reuseaddr,fork tcp:$destination_ip:28663 &
}


function kill_value() {
	process=$1
    for i in $(ps aux | grep $process | grep -v grep | awk '{print $2}'); do
    echo "killing pid: $i"
    echo "ps commandline: $(ps aux | grep ${i} | grep -v grep)"
    kill -9 $i
    done
}


function kill_socat() {
    for i in $(ps aux | grep socat | grep -v grep | awk '{print $2}'); do
    echo "killing pid: $i"
    echo "ps commandline: $(ps aux | grep ${i} | grep -v grep)"
    kill -9 $i
    done
}


