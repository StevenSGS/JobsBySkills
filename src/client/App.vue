<script setup>
import HelloWorld from './components/HelloWorld.vue'
</script>

<template>
  <div class="logo-container">
    <a href="https://vitejs.dev" target="_blank">
      <img src="/vite.svg" class="logo" alt="Vite logo" />
    </a>
    <span class="plus">+</span>
    <a href="https://vuejs.org/" target="_blank">
      <img src="/vue.svg" class="logo vue" alt="Vue logo" />
    </a>
  </div>
  <HelloWorld msg="Servidor JobsBySkills activo." />
</template>

<style scoped>
.logo-container {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1.5em;
  margin-bottom: 2rem;
}

.plus {
  font-size: 2.5em;
  color: #cfcfcf;
}

.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>