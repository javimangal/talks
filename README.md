# talks

Hub de charlas y conferencias de Javier Mancilla Galindo.
Talks and lectures hub — bilingual (Spanish / English).

**<https://javimangal.github.io/talks/>**

Este repositorio contiene únicamente los **HTML ya renderizados** de las
presentaciones y la portada que las lista. El código fuente de cada baraja
(`.qmd`, datos, scripts de R) vive en el repositorio del proyecto al que
pertenece, no aquí.

---

## Estructura

```
talks/
├── .nojekyll        ← obligatorio: ver más abajo
├── index.html       ← portada bilingüe; el listado de charlas vive aquí dentro
├── LICENSE          ← CC BY 4.0
├── publicar.ps1     ← copia un HTML renderizado a su carpeta
└── AAAA/
    └── slug-de-la-charla/
        └── index.html   ← la baraja
```

Una charla por carpeta, y el archivo **siempre** se llama `index.html`. Eso es
lo que hace que la URL quede limpia:

```
https://javimangal.github.io/talks/2026/comexane-tesis-medico-residente/
```

y no `…/comexane-tesis-medico-residente.html`. También permite que, si algún
día una charla necesita recursos al lado (un PDF de respaldo, un anexo), vivan
en su propia carpeta sin estorbar.

### Por qué `.nojekyll`

GitHub Pages pasa todo por Jekyll por omisión, y **Jekyll ignora cualquier
archivo o carpeta que empiece con `_`**. Las barajas de Quarto pueden traer
carpetas de apoyo llamadas `nombre_files/`, y los proyectos de origen tienen
archivos como `_enlaces_citas.html`. Con `embed-resources: true` hoy no hace
falta ninguno, pero el día que se renderice sin empotrar recursos la
presentación se serviría rota y sin ningún mensaje de error. El archivo
`.nojekyll` (vacío) desactiva Jekyll y elimina esa clase entera de problema.

**No borrar.**

---

## Agregar una charla

1. **Renderizar** el `.html` en el repositorio de origen. Para la baraja de
   COMEXANE:

   ```r
   source("docs/presentations/renderizar.R")
   ```

2. **Copiarlo** a su carpeta aquí. A mano, o con el script incluido:

   ```powershell
   .\publicar.ps1 `
     -Origen "..\COMEXANE\comexane-2026-keynote\docs\presentations\tesis_medico_residente.html" `
     -Anio 2026 `
     -Slug "comexane-tesis-medico-residente"
   ```

3. **Anunciarla** en la portada: abrir `index.html` y añadir una entrada al
   arreglo `CHARLAS`, que está al principio del `<script>` y lleva sus
   instrucciones al lado. Todo lo demás —agrupar por año, ordenar, la etiqueta
   de idioma, el aviso de «Próxima»— se calcula solo a partir de la fecha.

   Conviene añadirla también en el bloque `<noscript>`, que es la lista que se
   ve si el navegador tiene JavaScript desactivado.

4. **Revisar en local**: doble clic en `index.html`. La portada se ve tal cual
   quedará publicada.

   > Un detalle de la vista previa local: al abrir con doble clic (`file://`),
   > los enlaces de las tarjetas **no** abren la presentación. Es porque el
   > navegador no resuelve `carpeta/` → `carpeta/index.html` cuando lee del
   > disco; un servidor web sí lo hace, y GitHub Pages es un servidor web. Para
   > probar los enlaces en local, desde esta carpeta:
   >
   > ```powershell
   > python -m http.server 8000
   > ```
   >
   > y abrir <http://localhost:8000/>. Ahí se comporta igual que en producción.

5. **Publicar**:

   ```
   git add .
   git commit -m "Agrega charla COMEXANE 2026"
   git push
   ```

   GitHub Pages tarda entre unos segundos y un par de minutos en reflejarlo.

### Nombres de carpeta (slug)

Minúsculas, sin acentos ni espacios, palabras separadas por guiones, y que
empiece por la sede o el congreso: `comexane-tesis-medico-residente`,
`smmce-seminario-diseno`, `uu-risk-communication`. Es lo que va a quedar en la
URL para siempre, así que no conviene meter la fecha (ya está en la carpeta del
año) ni el número de edición del congreso.

---

## Peso de los archivos

Las barajas se renderizan con `embed-resources: true`: cada `.html` es
autocontenido y pesa varios megabytes (la de COMEXANE, unos 8.6 MB, casi todo
`plotly.js`). Es a propósito, porque así se abre desde una memoria USB, sin
internet y sin carpeta de apoyo al lado.

La consecuencia en Git es que **cada re-render añade un archivo nuevo completo
al historial**, que ya no se recupera. Los límites de GitHub Pages (1 GB de
sitio, 100 GB de tráfico al mes, 10 compilaciones por hora) quedan lejos, pero
conviene:

- No subir un render por cada corrección de una coma. Publicar versiones, no
  guardados.
- Si el repositorio llega a pesar de más, la salida es reescribir el historial
  (`git filter-repo`) o empezar una rama huérfana. Mejor no llegar ahí.

---

## Configuración de GitHub Pages

Una sola vez, al crear el repositorio:

**Settings → Pages → Build and deployment → Source: _Deploy from a branch_ →
Branch: `main`, carpeta `/ (root)` → Save.**

El repositorio tiene que ser **público** para que Pages funcione en el plan
gratuito.

---

## Licencia

Contenido bajo [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.es).
Los logotipos institucionales y las figuras reproducidas de artículos publicados
conservan la licencia de su fuente y quedan fuera; ver `LICENSE`.
