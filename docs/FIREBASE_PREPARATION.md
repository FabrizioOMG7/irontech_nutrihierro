# Firebase Preparation (sin conexión activa todavía)

## Objetivo
Conectar Firebase en una siguiente iteración sin romper el avance UI/mock actual.

## Colecciones sugeridas (Firestore)

1. `users/{userId}`
   - `displayName`
   - `createdAt`

2. `users/{userId}/children/{childId}`
   - `name`
   - `birthDate`
   - `gender`
   - `createdAt`

3. `recipes/{recipeId}`
   - `title`
   - `description`
   - `foodIds` (array)
   - `preparationSteps` (array)
   - `imageUrl`
   - `targetStage`
   - `ironMgEstimate`

4. `foods/{foodId}`
   - `name`
   - `description`
   - `ironMgPer100g`
   - `imageUrl`

5. `users/{userId}/combinations/{combinationId}`
   - `foodIds` (array)
   - `note`
   - `imageUrl`
   - `createdAt`

6. `users/{userId}/children/{childId}/daily_requirements/{date}`
   - `estimatedIronGoalMg`
   - `consumedIronMg`
   - `progressPercent`
   - `status` (low, in_progress, completed)

## Reglas mínimas (base)

- Lectura de `recipes` y `foods`: pública (o autenticada según estrategia de producto).
- Escritura de `recipes` y `foods`: solo admins.
- Lectura/escritura de subcolecciones `users/{userId}/...`: solo dueño autenticado.

Ejemplo conceptual:

```txt
allow read, write: if request.auth != null && request.auth.uid == userId;
```

## Paso de integración recomendado

1. Inicializar Firebase (`firebase_core`) y entorno por plataforma.
2. Crear implementaciones Firestore para:
   - `RecipesRepository`
   - `UserCombinationsRepository`
   - `ProfileRepository` (migración opcional por fases)
3. Cambiar providers a implementación Firestore manteniendo la misma interfaz.
4. Mantener fallback mock para desarrollo offline/demo.
5. Migrar reglas locales de requerimiento diario (hoy mock por edad) a configuración centralizada en backend.
