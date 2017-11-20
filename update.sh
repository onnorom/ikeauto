#!/usr/bin/env bash
logfile="/tmp/puppet-run.log"
dir="$(dirname $(readlink -f $0))"
pwdir=$(pwd)

cd ${dir}
#./checkconn.sh 
#[[ $? -ne 0 ]] && exit
. .profile
i=1
while [[ $i -gt 0 ]]; do
/usr/bin/git pull origin master >${logfile} 2>&1 && /usr/local/bin/r10k puppetfile install --verbose >>${logfile} 2>&1
if [[ -n $(egrep -i "(could not resolve proxy|failed to connect)" ${logfile}) ]]; then
   echo "export HTTP_PROXY=" > .profile.$$
   echo "export HTTPS_PROXY=" >> .profile.$$
   echo "export http_proxy=" >> .profile.$$
   echo "export https_proxy=" >> .profile.$$
   . .profile.$$ 
   /usr/bin/git pull origin master >>${logfile} 2>&1 && /usr/local/bin/r10k puppetfile install --verbose >>${logfile} 2>&1
   rm .profile.$$
   i=$(( i-1 ))
else 
   i=-1
fi	
done

warnings=$(grep -i "skipping" ${logfile} |sed 's/.*Skipping *\([a-zA-Z0-9\/]*\) .*/\1/g')

if [[ -n ${warnings} ]]; then
   for x in $(echo $warnings); do
	rm -rf "${x}" >>${logfile} 2>&1
   done
   /usr/local/bin/r10k puppetfile install --verbose >>${logfile} 2>&1 && puppet apply ./site.pp >>${logfile} 2>&1
else
   puppet apply ./site.pp >>${logfile} 2>&1
fi

cd ${pwdir}
