#!/bin/bash


export STARTDATE="";
export ENDDATE="";

# Getting Client ID
echo "What is the Client Code that you want to get the logs? For Example: fgprd-100840-12459"
read clientid

<<COMMENT
# not using this for the time being.
# Getting the type of environment
while true; do
  read -p  "What type of environment, Production[1] or Stage[2]?: " env
  case $env in
    prd | prod | production | 1 | PRD | Prd)
      echo "you selected Production"; break;
      ;;
    stg | stage | staging | 2 | STG | Stg)
      echo "you selected Staging"; break;
      ;;
    *)
      echo "That is not a valid response.";
      echo "Please valid responses are: prd, production, PRD, stg, stage, STG, Stg, 1, 2";
  esac
done
COMMENT

<<COMMENT
# not using this for the time being.
# We have disabled this function to select the type of logs, since we are going to always get Tomcat access Logs since
# Apache are not longer required and Tomcat have the PK1 of the user and the IP.
# Identify what log
while true; do
  read -p "What Log are you looking to get? Tomcat-AccessLog[1], Apache-AccessLog[2]: " log
  case $log in
    1) echo "You Selected Tomcat Access Logs"; break;
      ;;
    2) echo "You Selected Apache Access Logs"; break;
      ;;
    *) echo "You have typed a not valid response."
       echo "Please valid responses are: 1, 2"
  esac
done
COMMENT




# Start Date (2015-04-22)
while true; do
  read -p "Please enter the start date of the logs to grab: (format: 2015-04-22): " start_date
  if [[ $start_date == [0-3][0-9][0-1][0-9]-[0-9][0-9]-[0-9][0-9] ]]; then
    export STARTDATE=$start_date;
    break
  fi

done



# End Date (2015-04-22)
while true; do
  read -p "Please enter the end date of the logs to grab: (format: 2015-04-22): " end_date
  if [[ $end_date == [0-3][0-9][0-1][0-9]-[0-9][0-9]-[0-9][0-9] ]]; then
    export ENDDATE=$end_date;
    break;
  fi
done



validate () {


  echo " "
  errorMsg="Client needs to be April 2014 or October 2014 release. This does not work before that."
  string=`hostname`;
  echo '-------------------';
  echo "Reviewing $string ";

  if [[ $string == *"db"* ]]; then
    echo "  Err: Not an App Server. Exiting this server";
    exit 1;

  else
    configVersion=`grep bbconfig.version.number= /usr/local/blackboard/config/bb-config.properties`;
    version=${configVersion:24:60};
    case $version in
      9.1.201404.160205)
        echo "  App Server is April 2014 Release.";

        execution
        exit;
        echo '-------------------';
      ;;
      9.1.201410.160373)
        echo "  App Server is October 2014 Release.";
        execution
        exit;
        echo '-------------------';
      ;;
      *)
      echo $errorMsg;
      exit;
    esac
  fi

}

function execution {
  #load bash if not loaded
  if [ -n "$BASH_ENV" ]; then . "$BASH_ENV"; 
  fi

  #get array of date range
  #modifying the date to make date computations
  startdate=${STARTDATE:0:4}${STARTDATE:5:2}${STARTDATE:8:2};
  enddate=${ENDDATE:0:4}${ENDDATE:5:2}${ENDDATE:8:2};
  dates=();


  date=$startdate;
  while (( ${date} != ${enddate} )); do
    dates+=( "$date" );
    date="$(date --date="$date + 1 days" +'%Y%m%d')";
  done
  dates+=( "$enddate");
  


  if [ -d $LOGMINER ]; then
    echo "Directory already exists";
    cd /usr/local/blackboard/content/data-mining-logs/;
  else
    echo "Directory does not exist. Creating it.";
    mkdir -p /usr/local/blackboard/content/data-mining-logs;
    cd /usr/local/blackboard/content/data-mining-logs/;
  fi


  # identify if the server is FlexGen or AP
  vNAME=`hostname`;
  vID=${vNAME:0:2};

  if [[ $vID == "fg" ]]; then # its flexgen
    vAPPS=${vNAME: -6};
  else
    vAPPS=${vNAME: -5};
  fi


  # Logs locations to search and copy from
  OLDLOCATION=/usr/local/blackboard/asp/`hostname`/var/log/tomcat;
  NEWLOCATION1=/usr/local/blackboard/asp/`hostname`/tomcat;
  BBHOMELOGS="/usr/local/blackboard/logs/tomcat";

  # now lets search for the logs in the *not archived* location - regular logs
  for date in ${dates[@]}; do
    filename=$vNAME-bb-access-log.${date:0:4}-${date:4:2}-${date:6:2}.txt;
    cp $BBHOMELOGS/*bb-access-log.*${date:0:4}-${date:4:2}-${date:6:2}* /usr/local/blackboard/content/data-mining-logs/$filename;
  done

  # now lets search for archived logs
  for date in ${dates[@]}; do
    filename=$vNAME-bb-access-log.${date:0:4}-${date:4:2}-${date:6:2}.gz;
    cp $NEWLOCATION1/*bb-access-log.*${date:0:4}-${date:4:2}-${date:6:2}* /usr/local/blackboard/content/data-mining-logs/$filename;
  done

  # really old location if the client has it
  if [ -d $OLDLOCATION ]; then
    filename=$vNAME-bb-access-log.${date:0:4}-${date:4:2}-${date:6:2}.gz;
    cp $NEWLOCATION1/*bb-access-log.*${date:0:4}-${date:4:2}-${date:6:2}* /usr/local/blackboard/content/data-mining-logs/$filename;
  fi

  # List content
  ls -lsa;
}




getIpsAndConnect () {

  ips=`grep $clientid opsmart_server_list.txt | awk 'BEGIN {FS="\t"};  {a[$3]=$1} END { for (i in a) print a[i] | "sort" }'`

  for ip in $ips; do
    #ssh -o StrictHostKeyChecking=no $ip "$(typeset -f); validate"
    ssh -tt -o StrictHostKeyChecking=no $ip "export ENDDATE=$ENDDATE; export STARTDATE=$STARTDATE; mkdir -p /usr/local/blackboard/content/data-mining-logs; $(typeset -f); validate"



  done
}



getIpsAndConnect

#file with all the servers is here
#####   /mnt/asp/utils/bin/include
