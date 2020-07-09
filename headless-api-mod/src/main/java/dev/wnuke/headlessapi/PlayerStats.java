package dev.wnuke.headlessapi;

import com.google.gson.annotations.SerializedName;
import net.minecraft.client.network.ClientPlayerEntity;

public class PlayerStats {
    @SerializedName("Username")
    String name;
    @SerializedName("UUID")
    String uuid;
    @SerializedName("Player")
    PlayerInfo player;
    @SerializedName("Coordinates")
    Position coordinates;

    public PlayerStats(ClientPlayerEntity player) {
        name = player.getName().asString();
        uuid = player.getUuidAsString();
        this.player = new PlayerInfo();
        this.player.health = player.getHealth();
        this.player.hunger = player.getHungerManager().getFoodLevel();
        this.player.saturation = player.getHungerManager().getSaturationLevel();
        coordinates = new Position(player.getX(), player.getY(), player.getZ());
    }

    private static class PlayerInfo {
        @SerializedName("Health")
        float health;
        @SerializedName("Hunger")
        float hunger;
        @SerializedName("Saturation")
        float saturation;
    }

    private static class Position {
        @SerializedName("X")
        double x;
        @SerializedName("Y")
        double y;
        @SerializedName("Z")
        double z;

        public Position(double x, double y, double z) {
            this.x = x;
            this.y = y;
            this.z = z;
        }
    }
}
