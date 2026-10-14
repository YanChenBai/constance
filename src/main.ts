import { createVaporApp } from 'vue';

import App from './App.vue';

import './style.css';
import { router } from './router';

const app = createVaporApp(App);
app.use(router);
await router.isReady();
app.mount('#app');
