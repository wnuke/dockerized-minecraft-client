mkdir $INSTDIR/mods
./gradlew --no-daemon build
mv build/libs/headless-api-1.0.0.jar $INSTDIR/mods/
cd fabritone
./gradlew --no-daemon build
mv build/libs/fabritone-api-1.5.3.jar $INSTDIR/mods/
