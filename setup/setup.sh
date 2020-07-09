if [ -f "$MCDIR/installed" ]; then
  echo "Minecraft is installed"
  rm /tmp/.X5-lock
else
  python3 /srv/setup/install_mc.py
  mkdir $INSTDIR
  mkdir $INSTDIR/mods
  mkdir $MCDIR/versions
  mkdir $MCDIR/versions/fabric-1.15.2
  cp /srv/setup/fabric-1.15.2.json $MCDIR/versions/fabric-1.15.2/fabric-1.15.2.json
  cp /srv/setup/options.txt $INSTDIR/options.txt
  cp /srv/mods/* $INSTDIR/mods/
  mkdir $MCDIR
  mkdir $MCDIR/libraries
  mkdir $MCDIR/libraries/net
  mkdir $MCDIR/libraries/net/fabricmc
  mkdir $MCDIR/libraries/net/fabricmc/tiny-remapper
  mkdir $MCDIR/libraries/net/fabricmc/tiny-mappings-parser
  mkdir $MCDIR/libraries/net/fabricmc/sponge-mixin
  mkdir $MCDIR/libraries/net/fabricmc/intermediary
  mkdir $MCDIR/libraries/net/fabricmc/fabric-loader-sat4j
  mkdir $MCDIR/libraries/net/fabricmc/fabric-loader
  mkdir $MCDIR/libraries/net/fabricmc/tiny-remapper/0.2.2.64
  mkdir $MCDIR/libraries/net/fabricmc/tiny-mappings-parser/0.2.2.14
  mkdir $MCDIR/libraries/net/fabricmc/sponge-mixin/0.8+build.18
  mkdir $MCDIR/libraries/net/fabricmc/intermediary/1.15.2
  mkdir $MCDIR/libraries/net/fabricmc/fabric-loader-sat4j/2.3.5.4
  mkdir $MCDIR/libraries/net/fabricmc/fabric-loader/0.8.9+build.203
  wget https://maven.fabricmc.net/net/fabricmc/tiny-remapper/0.2.2.64/tiny-remapper-0.2.2.64.jar --output $MCDIR/libraries/net/fabricmc/tiny-remapper/0.2.2.64/tiny-remapper-0.2.2.64.jar
  wget https://maven.fabricmc.net/net/fabricmc/tiny-mappings-parser/0.2.2.14/tiny-mappings-parser-0.2.2.14.jar --output $MCDIR/libraries/net/fabricmc/tiny-mappings-parser/0.2.2.14/tiny-mappings-parser-0.2.2.14.jar
  wget https://maven.fabricmc.net/net/fabricmc/sponge-mixin/0.8+build.18/sponge-mixin-0.8+build.18.jar --output $MCDIR/libraries/net/fabricmc/sponge-mixin/0.8+build.18/sponge-mixin-0.8+build.18.jar
  wget https://maven.fabricmc.net/net/fabricmc/intermediary/1.15.2/intermediary-1.15.2.jar --output $MCDIR/libraries/net/fabricmc/intermediary/1.15.2/intermediary-1.15.2.jar
  wget https://maven.fabricmc.net/net/fabricmc/fabric-loader-sat4j/2.3.5.4/fabric-loader-sat4j-2.3.5.4.jar --output $MCDIR/libraries/net/fabricmc/fabric-loader-sat4j/2.3.5.4/fabric-loader-sat4j-2.3.5.4.jar
  wget https://maven.fabricmc.net/net/fabricmc/fabric-loader/0.8.9+build.203/fabric-loader-0.8.9+build.203.jar --output $MCDIR/libraries/net/fabricmc/fabric-loader/0.8.9+build.203/fabric-loader-0.8.9+build.203.jar
  mkdir $MCDIR/libraries/com
  mkdir $MCDIR/libraries/com/google
  mkdir $MCDIR/libraries/com/google/jimfs
  mkdir $MCDIR/libraries/com/google/guava
  mkdir $MCDIR/libraries/com/google/jimfs/jimfs
  mkdir $MCDIR/libraries/com/google/guava/guava
  mkdir $MCDIR/libraries/com/google/jimfs/jimfs/1.1
  mkdir $MCDIR/libraries/com/google/guava/guava/21.0
  wget https://maven.fabricmc.net/com/google/jimfs/jimfs/1.1/jimfs-1.1.jar --output $MCDIR/libraries/com/google/jimfs/jimfs/1.1/jimfs-1.1.jar
  wget https://maven.fabricmc.net/com/google/guava/guava/21.0/guava-21.0.jar --output $MCDIR/libraries/com/google/guava/guava/21.0/guava-21.0.jar
  mkdir $MCDIR/libraries/org
  mkdir $MCDIR/libraries/org/ow2
  mkdir $MCDIR/libraries/org/ow2/asm
  mkdir $MCDIR/libraries/org/ow2/asm/asm
  mkdir $MCDIR/libraries/org/ow2/asm/asm/8.0
  mkdir $MCDIR/libraries/org/ow2/asm/asm-util
  mkdir $MCDIR/libraries/org/ow2/asm/asm-util/8.0
  mkdir $MCDIR/libraries/org/ow2/asm/asm-tree
  mkdir $MCDIR/libraries/org/ow2/asm/asm-tree/8.0
  mkdir $MCDIR/libraries/org/ow2/asm/asm-analysis
  mkdir $MCDIR/libraries/org/ow2/asm/asm-analysis/8.0
  mkdir $MCDIR/libraries/org/ow2/asm/asm-commons
  mkdir $MCDIR/libraries/org/ow2/asm/asm-commons/8.0
  wget https://maven.fabricmc.net/org/ow2/asm/asm/8.0/asm-8.0.jar --output $MCDIR/libraries/org/ow2/asm/asm/8.0/asm-8.0.jar
  wget https://maven.fabricmc.net/org/ow2/asm/asm-util/8.0/asm-util-8.0.jar --output $MCDIR/libraries/org/ow2/asm/asm-util/8.0/asm-util-8.0.jar
  wget https://maven.fabricmc.net/org/ow2/asm/asm-tree/8.0/asm-tree-8.0.jar --output $MCDIR/libraries/org/ow2/asm/asm-tree/8.0/asm-tree-8.0.jar
  wget https://maven.fabricmc.net/org/ow2/asm/asm-analysis/8.0/asm-analysis-8.0.jar --output $MCDIR/libraries/org/ow2/asm/asm-analysis/8.0/asm-analysis-8.0.jar
  wget https://maven.fabricmc.net/org/ow2/asm/asm-commons/8.0/asm-commons-8.0.jar --output $MCDIR/libraries/org/ow2/asm/asm-commons/8.0/asm-commons-8.0.jar
  echo installed > $MCDIR/installed
fi
