<script setup vapor lang="ts">
import Atmosphere from '../Atmosphere.vue';
import Icon from '../Icon.vue';
const isAnimated = defineModel<boolean>('isAnimated', { required: true });
const intensity = defineModel<number>('intensity', { required: true });
const props = defineProps<{ gpuStatus: string }>();
</script>

<template>
  <section id="motion" class="standard-section">
    <div class="section-heading">
      <div>
        <div class="eyebrow">04 / ATMOSPHERE & MOTION</div>
        <h2>让夜色，轻轻流动<span>氛围与动效</span></h2>
      </div>
      <span class="section-note">慢一点，少一点，恰到好处。</span>
    </div>
    <div class="motion-layout">
      <div class="atmosphere-study">
        <Atmosphere :enabled="isAnimated" :intensity="intensity * 2" /><span class="study-label"
          >GHOSTFIRE / 幽焰光雾</span
        >
        <div>
          <h3>一缕光，足够。</h3>
          <p>低亮度的鸢尾紫雾带，伴随细微青色辉光。<br />让大部分画面，仍然归于黑。</p>
        </div>
        <span class="study-bottom">{{ props.gpuStatus }} <span>60 FPS MAX</span></span>
      </div>
      <div class="motion-controls">
        <div class="card-kicker">MOTION PRINCIPLES / 动效规则</div>
        <div class="control-row">
          <div>
            <strong>流动的夜色</strong>
            <p>关闭后，光雾停留在当前时刻</p>
          </div>
          <button
            :class="['toggle', { on: isAnimated }]"
            role="switch"
            :aria-checked="isAnimated"
            aria-label="流动的夜色"
            @click="isAnimated = !isAnimated"
          >
            <span></span>
          </button>
        </div>
        <label class="intensity-control"
          ><span
            >氛围亮度 <code>{{ Math.round(intensity * 100) }}%</code></span
          ><input v-model.number="intensity" type="range" min="0.2" max="1.4" step="0.05"
        /></label>
        <div class="motion-metrics">
          <div>
            <strong>800<span>ms</span></strong>
            <p>内容渐入</p>
          </div>
          <div>
            <strong>200<span>ms</span></strong>
            <p>交互响应</p>
          </div>
          <div>
            <strong>60<span>fps</span></strong>
            <p>背景帧率上限</p>
          </div>
        </div>
        <p class="motion-accessibility">
          <Icon name="leaf" :size="17" />尊重系统减少动态效果；离开标签页自动暂停。<br />不支持
          WebGPU 时，回归安静的纯黑背景。
        </p>
      </div>
    </div>
  </section>
</template>
