echo "Launching Minecraft..."
minecraft-launcher-cmd \
    --resolutionWidth=10 \
    --resolutionHeight=10 \
    --jvmArguments="-Xms512M -Xmx1024M" \
    --minecraftDir="/srv/minecraft" \
    --gameDir="/srv/instance" \
    --username="$USERNAME" \
    --password="$PASSWORD" \
    --version="fabric-1.16"