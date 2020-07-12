echo "Installing Minecraft..."

python3 /srv/setup/install_mc.py

mkdir /srv/instance
cp /srv/setup/options.txt /srv/instance/options.txt

mkdir -p /srv/minecraft/versions/1.15.2-HTTP-API
cp /srv/setup/1.15.2-HTTP-API.json /srv/minecraft/versions/1.15.2-HTTP-API/1.15.2-HTTP-API.json

#mkdir -p /srv/minecraft/libraries/cabaletta/baritone-api/1.5.3 \
#  ;
#cp /srv/baritone-api-1.5.3.jar /srv/minecraft/libraries/cabaletta/baritone-api/1.5.3/baritone-api-1.5.3.jar &&
#  echo "Baritone installed."

mkdir -p /srv/minecraft/libraries/dev/wnuke/mchttpapi/1.0.0/ \
  ;
cp /srv/mchttpapi-1.0.0.jar /srv/minecraft/libraries/dev/wnuke/mchttpapi/1.0.0/mchttpapi-1.0.0.jar &&
  echo "HTTP-API installed."

mkdir -p /srv/minecraft/libraries/org/spongepowered/mixin/0.7.11-SNAPSHOT \
  ;
wget https://repo.spongepowered.org/maven/org/spongepowered/mixin/0.7.11-SNAPSHOT/mixin-0.7.11-20180703.121122-1.jar --output /srv/minecraft/libraries/org/spongepowered/mixin/0.7.11-SNAPSHOT/mixin-0.7.11-SNAPSHOT.jar &&
  echo "Mixin installed."

mkdir -p /srv/minecraft/libraries/org/ow2/asm/asm-all/5.0.3 \
  ;
wget https://repo1.maven.org/maven2/org/ow2/asm/asm-all/5.0.3/asm-all-5.0.3.jar --output /srv/minecraft/libraries/org/ow2/asm/asm-all/5.0.3/asm-all-5.0.3.jar &&
  echo "asm-all installed."

mkdir -p /srv/minecraft/libraries/com/github/ImpactDevelopment/SimpleTweaker/1.2 \
  ;
wget https://impactdevelopment.github.io/maven/com/github/ImpactDevelopment/SimpleTweaker/1.2/SimpleTweaker-1.2.jar --output /srv/minecraft/libraries/com/github/ImpactDevelopment/SimpleTweaker/1.2/SimpleTweaker-1.2.jar &&
  echo "SimpleTweaker installed."

echo "Minecraft is ready."
