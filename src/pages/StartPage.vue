<script setup vapor lang="ts">
import { animate, stagger } from 'motion-v';
import { ref, onMounted, onBeforeUnmount } from 'vue';

import Atmosphere from '../components/Atmosphere.vue';
import Icon from '../components/Icon.vue';
import SearchBox from '../components/SearchBox.vue';
import { useClock } from '../composables/useClock';
const isAnimated = ref(true);
const isSearchFocused = ref(false);
const root = ref<HTMLElement>();
const { time, date } = useClock();
let entrance: ReturnType<typeof animate> | undefined;

onMounted(() => {
  if (root.value && !window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    entrance = animate(
      root.value.querySelectorAll('.start-center > *'),
      { opacity: [0, 1], y: [12, 0] },
      { duration: 0.8, delay: stagger(0.1), ease: [0.22, 1, 0.36, 1] },
    );
  }
});

onBeforeUnmount(() => {
  entrance?.stop();
});
</script>
<template>
  <div ref="root" :class="['start-preview', { 'search-focused': isSearchFocused }]">
    <Atmosphere :enabled="isAnimated" :intensity="0.85" />
    <div class="start-center">
      <div class="start-date">{{ date }}</div>
      <div class="start-clock">{{ time }}</div>
      <SearchBox v-model:focused="isSearchFocused" />
    </div>
    <div class="start-ambient-controls">
      <button
        class="icon-button"
        :aria-pressed="isAnimated"
        aria-label="开关背景动画"
        @click="isAnimated = !isAnimated"
      >
        <Icon :name="isAnimated ? 'pause' : 'play'" :size="16" />
      </button>
    </div>
  </div>
</template>
