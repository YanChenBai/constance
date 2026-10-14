<script setup vapor lang="ts">
import dahliaImage from '../../assets/images/dahlia.webp';
import { router } from '../../router';
import Atmosphere from '../Atmosphere.vue';
import Icon from '../Icon.vue';
const props = defineProps<{ isAnimated: boolean; intensity: number }>();
const emit = defineEmits<{ status: [value: string] }>();

function openStart() {
  void router.push('/');
}

function navigate(id: string) {
  document.getElementById(id)?.scrollIntoView({
    behavior: window.matchMedia('(prefers-reduced-motion: reduce)').matches ? 'instant' : 'smooth',
  });
}
</script>

<template>
  <section id="overview" class="overview">
    <div class="hero">
      <Atmosphere
        :enabled="props.isAnimated"
        :intensity="props.intensity"
        @status="emit('status', $event)"
      />
      <img :src="dahliaImage" class="hero-art" alt="大丽花角色立绘，月光下的紫衣与青色幽焰" />
      <div class="hero-content">
        <div class="eyebrow reveal"><span></span> CONSTANCE VISUAL LANGUAGE</div>
        <h1 class="reveal">
          黑曜夜庭<span>Quiet by nature.<br />Yours by design.</span>
        </h1>
        <p class="hero-description reveal">
          让喧嚣止于此，让灵感从这里开始。<br />以深邃的黑、温柔的紫与一缕幽焰，构筑你的起始页。
        </p>
        <div class="hero-actions reveal">
          <button class="button button-primary" @click="openStart">
            走进夜庭
            <Icon name="arrow-right" :size="18" /></button
          ><button class="text-button" @click="navigate('colors')">
            探索设计语言
            <Icon name="arrow-down" :size="16" />
          </button>
        </div>
      </div>
      <div class="art-caption">
        <span>CHARACTER STUDY / 01</span><strong>The Dahlia</strong><span>鸢尾 · 月光 · 幽焰</span>
      </div>
      <div class="hero-footer">
        <span><span class="status-dot"></span> DARKNESS, WITH A LITTLE LIGHT.</span
        ><span>视觉基调 / 黑曜夜庭</span>
      </div>
    </div>
    <div class="principles">
      <div>
        <span class="index">01</span>
        <div>
          <h3>黑，是留白</h3>
          <p>纯黑基底，让内容与角色自然浮现。</p>
        </div>
      </div>
      <div>
        <span class="index">02</span>
        <div>
          <h3>色彩，有分寸</h3>
          <p>以紫为韵，以青为光，克制而有记忆点。</p>
        </div>
      </div>
      <div>
        <span class="index">03</span>
        <div>
          <h3>动，而不扰</h3>
          <p>缓慢流动的光雾，陪伴每一次开始。</p>
        </div>
      </div>
    </div>
  </section>
</template>
