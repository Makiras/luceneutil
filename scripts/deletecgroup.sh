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
    echo "Delete cgroup /sys/fs/cgroup/cpu/$cgroupname"
    rmdir  /sys/fs/cgroup/cpu/$cgroupname
    rmdir /sys/fs/cgroup/cpuset/$cgroupname
else
    echo "cgroup $cgroupname does not exist"
fi
    


