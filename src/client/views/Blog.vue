<template>
  <div class="blog-view container">
    <h1>Nuestro Blog</h1>
    <p class="subtitle">Consejos, tendencias y noticias del mundo profesional y tecnológico.</p>

    <div class="blog-posts-grid">
      <BaseCard v-for="post in blogPosts" :key="post.id" class="post-card">
        <div class="post-content">
          <router-link :to="{ name: 'BlogPost', params: { id: post.id } }" class="post-title-link">
            <h2>{{ post.title }}</h2>
          </router-link>
          <p class="post-meta">Por {{ post.author }} el {{ post.date }}</p>
          <p class="post-excerpt">{{ post.excerpt }}</p>
          <router-link :to="{ name: 'BlogPost', params: { id: post.id } }">
            <BaseButton type="text">Leer Más &rarr;</BaseButton>
          </router-link>
        </div>
      </BaseCard>
    </div>
  </div>
</template>

<script>
import BaseCard from '../components/BaseCard.vue';
import BaseButton from '../components/BaseButton.vue';

export default {
  name: 'BlogView',
  components: {
    BaseCard,
    BaseButton,
  },
  data() {
    return {
      blogPosts: [],
    };
  },
  async mounted() {
    try {
      const res = await fetch('/api/blog');
      this.blogPosts = await res.json();
    } catch (err) {
      console.error('Error loading blog posts:', err);
    }
  },
};
</script>

<style scoped>
.blog-view {
  padding-top: 2rem;
  padding-bottom: 4rem;
}

.blog-view h1 {
  font-size: 2.5rem;
  text-align: center;
  margin-bottom: 0.5rem;
}

.blog-view .subtitle {
  font-size: 1.2rem;
  text-align: center;
  margin-bottom: 3rem;
  color: var(--color-text);
  opacity: 0.8;
}

.blog-posts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 2rem;
}

.post-card {
  display: flex;
  flex-direction: column;
}

.post-content {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.post-title-link {
  text-decoration: none;
}

.post-content h2 {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
  color: var(--color-primary);
  transition: color 0.2s ease;
}

.post-title-link:hover h2 {
  color: var(--color-primary-hover);
}

.post-meta {
  font-size: 0.9rem;
  color: var(--color-text);
  opacity: 0.7;
  margin-bottom: 1rem;
}

.post-excerpt {
  flex-grow: 1;
  margin-bottom: 1.5rem;
}

.post-content .base-button {
  align-self: flex-start;
  padding-left: 0;
}
</style>