#RECON THE INTERNET
#NICOLAS JULIAN
#SCANNING PORT : 22
#21 June 2019
#Free to Modify

RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m' 
PURPLE='\033[0;35m'
NC='\033[0m'
GRN="\e[32m"
BACK_GRN="\e[102m"
MAGENTA="\033[45m"
BACK_RED="\033[41m"

manyol(){
	requestssh=$(nc -zv -w 20 $1 22 2>&1)
	live=$(echo $requestssh | grep -ic 'succeeded')
		if [[ $live == 1  ]]; then
			whatport=$(echo $requestssh | grep -Po 'port [^"]* ' | sed -r "s|port ||g")
			printf "${MAGENTA}$1 => PORT $whatport IN 22 OPENED \e[0m \n"
			echo "$1:22" >> opened-port.txt 
		else
			printf "${BACK_RED}$1 => PORT 22 CLOSED \e[0m \n"
		fi
printf "\r"
}

read -p "LIST IPS : " file
read -p "HOW MANY : " sendList
read -p "PER SEC  : " perSec

line=$(wc -l < $file)

IFS=$'\r\n' GLOBIGNORE='*' command eval  'ipslist=($(cat $file))'
for (( i = 0; i < $line ; i++ )); do
	ipe="${ipslist[i]}"
	fold=`expr $i % $sendList`
	  if [[ $fold == 0 && $i > 0 ]]; then
	    header="`date +%H:%M:%S`"
	    duration=$SECONDS
	    printf "Waiting $perSec seconds. $(($duration / 3600)) hours $(($duration / 60 % 60)) minutes and $(($duration % 60)) seconds elapsed, ratio ${YELLOW}$sendList domain${NC} / ${CYAN}$perSec seconds${NC}\n"
	    sleep $perSec
	  fi
	
	manyol "$ipe" &
done
wait
exit 
