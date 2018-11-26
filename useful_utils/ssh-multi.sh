#!/bin/bash
# a script to ssh multiple servers over multiple tmux panes
# -c is use ssh config file to provide user login info
starttmux() {
    if [ $config == "Y" ];then
        SSHCMD="$SSHCMD -l $user $port $key"
    fi
    Host="`sed -n '1p' $iplist`"
    if [[ "$Host" =~ ^.*bjzw.*.163.org.*$ ]];then
        SSHCMD="ssh -t tunnel0.bjzw.163.org ssh -o StrictHostKeyChecking=no -t $Host"
    elif [[ "$Host" =~ ^.*bjzjy.*.163.org.*$ ]];then
        SSHCMD="ssh -t tunnel0.bjzw.163.org ssh -o StrictHostKeyChecking=no -t $Host"
    elif [[ "$Host" =~ ^.*(zw|yz).*.server.163.org.*$ ]];then
        SSHCMD="ssh -t tunnel0.bjzw.163.org ssh -o StrictHostKeyChecking=no -t $Host"
    #elif [[ "$Host" =~ ^.*bjyz.*.163.org.*$ ]];then
    #    SSHCMD="ssh -t tunnel0.bjyz.163.org ssh -o StrictHostKeyChecking=no -t $Host"
    elif [[ "$Host" =~ ^urs-virt.*.dg.163.org.*$ ]];then
        SSHCMD="ssh -t tunnel1.dg.163.org ssh -o StrictHostKeyChecking=no -t $Host"
    elif [[ "$Host" =~ ^urs-virt.*.jd.163.org.*$ ]];then
        SSHCMD="ssh -t urs-tunnel1.jd.163.org ssh -o StrictHostKeyChecking=no -t $Host"
    elif [[ "$Host" =~ ^urs-.*.(dg|jd).163.org.*$ ]];then
        SSHCMD="ssh -t sa5.photo.163.org ssh -o StrictHostKeyChecking=no -t $Host"
    #elif [[ "$Host" =~ ^.*.bjth.163.org.*$ ]];then
    #    SSHCMD="ssh -t tunnel0.bjyz.163.org ssh -o StrictHostKeyChecking=no -t $Host"
    #elif [[ "$Host" =~ ^.*.th.163.org.*$ ]];then
    #    SSHCMD="ssh -t 119.253.88.8 ssh -o StrictHostKeyChecking=no -p 1046 -t $Host"
    else
        SSHCMD="ssh -o StrictHostKeyChecking=no -t $Host"
    fi
    if [ $config == "Y" ];then
        SSHCMD="$SSHCMD -l $user $port $key"
    fi
    tmux new-window "echo $SSHCMD;$SSHCMD;"
    while read Host
    do
        if [[ "$Host" =~ ^.*bjzw.*.163.org.*$ ]];then
            SSHCMD="ssh -t tunnel0.bjzw.163.org ssh -o StrictHostKeyChecking=no -t $Host"
        elif [[ "$Host" =~ ^.*bjzjy.*.163.org.*$ ]];then
            SSHCMD="ssh -t tunnel0.bjzw.163.org ssh -o StrictHostKeyChecking=no -t $Host"
        elif [[ "$Host" =~ ^.*(zw|yz).*.server.163.org.*$ ]];then
            SSHCMD="ssh -t tunnel0.bjzw.163.org ssh -o StrictHostKeyChecking=no -t $Host"
        #elif [[ "$Host" =~ ^.*bjyz.*.163.org.*$ ]];then
        #    SSHCMD="ssh -t tunnel0.bjyz.163.org ssh -o StrictHostKeyChecking=no -t $Host"
        elif [[ "$Host" =~ ^urs-virt.*.dg.163.org.*$ ]];then
            SSHCMD="ssh -t tunnel1.dg.163.org ssh -o StrictHostKeyChecking=no -t $Host"
        elif [[ "$Host" =~ ^urs-virt.*.jd.163.org.*$ ]];then
            SSHCMD="ssh -t urs-tunnel1.jd.163.org ssh -o StrictHostKeyChecking=no -t $Host"
        elif [[ "$Host" =~ ^urs-.*.(dg|jd).163.org.*$ ]];then
            SSHCMD="ssh -t sa5.photo.163.org ssh -o StrictHostKeyChecking=no -t $Host"
        #elif [[ "$Host" =~ ^.*.bjth.163.org.*$ ]];then
        #    SSHCMD="ssh -t tunnel0.bjyz.163.org ssh -o StrictHostKeyChecking=no -t $Host"
        #elif [[ "$Host" =~ ^.*.th.163.org.*$ ]];then
        #    SSHCMD="ssh -t 119.253.88.8 ssh -o StrictHostKeyChecking=no -p 1046 -t $Host"
        else
            SSHCMD="ssh -o StrictHostKeyChecking=no -t $Host"
        fi
        if [ $config == "Y" ];then
            SSHCMD="$SSHCMD -l $user $port $key"
        fi
        tmux split-window -v "echo $SSHCMD;$SSHCMD;" 2>/dev/null
        tmux select-layout tiled > /dev/null
    done < <(sed -n '2,$p' $iplist)
    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on > /dev/null
}

FLAG=0
user=`whoami`
port=''
config='N'

while getopts "hci:l:p:a:" Option
do
    case $Option in
	i) key="-i $OPTARG"             
		if [ $OPTARG == "NULL" ];then
			key=""
		fi
		;;
	p) port='-p '$OPTARG;;                  
	l) user=$OPTARG;;                 
	c) config="Y";;                 
	a) iplist=$OPTARG
	   FLAG=1
		;;               
	h)
	   echo -e "\033[01;31mUsage:$0 [-c] [-l user] [-p port] [-i identify_key|NULL] -a ip_list_file \033[0m"	
	   exit 2
		;;
    esac
done

sed -i '/^#/d' $iplist

if [ $FLAG -eq 1 ]
then
	HOSTS=`cat $iplist`
else
	echo -e "please use \033[01;31m -a ip_list_file \033[0m to ip or hostname list"
	exit 1
fi
starttmux
