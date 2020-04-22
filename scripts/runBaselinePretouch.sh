#!/bin/bash
#source $(dirname $0)/td2Setting.sh
source $(dirname $0)/td2VM1Setting.sh
INDEX_DIR="${LUCENE_UTIL}/../indices/wikimedium10k.trunk.facets.taxonomy:Date.taxonomy:Month.taxonomy:DayOfYear.sortedset:Month.sortedset:DayOfYear.Lucene70.Lucene50.nd0.1M"

# current val of /proc/sys/kernel/sched_domain/cpu0/domain0/flags
# SD flag: 4783
# +   1: SD_LOAD_BALANCE:          Do load balancing on this domain
# +   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
# +   4: SD_BALANCE_EXEC:          Balance on exec
# +   8: SD_BALANCE_FORK:          Balance on fork, clone
# -  16: SD_BALANCE_WAKE:             Balance on wakeup
# +  32: SD_WAKE_AFFINE:           Wake task to waking CPU
# -  64:
# + 128: SD_SHARE_CPUCAPACITY:    Domain members share cpu power
# - 256: SD_SHARE_POWERDOMAIN:   Domain members share power domain
# + 512: SD_SHARE_PKG_RESOURCES: Domain members share cpu pkg resources
# -1024: SD_SERIALIZE: Only a single load balancing instance
# -2048: SD_ASYM_PACKING: Place busy groups earlier in the domain
# +4096: SD_PREFER_SIBLING: Prefer to place tasks in a sibling domain
# -8192: SD_OVERLAP: sched_domains of this level overlap
# -16384: SD_NUM: cross-node balancing
# current val of /proc/sys/kernel/sched_domain/cpu0/domain1/flags
# SD flag: 4655
# +   1: SD_LOAD_BALANCE:          Do load balancing on this domain
# +   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
# +   4: SD_BALANCE_EXEC:          Balance on exec
# +   8: SD_BALANCE_FORK:          Balance on fork, clone
# -  16: SD_BALANCE_WAKE:             Balance on wakeup
# +  32: SD_WAKE_AFFINE:           Wake task to waking CPU
# -  64:
# - 128: SD_SHARE_CPUCAPACITY:    Domain members share cpu power
# - 256: SD_SHARE_POWERDOMAIN:   Domain members share power domain
# + 512: SD_SHARE_PKG_RESOURCES: Domain members share cpu pkg resources
# -1024: SD_SERIALIZE: Only a single load balancing instance
# -2048: SD_ASYM_PACKING: Place busy groups earlier in the domain
# +4096: SD_PREFER_SIBLING: Prefer to place tasks in a sibling domain
# -8192: SD_OVERLAP: sched_domains of this level overlap
# -16384: SD_NUM: cross-node balancing

#/home/xyang/print_domain.sh 4783 559

#-XX:TieredStopAtLevel=1
#${JAVA_HOME}/bin/java -server -Xms500m -Xmx500m -XX:TieredStopAtLevel=1 -Djava.library.path=${TARGET_DIR}/perf -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENNE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${TARGET_DIR} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount 6 -taskRepeatCount 20 -field body -cpuAffinity 0 -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk
#/home/yangxi/code/jdk9/build/linux-x86_64-normal-server-release/jdk/bin/java -server -Xms2g -Xmx2g -XX:TieredStopAtLevel=1 -Djava.library.path=${TARGET_DIR}/perf -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${TARGET_DIR} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount 1 -taskRepeatCount 20 -field body -cpuAffinity 0 -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk
taskset 0xff /home/yangxi/code/jdk9/build/linux-x86_64-normal-server-release/jdk/bin/java -server -Xms2g -Xmx2g -XX:+AlwaysPreTouch -XX:ParallelGCThreads=8 -XX:+PrintGC  -XX:TieredStopAtLevel=1 -Djava.library.path=${TARGET_DIR}/perf -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${TARGET_DIR} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount 7 -taskRepeatCount 20 -field body -cpuAffinity 0  -nodelay -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk

#${JAVA_HOME}/bin/java -server -Xms2g -Xmx2g -XX:-TieredCompilation -XX:+HeapDumpOnOutOfMemoryError -Xbatch -Djava.library.path=${TARGET_DIR}/perf -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${TARGET_DIR} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount 7 -taskRepeatCount 20 -field body -cpuAffinity 0 -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk
