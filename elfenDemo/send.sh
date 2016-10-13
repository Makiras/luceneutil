#!/bin/bash
python ../src/python/sendTasks.py ../tasks/wiki.1M.nostopwords.term.tasks 192.168.1.185 7777 100 1000000 200000 test_100_5 5
python ../src/python/parseTasks.py ./test_100_5
more qps-latency.csv
