if [ -f "/srv/minecraft/installed" ]; then
  echo "Minecraft is installed"
  rm /tmp/.X5-lock
else
  python3 /srv/setup/install_mc.py

  mkdir /srv/instance
  cp /srv/setup/options.txt /srv/instance/options.txt

  mkdir /srv/minecraft/versions/1.12.2-baritone
  cp /srv/setup/1.12.2-baritone.json /srv/minecraft/versions/1.12.2-baritone/1.12.2-baritone.json

  mkdir /srv/minecraft/libraries/cabaletta
  mkdir /srv/minecraft/libraries/cabaletta/baritone-standalone
  mkdir /srv/minecraft/libraries/cabaletta/baritone-standalone/1.2.14
  cp /srv/baritone-standalone-1.2.14.jar /srv/minecraft/libraries/cabaletta/baritone-standalone/1.2.14/baritone-standalone-1.2.14.jar

  mkdir /srv/minecraft/libraries/net/jodah
  mkdir /srv/minecraft/libraries/net/jodah/typetools
  mkdir /srv/minecraft/libraries/net/jodah/typetools/0.5.0
  wget https://repo.maven.apache.org/maven2/net/jodah/typetools/0.5.0/typetools-0.5.0.jar --output /srv/minecraft/libraries/net/jodah/typetools/0.5.0/typetools-0.5.0.jar

  mkdir /srv/minecraft/libraries/org/spongepowered
  mkdir /srv/minecraft/libraries/org/spongepowered/mixin
  mkdir /srv/minecraft/libraries/org/spongepowered/mixin/0.7.10-SNAPSHOT
  wget https://repo.spongepowered.org/maven/org/spongepowered/mixin/0.7.10-SNAPSHOT/mixin-0.7.10-20180611.151716-1.jar --output /srv/minecraft/libraries/org/spongepowered/mixin/0.7.10-SNAPSHOT/0.7.10-SNAPSHOT.jar

  mkdir /srv/minecraft/libraries/org/ow2
  mkdir /srv/minecraft/libraries/org/ow2/asm
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm-all
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm-all/5.2
  wget https://repo1.maven.org/maven2/org/ow2/asm/asm-all/5.2/asm-all-5.2.jar --output /srv/minecraft/libraries/org/ow2/asm/asm-all/5.2/asm-all-5.2.jar

  mkdir /srv/minecraft/libraries/com/github
  mkdir /srv/minecraft/libraries/com/github/ImpactDevelopment
  mkdir /srv/minecraft/libraries/com/github/ImpactDevelopment/SimpleTweaker
  mkdir /srv/minecraft/libraries/com/github/ImpactDevelopment/SimpleTweaker/1.2
  wget https://github.com/ImpactDevelopment/maven/blob/master/com/github/ImpactDevelopment/SimpleTweaker/1.2/SimpleTweaker-1.2.jar --output /srv/minecraft/libraries/com/github/ImpactDevelopment/SimpleTweaker/1.2/SimpleTweaker-1.2.jar

  echo installed > /srv/minecraft/installed
fi
