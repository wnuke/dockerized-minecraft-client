package dev.wnuke.headlessapi;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.annotations.SerializedName;
import net.fabricmc.api.ModInitializer;

import static java.util.stream.Collectors.groupingBy;
import static java.util.stream.Collectors.mapping;
import static java.util.stream.Collectors.toList;

import java.io.*;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import com.sun.net.httpserver.HttpServer;
import net.minecraft.client.MinecraftClient;
import net.minecraft.client.network.ClientPlayerEntity;

public class HeadlessAPI implements ModInitializer {
    private static final MinecraftClient mc = MinecraftClient.getInstance();

    public static Map<String, List<String>> splitQuery(String query) {
        if (query == null || "".equals(query)) {
            return
                    Collections.emptyMap();
        }

        return Pattern.compile("&").splitAsStream(query)
                .map(s -> Arrays.copyOf(s.split("="), 2))
                .collect(groupingBy(s -> decode(s[0]), mapping(s -> decode(s[1]), toList())));

    }

    private static String decode(final String encoded) {
        try {
            return encoded == null ? null : URLDecoder.decode(encoded, "UTF-8");
        } catch (final UnsupportedEncodingException e) {
            throw new RuntimeException("UTF-8 is a required encoding", e);
        }
    }

    public void apiServer() throws IOException {
        int serverPort = 8000;
        HttpServer server = HttpServer.create(new InetSocketAddress(serverPort), 0);
        server.createContext("/mc", (exchange -> {
            if ("GET".equals(exchange.getRequestMethod())) {
                Map<String, List<String>> params = splitQuery(exchange.getRequestURI().getRawQuery());
                String command = params.getOrDefault("msg", Collections.singletonList("")).stream().findFirst().orElse("");
                String response;
                if (!command.equals("")) {
                    if (mc.player != null) {
                        if (mc.player.getHealth() >= 0) {
                            mc.player.requestRespawn();
                            try {
                                this.wait(1000);
                            } catch (InterruptedException e) {
                                e.printStackTrace();
                            }
                        }
                        mc.player.sendChatMessage(command);
                        response = command + " : Sent.\n";
                    } else {
                        response = "Not in a world or server.\n";
                    }
                } else {
                    response = "Invalid request.\n";
                }
                exchange.sendResponseHeaders(200, response.getBytes().length);
                OutputStream output = exchange.getResponseBody();
                output.write(response.getBytes());
                output.flush();
            } else {
                exchange.sendResponseHeaders(405, -1);
            }
            exchange.close();
        }));
        /*server.createContext("/chat", (exchange -> {
            if ("GET".equals(exchange.getRequestMethod())) {
                StringBuilder messages = new StringBuilder();
                //TODO: get chat messages
                exchange.sendResponseHeaders(200, messages.toString().getBytes().length);
                OutputStream output = exchange.getResponseBody();
                output.write(messages.toString().getBytes());
                output.flush();
            } else {
                exchange.sendResponseHeaders(405, -1);
            }
            exchange.close();
        }));*/
        server.createContext("/stats", (exchange -> {
            if ("GET".equals(exchange.getRequestMethod())) {
                String message;
                if (mc.player != null) {
                    Gson gson = new GsonBuilder().serializeNulls().create();
                    PlayerStats player = new PlayerStats(mc.player);
                    message = gson.toJson(player) + "\n";
                } else {
                    message = "Not in a world or server.\n";
                }
                exchange.sendResponseHeaders(200, message.getBytes().length);
                OutputStream output = exchange.getResponseBody();
                output.write(message.getBytes());
                output.flush();
            } else {
                exchange.sendResponseHeaders(405, -1);
            }
            exchange.close();
        }));
        server.setExecutor(null);
        server.start();
    }

    private static class PlayerStats {
        @SerializedName("Username")
        String name;
        @SerializedName("UUID")
        String uuid;
        @SerializedName("Player")
        PlayerInfo player;
        @SerializedName("Coordinates")
        Position coords;

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

        public PlayerStats(ClientPlayerEntity player) {
            name = player.getName().asString();
            uuid = player.getUuidAsString();
            this.player = new PlayerInfo();
            this.player.health = player.getHealth();
            this.player.hunger = player.getHungerManager().getFoodLevel();
            this.player.saturation = player.getHungerManager().getSaturationLevel();
            coords = new Position(player.getX(), player.getY(), player.getZ());
        }
    }

    public void consoleScanner() {
        while (true) {
            String consoleLine = System.console().readLine();
            if (!consoleLine.matches("\\[..:..:..\\] \\[.*\\/.*\\]:.*")) {
                if (consoleLine.equals("kill-game")) {
                    mc.stop();
                    break;
                }
                if (mc.player != null) {
                    mc.player.sendChatMessage(consoleLine);
                } else {
                    System.out.println("Not in a world or server.");
                }
            }
        }
    }

    public void onInitialize() {
        Thread api = new Thread("HTTP-API") {
            @Override
            public void run() {
                System.out.println("Starting web server...");
                try {
                    apiServer();
                    System.out.println("Web server started.");
                } catch (IOException ioException) {
                    ioException.printStackTrace();
                }
            }
        };
        api.start();
        Thread console = new Thread("Console") {
            @Override
            public void run() {
                System.out.println("Starting console reader...");
                consoleScanner();
                System.out.println("Console reader started.");
            }
        };
        console.start();
        System.out.println("--------------------------");
        System.out.println();
        System.out.println("Headless MC loaded!");
        System.out.println();
        System.out.println("--------------------------");
    }
}
