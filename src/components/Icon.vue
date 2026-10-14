<script setup vapor lang="ts">
import { icons } from '../icons';

const props = defineProps<{ name: string; size?: number }>();

const source = () => {
  const icon = icons[props.name];

  if (!icon) {
    return '';
  }

  return `data:image/svg+xml,${encodeURIComponent(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" fill="${'#d3cce8'}">${icon}</svg>`)}`;
};
</script>

<template>
  <span
    :style="{
      maskImage: `url('${source()}')`,
      width: `${size ?? 20}px`,
      height: `${size ?? 20}px`,
    }"
    aria-hidden="true"
    class="icon"
  ></span>
</template>
