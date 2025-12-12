<template>
  <div id="app-container">
    <Navbar />
    <main class="main-content">
      <router-view />
    </main>
  </div>
</template>

<script>
import Navbar from './components/Navbar.vue';
import authStore from './store/authStore';

export default {
  name: 'App',
  components: {
    Navbar,
  },
  mounted() {
    authStore.methods.initializeStore();
  }
};
</script>

<style scoped>
#app-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.main-content {
  flex: 1;
  padding-top: 2rem;
  padding-bottom: 2rem;
}
</style>
