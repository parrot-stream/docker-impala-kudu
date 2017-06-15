#!/bin/bash

sudo -u hdfs hdfs dfs -ls /user/impala 2> /dev/null
if [[ "$?" != "0" ]]; then
	echo "Creating directories in HDFS for Impala"
        sudo -u hdfs hdfs dfs -mkdir -p /user
        sudo -u hdfs hdfs dfs -mkdir -p /user/impala
	sudo -u hdfs hdfs dfs -chmod 755  /user	
	sudo -u hdfs hdfs dfs -chown impala:impala /user/impala
fi

if [[ $IMPALA_STATE_STORE = "true" ]]; then
  supervisorctl start impala-state-store
  supervisorctl start impala-catalog

  ./wait-for-it.sh localhost:25010 -t 120
  ./wait-for-it.sh localhost:25020 -t 120
  rc=$?
  if [ $rc -ne 0 ]; then
    echo -e "\n----------------------------------------"
    echo -e "Impala State Store not ready! Exiting..."
    echo -e "----------------------------------------"
    exit $rc
  fi
fi
  
supervisorctl start impala-server

./wait-for-it.sh localhost:21050 -t 120
rc=$?
if [ $rc -ne 0 ]; then
  echo -e "\n----------------------------------------"
  echo -e "  Impala Server not ready! Exiting..."
  echo -e "----------------------------------------"
  exit $rc
fi

echo -e "\n\n--------------------------------------------------------------------------------"
echo -e "You can now access to the following Impala UIs:\n"
echo -e "Impala Server 1 		http://localhost:25001"
echo -e "Impala Server 2 		http://localhost:25002"
echo -e "Impala Server 3 		http://localhost:25003"
echo -e "Impala State Store 		http://localhost:25010"
echo -e "Impala Catalog 		http://localhost:25020"
echo -e "\nMantainer:   Matteo Capitanio <matteo.capitanio@gmail.com>"
echo -e "--------------------------------------------------------------------------------\n\n"
