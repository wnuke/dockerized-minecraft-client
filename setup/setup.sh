if [ -f "/srv/minecraft/installed" ]; then
  echo "Minecraft is installed"
  rm /tmp/.X5-lock
else
  python3 /srv/setup/install_mc.py
  mkdir /srv/instance
  mkdir /srv/instance/mods
  mkdir /srv/minecraft/versions
  mkdir /srv/minecraft/versions/fabric-1.15.2
  cp /srv/setup/fabric-1.15.2.json /srv/minecraft/versions/fabric-1.15.2/fabric-1.15.2.json
  cp /srv/setup/options.txt /srv/instance/options.txt
  cp /srv/mods/* /srv/instance/mods/
  mkdir /srv/minecraft
  mkdir /srv/minecraft/libraries
  mkdir /srv/minecraft/libraries/net
  mkdir /srv/minecraft/libraries/net/fabricmc
  mkdir /srv/minecraft/libraries/net/fabricmc/tiny-remapper
  mkdir /srv/minecraft/libraries/net/fabricmc/tiny-mappings-parser
  mkdir /srv/minecraft/libraries/net/fabricmc/sponge-mixin
  mkdir /srv/minecraft/libraries/net/fabricmc/intermediary
  mkdir /srv/minecraft/libraries/net/fabricmc/fabric-loader-sat4j
  mkdir /srv/minecraft/libraries/net/fabricmc/fabric-loader
  mkdir /srv/minecraft/libraries/net/fabricmc/tiny-remapper/0.2.2.64
  mkdir /srv/minecraft/libraries/net/fabricmc/tiny-mappings-parser/0.2.2.14
  mkdir /srv/minecraft/libraries/net/fabricmc/sponge-mixin/0.8+build.18
  mkdir /srv/minecraft/libraries/net/fabricmc/intermediary/1.15.2
  mkdir /srv/minecraft/libraries/net/fabricmc/fabric-loader-sat4j/2.3.5.4
  mkdir /srv/minecraft/libraries/net/fabricmc/fabric-loader/0.8.9+build.203
  wget https://maven.fabricmc.net/net/fabricmc/tiny-remapper/0.2.2.64/tiny-remapper-0.2.2.64.jar --output /srv/minecraft/libraries/net/fabricmc/tiny-remapper/0.2.2.64/tiny-remapper-0.2.2.64.jar
  wget https://maven.fabricmc.net/net/fabricmc/tiny-mappings-parser/0.2.2.14/tiny-mappings-parser-0.2.2.14.jar --output /srv/minecraft/libraries/net/fabricmc/tiny-mappings-parser/0.2.2.14/tiny-mappings-parser-0.2.2.14.jar
  wget https://maven.fabricmc.net/net/fabricmc/sponge-mixin/0.8+build.18/sponge-mixin-0.8+build.18.jar --output /srv/minecraft/libraries/net/fabricmc/sponge-mixin/0.8+build.18/sponge-mixin-0.8+build.18.jar
  wget https://maven.fabricmc.net/net/fabricmc/intermediary/1.15.2/intermediary-1.15.2.jar --output /srv/minecraft/libraries/net/fabricmc/intermediary/1.15.2/intermediary-1.15.2.jar
  wget https://maven.fabricmc.net/net/fabricmc/fabric-loader-sat4j/2.3.5.4/fabric-loader-sat4j-2.3.5.4.jar --output /srv/minecraft/libraries/net/fabricmc/fabric-loader-sat4j/2.3.5.4/fabric-loader-sat4j-2.3.5.4.jar
  wget https://maven.fabricmc.net/net/fabricmc/fabric-loader/0.8.9+build.203/fabric-loader-0.8.9+build.203.jar --output /srv/minecraft/libraries/net/fabricmc/fabric-loader/0.8.9+build.203/fabric-loader-0.8.9+build.203.jar
  mkdir /srv/minecraft/libraries/com
  mkdir /srv/minecraft/libraries/com/google
  mkdir /srv/minecraft/libraries/com/google/jimfs
  mkdir /srv/minecraft/libraries/com/google/guava
  mkdir /srv/minecraft/libraries/com/google/jimfs/jimfs
  mkdir /srv/minecraft/libraries/com/google/guava/guava
  mkdir /srv/minecraft/libraries/com/google/jimfs/jimfs/1.1
  mkdir /srv/minecraft/libraries/com/google/guava/guava/21.0
  wget https://maven.fabricmc.net/com/google/jimfs/jimfs/1.1/jimfs-1.1.jar --output /srv/minecraft/libraries/com/google/jimfs/jimfs/1.1/jimfs-1.1.jar
  wget https://maven.fabricmc.net/com/google/guava/guava/21.0/guava-21.0.jar --output /srv/minecraft/libraries/com/google/guava/guava/21.0/guava-21.0.jar
  mkdir /srv/minecraft/libraries/org
  mkdir /srv/minecraft/libraries/org/ow2
  mkdir /srv/minecraft/libraries/org/ow2/asm
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm/8.0
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm-util
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm-util/8.0
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm-tree
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm-tree/8.0
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm-analysis
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm-analysis/8.0
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm-commons
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm-commons/8.0
  wget https://maven.fabricmc.net/org/ow2/asm/asm/8.0/asm-8.0.jar --output /srv/minecraft/libraries/org/ow2/asm/asm/8.0/asm-8.0.jar
  wget https://maven.fabricmc.net/org/ow2/asm/asm-util/8.0/asm-util-8.0.jar --output /srv/minecraft/libraries/org/ow2/asm/asm-util/8.0/asm-util-8.0.jar
  wget https://maven.fabricmc.net/org/ow2/asm/asm-tree/8.0/asm-tree-8.0.jar --output /srv/minecraft/libraries/org/ow2/asm/asm-tree/8.0/asm-tree-8.0.jar
  wget https://maven.fabricmc.net/org/ow2/asm/asm-analysis/8.0/asm-analysis-8.0.jar --output /srv/minecraft/libraries/org/ow2/asm/asm-analysis/8.0/asm-analysis-8.0.jar
  wget https://maven.fabricmc.net/org/ow2/asm/asm-commons/8.0/asm-commons-8.0.jar --output /srv/minecraft/libraries/org/ow2/asm/asm-commons/8.0/asm-commons-8.0.jar
  echo installed > /srv/minecraft/installed
fi
