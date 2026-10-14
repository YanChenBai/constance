<script setup vapor lang="ts">
import { animate } from 'motion-v';
import { ref, nextTick, onMounted, onBeforeUnmount } from 'vue';

import { searchEngines } from '../data/searchEngines';
import Icon from './Icon.vue';

const props = defineProps<{ modelValue: string; options: string[] }>();

const brandNames = Object.fromEntries(searchEngines.map(engine => [engine.name, engine.icon]));

const emit = defineEmits<{ 'update:modelValue': [value: string] }>();
const isOpen = ref(false);
const root = ref<HTMLElement>();
const panel = ref<HTMLElement>();
const trigger = ref<HTMLButtonElement>();
let animation: ReturnType<typeof animate> | undefined;
let isClosing = false;
const reduced = window.matchMedia('(prefers-reduced-motion: reduce)');

async function open() {
  if (isOpen.value && !isClosing) {
    await close();

    return;
  }

  animation?.stop();
  isClosing = false;
  isOpen.value = true;
  await nextTick();

  if (!panel.value) {
    return;
  }

  animation = animate(
    panel.value,
    { opacity: [0, 1], y: [-5, 0] },
    { duration: reduced.matches ? 0 : 0.24, ease: [0.22, 1, 0.36, 1] },
  );
}

async function close() {
  if (!isOpen.value || !panel.value || isClosing) {
    return;
  }

  isClosing = true;
  animation?.stop();

  animation = animate(panel.value, { opacity: 0, y: -4 }, { duration: reduced.matches ? 0 : 0.16 });

  await animation;

  if (!isClosing) {
    return;
  }

  isOpen.value = false;
  isClosing = false;
}

function select(value: string) {
  emit('update:modelValue', value);
  void close();
  trigger.value?.focus();
}

async function handleKey(event: KeyboardEvent) {
  if (event.key === 'Escape') {
    event.stopPropagation();
    void close();
    trigger.value?.focus();

    return;
  }

  if (event.key === 'Tab') {
    void close();

    return;
  }

  if (!['ArrowDown', 'ArrowUp', 'Home', 'End'].includes(event.key)) {
    return;
  }

  event.preventDefault();

  if (!isOpen.value) {
    await open();
  }

  await nextTick();
  const buttons = Array.from(panel.value?.querySelectorAll('button') ?? []);
  const index = buttons.indexOf(document.activeElement as HTMLButtonElement);
  let next = event.key === 'ArrowUp' ? index - 1 : index + 1;

  if (event.key === 'Home') {
    next = 0;
  }

  if (event.key === 'End') {
    next = buttons.length - 1;
  }

  buttons[(next + buttons.length) % buttons.length]?.focus();
}

function outside(event: PointerEvent) {
  if (event.target instanceof Node && !root.value?.contains(event.target)) {
    void close();
  }
}

onMounted(() => {
  document.addEventListener('pointerdown', outside);
});

onBeforeUnmount(() => {
  animation?.stop();
  document.removeEventListener('pointerdown', outside);
});
</script>

<template>
  <div ref="root" class="engine-select" @keydown="handleKey">
    <button
      ref="trigger"
      class="select-trigger"
      type="button"
      :aria-label="`搜索引擎：${props.modelValue}`"
      aria-haspopup="listbox"
      :aria-expanded="isOpen"
      @click="open"
    >
      <img
        :src="`/engines/${brandNames[props.modelValue]}.svg`"
        width="17"
        height="17"
        alt=""
        class="engine-brand"
      />
    </button>
    <div v-if="isOpen" ref="panel" class="select-panel" role="listbox" aria-label="搜索引擎选项">
      <span class="select-label">搜索引擎</span>
      <button
        v-for="option in props.options"
        :key="option"
        type="button"
        role="option"
        :aria-selected="option === props.modelValue"
        :class="{ selected: option === props.modelValue }"
        @click="select(option)"
      >
        <span class="option-content"
          ><img
            :src="`/engines/${brandNames[option]}.svg`"
            width="16"
            height="16"
            alt=""
            class="engine-brand"
          />{{ option }}</span
        ><Icon v-if="option === props.modelValue" name="check" :size="15" />
      </button>
    </div>
  </div>
</template>
