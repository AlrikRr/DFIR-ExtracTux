#!/bin/bash

####### Global Variable

# Colors 
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default Folder name for saving data
SAVED=$(date +'%Y%d%d%H%M%S')"_DFIR"
ZIPSAVED=$(date +'%Y%d%d%H%M%S')"_DFIR.zip"
FOLDER1="1-Audit_Risks"
FOLDER2="2-Users_Groups"
FOLDER3="3-System_Conf"
FOLDER4="4-Users_Activities"
FOLDER5="5-Log_Analysis"
FOLDER6="6-Persistence"

# Folder name inside working path where are stored all the custom script such as LSE, linpeas or LES ...
MODULES="modules"

###### HELP FUNCTION
help()
{
   # Display Help
   echo "DFIR-ExtracTux - Extract Data from Live or Dead LINUX system."
   echo "--> Need root privilege "
   echo
   echo "Syntax: dfir-extractux.sh [ -h | -l | -d ]"
   echo "options:"
   echo "-h 	Print this help."
   echo "-l 	LIVE - Use this option of you are working directly on the system"
   echo "-d	    DEAD - Use this option of you are working on a mounted disk"
   echo 
}




# Workpath select funtion
workpathfunc()
{
	# Set $workpathvar variable which store the full PATH were all the data will be stored
	# For DFIR purpose, it can be a USB device, remote folder or the home of the current user.
	whl=1
	while [ $whl -eq 1 ]
	do
		# Ask User Working PATH
		echo "[?] Please Enter full Working PATH : "
		echo  ""
		echo -e "${ORANGE}[!] It can be a USB key or the same folder where DFIR-Extractux is stored${NC}"
		echo -e "${ORANGE}[!] Example : /media/USB${NC}"
		echo  ""
		read -p "$(echo -e $CYAN"[select-workpath] #> "$NC)" workpathvar

		if [ -d $workpathvar ]
		then
			whl=0
			echo -e "${GREEN}[+] Work PATH "$workpathvar" setup ! ${NC}"
			
			if [ -d ./$MODULES ]
			then
				echo -e "${GREEN}[+] Module folder named "$MODULES" found in WorkPath !${NC}"
			else
				echo -e "${ORANGE}[!] Module folder named "$MODULES" not found in WorkPath !${NC}"
			fi
		else
			echo -e "${RED}[-] ERR : "$workpathvar " does not exist.${NC}"
		fi
		
		
	done
}

########### OS SYSTEM ##########
os()
{
	# Function used to select the OS in use (LIVE)
	# Missing OS ? Add case switch and use this number to edit all the other case switch on the collect functions.
	oswhl=1
	while [ $oswhl -eq 1 ]
	do
		echo "#########################"
		echo "Please Select the OS :"
		echo
		echo " 1) Debian - Ubuntu"
		echo " 2) RedHat"
		echo " 3) Exit"
		echo
		read -p ead -p "$(echo -e $CYAN"[os-selection] #> "$NC)" osselected
		
		case $osselected in
			1) # Debian Ubuntu Selected
				echo -e "${ORANGE}[!] OS Selected - Debian / Ubuntu${NC}"
				oswhl=0
				;;
			2) # RedHat 
				echo -e "${ORANGE}[!] OS Selected - RedHat ${NC}"
				oswhl=0
				;;
			3) # FreeBSD
				echo -e "${ORANGE}[!] OS Selected - FreeBSD ${NC}"
				oswhl=0
				;;
			?) # Unknown
				echo -e "${RED}[-] Unknown option${NC}"
				;;
		esac
	done
				
}



######### collect #########
setup-work()
{
	# Create all the folders used to store data collection
	echo -e "${GREEN}[+] Working on" $workpathvar/$SAVED $NC
	mkdir -p $workpathvar/$SAVED/$FOLDER1/
	mkdir -p $workpathvar/$SAVED/$FOLDER2/
	mkdir -p $workpathvar/$SAVED/$FOLDER3/
	mkdir -p $workpathvar/$SAVED/$FOLDER4/
	mkdir -p $workpathvar/$SAVED/$FOLDER5/
	mkdir -p $workpathvar/$SAVED/$FOLDER6/
	
	#--------- Check modules folder and installed scripts
	
}

