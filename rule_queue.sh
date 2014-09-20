#!/bin/bash
case $1 in
 start)
    cd /home/deploy/apps/squadlink_production/current/;
    RAILS_ENV=production bundle exec rake qc:work &
    ;;
  stop)
    kill -9 `cat /home/deploy/apps/squadlink_production/shared/tmp/pids/qc.pid`
    rm -rf /home/deploy/apps/squadlink_production/shared/tmp/pids/qc.pid
    ;;
  *)
    echo "usage: rule_queue {start|stop}" ;;
esac
