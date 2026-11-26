export const bucket = 'blog-covers';
const maxSize = 5 * 1024 * 1024;
const formats = {
  'image/jpeg': { extension: 'jpg', matches: (b) => b[0] === 255 && b[1] === 216 && b[2] === 255 },
  'image/png': { extension: 'png', matches: (b) => [137, 80, 78, 71, 13, 10, 26, 10].every((v, i) => b[i] === v) },
  'image/webp': { extension: 'webp', matches: (b) => String.fromCharCode(...b.slice(0, 4)) === 'RIFF' && String.fromCharCode(...b.slice(8, 12)) === 'WEBP' },
};

export async function validateImage(file) {
  const format = formats[file.type];
  if (!format || file.size === 0 || file.size > maxSize) {
    throw new Error('Selecciona una imagen JPEG, PNG o WebP de hasta 5 MiB.');
  }
  const bytes = new Uint8Array(await file.slice(0, 12).arrayBuffer());
  if (!format.matches(bytes)) throw new Error('El contenido del archivo no coincide con su formato de imagen.');
  try {
    const image = await createImageBitmap(file);
    image.close();
  } catch {
    throw new Error('No se pudo leer la imagen. Selecciona un archivo válido.');
  }
  return format.extension;
}

export function safeUrl(value) {
  if (!value) return null;
  const url = new URL(value);
  if (!['http:', 'https:'].includes(url.protocol)) throw new Error('La portada debe usar una dirección HTTP o HTTPS.');
  return url.href;
}
