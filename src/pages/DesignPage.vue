<script setup vapor lang="ts">
import { animate, stagger } from 'motion-v';
import { ref, onMounted, onBeforeUnmount } from 'vue';

import DesignComponents from '../components/design/DesignComponents.vue';
import DesignHero from '../components/design/DesignHero.vue';
import DesignMotion from '../components/design/DesignMotion.vue';
import DesignPalette from '../components/design/DesignPalette.vue';
import DesignTypography from '../components/design/DesignTypography.vue';
import Icon from '../components/Icon.vue';
import { router } from '../router';
const isAnimated = ref(true);
const intensity = ref(0.85);
const gpuStatus = ref('背景初始化中');
const root = ref<HTMLElement>();
let entrance: ReturnType<typeof animate> | undefined;

onMounted(() => {
  if (root.value && !window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    entrance = animate(
      root.value.querySelectorAll('.reveal'),
      { opacity: [0, 1], y: [16, 0] },
      { duration: 0.8, delay: stagger(0.09) },
    );
  }
});

onBeforeUnmount(() => {
  entrance?.stop();
});
</script>
<template>
  <div ref="root" class="page-body">
    <header class="topbar">
      <div class="breadcrumb">Constance <span>/</span><strong>设计标准</strong></div>
      <div class="topbar-actions">
        <span class="edition">THE DAHLIA / 001</span
        ><button class="button button-small" @click="router.push('/')">
          起始页<Icon name="arrow-up-right" :size="15" />
        </button>
      </div>
    </header>
    <main>
      <DesignHero
        :is-animated="isAnimated"
        :intensity="intensity"
        @status="gpuStatus = $event"
      /><DesignPalette /><DesignTypography /><DesignComponents
        v-model:is-animated="isAnimated"
      /><DesignMotion
        v-model:is-animated="isAnimated"
        v-model:intensity="intensity"
        :gpu-status="gpuStatus"
      />
      <footer class="page-footer">
        <a href="#overview">constance.</a><span>DESIGNED FOR A QUIETER WEB.</span
        ><span>黑曜夜庭 / DESIGN STANDARD 0.1</span>
      </footer>
    </main>
  </div>
</template>
