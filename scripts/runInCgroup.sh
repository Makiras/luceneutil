#!/bin/bash
#source $(dirname $0)/td2Setting.sh
configFile=$(dirname $0)/td2VM1Setting.sh
if [ ! -z $1 ]; then
    configFile=$1
fi;
echo "Using config file $configFile"
source $configFile
#INDEX_DIR="${LUCENE_UTIL}/../indices/wikimedium10k.trunk.facets.taxonomy:Date.taxonomy:Month.taxonomy:DayOfYear.sortedset:Month.sortedset:DayOfYear.Lucene70.Lucene50.nd10M"
INDEX_DIR="${LUCENE_UTIL}/../indices/wikimedium10k.Lucene84.nd10M"

nohup java -server -Xms2g -Xmx2g -Djava.library.path=${TARGET_DIR}/perf -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${TARGET_DIR} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount $SEARCH_THREAD -taskRepeatCount 20 -field body -cpuAffinity -1  -nodelay -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk &
LuceneServerPID=$!
echo "The LuceneServer pid is $LuceneServerPID"
if [[ -z "$LuceneServerPID" ]]; then
    echo "Failed to create the Lucene search server."
    return -1
fi
sleep 3;
SOURCE="${BASH_SOURCE[0]}"
RDIR="$( dirname "$SOURCE" )"
cgroupName=lucene
if [ ! -z "$2" ]; then
    cgroupName=$2
fi   
echo "Create cgroup $cgroupName"
${RDIR}/createcgroup.sh $cgroupName xyang
echo "Add tasks to the cgroup"
${RDIR}/setcgroup.sh $cgroupName -1 0-15 $LuceneServerPID
