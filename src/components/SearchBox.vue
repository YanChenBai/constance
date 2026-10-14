<script setup vapor lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue';

import { searchEngines } from '../data/searchEngines';
import EngineSelect from './EngineSelect.vue';
import Icon from './Icon.vue';

const isFocused = defineModel<boolean>('focused', { default: false });
const props = defineProps<{ placeholder?: string }>();
const engine = ref('Google');
const query = ref('');
const input = ref<HTMLInputElement>();
const engines = searchEngines.map(item => item.name);

function search() {
  const provider = searchEngines.find(item => item.name === engine.value);

  if (!provider || !query.value.trim()) {
    return;
  }

  window.open(
    provider.url + encodeURIComponent(query.value.trim()),
    '_blank',
    'noopener,noreferrer',
  );
}

function handleKey(event: KeyboardEvent) {
  if (event.key === 'Escape') {
    input.value?.blur();
  }

  if ((event.metaKey || event.ctrlKey) && event.key === 'k') {
    event.preventDefault();
    input.value?.focus();
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKey);
});

onBeforeUnmount(() => {
  window.removeEventListener('keydown', handleKey);
});
</script>

<template>
  <form class="search-form" @submit.prevent="search">
    <EngineSelect v-model="engine" :options="engines" />
    <input
      ref="input"
      v-model="query"
      class="search-input"
      :placeholder="props.placeholder ?? '搜索你感兴趣的内容'"
      aria-label="搜索内容"
      @focus="isFocused = true"
      @blur="isFocused = false"
    />
    <button class="search-submit" aria-label="搜索">
      <Icon name="magnifying-glass" :size="21" />
    </button>
  </form>
</template>