##### Audit & Risks
collect-1()
{	##### Audit & Risks
	### Collect plain text password /!\ Lot of false positive
	### Collect All authorized_keys files
	### Collect All id_rsa private keys & timestamp of key generation
	### Collect All id_ed25519 private keys & timestamp of key generation
	
	#### FOLDER1 in use
	#### No need for OS check
	
	#### Global Variables available
	# 	- $workpathvar 	--> PATh of working dir where to save results
	#	- $SAVED 	--> Name of the Parent Folder where to save results
	#	- $FOLDERx	--> Name of subfolder where to save reslt of collect-x() function
	#	- $osselected	--> OS selected 

	echo -e "${PURPLE}[*] Starting Audit & Risks Collection${NC}"
	
	# Collect Plain Text Password with GREP on word PASSWORD
	echo -e "${ORANGE}[!] Collecting plain text passwords ${NC}"
	grep --color=auto -rnw '/home' -ie "PASSWORD" --color=always 2> /dev/null > $workpathvar/$SAVED/$FOLDER1/passwords.txt
	echo -e "${GREEN}[+] Plain Text Passwords${NC}"
	
	# Collect Authorized_keys keys
	find / -name authorized_keys -exec cat {} + 2> /dev/null > $workpathvar/$SAVED/$FOLDER1/authorized_keys.txt&
	find / -name known_hosts -exec cat {} + 2> /dev/null > $workpathvar/$SAVED/$FOLDER1/known_hosts.txt&
	echo -e "${GREEN}[+] Authorized Keys${NC}"

	# Collecting id_rsa & timestamp
	find / -name id_rsa -exec cat {} + 2> /dev/null > $workpathvar/$SAVED/$FOLDER1/id_rsa.txt&
	find / -name id_rsa -exec ls -la --time-style=full-iso {} + 2> /dev/null > $workpathvar/$SAVED/$FOLDER1/id_rsa_timestamp.txt&
	echo -e "${GREEN}[+] RSA keys${NC}"

	# Collecting id_ed25519 & timstamp
	find / -name id_ed25519 -exec cat {} + 2> /dev/null > $workpathvar/$SAVED/$FOLDER1/id_ed25519.txt&
	find / -name id_ed25519 -exec ls -la --time-style=full-iso {} + 2> /dev/null > $workpathvar/$SAVED/$FOLDER1/id_ed25519_timestamp.txt&
	echo -e "${GREEN}[+] ed25519 Keys${NC}"

}

##### Users & Groups
collect-2()
{	##### Users & Groups
	## Collect /etc/passwd
	## Collect /etc/shadow
	## Collect SetUID all users
	## Collect UID0 users
	## Collect Temporary Users
	## Collect /etc/group
	## Collect /etc/sudoers
	
	#### FOLDER2 in use
	#### No need for OS check
	
	#### Global Variables available
	# 	- $workpathvar 	--> PATh of working dir where to save results
	#	- $SAVED 	--> Name of the Parent Folder where to save results
	#	- $FOLDERx	--> Name of subfolder where to save reslt of collect-x() function
	#	- $osselected	--> OS selected 
	
	echo -e "${PURPLE}[*] Starting Users & Groups Collection${NC}"
	
	# Collect /etc/passwd
	{ #try 
		cat /etc/passwd > $workpathvar/$SAVED/$FOLDER2/passwd.txt &&
		echo -e "${GREEN}[+] passwd${NC}"
	} || { #catch
		echo -e "${RED}[-] passwd${NC}" 
	}
	
	# Collect /etc/shadow
	{ #try 
		cat /etc/passwd > $workpathvar/$SAVED/$FOLDER2/shadow.txt &&
		echo -e "${GREEN}[+] shadow${NC}"
	} || { #catch
		echo -e "${RED}[-] shadow${NC}" 
	}
	
	# Collect setUID
	{ #try 
		passwd -S -a > $workpathvar/$SAVED/$FOLDER2/setUID.txt &&
		echo -e "${GREEN}[+] setUID${NC}"
	} || { #catch
		echo -e "${RED}[-] setUID${NC}" 
	}	
	
	# Collect UID0 users
	{ #try 
		grep :0: /etc/passwd > $workpathvar/$SAVED/$FOLDER2/UID_0.txt &&
		echo -e "${GREEN}[+] UID 0${NC}"
	} || { #catch
		echo -e "${RED}[-] UID 0${NC}" 
	}
	
	# Collect Temporary Users
	echo -e "${ORANGE}[!] Collecting Temporary users ${NC}"
	find / -nouser -print 2> /dev/null > $workpathvar/$SAVED/$FOLDER2/temp_users.txt
	echo -e "${GREEN}[+] Temporary Users${NC}"	
	
	# Collect group list
	{ #try 
		cat /etc/group > $workpathvar/$SAVED/$FOLDER2/groups.txt &&
		echo -e "${GREEN}[+] /etc/group${NC}"
	} || { #catch
		echo -e "${RED}[-] /etc/group${NC}" 
	}
	
	# Collect sudoers
	{ #try 
		cat /etc/sudoers > $workpathvar/$SAVED/$FOLDER2/sudoers.txt &&
		echo -e "${GREEN}[+] /etc/sudoers${NC}"
	} || { #catch
		echo -e "${RED}[-] /etc/sudoers${NC}" 
	}
	
}

