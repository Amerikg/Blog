import { bucket, safeUrl, validateImage } from './covers.js';

const sections = [
  ['introduction', '<!-- blog:introduccion -->\n## Introducción\n'],
  ['synopsis', '\n\n<!-- blog:sinopsis -->\n## Sinopsis\n'],
  ['opinion', '\n\n<!-- blog:opinion -->\n## Opinión personal\n'],
  ['recommendation', '\n\n<!-- blog:recomendacion -->\n## ¿Lo recomiendo?\n'],
];

function decodeSections(body) {
  if (!body) return Object.fromEntries(sections.map(([name]) => [name, '']));
  if (!body.startsWith(sections[0][1])) return null;
  const result = {};
  let offset = 0;
  for (let i = 0; i < sections.length; i++) {
    const [name, marker] = sections[i];
    if (!body.startsWith(marker, offset)) return null;
    const start = offset + marker.length;
    const next = sections[i + 1]?.[1];
    const end = next ? body.indexOf(next, start) : body.length;
    if (end < 0 || (next && body.indexOf(next, end + next.length) !== -1)) return null;
    result[name] = body.slice(start, end);
    offset = end;
  }
  return result;
}

function extractOpinion(body) {
  const parsed = decodeSections(body);
  if (parsed) return { text: parsed.opinion, converted: Boolean(body) };
  const heading = /^##\s+opini[oó]n personal\s*$/im.exec(body);
  const recommendation = /^##\s+¿lo recomiendo\?\s*$/im.exec(body);
  if (heading && recommendation && recommendation.index > heading.index) {
    return {
      text: body.slice(heading.index + heading[0].length, recommendation.index)
        .replace(/<\/?div\b[^>]*>/gi, '').trim(),
      converted: true,
    };
  }
  return { text: body, converted: false };
}

