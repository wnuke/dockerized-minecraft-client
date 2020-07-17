echo "Installing libraries..."
mkdir -p /srv/minecraft/versions/fabric-1.16
cp /srv/setup/fabric-1.16.json /srv/minecraft/versions/fabric-1.16/fabric-1.16.json
mkdir -p /srv/minecraft/libraries
python3 /srv/setup/getlibs.py /srv/minecraft/versions/fabric-1.16/fabric-1.16.json /srv/minecraft/libraries/
echo "Libraries installed."

echo "Installing config..."
mkdir /srv/instance
cp /srv/setup/options.txt /srv/instance/options.txt
cp /srv/setup/APIconfig.json /srv/instance/APIconfig.json
echo "Config installed..."

echo "Installing mods..."
mkdir -p /srv/instance/mods
cp /srv/mchttpapi-1.0.0.jar /srv/instance/mods/mchttpapi-1.0.0.jar &&
  echo "HTTP-API installed."

cp /srv/fabritone-1.5.3.jar /srv/instance/mods/fabritone-1.5.3.jar &&
  echo "Fabritone installed."
echo "Mods installed."