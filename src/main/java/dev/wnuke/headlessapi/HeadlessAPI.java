package dev.wnuke.headlessapi;

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
                exchange.sendResponseHeaders(405, -1);// 405 Method Not Allowed
            }
            exchange.close();
        }));
        server.setExecutor(null); // creates a default executor
        server.start();
    }

    public void consoleScanner() throws IOException {
        while (true) {
            String consoleLine = System.console().readLine();
            if (!consoleLine.matches("\\[..:..:..\\] \\[.*\\/.*\\]:.*")) {
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
                try {
                    consoleScanner();
                    System.out.println("Console reader started.");
                } catch (IOException ioException) {
                    ioException.printStackTrace();
                }
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
