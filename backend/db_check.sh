#!/usr/bin/bash

set -euo pipefail

if ! command -v nc &>/dev/null; then
  echo "'nc' command not found." >&2
  exit 1
fi

if [[ $# -ne 2 ]]; then
  usage
fi

host="$1"
port="$2"
# host="mysql_db"
# port="3306"

while ! nc -z "${host}" "${port}"; do
  echo "Waiting on ${host}:${port}..."
  sleep 1
done

echo "${host}:${port} is now reachable."
exit 0
