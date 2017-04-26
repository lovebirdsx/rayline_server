Token='7439f664-4a1e-43b5-a682-4bf60007cdca'
Secret='OogDLwth8zoqqePl9YMsMPEjysR6jQp1XAlPrr8z3oXcQcyHxzbSls4tPKKQs0Sa'
Endpoint='lovebird.arukascloud.io'
Port='10000'

# Token=$1
# Secret=$2
# Endpoint=$3
# Port=$4

raw="curl -s -u $Token:$Secret https://app.arukas.io/api/containers -H 'Content-Type: application/vnd.api+json' -H 'Accept: application/vnd.api+json'"
json=`$raw | jq ".data[]?.attributes | select(.end_point==\"$Endpoint\") | .port_mappings[][] |select(.container_port==$Port)"`
addr=`echo $json | jq .host | tr -d '""' `
port=`echo $json | jq .service_port `

if [ -z "$addr" -o -z "$port"  ] ; then
	echo "Query Failed. Check you Token, Secert, Endpoint and Port!"
  exit 1
fi

ip=`curl -s http://119.29.29.29/d?dn=$addr`
addr=${ip:-$addr}
old=''
echo "$addr $port"
