import { createRouter, createWebHistory } from 'vue-router';
import Home from '../views/Home.vue';
import Signup from '../views/Signup.vue';
import Login from '../views/Login.vue';
import Jobs from '../views/Jobs.vue';
import JobDetails from '../views/JobDetails.vue';
import Profile from '../views/Profile.vue';
import MyApplications from '../views/MyApplications.vue';
import EditProfile from '../views/EditProfile.vue';
import CompanyProfile from '../views/company/CompanyProfile.vue';
import AboutUs from '../views/AboutUs.vue';
import Companies from '../views/Companies.vue';
import Blog from '../views/Blog.vue';
import BlogPost from '../views/BlogPost.vue';
import CompanyLogin from '../views/company/CompanyLogin.vue';
import CompanySignup from '../views/company/CompanySignup.vue';

import Clients from '../views/Clients.vue';
import CompanyRequests from '../views/company/CompanyRequests.vue';
import CompanyRequestDetails from '../views/company/CompanyRequestDetails.vue';

import AdminDashboard from '../views/admin/AdminDashboard.vue';

const routes = [
  { path: '/', name: 'Home', component: Home },
  { path: '/signup', name: 'Signup', component: Signup },
  { path: '/login', name: 'Login', component: Login },
  { path: '/jobs', name: 'Jobs', component: Jobs },
  { path: '/job/:id', name: 'JobDetails', component: JobDetails },
  { path: '/profile', name: 'Profile', component: Profile },
  { path: '/my-applications', name: 'MyApplications', component: MyApplications }, 
  { path: '/profile/edit', name: 'EditProfile', component: EditProfile },
  { path: '/company/:id', name: 'CompanyProfile', component: CompanyProfile },
  { path: '/about', name: 'AboutUs', component: AboutUs },
  { path: '/companies', name: 'Companies', component: Companies },
  { path: '/blog', name: 'Blog', component: Blog },
  { path: '/blog/:id', name: 'BlogPost', component: BlogPost },
  { path: '/company/login', name: 'CompanyLogin', component: CompanyLogin },
  { path: '/company/signup', name: 'CompanySignup', component: CompanySignup },

  { path: '/clients', name: 'Clients', component: Clients },
  { path: '/company/requests', name: 'CompanyRequests', component: CompanyRequests },
  { path: '/company/profile/:id', name: 'CompanyProfileView', component: CompanyProfile },
  { path: '/company/request/new', name: 'NewCompanyRequest', component: CompanyRequestDetails },
  { path: '/company/request/:id', name: 'CompanyRequestDetails', component: CompanyRequestDetails },

  { path: '/admin', name: 'AdminDashboard', component: AdminDashboard },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
