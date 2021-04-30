#!/bin/bash
usage="setcgroup.sh groupname quota[-1 for unlimited, 100000 for 1 CPU time] cpuquota[-1 for unlimited] cpuset[0-15] mems[0]"
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
    echo "The cpuquota is emoty"
    exit -1
fi

cpuquota=$3

if [ -z "$4" ]; then
    echo "The cpuset is empty"
    exit -1
fi

cpuset=$4

if [ -z "$5" ]; then
    echo The memory is empty
    exit -1
fi

mems=$5

cfsquotaconfig=/sys/fs/cgroup/cpu/$cgroupname/cpu.cfs_quota_us
cpuquotaconfig=/sys/fs/cgroup/cpu/$cgroupname/cpu.cfs_cpu_quota
cpusetconfig=/sys/fs/cgroup/cpuset/$cgroupname/cpuset.cpus
cpusetMemoryConfig=/sys/fs/cgroup/cpuset/$cgroupname/cpuset.mems

echo $quota > $cfsquotaconfig;
echo Check CFS QUOTA $quota `cat $cfsquotaconfig`
echo $cpuquota > $cpuquotaconfig;
echo Check CPU QUOTA $cpuquota `cat $cpuquotaconfig`
echo $cpuset > $cpusetconfig;
echo Check CPUSET $cpuset `cat $cpusetconfig`
echo $mems > $cpusetMemoryConfig;
echo Check CPUSET MEMS $mems `cat $cpusetMemoryConfig`



