#!/bin/bash

set -e

abs_path=$1
java_home=$2

if [ "$java_home" == "" ]; then
  java_home=/usr/lib/jvm/java-21-openjdk-amd64
fi

cp -r "$abs_path"/trino/core/docker/compose/* "$abs_path"/trino/core/trino-server/target/trino-server-437-SNAPSHOT

cp "$abs_path"/trino/core/docker/bin/run-trino "$abs_path"/trino/core/trino-server/target/trino-server-437-SNAPSHOT/trino-hms-hdfs

cd "$abs_path"
if ! (ls | grep 'jvmkill'); then
  git clone git@github.com:airlift/jvmkill.git
else
  echo "'jvmkill' repo exists locally."
fi

if ! (ls jvmkill | grep 'libjvmkill.so'); then
  cd jvmkill
  make JAVA_HOME="$java_home"
else
  echo "'libjvmkill.so' exists."
fi

cp "$abs_path"/jvmkill/libjvmkill.so "$abs_path"/trino/core/trino-server/target/trino-server-437-SNAPSHOT/trino-hms-hdfs

cd "$abs_path"/trino/core/trino-server/target/trino-server-437-SNAPSHOT/trino-hms-hdfs
