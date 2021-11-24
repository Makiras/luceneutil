#!/bin/bash

LUCENE_BUILD="/home/makiras/elfen/lucene/trunk/lucene/build"
TARGET_DIR="/home/makiras/elfen/lucene/util/build"
LUCENE_UTIL="/home/makiras/elfen/lucene/util"
#INDEX_DIR="/home/makiras/elfen/lucene/indices/wikimedium10k.trunk.Lucene50.Memory.nd10M"
INDEX_DIR="/home/makiras/elfen/lucene/indices/wikimedium10k.trunk.Lucene50.Memory.nd10M"
SERVER_IP="server:10.16.0.184:7777"
SEARCH_THREAD="7"
LOG_FILE="/home/makiras/elfen/lucene/logs/log"
JDK_PATH="/usr/lib/jvm/java-8-openjdk-amd64"

java -server -Xms2g -Xmx2g -XX:-TieredCompilation -XX:+HeapDumpOnOutOfMemoryError -Xbatch -Djava.library.path=${TARGET_DIR}/perf -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${TARGET_DIR} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount 1 -taskRepeatCount 20 -field body -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk
