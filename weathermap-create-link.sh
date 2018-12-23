#!/bin/bash
#by Narges Ahmadi n.sedigheh.ahmadi@gmail.com
#version v1-20171218(weathermap-create-link-v1-20171218.sh)
#
#create FilenameLocalGraaphIdFilter file with these commands(or find better way):
## echo "select local_graph_id,title_cache    from graph_templates_graph;" |mysql cacti -uroot -p > graph-template-id
## grep  "\-\ Advanced Ping"  ./graph-template-id |grep "SW" >FilenameLocalGraaphIdFilter
#
#create FilenameHosts and FilenameHostsID files with these commands(or find better way):
## echo "select  id,description    from host;" |mysql cacti -uroot -p > host-description
## grep "SW" host-description|awk '{print $2}' >FilenameHosts
## grep "SW" host-description|awk '{print $1}' >FilenameHostsID
#
#defult POSITION
#POSITION = "12 12"

#USESCALE="cactiupdown"
FilenameLocalGraaphIdFilter="./graph-template-id-filter"
FilenameHosts="./HOSTs"
#FilenameHostsLinkNames="./LINKs"
#FilenameHostsLinkNodes="./NODEs"
FilenameRraPath=""
#FilenameHostsLinkBandwidths=
FilenameDataRrdOut="./data_template_data-outgoingtraffic"
FilenameDataRrdIn="data_template_data-incomingtraffic"
LineNumber=`wc -l "$FilenameHostsLinkNames"|cut -d" " -f1`
flag="y"

#for ((i=1;i<=$LineNumber;i++))
#do
while [ $flag != "n" ]
do

#LinkName=`sed -n "$i"p $FilenameHostsLinkNames`
#LinkNodes=`sed -n "$i"p $FilenameHostsLinkNodes`

read -p "What is your Host ID ? " HostID
Node1=`grep "$HostID" "$FilenameHosts" | awk '{print $1}'`
read -p "Connect to what :|?(Node2)  " Node2

grep "$Node1" "$FilenameLocalGraaphIdFilter"
read -p "What can help in searchemoticon_wink? " Search
sleep 1
read -p "What is your LocalGraphId ? " LocalGraphId
echo "..............................................................."
echo "..............................................................."
echo "..............................................................."
echo "..............................................................."

RrdI=`grep "$Node1" "$FilenameDataRrdIn" | grep "$Search" | sed "s/<path_rra>/\/var\/lib\/cacti\/rra/" |awk '{print $2}'`
#read -p "What is Input Traffic ? " RrdI
RrdO=`grep "$Node1" "$FilenameDataRrdOut" | grep "$Search" | sed "s/<path_rra>/\/var\/lib\/cacti\/rra/" |awk '{print $2}'`
#read -p "What is Input Traffic ? " RrdO

echo "RrdI: $RrdI"
echo "RrdO: $RrdO"
sleep 1
echo
read -p "And what about Bandwidth ? " Bandwidth
#LocalGraphId=`grep "$InternalName"  "$FilenameLocalGraaphIdFilter"|awk '{print $1}'`
#POSITION=`sed -n "$i"p $FilenamePOSITION`

echo "

LINK "$Node1"-"$Node2"
  NODES "$Node1"  "$Node2"
    USESCALE cactiupdown percent
    INFOURL /cacti/graph.php?rra_id=all&local_graph_id="$LocalGraphId"
    OVERLIBGRAPH /cacti/graph_image.php?local_graph_id="$LocalGraphId"&rra_id=0&graph_nolegend=true&graph_height=100&graph_width=300
    TARGET "$RrdI":traffic_out_hc:- "$Rrd0":-:traffic_in_hc
    INBWFORMAT In: {link:this:bandwidth_in:%k}
    OUTBWFORMAT Out: {link:this:bandwidth_out:%k}
    BANDWIDTH "$Bandwidth"

" >>  regular-LINKs

echo "$i create!"
read -p "Still continue ?[y|n] " flag
done

echo "$i LINKs create!"
echo " FINISH..."
