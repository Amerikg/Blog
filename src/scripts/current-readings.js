import { createClient } from '@supabase/supabase-js';

const root = document.querySelector('[data-current-readings]');
const title = root.querySelector('[data-current-title]');
const author = root.querySelector('[data-current-author]');
const description = root.querySelector('[data-current-description]');
const status = root.querySelector('[data-current-status]');
const cover = root.querySelector('[data-current-cover]');
const coverStatus = root.querySelector('[data-current-cover-status]');
const navigation = root.querySelector('[data-current-navigation]');
const position = root.querySelector('[data-current-position]');
const { supabaseUrl, supabaseKey } = root.dataset;
let readings = [];
let index = 0;
let coverRequest = 0;
let coverObjectUrl = null;

function clearCover() {
  cover.querySelector('img')?.remove();
  if (coverObjectUrl) URL.revokeObjectURL(coverObjectUrl);
  coverObjectUrl = null;
}

async function showReading(supabase) {
  const reading = readings[index];
  const request = ++coverRequest;
  clearCover();
  coverStatus.textContent = 'Cargando portada…';
  coverStatus.hidden = false;
  title.textContent = reading.title;
  author.textContent = reading.book_author;
  author.hidden = false;
  description.textContent = reading.description || 'Aún no hay una descripción para esta lectura.';
  position.textContent = `${index + 1} / ${readings.length}`;
  status.textContent = '';
  try {
    let url = null;
    if (reading.cover_path) {
      const { data: image, error } = await supabase.storage.from('blog-covers').download(reading.cover_path);
      if (error) throw error;
      if (request !== coverRequest) return;
      url = URL.createObjectURL(image);
      coverObjectUrl = url;
    } else if (reading.cover_url) {
      const parsed = new URL(reading.cover_url);
      if (!['http:', 'https:'].includes(parsed.protocol)) throw new Error('Dirección de portada inválida.');
      url = parsed.href;
    }
    if (!url) {
      coverStatus.textContent = 'Sin portada';
      return;
    }
    const img = document.createElement('img');
    img.alt = `Portada de ${reading.title}`;
    img.addEventListener('load', () => {
      if (request === coverRequest) coverStatus.hidden = true;
    });
    img.addEventListener('error', () => {
      if (request !== coverRequest) return;
      clearCover();
      coverStatus.textContent = 'Portada no disponible';
      coverStatus.hidden = false;
      status.textContent = 'No se pudo mostrar la portada de esta lectura.';
    });
    img.src = url;
    cover.prepend(img);
  } catch (error) {
    if (request !== coverRequest) return;
    console.error('Error al cargar portada de lectura actual:', error);
    coverStatus.textContent = 'Portada no disponible';
    status.textContent = 'No se pudo cargar la portada de esta lectura.';
  }
}

async function load() {
  if (!supabaseUrl || !supabaseKey) {
    description.textContent = 'Las lecturas actuales no están configuradas.';
    return;
  }
  const supabase = createClient(supabaseUrl, supabaseKey, {
    auth: { persistSession: false, autoRefreshToken: false, detectSessionInUrl: false },
  });
  try {
    const { data, error } = await supabase.rpc('blog_current_readings_hero');
    if (error) throw error;
    readings = data;
    if (!readings.length) {
      description.textContent = 'Aún no hay lecturas actuales.';
      coverStatus.textContent = 'Sin lectura actual';
      return;
    }
    navigation.hidden = readings.length < 2;
    root.querySelector('[data-current-previous]').addEventListener('click', () => {
      index = (index - 1 + readings.length) % readings.length;
      void showReading(supabase);
    });
    root.querySelector('[data-current-next]').addEventListener('click', () => {
      index = (index + 1) % readings.length;
      void showReading(supabase);
    });
    await showReading(supabase);
  } catch (error) {
    console.error('Error al cargar lecturas actuales:', error);
    description.textContent = 'No se pudieron cargar las lecturas actuales. Inténtalo más tarde.';
    coverStatus.textContent = 'Portada no disponible';
  }
}

void load();
