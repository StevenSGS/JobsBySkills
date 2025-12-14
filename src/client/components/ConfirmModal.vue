<template>
  <div v-if="show" class="modal-overlay" @click.self="cancel">
    <div class="modal-container">
      <div class="modal-header">
        <h3>{{ title }}</h3>
        <button class="close-btn" @click="cancel">&times;</button>
      </div>
      <div class="modal-body">
        <p>{{ message }}</p>
        <input 
          v-if="requireConfirmText" 
          v-model="confirmInput" 
          :placeholder="`Escribe '${confirmText}' para confirmar`"
          class="confirm-input"
        />
      </div>
      <div class="modal-footer">
        <BaseButton type="secondary" @click="cancel">{{ cancelText }}</BaseButton>
        <BaseButton 
          :type="variant === 'danger' ? 'danger' : 'primary'" 
          @click="confirm"
          :disabled="requireConfirmText && confirmInput !== confirmText"
        >
          {{ confirmButtonText }}
        </BaseButton>
      </div>
    </div>
  </div>
</template>

<script>
import BaseButton from './BaseButton.vue';

export default {
  name: 'ConfirmModal',
  components: { BaseButton },
  props: {
    show: { type: Boolean, default: false },
    title: { type: String, default: 'Confirmar acción' },
    message: { type: String, required: true },
    confirmButtonText: { type: String, default: 'Confirmar' },
    cancelText: { type: String, default: 'Cancelar' },
    variant: { type: String, default: 'primary' },
    requireConfirmText: { type: Boolean, default: false },
    confirmText: { type: String, default: 'ELIMINAR' }
  },
  data() {
    return {
      confirmInput: ''
    };
  },
  watch: {
    show(newVal) {
      if (!newVal) {
        this.confirmInput = '';
      }
    }
  },
  methods: {
    confirm() {
      if (this.requireConfirmText && this.confirmInput !== this.confirmText) {
        return;
      }
      this.$emit('confirm');
    },
    cancel() {
      this.$emit('cancel');
    }
  }
};
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-container {
  background-color: var(--color-card-bg);
  border-radius: 8px;
  max-width: 500px;
  width: 90%;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid var(--color-border);
}

.modal-header h3 {
  margin: 0;
  color: var(--color-text);
}

.close-btn {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: var(--color-text);
  opacity: 0.7;
  transition: opacity 0.2s;
}

.close-btn:hover {
  opacity: 1;
}

.modal-body {
  padding: 1.5rem;
}

.modal-body p {
  margin: 0 0 1rem 0;
  color: var(--color-text);
}

.confirm-input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid var(--color-border);
  border-radius: 4px;
  font-size: 1rem;
  background-color: var(--color-background);
  color: var(--color-text);
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  padding: 1.5rem;
  border-top: 1px solid var(--color-border);
}
</style>
