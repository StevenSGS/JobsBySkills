
const STORAGE_KEYS = {
  USERS: 'jbs_users',
  COMPANIES: 'jbs_companies',
  JOBS: 'jbs_jobs',
  APPLICATIONS: 'jbs_applications',
  POSTS: 'jbs_posts'
};

const INITIAL_DATA = {
  users: [
    { id: 1, name: 'Juan Pérez', email: 'juan@example.com', type: 'client', bio: 'Desarrollador Web Full Stack', skills: ['JavaScript', 'Vue', 'Node.js'] },
    { id: 2, name: 'Admin User', email: 'admin@example.com', type: 'admin', bio: 'System Administrator', skills: [] }
  ],
  companies: [
    { id: 1, name: 'Tech Solutions', email: 'contact@techsolutions.com', location: 'Ciudad de México', description: 'Empresa líder en desarrollo de software.' },
    { id: 2, name: 'Global Innovations', email: 'info@global.com', location: 'Guadalajara', description: 'Innovación tecnológica al alcance de todos.' }
  ],
  jobs: [
    { id: 1, title: 'Frontend Developer', company: 'Tech Solutions', location: 'Remoto', status: 'Activa', description: 'Buscamos desarrollador Vue.js experimentado.', postedAt: new Date().toISOString() },
    { id: 2, title: 'Backend Engineer', company: 'Global Innovations', location: 'Guadalajara', status: 'Activa', description: 'Experiencia en Node.js y bases de datos SQL.', postedAt: new Date().toISOString() }
  ],
  posts: [
    { id: 1, title: 'El futuro del trabajo remoto', author: 'Juan Pérez', date: new Date().toISOString(), content: 'El trabajo remoto ha llegado para quedarse...' },
    { id: 2, title: 'Vue 3: Novedades', author: 'Admin User', date: new Date().toISOString(), content: 'Composition API cambia las reglas del juego...' }
  ]
};

const localStore = {
  init() {
    if (!localStorage.getItem(STORAGE_KEYS.USERS)) {
      localStorage.setItem(STORAGE_KEYS.USERS, JSON.stringify(INITIAL_DATA.users));
    }
    if (!localStorage.getItem(STORAGE_KEYS.COMPANIES)) {
      localStorage.setItem(STORAGE_KEYS.COMPANIES, JSON.stringify(INITIAL_DATA.companies));
    }
    if (!localStorage.getItem(STORAGE_KEYS.JOBS)) {
      localStorage.setItem(STORAGE_KEYS.JOBS, JSON.stringify(INITIAL_DATA.jobs));
    }
    if (!localStorage.getItem(STORAGE_KEYS.POSTS)) {
      localStorage.setItem(STORAGE_KEYS.POSTS, JSON.stringify(INITIAL_DATA.posts));
    }
  },

  _getAll(key) {
    try {
      return JSON.parse(localStorage.getItem(key)) || [];
    } catch (e) {
      return [];
    }
  },

  _saveAll(key, data) {
    localStorage.setItem(key, JSON.stringify(data));
  },

  _updateItem(key, id, updates) {
    const items = this._getAll(key);
    const index = items.findIndex(i => i.id === id || i.id === parseInt(id));
    if (index !== -1) {
      items[index] = { ...items[index], ...updates };
      this._saveAll(key, items);
      return items[index];
    }
    return null;
  },

  addUser(user) {
    const users = this._getAll(STORAGE_KEYS.USERS);
    users.push(user);
    this._saveAll(STORAGE_KEYS.USERS, users);
    return user;
  },

  getUsers() { return this._getAll(STORAGE_KEYS.USERS); },
  getUserById(id) { return this.getUsers().find(u => u.id === id || u.id === parseInt(id)); },
  updateUser(id, updates) { return this._updateItem(STORAGE_KEYS.USERS, id, updates); },

  getCompanies() { return this._getAll(STORAGE_KEYS.COMPANIES); },
  getCompanyById(id) { return this.getCompanies().find(c => c.id === id || c.id === parseInt(id)); },
  updateCompany(id, updates) { return this._updateItem(STORAGE_KEYS.COMPANIES, id, updates); },

  getJobs() { return this._getAll(STORAGE_KEYS.JOBS); },
  updateJob(id, updates) { return this._updateItem(STORAGE_KEYS.JOBS, id, updates); },

  getPosts() { return this._getAll(STORAGE_KEYS.POSTS); },
  updatePost(id, updates) { return this._updateItem(STORAGE_KEYS.POSTS, id, updates); }
};

localStore.init();

export default localStore;
