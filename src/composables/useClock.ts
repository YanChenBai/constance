import { computed, onMounted, onBeforeUnmount, ref } from 'vue';

export function useClock() {
  const now = ref(new Date());
  let timer: ReturnType<typeof setInterval>;

  const time = computed(() =>
    now.value.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit' }),
  );

  const date = computed(() =>
    now.value.toLocaleDateString('zh-CN', { month: 'long', day: 'numeric', weekday: 'long' }),
  );

  onMounted(() => {
    timer = setInterval(() => {
      now.value = new Date();
    }, 1000);
  });

  onBeforeUnmount(() => {
    clearInterval(timer);
  });

  return { time, date };
}
