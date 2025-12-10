import { computed } from 'vue';
import { useRouter } from 'vue-router';
import authStore from '../store/authStore';

export function useAuth() {
  const router = useRouter();
  
  const isAuthenticated = computed(() => authStore.state.isLoggedIn);
  const userType = computed(() => authStore.state.userType);
  const userId = computed(() => authStore.state.userData?.id);
  const userData = computed(() => authStore.state.userData);
  
  const requireAuth = (type = null) => {
    if (!isAuthenticated.value) {
      router.push('/login');
      return false;
    }
    if (type && userType.value !== type) {
      router.push('/');
      return false;
    }
    return true;
  };
  
  return {
    isAuthenticated,
    userType,
    userId,
    userData,
    requireAuth
  };
}
