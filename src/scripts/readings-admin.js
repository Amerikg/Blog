import { bucket, safeUrl, validateImage } from './covers.js';

export function setupReadings(root, supabase) {
  const list = root.querySelector('[data-reading-list]');
  const status = root.querySelector('[data-reading-status]');
  const form = root.querySelector('[data-reading-form]');
  const editor = root.querySelector('[data-reading-editor]');
  const create = root.querySelector('[data-reading-create]');
  const cancel = root.querySelector('[data-reading-cancel]');
  const formTitle = root.querySelector('[data-reading-form-title]');
  const formError = root.querySelector('[data-reading-error]');
  const isEditor = root.hasAttribute('data-admin-editor');
  const requestedId = new URLSearchParams(location.search).get('id');
  let readings = [];
  let previews = [];
  let request = 0;

  function reset() {
    if (!form) return;
    form.reset();
    form.elements.id.value = '';
    formTitle.textContent = 'Nueva lectura';
    formError.textContent = '';
    editor.hidden = true;
  }

  function releasePreviews() {
    previews.forEach((url) => URL.revokeObjectURL(url));
    previews = [];
  }

  function setBusy(busy) {
    form?.querySelectorAll('input, textarea, button').forEach((control) => { control.disabled = busy; });
    list?.querySelectorAll('button, input').forEach((control) => { control.disabled = busy; });
    if (create) create.disabled = busy;
  }

  function editReading(reading) {
    form.reset();
    form.elements.id.value = reading.id;
    form.elements.title.value = reading.title;
    form.elements.author.value = reading.book_author;
    form.elements.start.value = reading.started_on ?? '';
    form.elements.genre.value = reading.genre ?? '';
    form.elements.pageCount.value = reading.page_count ?? '';
    form.elements.description.value = reading.description ?? '';
    form.elements.cover.value = reading.cover_url ?? '';
    formTitle.textContent = 'Editar lectura';
    editor.hidden = false;
    form.elements.title.focus();
  }

  async function load() {
    const current = ++request;
    status.textContent = 'Consultando lecturas…';
    const { data, error } = await supabase.from('blog_readings')
      .select('id,title,book_author,cover_url,cover_path,started_on,genre,page_count,description')
      .eq('status', 'reading').order('created_at', { ascending: false });
    if (current !== request) return false;
    if (error) {
      console.error('Error al consultar lecturas:', error);
      status.textContent = 'No se pudieron cargar las lecturas. Revisa la conexión y la configuración de Supabase.';
      return false;
    }
    readings = data;
    if (isEditor) {
      status.textContent = '';
      if (requestedId) {
        const reading = data.find((item) => item.id === requestedId);
        if (!reading) {
          status.textContent = 'La lectura no existe o ya fue terminada. Vuelve al listado para continuar.';
          return false;
        }
        editReading(reading);
      } else {
        reset();
        editor.hidden = false;
        form.elements.title.focus();
      }
      return true;
    }
    releasePreviews();
    list.replaceChildren();
    status.textContent = new URLSearchParams(location.search).has('guardado')
      ? 'Lectura guardada.'
      : data.length ? `${data.length} ${data.length === 1 ? 'lectura actual' : 'lecturas actuales'}.` : 'Todavía no hay lecturas actuales.';
    for (const reading of data) {
      const card = document.createElement('li');
      card.className = 'admin-reading-card';
      const cover = document.createElement('div');
      cover.className = 'admin-reading-cover';
      cover.textContent = 'Sin portada';
      const title = document.createElement('h3');
      title.textContent = reading.title;
      const author = document.createElement('p');
      author.textContent = reading.book_author;
      const actions = document.createElement('div');
      actions.className = 'admin-card-actions';
      const edit = document.createElement('button');
      edit.type = 'button';
      edit.className = 'admin-card-button admin-card-button-secondary';
      edit.textContent = 'Editar';
      edit.setAttribute('aria-label', `Editar ${reading.title}`);
      edit.addEventListener('click', () => { location.assign(`/admin/lectura-formulario?id=${encodeURIComponent(reading.id)}`); });
      const finishForm = document.createElement('form');
      finishForm.className = 'reading-finish';
      finishForm.hidden = true;
      const finishLabel = document.createElement('label');
      finishLabel.textContent = '¿Cuándo terminaste esta lectura?';
      const finishDate = document.createElement('input');
      finishDate.type = 'date';
      finishDate.required = true;
      finishDate.setAttribute('aria-label', `Fecha de finalización de ${reading.title}`);
      finishLabel.append(finishDate);
      const finish = document.createElement('button');
      finish.type = 'button';
      finish.className = 'admin-card-button';
      finish.textContent = 'Terminado';
      finish.setAttribute('aria-label', `Marcar ${reading.title} como terminado`);
      finish.setAttribute('aria-expanded', 'false');
      finish.addEventListener('click', () => {
        finishForm.hidden = false;
        finish.setAttribute('aria-expanded', 'true');
        finishDate.focus();
      });
      const finishActions = document.createElement('div');
      finishActions.className = 'admin-card-actions';
      const confirmFinish = document.createElement('button');
      confirmFinish.type = 'submit';
      confirmFinish.className = 'admin-card-button';
      confirmFinish.textContent = 'Crear borrador';
      const cancelFinish = document.createElement('button');
      cancelFinish.type = 'button';
      cancelFinish.className = 'admin-card-button admin-card-button-secondary';
      cancelFinish.textContent = 'Cancelar';
      cancelFinish.addEventListener('click', () => {
        finishForm.reset();
        finishForm.hidden = true;
        finish.setAttribute('aria-expanded', 'false');
        finish.focus();
      });
      finishForm.addEventListener('submit', async (event) => {
        event.preventDefault();
        setBusy(true);
        status.textContent = 'Creando borrador…';
        try {
          const { error: finishError } = await supabase.rpc('blog_finish_reading', {
            reading_uuid: reading.id,
            review_slug: `lectura-${crypto.randomUUID()}`,
            finished_date: finishDate.value,
          });
          if (finishError) throw finishError;
          if (await load()) status.textContent = 'Lectura terminada y borrador creado. Puedes editarlo en Reseñas.';
        } catch (error) {
          console.error('Error al terminar lectura:', error);
          status.textContent = 'No se pudo terminar la lectura. Comprueba la fecha y vuelve a intentar.';
        } finally {
          setBusy(false);
        }
      });
      actions.append(edit, finish);
      finishActions.append(confirmFinish, cancelFinish);
      finishForm.append(finishLabel, finishActions);
      card.append(cover, title, author, actions, finishForm);
      list.append(card);
      try {
        let url = safeUrl(reading.cover_url);
        if (reading.cover_path) {
          const { data: image, error: imageError } = await supabase.storage.from(bucket).download(reading.cover_path);
          if (imageError) throw imageError;
          if (current !== request) return false;
          url = URL.createObjectURL(image);
          previews.push(url);
        }
        if (url) {
          const image = document.createElement('img');
          image.src = url;
          image.alt = `Portada de ${reading.title}`;
          image.addEventListener('error', () => {
            image.remove();
            cover.textContent = 'Sin portada';
            status.textContent = 'No se pudo mostrar una portada. Revisa su enlace o archivo.';
          });
          cover.replaceChildren(image);
        }
      } catch (error) {
        console.error('Error al cargar portada:', error);
        status.textContent = 'No se pudo cargar una portada. Revisa la conexión o la configuración de Storage.';
      }
    }
    return true;
  }

  create?.addEventListener('click', () => { location.assign('/admin/lectura-formulario'); });
  cancel?.addEventListener('click', () => { location.assign('/admin/lecturas-actuales'); });
  form?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const id = form.elements.id.value;
    const existing = readings.find((item) => item.id === id);
    if (id && !existing) {
      formError.textContent = 'La lectura ya no está disponible. Actualiza la lista.';
      return;
    }
    const file = form.elements.coverFile.files[0];
    formError.textContent = '';
    let uploadedPath = null;
    setBusy(true);
    status.textContent = 'Guardando lectura…';
    try {
      const title = form.elements.title.value.trim();
      const author = form.elements.author.value.trim();
      const genre = form.elements.genre.value.trim();
      const description = form.elements.description.value.trim();
      const pageCount = Number(form.elements.pageCount.value);
      if (!title || !author || !genre || !description || !form.elements.start.value ||
          !Number.isInteger(pageCount) || pageCount < 1 || pageCount > 2147483647) {
        throw new Error('Completa todos los datos y usa un número de páginas válido.');
      }
      let coverUrl = safeUrl(form.elements.cover.value.trim());
      let coverPath = existing?.cover_path ?? null;
      if (!file && !coverUrl && !coverPath) throw new Error('Agrega una portada mediante un enlace o una imagen.');
      if (file) {
        const extension = await validateImage(file);
        uploadedPath = `covers/${crypto.randomUUID()}.${extension}`;
        const { error } = await supabase.storage.from(bucket).upload(uploadedPath, file, { contentType: file.type, upsert: false });
        if (error) throw error;
        coverPath = uploadedPath;
        coverUrl = null;
      } else if (coverUrl) {
        coverPath = null;
      }
      const values = {
        title, book_author: author, started_on: form.elements.start.value,
        genre, page_count: pageCount, description, cover_url: coverUrl, cover_path: coverPath,
      };
      const query = id
        ? supabase.from('blog_readings').update(values).eq('id', id).eq('status', 'reading')
        : supabase.from('blog_readings').insert(values);
      const { data, error } = await query.select('id').single();
      if (error) throw error;
      if (!data) throw new Error('No se pudo confirmar que la lectura se guardó.');
      location.assign('/admin/lecturas-actuales?guardado=1');
    } catch (error) {
      console.error('Error al guardar lectura:', error);
      status.textContent = uploadedPath
        ? 'No se pudo confirmar el guardado. La portada subida puede haber quedado sin utilizar; revisa la lectura y Storage antes de volver a intentarlo.'
        : `No se pudo guardar la lectura: ${error.message || 'revisa la conexión y vuelve a intentar.'}`;
      formError.textContent = status.textContent;
    } finally {
      setBusy(false);
    }
  });

  return {
    load,
    clear() {
      request++;
      readings = [];
      releasePreviews();
      list?.replaceChildren();
      reset();
    },
  };
}
