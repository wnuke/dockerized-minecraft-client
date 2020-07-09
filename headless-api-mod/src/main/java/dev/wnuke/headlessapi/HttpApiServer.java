package dev.wnuke.headlessapi;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import static dev.wnuke.headlessapi.HeadlessAPI.chatMessages;
import static dev.wnuke.headlessapi.HeadlessAPI.mc;
import static java.util.stream.Collectors.*;

public class HttpApiServer {
    public HttpApiServer() throws IOException {
        Gson gson = new GsonBuilder().serializeNulls().create();
        int serverPort = 8000;
        HttpServer server = HttpServer.create(new InetSocketAddress(serverPort), 0);
        server.createContext("/mc", (he -> {
            if ("GET".equals(he.getRequestMethod())) {
                Map<String, List<String>> params = splitQuery(he.getRequestURI().getRawQuery());
                String message = params.getOrDefault("msg", Collections.singletonList("")).stream().findFirst().orElse("");
                if (!message.equals("")) {
                    if (mc.player != null) {
                        mc.player.sendChatMessage(message);
                        he.sendResponseHeaders(204, -1);
                    } else {
                        playerNullResponse(he);
                    }
                } else {
                    he.sendResponseHeaders(400, -1);
                }
            }
            he.close();
        }));
        server.createContext("/chat", (he -> {
            if ("GET".equals(he.getRequestMethod())) {
                sendOkJsonResponse(gson.toJson(chatMessages), he);
            }
            he.close();
        }));
        server.createContext("/stats", (he -> {
            if ("GET".equals(he.getRequestMethod())) {
                if (mc.player != null) {
                    sendOkJsonResponse(gson.toJson(new PlayerStats(mc.player)), he);
                } else {
                    playerNullResponse(he);
                }
            }
            he.close();
        }));
        server.setExecutor(null);
        server.start();
    }

    public static Map<String, List<String>> splitQuery(String query) {
        if (query == null || query.equals("")) {
            return Collections.emptyMap();
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

    public void sendResponse(String message, String type, HttpExchange httpExchange, int header) throws IOException {
        byte[] messageBytes = (message + "\n").getBytes();
        httpExchange.getResponseHeaders().set("Content-Type", type + "; charset=" + StandardCharsets.UTF_8);
        httpExchange.sendResponseHeaders(header, messageBytes.length);
        OutputStream output = httpExchange.getResponseBody();
        output.write(messageBytes);
        output.flush();
    }

    public void sendOkJsonResponse(String message, HttpExchange httpExchange) throws IOException {
        sendResponse(message, "application/json", httpExchange, 200);
    }

    public void playerNullResponse(HttpExchange httpExchange) throws IOException {
        sendResponse("PLAYER NOT CONNECTED TO SERVER", "text/html", httpExchange, 412);
    }
}
