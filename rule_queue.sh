#!/bin/bash

case $1 in
 start)
    RAILS_ENV=production bundle exec rake qc:work &
    ;;
  stop)
    kill -9 `cat tmp/pids/qc.pid`
    rm -rf tmp/pids/qc.pid
    ;;
  *)
    echo "usage: rule_queue {start|stop}" ;;
esac
