<template>
  <div class="blog-post-view container">
    <BaseCard v-if="post">
      <div class="post-header">
        <h1>{{ post.title }}</h1>
        <p class="post-meta">Por {{ post.author }} el {{ post.date }}</p>
      </div>
      <div class="post-body" v-html="post.content"></div>
      <div class="back-to-blog">
        <router-link to="/blog">
          <BaseButton type="text">&larr; Volver al Blog</BaseButton>
        </router-link>
      </div>
    </BaseCard>
    <div v-else class="loading-message">
      Cargando artículo...
    </div>
  </div>
</template>

<script>
import BaseCard from '../components/BaseCard.vue';
import BaseButton from '../components/BaseButton.vue';

export default {
  name: 'BlogPostView',
  components: {
    BaseCard,
    BaseButton,
  },
  data() {
    return {
      post: null,
    };
  },
  async created() {
    const postId = parseInt(this.$route.params.id);
    try {
      const res = await fetch(`/api/blog/${postId}`);
      if (res.ok) {
        this.post = await res.json();
      }
    } catch (err) {
      console.error('Error loading blog post:', err);
    }
  },
};
</script>

<style scoped>
.blog-post-view {
  max-width: 800px;
  margin: 2rem auto;
}

.post-header {
  text-align: center;
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid var(--color-border);
}

.post-header h1 {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
}

.post-meta {
  font-size: 1rem;
  color: var(--color-text);
  opacity: 0.8;
}

.post-body {
  line-height: 1.8;
  font-size: 1.1rem;
}

.post-body :deep(h3) {
  font-size: 1.5rem;
  margin-top: 2rem;
  margin-bottom: 1rem;
}

.post-body :deep(p) {
  margin-bottom: 1rem;
}

.back-to-blog {
  margin-top: 2rem;
  text-align: center;
}

.loading-message {
  text-align: center;
  font-size: 1.2rem;
  padding: 2rem;
}
</style>
