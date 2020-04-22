#!/bin/bash
#This points to the built directory of Lucene"
LUCENE_UTIL=".."
LUCENE_BUILD="${LUCENE_UTIL}/../lucene-solr/lucene/build";
LUCENE_ROOT="${LUCENE_UTIL}/../lucene-solr";
TARGET_DIR="${LUCENE_UTIL}/build"
SOURCE_DATA="${LUCENE_UTIL}/../data/enwiki-20120502-lines-1k.txt"
INDEX_ROOT="${LUCENE_UTIL}/../indices"
INDEX_DIR="${LUCENE_UTIL}/../indices/wikimedium10k.trunk.facets.taxonomy:Date.taxonomy:Month.taxonomy:DayOfYear.sortedset:Month.sortedset:DayOfYear.Lucene70.Lucene50.nd0.01M"
SERVER_IP="server:0.0.0.0:7777"
SEARCH_THREAD="1"
LOG_FILE="../VM1.log"
JDK_PATH=$JAVA_HOME
#JDK_PATH=$JAVA_HOME
