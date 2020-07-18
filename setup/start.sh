bash /srv/setup/setup.sh
echo "Launching Minecraft..."
cd /srv/instance && \
  python3 /srv/setup/launch_mc.py \
    --username="$USERNAME" \
    --password="$PASSWORD" \
    --version="fabric-1.16"