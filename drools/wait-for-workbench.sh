#!/bin/sh
# wait-for-workbench.sh

set -e

host="$1"
shift
cmd="$@"

until curl -f -s -u ${KIE_SERVER_USER}:${KIE_SERVER_PWD} \
    http://drools-workbench:8080/business-central/rest/spaces; do
  >&2 echo "Workbench is unavailable - sleeping"
  sleep 5
done

>&2 echo "Postgres is up - executing command"
exec $cmd
