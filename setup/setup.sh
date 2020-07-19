export GAMEDIR=$GAMEDIR
export GAMEVER=$GAMEVER
export INSTDIR=$INSTDIR
export SETUPDIR=$SETUPDIR
export PORT=$PORT
export USERNAME=$USERNAME
export PASSWORD=$PASSWORD

if [ -z "$GAMEDIR" ]
then
      GAMEDIR="/srv/minecraft"
fi
if [ -z "$GAMEVER" ]
then
      GAMEDIR="/srv/minecraft"
fi
if [ -z "$INSTDIR" ]
then
      INSTDIR="/srv/instance"
fi
if [ -z "$SETUPDIR" ]
then
      SETUPDIR="/srv/setup"
fi
if [ -z "$PORT" ]
then
      PORT="8000"
fi
if [ -z "$USERNAME" ]
then
      USERNAME="test"
fi
if [ -z "$PASSWORD" ]
then
      PASSWORD=""
fi

echo "Downloading libraries..."
mkdir -p $GAMEDIR/versions/$GAMEVER
cp $SETUPDIR/$GAMEVER.json $GAMEDIR/versions/$GAMEVER/$GAMEVER.json
mkdir -p $GAMEDIR/libraries
python3 $SETUPDIR/getlibs.py $GAMEDIR/versions/$GAMEVER/$GAMEVER.json $GAMEDIR/libraries/
echo "Libraries downloaded."

echo "Downloading Minecraft..."
python3 $SETUPDIR/download_mc.py \
    --version=$GAMEVER \
    --directory=$GAMEDIR
echo "Minecraft downloaded."

echo "Installing config..."
mkdir $INSTDIR
cp $SETUPDIR/options.txt $INSTDIR/options.txt
cp $SETUPDIR/APIconfig.json $INSTDIR/APIconfig.json
echo "Config installed..."

echo "Installing mods..."
mkdir -p $INSTDIR/mods
cp $SETUPDIR/mchttpapi-1.0.0.jar $INSTDIR/mods/mchttpapi-1.0.0.jar && \
  echo "HTTP-API installed."

cp $SETUPDIR/fabritone-1.5.3.jar $INSTDIR/mods/fabritone-1.5.3.jar && \
  echo "Fabritone installed."
echo "Mods installed."

echo "Launching Minecraft..."
cd $INSTDIR && \
  python3 $SETUPDIR/launch_mc.py \
    --username="$USERNAME" \
    --password="$PASSWORD" \
    --version=$GAMEVER \
    --gamedir=$GAMEDIR \
    --instdir=$INSTDIR \
    --port="$PORT" && \
  echo "Minecraft stopped." && exit