LUCENE_BUILD="/home/makiras/elfen/lucene/trunk/lucene/build"
TARGET_DIR="/home/makiras/elfen/lucene/util/build"
LUCENE_UTIL="/home/makiras/elfen/lucene/util"
SOURCE_DATA="/home/makiras/elfen/lucene/data/enwiki-20120502-lines-1k.txt"
INDEX_DIR="/home/makiras/elfen/lucene/indices/wikimedium10k.trunk.Lucene50.Memory.nd10M"
#INDEX_DIR="/home/yangxi/benchmark/lucene/indices/wikimedium10k.trunk.Lucene50.Memory.nd10M"
SERVER_IP="server:192.168.1.160:7777"
SEARCH_THREAD="7"
LOG_FILE="/home/makiras/elfen/lucene/logs/log"
JDK_PATH="/usr/lib/jvm/java-8-openjdk-amd64"

java -server -Xms2g -Xmx2g -XX:-TieredCompilation -XX:+HeapDumpOnOutOfMemoryError -Xbatch -classpath "${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${TARGET_DIR}" perf.Indexer -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -lineDocsFile ${SOURCE_DATA} -docCountLimit 1000000 -threadCount 1 -maxConcurrentMerges 1 -ramBufferMB -1 -maxBufferedDocs 18 -postingsFormat Lucene50 -waitForMerges -mergePolicy LogDocMergePolicy -idFieldPostingsFormat Memory -grouping
