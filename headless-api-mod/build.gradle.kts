plugins {
    id("java")
    id("fabric-loom") version "0.4-SNAPSHOT"
}

version = "1.0.0"
group = "dev.wnuke"

java {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}

base {
    archivesBaseName = "headless-api"
}

dependencies {
    minecraft(group = "com.mojang", name = "minecraft", version = "1.15.2")
    mappings(group = "net.fabricmc", name = "yarn", version = "1.15.2+build.17", classifier = "v2")

    modImplementation(group = "net.fabricmc", name = "fabric-loader", version = "0.8.9+build.203")

    // Fabric API. This is technically optional, but you probably want it anyway.
    modImplementation(group = "net.fabricmc.fabric-api", name = "fabric-api", version = "0.14.0+build.317-1.15")
}

tasks {
    named<ProcessResources>("processResources") {
        include("fabric.mod.json")
        include("headlessapi.mixins.json")
    }
}