######### System Configuration ###########
collect-3()
{	##### System Configuration
	## Collect /etc/resolv.conf
	## Collect /etc/hosts
	## Collect /etc/hostname
	## Collect network interfaces
	## Collect dnsmasq.conf
	## Collect /etc/issue
	## Collect os release
	## Collect mounted disks fstab and USB devices
	
	#### FOLDER3 in use
	#### Need OS check
	
	#### Global Variables available
	# 	- $workpathvar 	--> PATh of working dir where to save results
	#	- $SAVED 	--> Name of the Parent Folder where to save results
	#	- $FOLDERx	--> Name of subfolder where to save reslt of collect-x() function
	#	- $osselected	--> OS selected 
	
	echo -e "${PURPLE}[*] Starting System Configuration Collection${NC}"
	
	#----- Network Configuration
	cat /etc/resolv.conf 2> /dev/null > $workpathvar/$SAVED/$FOLDER3/resolv.conf.txt&
	cat /etc/hosts 2> /dev/null > $workpathvar/$SAVED/$FOLDER3/hosts.txt&
	cat /etc/hostname 2> /dev/null > $workpathvar/$SAVED/$FOLDER3/hostname.txt&
	case $osselected in
		1) # Debian - Ubuntu
			cat /etc/network/interfaces 2> /dev/null > $workpathvar/$SAVED/$FOLDER3/interfaces.txt&
			cat /etc/dnsmasq.conf 2> /dev/null > $workpathvar/$SAVED/$FOLDER3/dnsmasq.conf.txt&
			
			;;
		2) # RedHat
			cat /etc/sysroot/network-scripts/ifcfg-* 2> /dev/null > $workpathvar/$SAVED/$FOLDER3/interfaces.txt&
			;;
	esac
	echo -e "${GREEN}[+] Network Configuration${NC}"
		
	# ----- OS Information
	cat /etc/issue 2> /dev/null > $workpathvar/$SAVED/$FOLDER3/issue.txt&
	case $osselected in
		1) # Debian - Ubuntu
			cat /etc/os-release 2> /dev/null > $workpathvar/$SAVED/$FOLDER3/os-release.txt&
			;;
		2) # RedHat
			cat /etc/redhat-release > $workpathvar/$SAVED/$FOLDER3/os-release.txt&
			;;
	esac
	echo -e "${GREEN}[+] OS Information${NC}"
	
	# ----- Time Zone
	case $osselected in
		1) # Debian - Ubuntu
			cat /etc/timezone 2> /dev/null > $workpathvar/$SAVED/$FOLDER3/timezone.txt&
			;;
		2) # Redhat
			##//////////////// ??????
			;;
	esac
	echo -e "${GREEN}[+] Time Zone${NC}"
	
	# ----- Disks & Mounted Devices
	mount > $workpathvar/$SAVED/$FOLDER3/mount.txt&
	findmnt 2> /dev/null > $workpathvar/$SAVED/$FOLDER3/findmnt.txt&
	findmnt -t cifs,nfs4 2> /dev/null > $workpathvar/$SAVED/$FOLDER3/findmnt_cifs-nfs.txt&
	lsblk > $workpathvar/$SAVED/$FOLDER3/lsblk.txt&
	blkid > $workpathvar/$SAVED/$FOLDER3/blkid.txt&
	cat /etc/fstab 2> /dev/null > $workpathvar/$SAVED/$FOLDER3/fstab.txt&
	echo -e "${GREEN}[+] Disk & Mount${NC}"
	
}

