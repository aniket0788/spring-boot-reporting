#!/bin/bash
#
# Author : AC

report_pid() {
  echo `ps -f -u svc_chipuser | grep reporte* |grep -v grep | awk '{ print $2 }'`
}
pid=$(report_pid)
 if [ -n "$pid" ]
  then
    kill -9 $pid
    nohup java -javaagent:/web-chip/microservices/newrelic/newrelic.jar -jar -Dspring.profiles.active=UAT "/web-chip/microservices/CHIP-INVRE/reportengine-0.0.1-SNAPSHOT.jar" > report.log 2>&1 </dev/null &
   else
    nohup java -javaagent:/web-chip/microservices/newrelic/newrelic.jar -jar -Dspring.profiles.active=UAT "/web-chip/microservices/CHIP-INVRE/reportengine-0.0.1-SNAPSHOT.jar" > report.log 2>&1 </dev/null &
fi
exit 0

