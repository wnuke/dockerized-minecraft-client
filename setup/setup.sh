#!/usr/bin/env bash

pip install --user pipenv
pip install --user minecraft-launcher-cmd
pipenv sync
./install_mc.py
mkdir minecraft/versions
mkdir minecraft/versions/fabric-1.15.2
cp fabric-1.15.2.json minecraft/versions/fabric-1.15.2/fabric-1.15.2.json
mkdir minecraft/mods
cp headless-api-1.0.0.jar minecraft/mods/headlessapi.jar
cp fabritone-1.5.3.jar minecraft/mods/fabritone.jar
cp options.txt minecraft/options.txt
mvn dependency:copy-dependencies
mkdir minecraft/libraries/net/{tiny-remapper,tiny-mappings-parser,sponge-mixin,intermediary,fabric-loader-sat4j,fabric-loader}
mkdir minecraft/libraries/net/tiny-remapper/0.2.2.64
mkdir minecraft/libraries/net/tiny-mappings-parser/0.2.2.14
mkdir minecraft/libraries/net/sponge-mixin/0.8+build.18
mkdir minecraft/libraries/net/intermediary/1.15.2
mkdir minecraft/libraries/net/fabric-loader-sat4j/2.3.5.4
mkdir minecraft/libraries/net/fabric-loader/0.8.9+build.203
mv target/dependency/tiny-remapper-0.2.2.64.jar minecraft/libraries/net/tiny-remapper/0.2.2.64/
mv target/dependency/tiny-mappings-parser-0.2.2.14.jar minecraft/libraries/net/tiny-mappings-parser/0.2.2.14/
mv target/dependency/sponge-mixin-0.8+build.18.jar minecraft/libraries/net/sponge-mixin/0.8+build.18/
mv target/dependency/intermediary-1.15.2.jar minecraft/libraries/net/intermediary/1.15.2/
mv target/dependency/fabric-loader-sat4j-2.3.5.4.jar minecraft/libraries/net/fabric-loader-sat4j/2.3.5.4/
mv target/dependency/fabric-loader-0.8.9+build.203.jar minecraft/libraries/net/fabric-loader/0.8.9+build.203/
mkdir minecraft/libraries/com/google/{jimfs,gson,guava}
mkdir minecraft/libraries/com/google/jimfs/1.1
mkdir minecraft/libraries/com/google/gson/2.2.4
mkdir minecraft/libraries/com/google/guava/21.0
mv target/dependency/jimfs-1.1.jar minecraft/libraries/com/google/jimfs/1.1/
mv target/dependency/gson-2.2.4.jar minecraft/libraries/com/google/gson/2.2.4/
mv target/dependency/guava-21.0.jar minecraft/libraries/com/google/guava/21.0/
mkdir minecraft/libraries/org/ow2
mkdir minecraft/libraries/org/ow2/asm
mkdir minecraft/libraries/org/ow2/asm/asm
mkdir minecraft/libraries/org/ow2/asm/asm/8.0
mkdir minecraft/libraries/org/ow2/asm/asm-{util,tree,analysis,commons}
mkdir minecraft/libraries/org/ow2/asm/asm-{util,tree,analysis,commons}/8.0
mv target/dependency/asm-8.0.jar minecraft/libraries/org/ow2/asm/asm/8.0/
mv target/dependency/asm-util-8.0.jar minecraft/libraries/org/ow2/asm/asm-util/8.0/
mv target/dependency/asm-tree-8.0.jar minecraft/libraries/org/ow2/asm/asm-tree/8.0/
mv target/dependency/asm-analysis-8.0.jar minecraft/libraries/org/ow2/asm/asm-analysis/8.0/
mv target/dependency/asm-commons-8.0.jar minecraft/libraries/org/ow2/asm/asm-commons/8.0/