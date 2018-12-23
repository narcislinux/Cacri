#!/bin/bash
#by Narges Ahmadi n.sedigheh.ahmadi@gmail.com
#version v1-20180405(zabbix-vs-cacti-v1-20180405.sh)

#USER='Your_Api_User'
echo -n "Enter your api user:"
read  USER
#PASS='Zabbix_Password'
read -p "Password:" -s PASS

#ZABBIX_SERVER='zabbix.server.com'
API='http://zabbix.server.com/zabbix/api_jsonrpc.php'

# Authenticate with Zabbix API
authenticate() {
 echo `curl -s -H  'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\",\"method\":\"user.login\",\"params\":{\"user\":\""${USER}"\",\"password\":\""${PASS}"\"},\"auth\": null,\"id\":0}" $API`
  }

AUTH_TOKEN=`echo $(authenticate)|jq -r .result`
echo $AUTH_TOKEN

        # Get This Host HostId:

      gethostiplist() {
            curl --data-binary "{\"jsonrpc\": \"2.0\",\"method\": \"hostinterface.get\",\"params\": {\"output\": [\"ip\"],\"selectParentTemplates\": [\"templateid\",\"name\"]},\"auth\":\""${AUTH_TOKEN}"\" ,\"id\": 1}" -H 'content-type:application/json-rpc;' $API  2> /dev/null | jq .result[].ip

      }

gethostiplist |grep '^"' |sed 's/"//g' > zabbixlist

ssh root@cacti.com php /var/www/html/cacti/cli/add_graphs.php  --list-hosts |awk '{print $2}' > cactilist

FileNameOrigin="./cactilist"
FileNameDestination="./zabbixlist"
FileNameDestinationCopy="./FileNameDestinationCopy"; cp $FileNameDestination ./FileNameDestinationCopy
Step=0
LineNumber=`wc -l "$FileNameOrigin"|cut -d" " -f1`

while [ $Step != "q" ]
do
    echo  "-----------  HELLO! this sript is for compare files!  -----------"
    echo  "1-what is difference between two files?"
    echo  "2-what is similarity of two files?"
    echo  "3-How much it is repeated?"
    echo  "q-quit."
    read -p " What do you want? [1/2/3/q] " Step

    if [ $Step = "1" ]
    then
        echo "Do you want Insert in file?"
        read -p "write file path:[type N if no]  "  SaveFileIn
        for ((i=1;i<=$LineNumber;i++))
        do
            OkLine=`sed -n "$i"p $FileNameOrigin`
            sed -i  "/$OkLine/d" $FileNameDestinationCopy
        done
  
        if [ $SaveFileIn != "N" ]
        then
            cat "$FileNameDestinationCopy" >> "$SaveFileIn"
        else
            cat "$FileNameDestinationCopy"
        fi

    elif [ $Step = "2" ]
    then
        echo "Do you want Insert in file?"
        read -p "write file path:[type N if no]  "  SaveFileIn
        for ((i=1;i<=$LineNumber;i++))
        do
            OkLine=`sed -n "$i"p $FileNameOrigin`
            if [ $SaveFileIn != "y" ]
            then
                grep "$OkLine" "$FileNameDestination" >> "$SaveFileIn"
            else
                grep "$OkLine" "$FileNameDestination"
            fi

        done
    elif [ $Step = "3" ]
    then
        echo "Do you want Insert in file?"
        read -p "write file path:[type N if no]  "  SaveFileIn
        for ((i=1;i<=$LineNumber;i++))
        do
            OkLine=`sed -n "$i"p "$FileNameOrigin"`
            Counter=`grep -c "$OkLine" "$FileNameDestination"`
            echo "$Counter  $OkLine"

            if [ $SaveFileIn != "N" ]
            then
                echo "$Counter  $OkLine" >> "$SaveFileIn"
            else
                echo "$Counter  $OkLine"
            fi

        done
    fi    

done
