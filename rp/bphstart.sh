#!/bin/bash
cat /root/tmp/system_wrapper.bit > /dev/xdevcfg

./settings m 000000111010
./settings p 190
./settings f 1e3
./settings t 1e-2
./settings a 0.01
./settings d 150 1
./settings s -0.9 0.9 1

#echo "Please run the slave script"
#read -rsp $'Press any key to continue...\n' -n1 key

./settings x

python bphsock.py
