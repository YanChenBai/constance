<script setup vapor lang="ts">
import { ref, onBeforeUnmount } from 'vue';

import Icon from '../Icon.vue';
const toast = ref('');
let toastTimer: ReturnType<typeof setTimeout>;

const colors = [
  { name: '曜石黑', en: 'Obsidian', value: '#000000', role: '全局背景 · 70%' },
  { name: '夜幕灰', en: 'Nightfall', value: '#111116', role: '组件表面 · 18%' },
  { name: '鸢尾紫', en: 'Iris', value: '#A996EA', role: '品牌主色 · 7%' },
  { name: '幽焰青', en: 'Ghostfire', value: '#67DDE8', role: '焦点强调 · 2%' },
  { name: '月光白', en: 'Moonlight', value: '#EDEAF5', role: '主要文字 · 3%' },
];

async function copyColor(value: string) {
  try {
    await navigator.clipboard.writeText(value);
    toast.value = `已复制 ${value}`;
  } catch {
    toast.value = '无法复制，请手动选择色值';
  }

  clearTimeout(toastTimer);

  toastTimer = setTimeout(() => {
    toast.value = '';
  }, 2200);
}

onBeforeUnmount(() => {
  clearTimeout(toastTimer);
});
</script>

<template>
  <section id="colors" class="standard-section">
    <div class="section-heading">
      <div>
        <div class="eyebrow">01 / COLOR PALETTE</div>
        <h2>夜色里的五种语言<span>色彩系统</span></h2>
      </div>
      <span class="section-note">取色于角色，归于纯黑。点击色值即可复制。</span>
    </div>
    <div class="palette">
      <button
        v-for="color in colors"
        :key="color.value"
        class="swatch"
        @click="copyColor(color.value)"
        :aria-label="`复制${color.name} ${color.value}`"
      >
        <div class="swatch-color" :style="{ background: color.value }">
          <span>{{ color.en }}</span>
          <Icon name="copy" :size="17" />
        </div>
        <div class="swatch-info">
          <strong>{{ color.name }}</strong
          ><code>{{ color.value }}</code
          ><span>{{ color.role }}</span>
        </div>
      </button>
    </div>
    <div class="color-note">
      <Icon name="info" :size="17" />
      <p>紫色建立品牌识别，青色只点亮关键交互。大面积保持纯黑，避免光效压过内容。</p>
      <span>70 / 18 / 7 / 2 / 3</span>
    </div>
  </section>
  <div v-if="toast" class="toast" role="status">
    <Icon name="check-circle" :size="18" />{{ toast }}
  </div>
</template>
