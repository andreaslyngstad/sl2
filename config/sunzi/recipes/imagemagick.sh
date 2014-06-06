if aptitude search '~i ^imagemagick$' | grep -q nginx; then
  echo "imagemagick already installed, skipping."
else
  apt-get -y install imagemagick
fi