##### User Activities
collect-4()
{
	##### Users Activities
	## Collect recently modified/accessed/changed files
	## Collect bash_history of all users
	## Collect bashrc of all users
	
	#### FOLDER4 in use
	#### No Need for OS check
	
	#### Global Variables available
	# 	- $workpathvar 	--> PATh of working dir where to save results
	#	- $SAVED 	--> Name of the Parent Folder where to save results
	#	- $FOLDERx	--> Name of subfolder where to save reslt of collect-x() function
	#	- $osselected	--> OS selected 
	echo -e "${PURPLE}[*] Starting User Activities Collection${NC}"
	
	# Collect all /home/* folder
	users_home=($(ls -d /home/* ))
	len=${#users_home[@]}
	
	# for each /home/user
	for (( i=0; i<$len; i++ ))
	do 	
		# Grab username 
		username=$( echo ${users_home[$i]} | cut -d"/" -f3 )
		# ------ Files recntly edited	
		echo -e "${ORANGE}[!] Collecting Files Access/Modified/Changed for ${username} ${NC}"
		find . -type f -atime -7 -printf "%AY/%Am/%Ad %AH:%AM:%AS %h/%s/%f\n" -user $username |sort -n > $workpathvar/$SAVED/$FOLDER4/${username}_recently_accesses_files.txt
		echo -e "${GREEN}[+] Recently Accesses Files from ${username} ${NC}"
		find . -type f -mtime -7 -printf "%TY/%Tm/%Td %TH:%TM:%TS %h — %s — %f\n" -user $username |sort -n >  $workpathvar/$SAVED/$FOLDER4/${username}_recently_modified_files.txt
		echo -e "${GREEN}[+] Recently Modified Files from ${username} ${NC}"
		find . -type f -ctime -7 -printf "%CY/%Cm/%Cd/ %CH:%CM:%CS %h — %s — %f\n" -user $username |sort -n >  $workpathvar/$SAVED/$FOLDER4/${username}_recently_changed_files.txt
		echo -e "${GREEN}[+] Recently Changed Files from ${username} ${NC}"
		# ---- Collect Bash_hirstory & bashrc
		cat ${users_home[$i]}/.bash_history 2> /dev/null > $workpathvar/$SAVED/$FOLDER4/${username}_bash_history.txt
		cat ${users_home[$i]}/.zsh_history 2> /dev/null > $workpathvar/$SAVED/$FOLDER4/${username}_zsh_history.txt
		cat ${users_home[$i]}/.bashrc 2> /dev/null > $workpathvar/$SAVED/$FOLDER4/${username}_bashrc.txt
		cat ${users_home[$i]}/.zshrc 2> /dev/null > $workpathvar/$SAVED/$FOLDER4/${username}_zshrc.txt
		
		echo -e "${GREEN}[+] History and Shell source from ${username} ${NC}"
	done
}

###### Log Analysis ########
collect-5()
{
	##### Log Analysis 
	## Collect lastlog
	## Collect auth logs
	## Collect deamon
	## Collect syslog
	## Collect wtmp
	## Collect btmp
	## Application (Apache, http, mysql, smb)
	
	#### FOLDER5 in use
	#### Need OS check
	
	#### Global Variables available
	# 	- $workpathvar 	--> PATh of working dir where to save results
	#	- $SAVED 	--> Name of the Parent Folder where to save results
	#	- $FOLDERx	--> Name of subfolder where to save reslt of collect-x() function
	#	- $osselected	--> OS selected 
	echo -e "${PURPLE}[*] Starting Log Analysis Collection${NC}"
	
	# ----- Lastlog
	lastlog > $workpathvar/$SAVED/$FOLDER5/lastlog.txt
	echo -e "${GREEN}[+] Lastlog ${NC}"
	
	# ----- Auth Log
	case $osselected in
		1) # Debian - Ubuntu
			cat /var/log/auth.log > $workpathvar/$SAVED/$FOLDER5/auth.txt
			;;
		2) # Redhat
			cp /var/log/secure* $workpathvar/$SAVED/$FOLDER5/
			cp /var/log/message* $workpathvar/$SAVED/$FOLDER5/
			;;
	esac
	echo -e "${GREEN}[+] Auth Logs ${NC}"
	
	# ----- Daemon Log
	case $osselected in
		1) # Debian - Ubuntu
			cat /var/log/daemon.log > $workpathvar/$SAVED/$FOLDER5/deamon.txt
			;;
		2) # Redhat
			#/////// ????????
			;;
	esac
	echo -e "${GREEN}[+] Deamon Logs ${NC}"
	
	# ------ Syslog
	case $osselected in
		1) # Debian - Ubuntu
			cp /var/log/syslog* $workpathvar/$SAVED/$FOLDER5/
			;;
		2) # Redhat
			#/////// ????????
			;;
	esac
	echo -e "${GREEN}[+] Syslog ${NC}"
	
	# ------ wtmp
	cp /var/log/wtmp $workpathvar/$SAVED/$FOLDER5/
	echo -e "${GREEN}[+] wtmp file ${NC}"
	
	# ------ btmp
	cp /var/log/btmp $workpathvar/$SAVED/$FOLDER5/
	echo -e "${GREEN}[+] btmp file ${NC}"
	
	# ----- Apache2 & httpd
	case $osselected in
		1) # Debian - Ubuntu
			cat /var/log/apache2/error.log 2> /dev/null > $workpathvar/$SAVED/$FOLDER5/apache2_error.txt
			cat /var/log/apache2/access.log 2> /dev/null > $workpathvar/$SAVED/$FOLDER5/apache2_access.txt
			;;
		2) # Redhat
			cat /var/log/httpd/error_log 2> /dev/null > $workpathvar/$SAVED/$FOLDER5/httpd_error.txt
			cat /var/log/httpd/access_log 2> /dev/null > $workpathvar/$SAVED/$FOLDER5/httpd_access.txt
			;;
		3) # FreeBSD
			cat /var/log/httpd-error.log 2> /dev/null > $workpathvar/$SAVED/$FOLDER5/httpd_error.txt
			cat /var/log/httpd-access.log 2> /dev/null > $workpathvar/$SAVED/$FOLDER5/httpd_access.txt
			;;
	esac
	echo -e "${GREEN}[+] Apache2 ${NC}"
	
}

# Persistence Mechanism (Only for LIVE )
collect-6()
{
	##### Log Analysis 
	## Collect Services status
	## Collect Process
	## Collect Crontab
	## Collect Firewall
	## Collect Network Connections
	
	#### FOLDER5 in use
	#### Need OS check
	
	#### Global Variables available
	# 	- $workpathvar 	--> PATh of working dir where to save results
	#	- $SAVED 	--> Name of the Parent Folder where to save results
	#	- $FOLDERx	--> Name of subfolder where to save reslt of collect-x() function
	#	- $osselected	--> OS selected 
	echo -e "${PURPLE}[*] Starting Persistence Mechanism Collection${NC}"
	
	# ------ Service Status
	service --status-all > $workpathvar/$SAVED/$FOLDER6/service_status.txt
	echo -e "${GREEN}[+] Service Status ${NC}"
	
	# ------ Process 
	ps -aux > $workpathvar/$SAVED/$FOLDER6/process_list.txt
	echo -e "${GREEN}[+] Process List ${NC}"
	
	# ------ Crontab
	cat /etc/crontab > $workpathvar/$SAVED/$FOLDER6/crontab.txt
	echo -e "${GREEN}[+] Crontab${NC}"
	
	# ------ iptables
	iptables -L -n > $workpathvar/$SAVED/$FOLDER6/iptables.txt
	echo -e "${GREEN}[+] Iptables${NC}"
	
	# ------ Netstat
	netstat -nap > $workpathvar/$SAVED/$FOLDER6/netstat.txt
	echo -e "${GREEN}[+] Netstat${NC}"
	
	# ------ zip tmp folder
	echo -e "${ORANGE}[!] Reducio tmp folder !${NC}"
	/usr/bin/zip -rq $workpathvar/$SAVED/$FOLDER6/tmp.zip /tmp 2> /dev/null
	echo -e "${GREEN}[+] Zip tmp folder${NC}"
}

# --- Zip Function
zipper()
{
	# menu
	## ask zip password
	## zip folder
	## Erase folder y/N ?
	echo 
	echo -e "####--- Reducio Menu ---####"
	echo
	echo -e "[?] Please enter Zip Password"
	echo
	read -p ead -p "$(echo -e $CYAN"[zip][password] #> "$NC)" zipPassword
	
	# Avoid Zip relative path, cd into workpath then zip then go back - ez
	cd $workpathvar > /dev/null && /usr/bin/zip -erq $ZIPSAVED $SAVED/ -P $zipPassword && cd - > /dev/null
	
	echo
	echo -e "[?] Delete ${SAVED} folder ? [y/N] "
	echo
	read -p "$(echo -e $CYAN"[${SAVED}][delete] #> "$NC)" zipConfirm
	
	if [ $zipConfirm = "y" ] || [ $zipConfirm = "Y" ] || [ $zipConfirm = "yes" ] || [ $zipConfirm = "Yes" ] || [ $zipConfirm = "YES" ]
	then
		/usr/bin/rm -rf  $workpathvar/$SAVED/
		echo
		echo -e "${GREEN}[+] ${SAVED} deleted !${NC}"
	fi
}

######### LIVE - Current #########
current()
{
	### Global Variables :
	### - $osselected  --> 1 = Debian Ubuntu / 2 = RedHat CentOS
	### - $workpathvar --> PATH of saved results 
	
	# Ask OS to use
	os
	
	# Setup work folder in PATH where to save results
	setup-work
	
	isfinish=1
	
	while [ $isfinish -eq 1 ];
	do
		echo
		echo -e "####---- Collect Menu ----####"
		echo 
		echo -e "1) Collect Audit-Risk"
		echo -e "2) Collect Users & Groups"
		echo -e "3) Collect System Configuration"
		echo -e "4) Collect User Activities"
		echo -e "5) Log System"
		echo -e "6) Persistence Mechanism"
		echo -e "7) All"
		echo -e "- - - - - - - - - - - - -"
		echo -e "8) Custom Script Menu"
		echo -e "9) Zip & Exit"
		echo
		
		read -p ead -p "$(echo -e $CYAN"[live-system][action] #> "$NC)" collectOPT
		
		case $collectOPT in
			1) # Audit-Risk
				collect-1
				;;
			2) # Users & Groups
				collect-2
				;;
			3) # System Configuration
				collect-3
				;;
			4) # User activities
				collect-4
				;;
			5) # Log Analysis
				collect-5
				;;
			6) # Persistence
				collect-6
				;;
			7) # All
				collect-1
				collect-2
				collect-3
				collect-4
				collect-5
				collect-6
				;;
			9) #Zip and exit
				zipper
				exit
				;;
			?) # Unknown options
				echo -e "${RED}[-] Unknown Option RTFM${NC}"
				;; 
		esac
	done
	# while loop ask actions

	
}

########### DEAD - Mounted #######
mounted()
{
	echo "TBD"
	# Ask PATH for / of mounted system
	# ASK PATH for /home
	# ASK PATH for /var/log
	# AKS PATH for /root
	# ASK PATH for /tmp
}

########### MAIN #############

printf "

██████╗ ███████╗██╗██████╗       ███████╗██╗  ██╗████████╗██████╗  █████╗  ██████╗████████╗██╗   ██╗██╗  ██╗
██╔══██╗██╔════╝██║██╔══██╗      ██╔════╝╚██╗██╔╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██║   ██║╚██╗██╔╝
██║  ██║█████╗  ██║██████╔╝█████╗█████╗   ╚███╔╝    ██║   ██████╔╝███████║██║        ██║   ██║   ██║ ╚███╔╝ 
██║  ██║██╔══╝  ██║██╔══██╗╚════╝██╔══╝   ██╔██╗    ██║   ██╔══██╗██╔══██║██║        ██║   ██║   ██║ ██╔██╗ 
██████╔╝██║     ██║██║  ██║      ███████╗██╔╝ ██╗   ██║   ██║  ██║██║  ██║╚██████╗   ██║   ╚██████╔╝██╔╝ ██╗
╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝      ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝

By ${RED}@alrikrr${NC} --                                                                                                            
"
echo
if [[ $EUID -ne 0 ]]; then
	echo -e "${RED}[-] Require Severus Root Privilege ${NC}" 
	exit 1
else
	echo -e "${GREEN}[+] Root Privilege${NC}"	
fi


while getopts "hld" option; do
	case $option in
		h) # display Help
			help
			exit;;
		l) # Current system LIVE
			echo -e "${ORANGE}[!] You chose to analys this system ! Time for Magic !${NC}"
			workpathfunc
			current
			exit;;
		d) # Mounted Disk DEAD
			workpathfunc
			mounted
			exit;;
			
		?) # incorrect option
			echo -e "${RED}[-] Error: Invalid Option${NC}"
			exit;;
	esac
done
echo -e "${ORANGE}[!] Check -h my wizard friend !${NC}"

