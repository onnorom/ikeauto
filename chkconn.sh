#!/usr/bin/env bash
PROGNAME=$(basename $0 |sed 's/\(.*\).sh/\1/g').txt
dir="$(dirname $(readlink -f $0))"
url=${1:-"https://github.com"}
chkwget=$(which wget)
chkcurl=$(which curl)
myproxy=${2:-""}
proxy_set=
date_url="google.com"
cd $dir

iproxyset() {
   local arg=$1
   echo "Offline" >>/tmp/${PROGNAME} 2>&1
   case $arg in 
   set)
      echo "Setting proxy and retrying..." >>/tmp/${PROGNAME} 2>&1
      echo "export http_proxy=$myproxy" > .profile.$$
      echo "export https_proxy=$myproxy" >> .profile.$$
      echo "export HTTP_PROXY=$myproxy" >> .profile.$$
      echo "export HTTPS_PROXY=$myproxy" >> .profile.$$
      . .profile.$$
      proxy_set=2
      rm .profile.$$
   ;;
   unset)
      echo "Retrying with proxy unset..." >>/tmp/${PROGNAME} 2>&1
      echo "export http_proxy=" > .profile.$$
      echo "export https_proxy=" >> .profile.$$
      echo "export HTTP_PROXY=" >> .profile.$$
      echo "export HTTPS_PROXY=" >> .profile.$$
      . .profile.$$
      proxy_set=
      rm .profile.$$
   ;;
   esac
}

isetdate() {
  local cmd=$1
  local date_utc=
  echo "Online" >>/tmp/${PROGNAME} 2>&1
  case $cmd in 
	curl) date_utc=$($chkcurl -sD - "$date_url" | grep '^Date:' | cut -d' ' -f3-6);;
	wget) date_utc=$($chkwget -S  "$date_url" 2>&1 | grep -E '^[[:space:]]*[dD]ate:' | sed 's/^[[:space:]]*[dD]ate:[[:space:]]*//' | head -1l | awk '{print $1, $3, $2, $5, "GMT", $4}' |cut -d' ' -f2-4,6)
	   rm index.html 2>/dev/null
	;;
  esac
  echo $date_utc >>/tmp/${PROGNAME} 2>&1
  [ -n "$date_utc" ] && sudo date -s "${date_utc}Z" >>/tmp/${PROGNAME} 2>&1
}

for proxy in $(env |grep -i "^http"); do 
    if [[ -n $(echo $proxy |sed 's/http.*_proxy=\(.*\)/\1/g') ]]; then
	proxy_set=1
    fi	
done

rm /tmp/${PROGNAME} 2>/dev/null
while true; do
if [[ -n $url ]]; then
    if [[ -n $chkcurl ]]; then
	if [[ -n $(echo "$url" |grep -i https) ]]; then 
	   $chkcurl -k $url 2>/tmp/${PROGNAME} >/dev/null
	   xcode=$?
        elif [[ -n $(echo "$url" |grep -i http |grep -vi https) ]]; then 
	   $chkcurl $url 2>/tmp/${PROGNAME} >/dev/null
	   xcode=$?
        fi

	if [[ $xcode -eq 0 ]]; then
	  isetdate "curl"
	  exit 0
	else
	  if [[ $proxy_set = 1 ]]; then
		iproxyset "unset" 
		continue
	  elif [[ ! -n $proxy_set ]]; then
		iproxyset "set" 
		continue
	  fi
	  exit 1
	fi
    elif [[ -n $chkwget ]]; then
       $chkwget -q --spider $url 2>/tmp/${PROGNAME} >/dev/null
	if [ $? -eq 0 ]; then
	   isetdate "wget"
	   exit 0
	else
	  if [[ $proxy_set = 1 ]]; then
	       iproxyset "unset"
	       continue
	  elif [[ ! -n $proxy_set ]]; then
	       iproxyset "set"
	       continue
	  fi
	  exit 1
	fi
    fi
fi
done
