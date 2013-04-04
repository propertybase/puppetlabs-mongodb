RS_PRIMARY=`mongo --host $1 --eval "printjson(rs.isMaster())" | grep "primary" | cut -d"\"" -f4`
COMMAND="rs.add( { \"_id\": $2, \"host\": \"$3\", \"priority\": $4 } )"
mongo --host $RS_PRIMARY --eval "$COMMAND"