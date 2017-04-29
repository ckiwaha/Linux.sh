#!/bin/sh

PATH=/bin:/usr/bin
WORKDIR=/home/edi/send_route_rules_export
d=$(date +%Y%m%d)

cd ${WORKDIR} || exit 1

curl -s -S -c ${WORKDIR}/cookiejar.txt 'http://sterling-dev:37381/fmi/FMILogin.do' -H 'Origin: http://sterling-dev:37381'  -H 'Accept-Encoding: gzip, deflate'  -H 'Accept-Language: en-US,en;q=0.8'  -H 'Upgrade-Insecure-Requests: 1'  -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36'  -H 'Content-Type: application/x-www-form-urlencoded'  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'  -H 'Cache-Control: max-age=0'  -H 'Referer: http://sterling-dev:37381/fmi/FMISaveExportSendRules.do'  -H 'Connection: keep-alive' --data 'username=user&password=password' --compressed || exit 1

curl -s -S -b ${WORKDIR}/cookiejar.txt -c ${WORKDIR}/cookiejar.txt 'http://sterling-dev:37381/fmi/FMIExportRules.do?type=FW1_SEND_RULES'  --compressed -o ${WORKDIR}/fmi2_FW1_SEND_RULES.xml$d || exit 1

curl -s -S -b ${WORKDIR}/cookiejar.txt -c ${WORKDIR}/cookiejar.txt 'http://sterling-dev:37381/fmi/FMIExportRules.do?type=FW1_ROUTE_RULES' --compressed -o ${WORKDIR}/fmi2_FW1_ROUTE_RULES.xml$d || exit 1

rm -f ${WORKDIR}/cookiejar.txt