export function setupReviews(root, supabase) {
  const list = root.querySelector('[data-review-list]');
  const status = root.querySelector('[data-review-status]');
  const form = root.querySelector('[data-review-form]');
  const editor = root.querySelector('[data-review-editor]');
  const create = root.querySelector('[data-review-create]');
  const cancel = root.querySelector('[data-review-cancel]');
  const formTitle = root.querySelector('[data-review-form-title]');
  const notice = root.querySelector('[data-review-edit-notice]');
  const formError = root.querySelector('[data-review-error]');
  const imagesContainer = root.querySelector('[data-context-images]');
  const preview = root.querySelector('[data-review-preview]');
  const previewButton = root.querySelector('[data-review-preview-button]');
  const isEditor = root.hasAttribute('data-admin-editor');
  const requestedId = new URLSearchParams(location.search).get('id');
  let contextImages = [];
  let previewUrls = [];
  let previewRequest = 0;
  let reviews = [];
  let request = 0;
  let editing = null;
  let initialOpinion = '';

  function clearPreview() {
    previewRequest++;
    previewUrls.forEach((url) => URL.revokeObjectURL(url));
    previewUrls = [];
    preview.hidden = true;
    root.querySelector('[data-preview-cover]').replaceChildren();
    root.querySelector('[data-preview-images]').replaceChildren();
  }

  function reset() {
    if (!form) return;
    form.reset();
    form.elements.id.value = '';
    formTitle.textContent = 'Nueva reseña';
    formError.textContent = '';
    notice.textContent = '';
    clearPreview();
    form.querySelector('button[type="submit"]').disabled = false;
    contextImages = [];
    imagesContainer.replaceChildren();
    editor.hidden = true;
    editing = null;
    initialOpinion = '';
  }

  function renderImages() {
    imagesContainer.replaceChildren();
    contextImages.forEach((item, index) => {
      const row = document.createElement('div');
      row.className = 'context-image-row';
      const urlLabel = document.createElement('label');
      urlLabel.textContent = `Enlace de imagen ${index + 1}`;
      const url = document.createElement('input');
      url.type = 'url';
      url.maxLength = 2048;
      url.placeholder = 'https://...';
      url.value = item.url ?? '';
      url.addEventListener('input', () => { item.url = url.value; });
      urlLabel.append(url);
      const fileLabel = document.createElement('label');
      fileLabel.textContent = item.path ? 'Reemplazar archivo guardado' : 'O subir una imagen';
      const file = document.createElement('input');
      file.type = 'file';
      file.accept = 'image/jpeg,image/png,image/webp';
      file.addEventListener('change', () => { item.file = file.files[0] ?? null; });
      fileLabel.append(file);
      if (item.file) {
        const selected = document.createElement('span');
        selected.className = 'reading-help';
        selected.textContent = `Archivo seleccionado: ${item.file.name}`;
        fileLabel.append(selected);
      }
      const altLabel = document.createElement('label');
      altLabel.textContent = 'Descripción de la imagen';
      const alt = document.createElement('input');
      alt.maxLength = 500;
      alt.required = true;
      alt.value = item.alt ?? '';
      alt.addEventListener('input', () => { item.alt = alt.value; });
      altLabel.append(alt);
      if (item.path) {
        const saved = document.createElement('p');
        saved.className = 'reading-help';
        saved.textContent = 'Imagen guardada en Storage; se conservará si no eliges otra.';
        row.append(saved);
      }
      const remove = document.createElement('button');
      remove.type = 'button';
      remove.className = 'admin-button admin-button-secondary';
      remove.textContent = 'Quitar imagen';
      remove.setAttribute('aria-label', `Quitar imagen ${index + 1}`);
      remove.addEventListener('click', () => {
        contextImages.splice(index, 1);
        renderImages();
        clearPreview();
      });
      row.append(urlLabel, fileLabel, altLabel, remove);
      imagesContainer.append(row);
    });
  }

  function setBusy(busy) {
    form?.querySelectorAll('input, textarea, button').forEach((control) => { control.disabled = busy; });
    list?.querySelectorAll('button').forEach((control) => { control.disabled = busy; });
    if (create) create.disabled = busy;
  }

  function edit(review) {
    reset();
    editing = review;
    form.elements.id.value = review.id;
    form.elements.title.value = review.title;
    form.elements.bookAuthor.value = review.book_author;
    form.elements.genre.value = review.genre;
    form.elements.pageCount.value = review.page_count ?? '';
    form.elements.description.value = review.description;
    form.elements.readStart.value = review.read_start ?? '';
    form.elements.readEnd.value = review.read_end ?? '';
    for (const name of ['rating', 'tears', 'spice']) form.elements[name].value = review[name] ?? '';
    form.elements.cover.value = review.cover_url ?? '';
    const extracted = extractOpinion(review.body_markdown);
    const savedImages = review.extra_frontmatter?.context_images ?? [];
    if (!Array.isArray(savedImages) || savedImages.some((item) =>
      !item || typeof item !== 'object' || typeof item.alt !== 'string' ||
      (item.url != null && typeof item.url !== 'string') ||
      (item.path != null && typeof item.path !== 'string') || (!item.url && !item.path) || (item.url && item.path))) {
      formError.textContent = 'Las imágenes guardadas tienen un formato desconocido. No se puede editar esta reseña sin revisarlas.';
      editor.hidden = false;
      form.querySelector('button[type="submit"]').disabled = true;
      return;
    }
    contextImages = savedImages.map((item) => ({ ...item, url: item.url ?? '', path: item.path ?? null, file: null }));
    let opinion = extracted.text;
    if (extracted.converted && !contextImages.length) {
      opinion = opinion.replace(/<img\s+[^>]*src="(https?:\/\/[^"]+)"[^>]*alt="([^"]*)"[^>]*>/gi, (tag, url, alt) => {
        try {
          safeUrl(url);
          contextImages.push({ url, path: null, alt: alt || 'Imagen de contexto', file: null });
          return '';
        } catch {
          return tag;
        }
      }).trim();
    }
    form.elements.opinion.value = opinion;
    initialOpinion = form.elements.opinion.value;
    renderImages();
    formTitle.textContent = 'Editar reseña';
    notice.textContent = review.published
      ? 'Esta reseña está publicada en la base de datos. Los cambios pueden ser visibles mediante la API pública.'
      : 'Este borrador no es público.';
    if (extracted.converted) notice.textContent += ' Al guardar, solo se conservará la opinión en el contenido de la reseña; las demás secciones se quitarán.';
    editor.hidden = false;
    form.elements.title.focus();
  }

  async function load() {
    const current = ++request;
    status.textContent = 'Consultando reseñas…';
    const { data, error } = await supabase.from('blog_reviews')
      .select('id,title,book_author,genre,page_count,description,read_start,read_end,rating,tears,spice,tags,cover_url,cover_path,body_markdown,extra_frontmatter,published,updated_at')
      .order('updated_at', { ascending: false });
    if (current !== request) return false;
    if (error) {
      console.error('Error al consultar reseñas:', error);
      status.textContent = 'No se pudieron cargar las reseñas. Revisa la conexión y vuelve a intentar.';
      return false;
    }
    reviews = data;
    if (isEditor) {
      status.textContent = '';
      if (requestedId) {
        const review = data.find((item) => item.id === requestedId);
        if (!review) {
          status.textContent = 'La reseña no existe o ya no está disponible. Vuelve al listado para continuar.';
          return false;
        }
        edit(review);
      } else {
        reset();
        editor.hidden = false;
        notice.textContent = 'Solo el título y el autor son obligatorios; puedes completar el borrador después.';
        form.elements.title.focus();
      }
      return true;
    }
    list.replaceChildren();
    status.textContent = new URLSearchParams(location.search).has('guardado')
      ? 'Reseña guardada.'
      : data.length ? `${data.length} ${data.length === 1 ? 'reseña' : 'reseñas'}.` : 'Todavía no hay reseñas guardadas.';
    for (const review of data) {
      const card = document.createElement('li');
      card.className = 'admin-review-card';
      const info = document.createElement('div');
      const title = document.createElement('h3');
      title.textContent = review.title;
      const author = document.createElement('p');
      author.textContent = review.book_author;
      const state = document.createElement('p');
      state.textContent = review.published ? 'Publicada en la base de datos' : 'Borrador';
      info.append(title, author, state);
      const actions = document.createElement('div');
      actions.className = 'admin-card-actions';
      const editButton = document.createElement('button');
      editButton.type = 'button';
      editButton.className = 'admin-card-button admin-card-button-secondary';
      editButton.textContent = 'Editar';
      editButton.setAttribute('aria-label', `Editar reseña de ${review.title}`);
      editButton.addEventListener('click', () => { location.assign(`/admin/resena-formulario?id=${encodeURIComponent(review.id)}`); });
      actions.append(editButton);
      if (!review.published) {
        const deleteButton = document.createElement('button');
        deleteButton.type = 'button';
        deleteButton.className = 'admin-card-button admin-card-button-secondary';
        deleteButton.textContent = 'Eliminar';
        deleteButton.setAttribute('aria-label', `Eliminar borrador de ${review.title}`);
        deleteButton.addEventListener('click', async () => {
          if (!window.confirm(`¿Eliminar el borrador de «${review.title}»? Esta acción no se puede deshacer.`)) return;
          setBusy(true);
          status.textContent = 'Eliminando borrador…';
          try {
            const { data: removed, error: removeError } = await supabase.from('blog_reviews')
              .delete().eq('id', review.id).eq('updated_at', review.updated_at).eq('published', false)
              .select('id').maybeSingle();
            if (removeError) throw removeError;
            if (!removed) throw new Error('El borrador cambió o ya no está disponible. Actualiza la página.');
            if (editing?.id === review.id) reset();
            if (await load()) status.textContent = 'Borrador eliminado. La portada y la lectura asociada, si existe, se conservan.';
          } catch (error) {
            console.error('Error al eliminar borrador:', error);
            status.textContent = `No se pudo eliminar el borrador: ${error.message || 'vuelve a intentar.'}`;
          } finally {
            setBusy(false);
          }
        });
        actions.append(deleteButton);
      }
      card.append(info, actions);
      list.append(card);
    }
    return true;
  }

  create?.addEventListener('click', () => { location.assign('/admin/resena-formulario'); });
  root.querySelector('[data-context-add]')?.addEventListener('click', () => {
    contextImages.push({ url: '', path: null, alt: '', file: null });
    renderImages();
  });
  previewButton?.addEventListener('click', async () => {
    clearPreview();
    const current = previewRequest;
    preview.hidden = false;
    formError.textContent = '';
    root.querySelector('[data-preview-title]').textContent = form.elements.title.value.trim() || 'Título de la reseña';
    root.querySelector('[data-preview-author]').textContent = form.elements.bookAuthor.value.trim()
      ? `de ${form.elements.bookAuthor.value.trim()}` : 'Autor o autora';
    root.querySelector('[data-preview-genre]').textContent = form.elements.genre.value.trim() || 'Reseña';
    root.querySelector('[data-preview-description]').textContent = form.elements.description.value;
    root.querySelector('[data-preview-opinion]').textContent = form.elements.opinion.value;
    const coverTarget = root.querySelector('[data-preview-cover]');
    const imagesTarget = root.querySelector('[data-preview-images]');
    async function addImage(target, item, alt) {
      let url;
      if (item.file) {
        await validateImage(item.file);
        url = URL.createObjectURL(item.file);
        if (current !== previewRequest) { URL.revokeObjectURL(url); return; }
        previewUrls.push(url);
      } else if (item.url) {
        url = safeUrl(item.url.trim());
      } else if (item.path) {
        const { data, error } = await supabase.storage.from(bucket).download(item.path);
        if (error) throw error;
        if (current !== previewRequest) return;
        url = URL.createObjectURL(data);
        previewUrls.push(url);
      } else {
        throw new Error('Agrega un enlace o archivo para cada imagen de contexto.');
      }
      if (current !== previewRequest) return;
      const img = document.createElement('img');
      img.alt = alt;
      img.addEventListener('error', () => {
        if (current !== previewRequest) return;
        img.remove();
        formError.textContent = 'No se pudo mostrar una imagen de la vista previa. Revisa el enlace o archivo.';
      });
      img.src = url;
      target.append(img);
    }
    try {
      const coverFile = form.elements.coverFile.files[0];
      const coverUrl = form.elements.cover.value.trim();
      const coverPath = !form.elements.removeCover.checked && !coverUrl ? editing?.cover_path : null;
      if (coverFile || (!form.elements.removeCover.checked && (coverUrl || coverPath))) {
        await addImage(coverTarget, { file: coverFile, url: coverUrl, path: coverPath }, 'Portada del libro');
      } else {
        coverTarget.textContent = 'Sin portada';
      }
      for (const item of contextImages) await addImage(imagesTarget, item, item.alt.trim() || 'Imagen de contexto');
      if (current === previewRequest) preview.scrollIntoView({ behavior: 'smooth', block: 'start' });
    } catch (error) {
      if (current !== previewRequest) return;
      console.error('Error al crear vista previa:', error);
      formError.textContent = `No se pudo completar la vista previa: ${error.message || 'revisa las imágenes.'}`;
    }
  });
  cancel?.addEventListener('click', () => { location.assign('/admin/resenas'); });
  form?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const id = form.elements.id.value;
    if (id && (!editing || !reviews.some((review) => review.id === id))) {
      formError.textContent = 'La reseña ya no está disponible. Actualiza la página.';
      return;
    }
    formError.textContent = '';
    const uploadedPaths = [];
    setBusy(true);
    status.textContent = 'Guardando reseña…';
    try {
      const title = form.elements.title.value.trim();
      const bookAuthor = form.elements.bookAuthor.value.trim();
      if (!title || !bookAuthor) throw new Error('El título y el autor son obligatorios.');
      const start = form.elements.readStart.value || null;
      const end = form.elements.readEnd.value || null;
      if (start && end && start > end) throw new Error('La fecha de finalización no puede ser anterior a la de inicio.');
      const pageCount = form.elements.pageCount.value ? Number(form.elements.pageCount.value) : null;
      if (pageCount !== null && (!Number.isInteger(pageCount) || pageCount < 1 || pageCount > 2147483647)) {
        throw new Error('El número de páginas debe ser un entero positivo.');
      }
      const ratings = {};
      for (const name of ['rating', 'tears', 'spice']) {
        const value = form.elements[name].value;
        ratings[name] = value === '' ? null : Number(value);
        if (ratings[name] !== null && (!Number.isInteger(ratings[name]) || ratings[name] < 0 || ratings[name] > 5)) {
          throw new Error('Las puntuaciones deben ser números enteros entre 0 y 5.');
        }
      }
      const extracted = editing ? extractOpinion(editing.body_markdown) : null;
      const body = editing && !extracted.converted && form.elements.opinion.value === initialOpinion
        ? editing.body_markdown : form.elements.opinion.value;
      for (const image of contextImages) {
        if (!image.alt.trim()) throw new Error('Agrega una descripción para cada imagen de contexto.');
        if (!image.file && !image.url.trim() && !image.path) throw new Error('Agrega un enlace o archivo para cada imagen de contexto.');
        if (image.url.trim()) safeUrl(image.url.trim());
        if (image.file) await validateImage(image.file);
      }
      const file = form.elements.coverFile.files[0];
      let coverUrl = safeUrl(form.elements.cover.value.trim());
      let coverPath = editing?.cover_path ?? null;
      if (form.elements.removeCover.checked) {
        coverUrl = null;
        coverPath = null;
      }
      if (file) {
        const extension = await validateImage(file);
        const uploadedPath = `covers/${crypto.randomUUID()}.${extension}`;
        const { error } = await supabase.storage.from(bucket).upload(uploadedPath, file, { contentType: file.type, upsert: false });
        if (error) throw error;
        uploadedPaths.push(uploadedPath);
        coverPath = uploadedPath;
        coverUrl = null;
      } else if (coverUrl) {
        coverPath = null;
      }
      const savedImages = [];
      for (const image of contextImages) {
        let url = image.url.trim() ? safeUrl(image.url.trim()) : null;
        let path = url ? null : image.path;
        if (image.file) {
          const extension = await validateImage(image.file);
          const uploadedPath = `covers/${crypto.randomUUID()}.${extension}`;
          const { error } = await supabase.storage.from(bucket).upload(uploadedPath, image.file, { contentType: image.file.type, upsert: false });
          if (error) throw error;
          uploadedPaths.push(uploadedPath);
          path = uploadedPath;
          url = null;
        }
        const { file: _file, ...original } = image;
        savedImages.push({ ...original, url, path, alt: image.alt.trim() });
      }
      const values = {
        title, book_author: bookAuthor, genre: form.elements.genre.value.trim(),
        page_count: pageCount, description: form.elements.description.value,
        read_start: start, read_end: end, ...ratings,
        cover_url: coverUrl, cover_path: coverPath, body_markdown: body,
        extra_frontmatter: { ...editing?.extra_frontmatter, context_images: savedImages },
      };
      const query = id
        ? supabase.from('blog_reviews').update(values).eq('id', id).eq('updated_at', editing.updated_at)
        : supabase.from('blog_reviews').insert({ ...values, slug: `resena-${crypto.randomUUID()}`, published: false });
      const { data, error } = await query.select('id').maybeSingle();
      if (error) throw error;
      if (!data) throw new Error('La reseña cambió o ya no está disponible. Recarga la página antes de intentar nuevamente.');
      location.assign('/admin/resenas?guardado=1');
    } catch (error) {
      console.error('Error al guardar reseña:', error);
      formError.textContent = uploadedPaths.length
        ? 'No se pudo confirmar el guardado. Las imágenes subidas pueden haber quedado sin utilizar; revisa la reseña y Storage.'
        : `No se pudo guardar la reseña: ${error.message || 'revisa la conexión y vuelve a intentar.'}`;
      status.textContent = 'No se pudo guardar la reseña.';
    } finally {
      setBusy(false);
    }
  });

  return {
    load,
    clear() {
      request++;
      reviews = [];
      list?.replaceChildren();
      reset();
    },
  };
}
