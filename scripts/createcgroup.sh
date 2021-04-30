#!/bin/bash
cgroupUser=${USER}
if [ -z "$1" ]; then
    echo "The cgroup name is empty"
    return -1
fi

cgroupname=$1

if [ ! -z "$2" ]; then
    echo "The user is $2"
    cgroupUser=$2
fi

if [ -d /sys/fs/cgroup/cpu/$cgroupname ]; then
    echo "cgroup $cgroupname exits already"
else
    echo "Create cgroup $cgroupname"
    sudo mkdir /sys/fs/cgroup/cpu/$cgroupname
    sudo chown -R ${cgroupUser} /sys/fs/cgroup/cpu/$cgroupname
    sudo mkdir /sys/fs/cgroup/cpuset/$cgroupname    
    sudo chown -R ${cgroupUser} /sys/fs/cgroup/cpuset/$cgroupname
    echo 0 > /sys/fs/cgroup/cpuset/$cgroupname/cpuset.mems
fi
    


