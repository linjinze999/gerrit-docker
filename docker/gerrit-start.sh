#!/usr/bin/env sh
set -e
echo "Starting Gerrit..."
exec ${GERRIT_SITE}/bin/gerrit.sh ${GERRIT_START_ACTION:-daemon}
