#!/bin/bash



##########################################################
#       Change the hostname to mycentos.example.com      #
##########################################################

check_hostname() {
checkhost=$(hostname)

if [ ${checkhost} == "linuxgeeks.in" ]

then
        echo "Correct hostname is assigned"
        echo "15" >> /tmp/marks.txt
	break
else
        break
fi
}


davis_password() {

###################################################################################################
#  Create user davis with UID=3000 pasword=87654321 and it will expires in one month i.e 30 days  #
###################################################################################################

EXP=`date -d "30 days" +"%b-%d-%Y"`
ACC_EXP=`chage -l davis | grep ^Account | awk -F : '{print $2}' | sed 's/\ //' | sed 's/\,//g' |sed 's/\ /-/g'`

read USERNAME <<< "davis"
que1_1=$(cat /etc/passwd | grep  ^davis | awk -F : '{print $3}')
id -u $USERNAME > /dev/null
if [ $? -ne 0 ]
then
        echo "User $USERNAME is not valid"
        exit 1
else
       #echo "Enter the Password:"
        read PASSWD <<< "87654321"
        export PASSWD
        ORIGPASS=`grep -w "$USERNAME" /etc/shadow | cut -d: -f2`
        export ALGO=`echo $ORIGPASS | cut -d'$' -f2`
        export SALT=`echo $ORIGPASS | cut -d'$' -f3`
        GENPASS=$(perl -le 'print crypt("$ENV{PASSWD}","\$$ENV{ALGO}\$$ENV{SALT}\$")')
        if [ "$GENPASS" == "$ORIGPASS" ] && [ "$que1_1" -eq "3000" ]  && [ "${EXP}" == "${ACC_EXP}" ]
        then
                #echo "Valid Username-Password Combination"
                echo "25" >> /tmp/marks.txt
                break
        else
                #echo "Invalid Username-Password Combination"
                break
        fi
fi
}

john_password() {
#########################################################################
#          Create user john with UID=2000 and password=12345678         #
#########################################################################

read USERNAME <<< "john"
que1_1=$(cat /etc/passwd | grep  ^john | awk -F : '{print $3}')
id -u $USERNAME > /dev/null
if [ $? -ne 0 ]
then
        echo "User $USERNAME is not valid"
        break
else
       #echo "Enter the Password:"
        read PASSWD <<< "12345678"
        export PASSWD
        ORIGPASS=`grep -w "$USERNAME" /etc/shadow | cut -d: -f2`
        export ALGO=`echo $ORIGPASS | cut -d'$' -f2`
        export SALT=`echo $ORIGPASS | cut -d'$' -f3`
        GENPASS=$(perl -le 'print crypt("$ENV{PASSWD}","\$$ENV{ALGO}\$$ENV{SALT}\$")')
        if [ "$GENPASS" == "$ORIGPASS" -a "$que1_1" -eq 2000 ]
        then
               # echo "Valid Username-Password Combination"
                echo "25" >> /tmp/marks.txt
                break
        else
                #echo "Invalid Username-Password Combination"
                break        
	        fi
fi
}



question2() {
##################################################################################
#   Allow davis (and only davis) to get full access to john‘s home directory.    #
##################################################################################
SETPERM=$(getfacl -p /home/john/ | grep davis | awk -F : '{print $3}')

if [ ${SETPERM} == "rwx" ]
then
        echo "Permission is CORRECT"
        echo "25" >> /tmp/marks.txt
        break
else
        break
fi
}


question3() {

##########################################################################################     
# Create a directory named /common. Allow john and davis to share documents in the       #
#/common directory using a group called team. Both of them can read, write and remove    #
# documents from the other in this  directory but any user not member of the group can’t.#                                                
##########################################################################################


SETPERM=$(getfacl -p /common | grep team | awk -F : '{print $3}')

if [ ${SETPERM} == "rwx" ]
then
        echo "Permission is CORRECT"
        echo "25" >> /tmp/marks.txt
        break
else
        break
fi
}


question4() {

############################################################################################
#   Create a cron job running as root, starting at 11PM every day and writing              #
#   a report on daily system resource consumption in the /var/log/consumption.log file.    #
############################################################################################

# 00 23 * * * /usr/bin/sar  > /var/log/consumption.log


#Global parameters:
EVERYDAY=$(crontab -l | sed -n 's/00 23/00_23/p' | awk '{print $1}')
CMD_CHECK=$(crontab -l | sed -n '/00 23/p' | awk '{print $6}')
#Check if job runs everyday @11 or not.

if [ "${EVERYDAY}" = 00_23 ]
 then
        #echo "CORRECT"
        echo "10" >> /tmp/marks.txt
else
        break
fi

#Check for Command i.e updatedb or not

if [ "${CMD_CHECK}" = updatedb ]
 then
        #echo "CORRECT"
        echo "15" >> /tmp/marks.txt

else
        break

fi
}

question5() {

###################################################################################
#   Setup a /home/rhce directory to facilitate collaboration among the rhce group.#
#   Each member should be able to create files and modify each others’ files,     #
#   but should not be able to delete any one else’s files in this directory.      #
###################################################################################

FIRST_CHECK=$(getfacl -p /rhce/ | grep group  | head -1 | awk '{print $3}')
SECOND_CHECK=$(getfacl -p /rhce/ | grep group | tail -1 | awk -F "::" '{print $2}')

#First check for group exeist or not
if [ ${FIRST_CHECK} == "redhat" -a  ${SECOND_CHECK} == "rwx" ]

then
        #echo "Permission is CORRECT"
        echo "25" >> /tmp/marks.txt
        break


else
        break
fi
}
#############################################################################################
#    Set the default target to boot into X Window level (previously on multi-user.target).  #
#############################################################################################

question6() {

checkrunlevel=$(systemctl get-default)

if [ ${checkrunlevel} == "graphical.target" ]

then
        echo "25" >> /tmp/marks.txt
        break
else

        break
fi

}

bob_acc_expiry_check() {
EXP=`date -d "7 days" +"%b-%d-%Y"`
ACC_EXP=`chage -l bob | grep ^Account | awk -F : '{print $2}' | sed 's/\ //' | sed 's/\,//g' |sed 's/\ /-/g'`

        
if [ "${EXP}" == "${ACC_EXP}" ]  #checking both EXP date.
        then
                echo "15" >> /tmp/marks.txt
                break
        else
                break
        fi
}

check_hostname
davis_password
john_password
question2
question3
question4
question5
question6
bob_acc_expiry_check
