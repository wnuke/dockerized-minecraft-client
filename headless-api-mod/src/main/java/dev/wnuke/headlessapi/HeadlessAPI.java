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
                }
            }
        }
    }

    public void onInitialize() {
        Thread api = new Thread("HTTP-API") {
            @Override
            public void run() {
                try {
                    new HttpApiServer();
                } catch (IOException ioException) {
                    ioException.printStackTrace();
                }
            }
        };
        api.start();
        Thread console = new Thread("Console") {
            @Override
            public void run() {
                consoleScanner();
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

