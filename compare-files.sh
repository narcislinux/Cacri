#!/bin/bash
#by Narges Ahmadi n.sedigheh.ahmadi@gmail.com
#version (compare-files-20171209.sh)

FileNameOrigin=$1
FileNameDestination=$2
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
            sed -i  '/$OkLine/d' $FileNameDestinationCopy
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
