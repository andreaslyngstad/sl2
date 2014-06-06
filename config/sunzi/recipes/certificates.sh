#certificates copy
CERTIFI=/etc/ssl/<%= @attributes.app_name %>.crt
if  [  -e ${CERTIFI} ]; then
  echo "certificates already copied, skipping."
else
	echo "copying certificates"
	mv files/<%= @attributes.app_name %>.key /etc/ssl/<%= @attributes.app_name %>.key
	mv files/<%= @attributes.app_name %>-unified.crt /etc/ssl/<%= @attributes.app_name %>-unified.crt
	mv files/<%= @attributes.app_name %>.crt /etc/ssl/<%= @attributes.app_name %>.crt
fi