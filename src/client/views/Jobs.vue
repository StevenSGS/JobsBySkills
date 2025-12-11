<template>
  <div class="jobs-view container">
    <h2>Explora Ofertas de Empleo</h2>

    <div class="search-filter-section">
      <InputField
        id="jobSearch"
        v-model="searchQuery"
        placeholder="Buscar por título, empresa o habilidad..."
        class="search-input"
      />
      <BaseButton type="primary">Buscar</BaseButton>
    </div>

    <div class="job-list">
      <JobCard v-for="job in filteredJobs" :key="job.id" :job="job" />
    </div>
  </div>
</template>

<script>
import JobCard from '../components/JobCard.vue';
import InputField from '../components/InputField.vue';
import BaseButton from '../components/BaseButton.vue';

export default {
  name: 'JobsView',
  components: {
    JobCard,
    InputField,
    BaseButton,
  },
  data() {
    return {
      searchQuery: '',
      allJobs: [],
    };
  },
  async mounted() {
    try {
      const res = await fetch('/api/jobs');
      this.allJobs = await res.json();
    } catch (err) {
      console.error('Error loading jobs:', err);
    }
  },
  computed: {
    filteredJobs() {
      if (!this.searchQuery) {
        return this.allJobs;
      }
      const query = this.searchQuery.toLowerCase();
      return this.allJobs.filter(job =>
        job.title.toLowerCase().includes(query) ||
        job.company.toLowerCase().includes(query) ||
        job.skills.some(skill => skill.toLowerCase().includes(query))
      );
    },
  },
};
</script>

<style scoped>
.jobs-view h2 {
  font-size: 2.5rem;
  margin-bottom: 2rem;
  text-align: center;
  color: var(--color-text);
}

.search-filter-section {
  display: flex;
  gap: 1rem;
  margin-bottom: 2rem;
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
}

.search-input {
  flex-grow: 1;
}

.job-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}
</style>
