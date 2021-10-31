#!/bin/bash

LUCENE_BUILD="/home/makiras/elfen/lucene/trunk/lucene/build"
TARGET_DIR="/home/makiras/elfen/lucene/util/build"
LUCENE_UTIL="/home/makiras/elfen/lucene/util"
#INDEX_DIR="/home/makiras/elfen/lucene/indices/wikimedium10k.trunk.Lucene50.Memory.nd10M"
INDEX_DIR="/home/makiras/elfen/lucene/indices/wikimedium10k.trunk.Lucene50.Memory.nd10M"
SERVER_IP="192.168.1.160:7777"
SEARCH_THREAD="7"
LOG_FILE="/home/makiras/elfen/lucene/logs/log"
JDK_PATH="/usr/lib/jvm/java-8-openjdk-amd64"

if [ ! -d "${TARGET_DIR}" ]; then
    mkdir ${TARGET_DIR};
fi

echo "Compiling Lucene"

javac -d ${TARGET_DIR} -classpath "${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${LUCENE_BUILD}" ${LUCENE_UTIL}/src/main/perf/Affinity.java ${LUCENE_UTIL}/src/main/perf/Args.java ${LUCENE_UTIL}/src/main/perf/IndexState.java ${LUCENE_UTIL}/src/main/perf/IndexThreads.java ${LUCENE_UTIL}/src/main/perf/NRTPerfTest.java ${LUCENE_UTIL}/src/main/perf/Indexer.java ${LUCENE_UTIL}/src/main/perf/KeepNoCommitsDeletionPolicy.java ${LUCENE_UTIL}/src/main/perf/LineFileDocs.java ${LUCENE_UTIL}/src/main/perf/LocalTaskSource.java ${LUCENE_UTIL}/src/main/perf/OpenDirectory.java ${LUCENE_UTIL}/src/main/perf/PKLookupTask.java ${LUCENE_UTIL}/src/main/perf/PerfUtils.java ${LUCENE_UTIL}/src/main/perf/RandomQuery.java ${LUCENE_UTIL}/src/main/perf/RemoteTaskSource.java ${LUCENE_UTIL}/src/main/perf/RespellTask.java ${LUCENE_UTIL}/src/main/perf/SearchPerfTest.java ${LUCENE_UTIL}/src/main/perf/SearchTask.java ${LUCENE_UTIL}/src/main/perf/StatisticsHelper.java ${LUCENE_UTIL}/src/main/perf/Task.java ${LUCENE_UTIL}/src/main/perf/TaskParser.java ${LUCENE_UTIL}/src/main/perf/TaskSource.java ${LUCENE_UTIL}/src/main/perf/TaskThreads.java

gcc -O2 -g  -D_GNU_SOURCE -fPIC -shared -std=c99 -fPIC ${LUCENE_UTIL}/src/main/perf/elfen_signal.c -o ${TARGET_DIR}/perf/libelfen_signal.so $@ -I"${JDK_PATH}"/include -I"${JDK_PATH}"/include/linux/ -pthread -lpfm


#sudo chrt -r 99 java -server -Xms2g -Xmx2g -XX:-TieredCompilation -XX:+HeapDumpOnOutOfMemoryError -Xbatch -Djava.library.path=${TARGET_DIR}/native -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${LUCENE_BUILD} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount ${SEARCH_THREAD} -taskRepeatCount 20 -field body -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk

#java -server -Xms2g -Xmx2g -XX:-TieredCompilation -XX:+HeapDumpOnOutOfMemoryError -Xbatch -Djava.library.path=${TARGET_DIR}/native -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${LUCENE_BUILD} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount 1 -taskRepeatCount 20 -field body -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk
