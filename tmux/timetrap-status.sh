#!/bin/bash
t now all &> /tmp/timetrap_status

STATUS=$(sed -n '$p' /tmp/timetrap_status | grep "not running")

if [ -z "${STATUS}" ]; then
  echo " ON "
else
  echo " OFF "
fi
