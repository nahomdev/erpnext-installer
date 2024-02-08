#!/bin/bash

tail -n +$(awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' "$0") "$0" | tar xz
exec ./installer.sh "$@"
__ARCHIVE_BELOW__
