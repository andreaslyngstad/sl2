if aptitude search '~i ^monit$' | grep -q nginx; then
  echo "monit already installed, skipping."
else
  apt-get -y install monit
fi