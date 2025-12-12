<template>
  <BaseCard class="job-card">
    <router-link :to="cardLink">
      <h3>{{ job.title }}</h3>
      <p class="company-name">{{ job.company }}</p>
      <p class="job-location">{{ job.location }}</p>
      <div class="job-skills">
        <span v-for="skill in job.skills" :key="skill" class="skill-tag">{{ skill }}</span>
      </div>
    </router-link>
  </BaseCard>
</template>

<script>
import BaseCard from './BaseCard.vue';

export default {
  name: 'JobCard',
  components: {
    BaseCard,
  },
  props: {
    job: {
      type: Object,
      required: true,
    },
    customLink: {
      type: [String, Object],
      default: null,
    },
  },
  computed: {
    cardLink() {
      if (this.customLink) {
        return this.customLink;
      }
      return { name: 'JobDetails', params: { id: this.job.id } };
    },
  },
};
</script>

<style scoped>
.job-card {
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.job-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 16px var(--color-card-shadow);
}

.job-card a {
  display: block;
  color: inherit;
  text-decoration: none;
}

.job-card h3 {
  font-size: 1.25rem;
  margin-bottom: 0.5rem;
  color: var(--color-primary);
}

.job-card .company-name {
  font-weight: 500;
  margin-bottom: 0.25rem;
}

.job-card .job-location {
  font-size: 0.9rem;
  color: var(--color-text);
  opacity: 0.8;
  margin-bottom: 1rem;
}

.job-skills {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.skill-tag {
  background-color: var(--color-border);
  color: var(--color-text);
  padding: 0.3rem 0.7rem;
  border-radius: 5px;
  font-size: 0.8rem;
}
</style>
