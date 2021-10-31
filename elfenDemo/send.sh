#!/bin/bash
python ../src/python/sendTasks.py ../tasks/wikimedium.1M.nostopwords.tasks 192.168.1.160 7777 100 1000000 200000 test_100_5 5
python ../src/python/parseTasks.py ./test_100_5
more qps-latency.csv
