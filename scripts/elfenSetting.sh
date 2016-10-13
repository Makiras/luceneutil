#!/bin/bash
#This points to the built directory of Lucene"
LUCENE_BUILD="/home/yangxi/code/elfen/lucene/trunk/lucene/build"
#This is the build target path of the searching benchmark"
TARGET_DIR="/home/yangxi/code/elfen/lucene/util/build"
LUCENE_UTIL="/home/yangxi/code/elfen/lucene/util"
#Raw wikipedia data
SOURCE_DATA="/home/yangxi/benchmark/lucene/data/enwiki-20120502-lines-1k.txt"
#Where is the index
INDEX_DIR="/home/yangxi/benchmark/lucene/indices/wikimedium10k.trunk.Lucene50.Memory.nd10M"
#Which IP address and port number does the searching server waits on
SERVER_IP="server:192.168.1.185:7777"
SEARCH_THREAD="1"
LOG_FILE="/home/yangxi/code/elfen/lucene/logs/log"
JDK_PATH="/usr/lib/jvm/java-8-openjdk-amd64"
