package dev.wnuke.headlessapi;

import net.fabricmc.api.ModInitializer;
import net.minecraft.client.MinecraftClient;

import java.io.IOException;
import java.util.ArrayList;

public class HeadlessAPI implements ModInitializer {
    public static final MinecraftClient mc = MinecraftClient.getInstance();
    public static ArrayList<String> chatMessages = new ArrayList<>();

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
                try {
                    System.out.println("Starting web server...");
                    new HttpApiServer();
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

