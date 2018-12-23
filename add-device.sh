#!/bin/bash
#by Narges Ahmadi n.sedigheh.ahmadi@gmail.com
#Required:
#    --description  the name that will be displayed by Cacti in the graphs
#    --ip           self explanatory (can also be a FQDN)
#Optional:
#    --template     0, is a number (read below to get a list of templates)
#    --notes        '', General information about this host.  Must be enclosed using double quotes.
#    --disable      0, 1 to add this host but to disable checks and 0 to enable it
#    --avail        pingsnmp, [ping][none, snmp, pingsnmp]
#    --ping_method  tcp, icmp|tcp|udp
#    --ping_port    '', 1-65534
#    --ping_retries 2, the number of time to attempt to communicate with a host
#    --version      1, 1|2|3, snmp version
#    --community    '', snmp community string for snmpv1 and snmpv2.  Leave blank for no community
#    --port         161
#    --timeout      500
#    --username     '', snmp username for snmpv3
#    --password     '', snmp password for snmpv3
#    --authproto    '', snmp authentication protocol for snmpv3
#    --privpass     '', snmp privacy passphrase for snmpv3
#    --privproto    '', snmp privacy protocol for snmpv3
#    --context      '', snmp context for snmpv3
#
#List Options:
#    --list-host-templates
#    --list-communities
#    --quiet - batch mode value return

#description=
#ip=
#template=
#notes=
#disable=
#avail=
#ping_method=icmp
#ping_port=
#ping_retries=
#version=
#community="noc-gat-pub"
#port="10050"
#timeout=
#username=
#password=
#authproto=
#privpass=
#privproto=
#context=
#quiet=

stay="y"
OldHost="172.20.8.16"
NewHost="172.20.8.223"

#filenameip="ip"
#filenamehost="host"
tmppath="/tmp/cacti-file"

if [ -d $tmppath ]
then
    echo "SCRIPT:---------------- $mppath found. ------------------"
else
    mkdir "$tmppath"
    echo "SCRIPT:---------------- $mppath Create. -----------------"
fi
sleep 2

while [ $stay="y"  ]
do
    #echo -n "SCRIPT:Old Host template list : "
    #ssh root@"$OldHost" php -q add_device.php   --list-host-templates
    #echo -n "SCRIPT:New Host template list : "
    #ssh root@"$NewHost" php -q add_device.php   --list-host-templates

    echo -n "SCRIPT:Enter  number of host template : "
    echo "SCRIPT:Old cacti :"
    read  OldTemplateNumber
    echo "SCRIPT:New cacti :"
    read  NewTemplateNumber

    #get host and ip lists
    ssh root@172.20.8.16 php /usr/share/cacti/cli/add_graphs.php --list-hosts |awk '{print $3,$2,$4,$5,$6}'   |sort |grep "^$OldTemplateNumber"|cut -d" "  -f3-10 > "$tmppath"/"host-name"-"$NewTemplateNumber"
    ssh root@172.20.8.16 php /usr/share/cacti/cli/add_graphs.php --list-hosts |awk '{print $3,$2,$4,$5,$6}'   |sort |grep "^$OldTemplateNumber"|cut -d" "  -f2 > "$tmppath"/"host-ip"-"$NewTemplateNumber"

    FilenameDescription=""$tmppath"/host-name-"$NewTemplateNumber""
    FilenameIp=""$tmppath"/host-ip-"$NewTemplateNumber""
    LineNumber=`wc -l "$FilenameDescription"|cut -d" " -f1`

            echo "SCRIPT: which type sould add snmp or ping?[s/p] "
            read  HosType
            if [ $HosType = "p" ]
            then

                template="$NewTemplateNumber"
                avail="ping"
                ping_method="icmp"
                version="0"
                for ((i=1;i<=$LineNumber;i++))
                do

                    echo "SCRIPT:Host number $i"
                    description=` sed -n "$i"p $FilenameDescription `
                    ip=` sed -n "$i"p $FilenameIp `

                #usage: add_device.php --description=[description] --ip=[IP] --template=[ID] [--notes="[]"] [--disable]
                #    [--avail=[ping]] --ping_method=[icmp] --ping_port=[N/A, 1-65534] --ping_retries=[2]
                #    [--version=[1|2|3]] [--community=] [--port=161] [--timeout=500]
                #    [--username= --password=] [--authproto=] [--privpass= --privproto=] [--context=]
                #    [--quiet]

                php /usr/share/cacti/cli/add_device.php --description="$description" --ip="$ip" --template="$template" --avail="$avail" --ping_method="$ping_method"
                echo "SCRIPT:Finish!"
                done
            elif [ $HosType = "s" ]
            then
                template="$NewTemplateNumber"
                version="2"

                echo -n "SCRIPT:noc-gat-pub(1)"
                echo -n "SCRIPT:samsung(2)"
                echo -n "SCRIPT:zabbix-test(3)"
                echo -n "SCRIPT:FDI-SNMP-RO(4)"
                echo -n "SCRIPT:which snmp community:[1/2/3/4] "
                read  CommuNumber
                if [ $CommuNumber = 1 ];then community="noc-gat-pub";fi
                if [ $CommuNumber = 2 ];then community="samsung";fi
                if [ $CommuNumber = 3 ];then community="zabbix-test";fi
                if [ $CommuNumber = 4 ];then community="FDI-SNMP-RO";fi
    
                port="161"
                for ((i=1;i<=$LineNumber;i++))
                do

                    echo "SCRIPT:Host number $i"
                    description=` sed -n "$i"p $FilenameDescription `
                    ip=` sed -n "$i"p $FilenameIp `

                #usage: add_device.php --description=[description] --ip=[IP] --template=[ID] [--notes="[]"] [--disable]
                #    [--avail=[ping]] --ping_method=[icmp] --ping_port=[N/A, 1-65534] --ping_retries=[2]
                #    [--version=[1|2|3]] [--community=] [--port=161] [--timeout=500]
                #    [--username= --password=] [--authproto=] [--privpass= --privproto=] [--context=]
                #    [--quiet]

                php /usr/share/cacti/cli/add_device.php --description="$description" --ip="$ip" --template="$template" --version="$version" --community="$community" --port="$port"

                echo "SCRIPT:Finish!"
                done
            fi

    echo "SCRIPT:should keep going?[y/n] "
    read  stay
done

#then add graph with for i in {1301..1459}; do php /usr/share/cacti/cli/add_graphs.php  --graph-type=cg --graph-template-id=47 --host-id="$i" ;done

#php add_tree.php --list-nodes --tree-id=1|grep Header | awk '{print $4}'

#php add_tree.php  --type=tree --name=FDI --sort-method=manual

#for name in  "headername1" "headername2" "..." ; do php add_tree.php  --type=node --node-type=header --tree-id=2 --name="$name"; done
#whiptail --title "Cacti customize" --msgbox "Choose Ok to exit" 10 60
