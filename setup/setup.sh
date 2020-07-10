if [ -f "/srv/minecraft/installed" ]; then
  echo "Minecraft is installed"
  rm /tmp/.X5-lock
else
  python3 /srv/setup/install_mc.py

  mkdir /srv/instance
  cp /srv/setup/options.txt /srv/instance/options.txt

  mkdir /srv/minecraft/versions/1.15.2-Baritone
  cp /srv/setup/1.15.2-Baritone.json /srv/minecraft/versions/1.15.2-Baritone/1.15.2-Baritone.json

  mkdir /srv/minecraft/libraries/cabaletta
  mkdir /srv/minecraft/libraries/cabaletta/baritone-api
  mkdir /srv/minecraft/libraries/cabaletta/baritone-api/1.5.3
  cp /srv/baritone-api-1.5.3.jar /srv/minecraft/libraries/cabaletta/baritone-api/1.5.3/baritone-api-1.5.3.jar

  mkdir /srv/minecraft/libraries/org/spongepowered
  mkdir /srv/minecraft/libraries/org/spongepowered/mixin
  mkdir /srv/minecraft/libraries/org/spongepowered/mixin/0.7.11-SNAPSHOT
  wget https://repo.spongepowered.org/maven/org/spongepowered/mixin/0.7.11-SNAPSHOT/mixin-0.7.11-20180703.121122-1.jar --output /srv/minecraft/libraries/org/spongepowered/mixin/0.7.11-SNAPSHOT/0.7.11-SNAPSHOT.jar

  mkdir /srv/minecraft/libraries/org/ow2
  mkdir /srv/minecraft/libraries/org/ow2/asm
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm-all
  mkdir /srv/minecraft/libraries/org/ow2/asm/asm-all/5.0.3
  wget https://repo1.maven.org/maven2/org/ow2/asm/asm-all/5.0.3/asm-all-5.0.3.jar --output /srv/minecraft/libraries/org/ow2/asm/asm-all/5.0.3/asm-all-5.0.3.jar

  mkdir /srv/minecraft/libraries/com/github
  mkdir /srv/minecraft/libraries/com/github/ImpactDevelopment
  mkdir /srv/minecraft/libraries/com/github/ImpactDevelopment/SimpleTweaker
  mkdir /srv/minecraft/libraries/com/github/ImpactDevelopment/SimpleTweaker/1.2
  wget https://github.com/ImpactDevelopment/maven/blob/master/com/github/ImpactDevelopment/SimpleTweaker/1.2/SimpleTweaker-1.2.jar --output /srv/minecraft/libraries/com/github/ImpactDevelopment/SimpleTweaker/1.2/SimpleTweaker-1.2.jar

  echo installed > /srv/minecraft/installed
fi