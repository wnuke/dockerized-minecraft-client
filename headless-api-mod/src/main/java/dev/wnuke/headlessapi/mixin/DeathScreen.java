package dev.wnuke.headlessapi.mixin;

import net.minecraft.client.MinecraftClient;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(net.minecraft.client.gui.screen.DeathScreen.class)
public class DeathScreen {
    @Inject(method = "render", at = @At("HEAD"))
    public void render(int mouseX, int mouseY, float delta, CallbackInfo ci) {
        if (MinecraftClient.getInstance().player != null) {
            MinecraftClient.getInstance().player.requestRespawn();
            MinecraftClient.getInstance().openScreen(null);
        }
    }
}
