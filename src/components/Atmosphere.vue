<script setup vapor lang="ts">
import { init, surface, effect, frameLoop, clock, frame } from 'vgpu';
import type { Gpu, FrameLoopHandle } from 'vgpu';
import { onMounted, onBeforeUnmount, ref, watch } from 'vue';

import shader from '../shaders/atmosphere.wgsl';

const props = defineProps<{ enabled: boolean; intensity: number }>();
const emit = defineEmits<{ status: [value: string] }>();
const canvas = ref<HTMLCanvasElement>();
let gpu: Gpu | undefined;
let loop: FrameLoopHandle | undefined;
let redraw: (() => void) | undefined;
let start: (() => void) | undefined;
let isDisposed = false;
const reduced = window.matchMedia('(prefers-reduced-motion: reduce)');

function syncPlayback() {
  loop?.stop();

  if (!document.hidden && props.enabled && !reduced.matches) {
    start?.();
  } else {
    redraw?.();
  }
}

onMounted(async () => {
  if (!navigator.gpu || !canvas.value) {
    emit('status', '静态黑底');

    return;
  }

  try {
    const context = await init();

    if (isDisposed) {
      context.dispose();

      return;
    }

    gpu = context;
    const target = surface(context, canvas.value, { dpr: [1, 1.5] });

    const atmosphere = effect(context, shader, {
      set: { atmosphere: { time: 0, intensity: props.intensity, resolution: target.size } },
    });

    await atmosphere.compile(target);

    if (isDisposed) {
      return;
    }

    const time = clock(context);

    const draw = () => {
      atmosphere.set({
        atmosphere: { time: time.time, intensity: props.intensity, resolution: target.size },
      });
    };

    redraw = () => {
      draw();

      frame(context, current => {
        current.pass(target, atmosphere);
      });
    };

    start = () => {
      loop = frameLoop(
        context,
        current => {
          draw();
          current.pass(target, atmosphere);
        },
        { fps: 60 },
      );
    };

    emit('status', 'WebGPU 已就绪');
    syncPlayback();
  } catch (error) {
    console.warn('夜庭背景初始化失败，使用纯黑背景', error);
    gpu?.dispose();
    emit('status', '静态黑底');
  }
});

watch(() => [props.enabled, props.intensity], syncPlayback);
document.addEventListener('visibilitychange', syncPlayback);
reduced.addEventListener('change', syncPlayback);

onBeforeUnmount(() => {
  isDisposed = true;
  loop?.stop();
  gpu?.dispose();
  document.removeEventListener('visibilitychange', syncPlayback);
  reduced.removeEventListener('change', syncPlayback);
});
</script>

<template><canvas ref="canvas" class="atmosphere" aria-hidden="true" /></template>
