# 📋 MAPEO MAESTRO DE RECETAS CON IMÁGENES

**Organización completa de todas las recetas por categoría de edad**

---

## 🎯 RECETAS IDENTIFICADAS (6 Total)

### **CATEGORÍA 1: LACTANCIA EXCLUSIVA (0-5 meses)**
**Ubicación de imágenes**: `assets/images/recipes/age_lactancia/`

| # | Receta ID | Nombre Receta | Nombre de Imagen | Estado |
|----|-----------|---------------|-----------------|--------|
| 1 | - | *No hay recetas en esta categoría* | - | - |

**→ ACCIÓN**: ¿Tienes recetas para 0-5 meses? Si no, dejamos vacío por ahora.

---

### **CATEGORÍA 2: PAPILLAS (6-8 meses)**
**Ubicación de imágenes**: `assets/images/recipes/age_papillas/`

| # | Receta ID | Nombre Receta | Nombre de Imagen | Estado |
|----|-----------|---------------|-----------------|--------|
| 1 | `1` | Papilla de Sangrecita | `papilla_sangrecita.png` | ⏳ A descargar |
| 2 | `2` | Puré de Hígado con Zanahoria | `pure_higado_zanahoria.png` | ⏳ A descargar |

**Total**: 2 imágenes para descargar

---

### **CATEGORÍA 3: PICADOS (9-11 meses)**
**Ubicación de imágenes**: `assets/images/recipes/age_picados/`

| # | Receta ID | Nombre Receta | Nombre de Imagen | Estado |
|----|-----------|---------------|-----------------|--------|
| 1 | `3` | Picadito de Bazo con Lentejas | `picadito_bazo_lentejas.png` | ⏳ A descargar |

**Total**: 1 imagen para descargar

---

### **CATEGORÍA 4: OLLA FAMILIAR (12-23 meses)**
**Ubicación de imágenes**: `assets/images/recipes/age_olla_familiar/`

| # | Receta ID | Nombre Receta | Nombre de Imagen | Estado |
|----|-----------|---------------|-----------------|--------|
| 1 | `4` | Guiso Familiar con Pescado Oscuro | `guiso_pescado_oscuro.png` | ⏳ A descargar |

**Total**: 1 imagen para descargar

---

### **CATEGORÍA 5: ESCOLAR (24+ meses)**
**Ubicación de imágenes**: `assets/images/recipes/age_escolar/`

| # | Receta ID | Nombre Receta | Nombre de Imagen | Estado |
|----|-----------|---------------|-----------------|--------|
| 1 | `5` | Arroz Tapado con Hígado y Lentejas | `arroz_tapado_higado_lentejas.png` | ⏳ A descargar |
| 2 | `6` | Tortilla de Sangrecita con Quinua | `tortilla_sangrecita_quinua.png` | ⏳ A descargar |

**Total**: 2 imágenes para descargar

---

## 📊 RESUMEN DE DESCARGA

```
CATEGORÍA                    → IMÁGENES → ESTADO
─────────────────────────────────────────────────
Lactancia (0-5m)            →    0     → Vacío
Papillas (6-8m)             →    2     → ⏳ Pendiente
Picados (9-11m)             →    1     → ⏳ Pendiente
Olla Familiar (12-23m)      →    1     → ⏳ Pendiente
Escolar (24+m)              →    2     → ⏳ Pendiente
─────────────────────────────────────────────────
TOTAL                       →    6     ← ⏳ A DESCARGAR
```

---

## 🔍 VERIFICACIÓN CON EL USUARIO

**Preguntas importantes antes de continuar:**

### ✅ Pregunta 1: ¿Es esta la lista completa?
```
Tengo identificadas estas 6 recetas en tu código:
1. Papilla de Sangrecita
2. Puré de Hígado con Zanahoria
3. Picadito de Bazo con Lentejas
4. Guiso Familiar con Pescado Oscuro
5. Arroz Tapado con Hígado y Lentejas
6. Tortilla de Sangrecita con Quinua

¿Hay más recetas que no están en el código?
¿Hay más recetas en Firestore o archivo JSON?
```

### ✅ Pregunta 2: ¿Tienes más recetas para Lactancia (0-5m)?
```
No encontré recetas para bebés 0-5 meses.
¿Solo darás leche materna/fórmula en esa etapa?
¿O hay recetas adicionales?
```

### ✅ Pregunta 3: ¿De dónde descargarás las imágenes?
```
¿Tienes un carpeta con imágenes locales?
¿Las buscaremos online?
¿Las crearemos?
```

---

## 📝 CONVENCIÓN DE NOMBRES QUE USARÉ

```
FORMATO: {alimento_principal}_{ingredientes_secundarios}.png

EJEMPLOS:
✅ papilla_sangrecita.png
✅ pure_higado_zanahoria.png
✅ picadito_bazo_lentejas.png
✅ guiso_pescado_oscuro.png
✅ arroz_tapado_higado_lentejas.png
✅ tortilla_sangrecita_quinua.png

❌ EVITAR: papilla1.png, rec2.png, imagen.png
```

---

## ⚠️ IMPORTANTE ANTES DE DESCARGAR

**Tamaños recomendados** (para NO cargar después):
- **Ancho**: 800px
- **Alto**: 600px  
- **Tamaño máximo**: 200KB
- **Formato**: PNG o JPG

**Si las imágenes son más grandes**:
→ Use herramienta online: TinyPNG.com
→ O comando Linux: `mogrify -resize 800x600 -quality 85% imagen.png`

---

## 🚀 PRÓXIMO PASO

Una vez confirmes:
1. Si hay más recetas
2. De dónde obtener las imágenes

**Yo haré**:
1. Crear carpetas del sistema
2. Copiar imágenes a ubicaciones correctas
3. Actualizar CÓDIGO automáticamente
4. Verificar que todo funcione

---

**¿LISTO? Por favor responde:**

1. ¿Cuál es la lista COMPLETA de recetas que tienes?
2. ¿De dónde descargarás/tienes las imágenes?
3. ¿Necesitas agregar más recetas o solo mapear estas 6?
