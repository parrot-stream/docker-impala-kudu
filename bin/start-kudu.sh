#!/bin/bash


if [[ $KUDU_MASTER = "true" ]]; then
  supervisorctl start kudu-master
fi

./wait-for-it.sh kudu:7051 -t 120
./wait-for-it.sh kudu:8051 -t 120
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n----------------------------------------"
    echo -e "    Kudu Master not ready! Exiting..."
    echo -e "----------------------------------------"
    exit $rc
fi

supervisorctl start kudu-tserver

./wait-for-it.sh localhost:7050 -t 120
./wait-for-it.sh localhost:8050 -t 120
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n----------------------------------------"
    echo -e "  Kudu Tablet Server not ready! Exiting..."
    echo -e "----------------------------------------"
    exit $rc
fi

echo -e "\n\n--------------------------------------------------------------------------------"
echo -e "You can now access to the following Kudu Web UIs:"
echo -e ""
echo -e "Apache Kudu Master:			http://localhost:8051"
echo -e "Apache Kudu Tablet Server:		http://localhost:8050"
echo -e "\nMantainer:   Matteo Capitanio <matteo.capitanio@gmail.com>"
echo -e "--------------------------------------------------------------------------------\n\n"
