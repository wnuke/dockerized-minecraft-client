package dev.wnuke.headlessapi;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;
import net.minecraft.client.network.ClientLoginNetworkHandler;
import net.minecraft.network.ClientConnection;
import net.minecraft.network.NetworkState;
import net.minecraft.network.packet.c2s.handshake.HandshakeC2SPacket;
import net.minecraft.network.packet.c2s.login.LoginHelloC2SPacket;
import net.minecraft.text.LiteralText;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.atomic.AtomicInteger;

import static dev.wnuke.headlessapi.HeadlessAPI.chatMessages;
import static dev.wnuke.headlessapi.HeadlessAPI.mc;

public class HttpApiServer {
    private static AtomicInteger CONNECTOR_THREADS_COUNT;
    private static ClientConnection connection;
    private static String status;
    private static boolean connecting;
    private static Boolean connectGood;

    public HttpApiServer() throws IOException {
        Gson gson = new GsonBuilder().serializeNulls().create();
        int serverPort = 8000;
        HttpServer server = HttpServer.create(new InetSocketAddress(serverPort), 0);
        server.createContext("/sendmsg", (he -> {
            if ("GET".equals(he.getRequestMethod())) {
                String message = he.getRequestURI().getQuery();
                if (!message.equals("")) {
                    if (mc.player != null) {
                        mc.player.sendChatMessage(message);
                        sendOkJsonResponse(gson.toJson("SENT MESSAGE"), he);
                    } else {
                        getCurrentStatus();
                        sendOkJsonResponse(gson.toJson(status), he);
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
        server.createContext("/player", (he -> {
            if ("GET".equals(he.getRequestMethod())) {
                if (mc.player != null) {
                    sendOkJsonResponse(gson.toJson(new PlayerStats(mc.player)), he);
                } else {
                    getCurrentStatus();
                    sendOkJsonResponse(gson.toJson(status), he);
                }
            }
            he.close();
        }));
        server.createContext("/status", (he -> {
            if ("GET".equals(he.getRequestMethod())) {
                getCurrentStatus();
                sendOkJsonResponse(gson.toJson(status), he);
            }
            he.close();
        }));
        server.createContext("/connect", (he -> {
            if ("GET".equals(he.getRequestMethod())) {
                if (connection != null) {
                    connection.disconnect(new LiteralText("LEAVE"));
                }
                sendOkJsonResponse(gson.toJson("CONNECTING TO " + he.getRequestURI().getQuery()), he);
                String[] requestSplit = he.getRequestURI().getQuery().split(":");
                connectToServer(requestSplit[0], Integer.parseInt(requestSplit[1]));
            }
            he.close();
        }));
        server.createContext("/connect", (he -> {
            if ("GET".equals(he.getRequestMethod())) {
                if (connection != null) {
                    connection.disconnect(new LiteralText("LEAVE"));
                }
                sendOkJsonResponse(gson.toJson("DISCONNECTED"), he);
            }
            he.close();
        }));
        server.setExecutor(null);
        server.start();
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

    public void getCurrentStatus() {
        if (mc.getSession() == null) {
            status = "NOT SIGNED IN";
        } else if (connecting) {
            status = "CONNECTING TO SERVER";
         } else if (connectGood != null) {
            if (connectGood) {
                status = "CONNECTION TO SERVER SUCCEEDED";
            } else {
                status = "CONNECTION TO SERVER FAILED";
            }
            connectGood = null;
        } else if (mc.player == null) {
            status = "NOT IN WORLD";
        } else {
            status = "ALL GOOD";
        }
    }

    public void connectToServer(final String address, final int port) {
        System.out.println("Connecting to " + address + " on port: " + port + "...");
        InetAddress inetAddress;
        connecting = true;
        try {
            inetAddress = InetAddress.getByName(address);
            connection = ClientConnection.connect(inetAddress, port, mc.options.shouldUseNativeTransport());
            connection.setPacketListener(new ClientLoginNetworkHandler(connection, mc, null, (text) -> {
                System.out.println(text.asString());
            }));
            connection.send(new HandshakeC2SPacket(address, port, NetworkState.LOGIN));
            connection.send(new LoginHelloC2SPacket(mc.getSession().getProfile()));
            System.out.println("Connected.");
            connectGood = true;
        } catch (Exception e) {
            connectGood = false;
            e.printStackTrace();
        }
        connecting = false;
    }
}
