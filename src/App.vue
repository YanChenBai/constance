<script setup vapor lang="ts">
import { computed } from 'vue';

import { router } from './router';

// Vue Router 管理导航与路由解析，Vapor 直接挂载页面，避免引入 VDOM RouterView。
const page = computed(() => router.currentRoute.value.matched.at(-1)?.components?.default);
</script>

<template><component :is="page" /></template>
