#rule_queue
RULEQUEUE=/usr/local/bin/rule_queue.sh
if  [  -e ${RULEQUEUE} ]; then
  echo "rule_queue already copied, skipping."
else
	echo "copying rule_queue"
	mv files/rule_queue.sh /usr/local/bin/rule_queue.sh
	chmod 755 /usr/local/bin/rule_queue.sh
fi