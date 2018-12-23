#!/bin/bash
#by Narges Ahmadi n.sedigheh.ahmadi@gmail.com
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

USESCALE="cactiupdown"
FilenameLocalGraaphIdFilter="./FilenameLocalGraaphIdFilter"
FilenameHosts="./host"
FilenameHostsID="./hostID"
FilenamePOSITION="./position"
LineNumber=`wc -l "$FilenameHosts"|cut -d" " -f1`

for ((i=1;i<=$LineNumber;i++))
do
echo "$i create!"
InternalName=`sed -n "$i"p $FilenameHosts` #Description
HostID=`sed -n "$i"p $FilenameHostsID`
LocalGraphId=`grep "$InternalName"  "$FilenameLocalGraaphIdFilter"|awk '{print $1}'`
POSITION=`sed -n "$i"p $FilenamePOSITION`

#LocalGraphId=`grep "$Description"  "$FilenameLocalGraaphIdFilter"|awk '{print $1}'`
#InternalName=`grep "$Description"  "$FilenameLocalGraaphIdFilter"|awk '{print $2,$3,$4,$5,$6,$7,$8,$9,$10}'`

echo "

NODE "$InternalName"
        LABEL "$InternalName"
        INFOURL /cacti/graph.php?rra_id=all&local_graph_id="$LocalGraphId"
        OVERLIBGRAPH /cacti/graph_image.php?rra_id=0&graph_nolegend=true&graph_height=100&graph_width=300&local_graph_id="$LocalGraphId"
        ICON images/grey-ball-32.png
    TARGET cactihost:"$HostID"
    USESCALE "$USESCALE" in percent
        POSITION "$POSITION"

" >>  regular-NODEs

done
echo "$i NODEs create!"
echo " FINISH..."
