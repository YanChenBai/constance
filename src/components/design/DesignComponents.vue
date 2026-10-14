<script setup vapor lang="ts">
import { useClock } from '../../composables/useClock';
import { router } from '../../router';
import Icon from '../Icon.vue';
import SearchBox from '../SearchBox.vue';
const isAnimated = defineModel<boolean>('isAnimated', { required: true });
const { time, date } = useClock();

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
  <section id="components" class="standard-section">
    <div class="section-heading">
      <div>
        <div class="eyebrow">03 / COMPONENTS</div>
        <h2>简单的界面，完整的细节<span>界面组件</span></h2>
      </div>
      <span class="section-note">低对比边界 · 温柔圆角 · 明确的焦点</span>
    </div>
    <div class="component-grid">
      <div class="component-card search-card">
        <div class="card-kicker">SEARCH / 搜索 <span>01</span></div>
        <SearchBox />
        <div class="component-description">
          <span>默认 / 悬停 / 聚焦</span><span>高度 46 · 胶囊圆角</span>
        </div>
      </div>
      <div class="component-card">
        <div class="card-kicker">BUTTONS / 按钮 <span>02</span></div>
        <div class="button-examples">
          <button class="button button-primary" @click="openStart">
            开启新旅程
            <Icon name="arrow-up-right" :size="17" /></button
          ><button class="button" @click="navigate('motion')">探索更多</button
          ><button
            class="icon-button"
            aria-label="开关背景动画"
            :aria-pressed="isAnimated"
            @click="isAnimated = !isAnimated"
          >
            <Icon name="sparkle" />
          </button>
        </div>
        <div class="component-description">
          <span>主要 / 次要 / 图标</span><span>高度 44 · 圆角 16</span>
        </div>
      </div>
      <div class="component-card clock-card">
        <div class="card-kicker">TIME / 时间 <span>04</span></div>
        <div class="clock-specimen">
          {{ time }}<span>{{ date }}</span>
        </div>
        <div class="component-description">
          <span>安静的存在，不抢夺注意力</span><span>等宽数字 · 实时时钟</span>
        </div>
      </div>
    </div>
  </section>
</template>
