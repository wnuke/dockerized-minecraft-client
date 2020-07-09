package dev.wnuke.headlessapi.mixin;

import dev.wnuke.headlessapi.HeadlessAPI;
import net.minecraft.text.Text;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import java.time.Instant;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

@Mixin(net.minecraft.client.gui.hud.ChatHud.class)
public class ChatHud {
    @Inject(method = "addMessage(Lnet/minecraft/text/Text;)V", at = @At("HEAD"))
    public void addMessage(Text message, CallbackInfo ci) {
        String timeStamp = DateTimeFormatter
                .ofPattern("[HH:mm:ss]")
                .withZone(ZoneOffset.UTC)
                .format(Instant.now());

        HeadlessAPI.chatMessages.add(timeStamp + " " + message.getString());
    }
}
