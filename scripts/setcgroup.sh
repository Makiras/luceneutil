#!/bin/bash
usage="setcgroup.sh groupname quota[-1 for unlimited, 100000 for 1 CPU time] cpuset[0-15] pid"
if [ -z "$1" ]; then
    echo "The cgroup name is empty"
    exit -1
fi

cgroupname=$1

if [ -z "$2" ]; then
    echo "The quota is empty"
    exit -1
fi

quota=$2

if [ -z "$3" ]; then
    echo "The cpuset is empty"
    exit -1
fi

cpuset=$3

if [ -z "$4" ]; then
    echo "The pid is empty"
    exit -1
fi

pid=$4

echo "Set $cgroupname cfs_quota_us to $quota cpuset.cpus to $cpuset and add pid $pid to $cgroupname"

if [ ! -d /sys/fs/cgroup/cpu/$cgroupname ]; then
    echo "error: cgroup does not exist."
    return -1
fi

cpuquotaconfig=/sys/fs/cgroup/cpu/$cgroupname/cpu.cfs_quota_us
cpuquotatask=/sys/fs/cgroup/cpu/$cgroupname/tasks
cpusetconfig=/sys/fs/cgroup/cpuset/$cgroupname/cpuset.cpus
cpusetMemoryConfig=/sys/fs/cgroup/cpuset/$cgroupname/cpuset.mems
cpusettask=/sys/fs/cgroup/cpuset/$cgroupname/tasks
#start with cpu controller
echo $quota > $cpuquotaconfig
echo "Checking the quota: `cat $cpuquotaconfig`"
echo $cpuset > $cpusetconfig
echo "Checking the cpuset: `cat $cpusetconfig`"
echo 0 > ${cpusetMemoryConfig}
for t in `ls /proc/$pid/task/`; do
    echo "Add thread $t in $pid to the cgroup"
    echo $t > $cpuquotatask
    echo $t > $cpusettask
done
