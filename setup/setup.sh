mkdir $INSTDIR
mv options.txt $INSTDIR/options.txt
mkdir $MCDIR
mkdir $MCDIR/versions
mkdir $MCDIR/versions/fabric-1.15.2
mv fabric-1.15.2.json $MCDIR/versions/fabric-1.15.2/fabric-1.15.2.json
mkdir $MCDIR/libraries
mkdir $MCDIR/libraries/net
mkdir $MCDIR/libraries/net/{tiny-remapper,tiny-mappings-parser,sponge-mixin,intermediary,fabric-loader-sat4j,fabric-loader}
mkdir $MCDIR/libraries/net/tiny-remapper/0.2.2.64
mkdir $MCDIR/libraries/net/tiny-mappings-parser/0.2.2.14
mkdir $MCDIR/libraries/net/sponge-mixin/0.8+build.18
mkdir $MCDIR/libraries/net/intermediary/1.15.2
mkdir $MCDIR/libraries/net/fabric-loader-sat4j/2.3.5.4
mkdir $MCDIR/libraries/net/fabric-loader/0.8.9+build.203
curl https://maven.fabricmc.net/net/tiny-remapper/0.2.2.64/tiny-remapper-0.2.2.64.jar --output $MCDIR/libraries/net/tiny-remapper/0.2.2.64/tiny-remapper-0.2.2.64.jar
curl https://maven.fabricmc.net/net/tiny-mappings-parser/0.2.2.14/tiny-mappings-parser-0.2.2.14.jar --output $MCDIR/libraries/net/tiny-mappings-parser/0.2.2.14/tiny-mappings-parser-0.2.2.14.jar
curl https://maven.fabricmc.net/net/sponge-mixin/0.8+build.18/sponge-mixin-0.8+build.18.jar --output $MCDIR/libraries/net/sponge-mixin/0.8+build.18/sponge-mixin-0.8+build.18.jar
curl https://maven.fabricmc.net/net/intermediary/1.15.2/intermediary-1.15.2.jar --output $MCDIR/libraries/net/intermediary/1.15.2/intermediary-1.15.2.jar
curl https://maven.fabricmc.net/net/fabric-loader-sat4j/2.3.5.4/fabric-loader-sat4j-2.3.5.4.jar --output $MCDIR/libraries/net/fabric-loader-sat4j/2.3.5.4/fabric-loader-sat4j-2.3.5.4.jar
curl https://maven.fabricmc.net/net/fabric-loader/0.8.9+build.203/fabric-loader-0.8.9+build.203.jar --output $MCDIR/libraries/net/fabric-loader/0.8.9+build.203/fabric-loader-0.8.9+build.203.jar
mkdir $MCDIR/libraries/com
mkdir $MCDIR/libraries/com/google
mkdir $MCDIR/libraries/com/google/{jimfs,guava}
mkdir $MCDIR/libraries/com/google/jimfs/1.1
mkdir $MCDIR/libraries/com/google/guava/21.0
curl https://maven.fabricmc.net/com/google/jimfs/1.1/jimfs-1.1.jar --output $MCDIR/libraries/com/google/jimfs/1.1/jimfs-1.1.jar
curl https://maven.fabricmc.net/com/google/guava/21.0/guava-21.0.jar --output $MCDIR/libraries/com/google/guava/21.0/guava-21.0.jar
mkdir $MCDIR/libraries/org
mkdir $MCDIR/libraries/org/ow2
mkdir $MCDIR/libraries/org/ow2/asm
mkdir $MCDIR/libraries/org/ow2/asm/asm
mkdir $MCDIR/libraries/org/ow2/asm/asm/8.0
mkdir $MCDIR/libraries/org/ow2/asm/asm-{util,tree,analysis,commons}
mkdir $MCDIR/libraries/org/ow2/asm/asm-{util,tree,analysis,commons}/8.0
curl https://maven.fabricmc.net/org/ow2/asm/asm/8.0/asm-8.0.jar --output $MCDIR/libraries/org/ow2/asm/asm/8.0/asm-8.0.jar
curl https://maven.fabricmc.net/org/ow2/asm/asm/asm-util/8.0/asm-util-8.0.jar --output $MCDIR/libraries/org/ow2/asm/asm-util/8.0/asm-util-8.0.jar
curl https://maven.fabricmc.net/org/ow2/asm/asm/asm-tree/8.0/asm-tree-8.0.jar --output $MCDIR/libraries/org/ow2/asm/asm-tree/8.0/asm-tree-8.0.jar
curl https://maven.fabricmc.net/org/ow2/asm/asm/asm-analysis/8.0/asm-analysis-8.0.jar --output $MCDIR/libraries/org/ow2/asm/asm-analysis/8.0/asm-analysis-8.0.jar
curl https://maven.fabricmc.net/org/ow2/asm/asm/asm-commons/8.0/asm-commons-8.0.jar --output $MCDIR/libraries/org/ow2/asm/asm-commons/8.0/asm-commons-8.0.jar