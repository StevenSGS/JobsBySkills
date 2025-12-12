import { reactive } from 'vue';

const state = reactive({
  state: {
    isAuthenticated: false,
    userType: null,
    userData: null
  },
  
  inactivityTimer: null,
  timeoutMinutes: 30,
});

const methods = {
  login(userData) {
    state.state.isAuthenticated = true;
    state.state.userType = userData.userType;
    state.state.userData = userData;
    
    localStorage.setItem('auth', JSON.stringify({
      isAuthenticated: true,
      userType: userData.userType,
      userData: userData
    }));
    
    this.startInactivityTimer();
  },

  logout() {
    state.state.isAuthenticated = false;
    state.state.userType = null;
    state.state.userData = null;
    
    localStorage.removeItem('auth');
    if (state.inactivityTimer) clearTimeout(state.inactivityTimer);
    
    window.location.href = '/login'; 
  },

  initializeStore() {
    const savedAuth = localStorage.getItem('auth');
    if (savedAuth) {
      try {
        const { isAuthenticated, userType, userData } = JSON.parse(savedAuth);
        if (isAuthenticated) {
          state.state.isAuthenticated = isAuthenticated;
          state.state.userType = userType || userData?.type || userData?.userType;
          state.state.userData = userData;
          
          if (!state.state.userType) {
             console.warn('Invalid session found (no userType). Clearing auth.');
             this.logout();
             return;
          }

          if (state.state.userData && !state.state.userData.userType) {
             state.state.userData.userType = state.state.userType;
          }

          this.startInactivityTimer();
        }
      } catch (e) {
        console.error('Error parsing auth:', e);
        localStorage.removeItem('auth');
        this.logout();
      }
    }
    
    this.setupActivityListeners();
  },

  setupActivityListeners() {
    const resetTimer = () => this.resetInactivityTimer();
    window.addEventListener('mousemove', resetTimer);
    window.addEventListener('keydown', resetTimer);
    window.addEventListener('click', resetTimer);
    window.addEventListener('scroll', resetTimer);
  },

  startInactivityTimer() {
    if (state.inactivityTimer) clearTimeout(state.inactivityTimer);
    if (!state.state.isAuthenticated) return;

    state.inactivityTimer = setTimeout(() => {
      this.handleSessionTimeout();
    }, state.timeoutMinutes * 60 * 1000);
  },

  resetInactivityTimer() {
    if (state.state.isAuthenticated) {
      this.startInactivityTimer();
    }
  },

  handleSessionTimeout() {
    if (state.state.isAuthenticated) {
      alert('Tu sesión ha expirado por inactividad.');
      this.logout();
    }
  },

  updateUserSession(updates) {
    if (!state.state.isAuthenticated) return;
    
    const newUserData = { ...state.state.userData, ...updates };
    state.state.userData = newUserData;
    
    const authData = JSON.parse(localStorage.getItem('auth') || '{}');
    authData.userData = newUserData;
    localStorage.setItem('auth', JSON.stringify(authData));
  }
};

export default {
  state: state.state,
  methods,
};
