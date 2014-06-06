if aptitude search '~i ^openjdk$' | grep -q openjdk; then
  echo "openjdk already installed, skipping."
else
  apt-get install openjdk-6-jdk
fi
