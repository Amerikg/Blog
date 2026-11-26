import { createClient } from '@supabase/supabase-js';
import { setupReadings } from './readings-admin.js';
import { setupReviews } from './reviews-admin.js';

const root = document.querySelector('[data-admin-root]');
const status = root.querySelector('[data-admin-status]');
const form = root.querySelector('[data-admin-login]');
const welcome = root.querySelector('[data-admin-welcome]');
const logout = root.querySelector('[data-admin-logout]');
const isLogin = root.dataset.adminPage === 'login';
const { supabaseUrl, supabaseKey } = root.dataset;

function show(message, view) {
  status.textContent = message;
  if (form) form.hidden = view !== 'login';
  if (welcome) welcome.hidden = view !== 'welcome';
}

if (!supabaseUrl || !supabaseKey) {
  show('Falta configurar la URL o la clave pública de Supabase. Revisa las variables de entorno.', null);
} else {
  const supabase = createClient(supabaseUrl, supabaseKey);
  const content = root.dataset.adminPage === 'readings'
    ? setupReadings(root, supabase)
    : root.dataset.adminPage === 'reviews' ? setupReviews(root, supabase) : null;
  let generation = 0;
  let adminActive = false;
  let navigating = false;

  function navigate(url) {
    navigating = true;
    window.location.replace(url);
  }

  async function checkSession() {
    if (navigating) return;
    const current = ++generation;
    if (!adminActive) show('Comprobando la sesión…', null);
    try {
      const { data: { session }, error: sessionError } = await supabase.auth.getSession();
      if (current !== generation) return;
      if (sessionError) throw sessionError;
      if (!session) {
        adminActive = false;
        content?.clear();
        if (!isLogin) {
          navigate('/admin');
          return;
        }
        show(new URLSearchParams(window.location.search).has('denied')
          ? 'Esta cuenta no tiene acceso de administradora.'
          : 'Inicia sesión para continuar.', 'login');
        return;
      }

      const { data: isAdmin, error } = await supabase.rpc('blog_is_administrator');
      if (current !== generation) return;
      if (error) throw error;
      if (isAdmin !== true) {
        adminActive = false;
        content?.clear();
        if (!isLogin) {
          navigate('/admin?denied=1');
          return;
        }
        show('Esta cuenta no tiene acceso de administradora.', 'login');
        return;
      }
      if (isLogin) {
        navigate('/admin/lecturas-actuales');
        return;
      }
      show('', 'welcome');
      if (!adminActive) {
        adminActive = true;
        await content.load();
      }
    } catch (error) {
      if (current !== generation) return;
      console.error('Error al comprobar el acceso de administración:', error);
      adminActive = false;
      content?.clear();
      show('No se pudo verificar el acceso. Comprueba la conexión y la configuración de Supabase; recarga la página para volver a intentar.', null);
    }
  }

  form?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const submit = form.querySelector('button[type="submit"]');
    const email = form.querySelector('input[name="email"]');
    const password = form.querySelector('input[name="password"]');
    submit.disabled = true;
    show('Iniciando sesión…', 'login');
    try {
      const { error } = await supabase.auth.signInWithPassword({
        email: email.value.trim(),
        password: password.value,
      });
      if (error) {
        console.error('Error al iniciar sesión:', error);
        show('No se pudo iniciar sesión. Revisa tus datos y la conexión.', 'login');
        return;
      }
      await checkSession();
    } catch (error) {
      console.error('Error al iniciar sesión:', error);
      show('No se pudo iniciar sesión. Revisa tus datos y la conexión.', 'login');
    } finally {
      password.value = '';
      submit.disabled = false;
    }
  });

  logout?.addEventListener('click', async () => {
    logout.disabled = true;
    try {
      const { error } = await supabase.auth.signOut();
      if (error) throw error;
      await checkSession();
    } catch (error) {
      console.error('Error al cerrar sesión:', error);
      show('No se pudo cerrar la sesión. Inténtalo nuevamente.', 'welcome');
    } finally {
      logout.disabled = false;
    }
  });

  supabase.auth.onAuthStateChange((event) => {
    if (event === 'SIGNED_OUT' || event === 'SIGNED_IN' || event === 'TOKEN_REFRESHED') {
      setTimeout(() => { void checkSession(); }, 0);
    }
  });

  void checkSession();
}
