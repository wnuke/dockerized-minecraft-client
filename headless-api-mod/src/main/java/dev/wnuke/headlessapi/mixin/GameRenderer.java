package dev.wnuke.headlessapi.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(net.minecraft.client.render.GameRenderer.class)
public class GameRenderer {
    @Inject(method = "render", at = @At("HEAD"), cancellable = true)
    public void render(float tickDelta, long startTime, boolean tick, CallbackInfo ci) {
        ci.cancel();
    }
}
