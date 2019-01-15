#!/bin/bash

/wait-for-it.sh kudu-master:7051 -t 120
/wait-for-it.sh kudu-master:8051 -t 120
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n----------------------------------------"
    echo -e "    Kudu Master not ready! Exiting..."
    echo -e "----------------------------------------"
    exit $rc
fi

/wait-for-it.sh kudu-tserver:7050 -t 120
/wait-for-it.sh kudu-tserver:8050 -t 120
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n----------------------------------------"
    echo -e "  Kudu Tablet Server not ready! Exiting..."
    echo -e "----------------------------------------"
    exit $rc
fi

#if [[ $IMPALA_STATE_STORE = "true" ]]; then
  supervisorctl start impala-state-store
  supervisorctl start impala-catalog

  /wait-for-it.sh localhost:25010 -t 120
  /wait-for-it.sh localhost:25020 -t 120
  rc=$?
  if [ $rc -ne 0 ]; then
    echo -e "\n----------------------------------------"
    echo -e "Impala State Store not ready! Exiting..."
    echo -e "----------------------------------------"
    exit $rc
  fi
#fi
  
supervisorctl start impala-server

/wait-for-it.sh localhost:21050 -t 120
rc=$?
if [ $rc -ne 0 ]; then
  echo -e "\n----------------------------------------"
  echo -e "  Impala Kudu Server not ready! Exiting..."
  echo -e "----------------------------------------"
  exit $rc
fi

echo -e "\n\n--------------------------------------------------------------------------------"
echo -e "You can now access to the following Impala UIs:\n"
echo -e "Impala Server        http://localhost:25000"
echo -e "Impala State Store   http://localhost:25010"
echo -e "Impala Catalog       http://localhost:25020"
echo -e "\nMantainer:   Matteo Capitanio <matteo.capitanio@gmail.com>"
echo -e "--------------------------------------------------------------------------------\n\n"
