# LOG DE IMPLEMENTACION - FASE 2 Y AJUSTE DE ARQUITECTURA

## 1) Objetivo funcional alcanzado

1. Usuario entra en detalle de organizacion.
2. App hace GET de tareas de esa organizacion.
3. Usuario pulsa "Crear tarea".
4. App abre formulario, valida datos y hace POST.
5. Al volver, la pantalla de detalle lanza de nuevo el GET y refresca lista.

## 2) Ficheros creados y carpeta

### Creado

- `lib/models/task.dart`

Que aporta:

- Modelo `Task` independiente (ya no depende de que organizacion traiga tareas embebidas).
- Campos: `id`, `titulo`, `fechaInicio`, `fechaFin`.
- `Task.fromJson(...)` para parsear respuestas de API.

## 3) Ficheros actualizados y carpeta

### Actualizado en servicios

- `lib/services/organization_service.dart`

Cambios clave:

- Metodo `fetchTasksByOrganization(String organizacionId)`:
	- GET `/organizaciones/{organizacionId}/tareas`
	- Retorna `Future<List<Task>>`.
- Metodo `createTaskByOrganization(...)`:
	- POST `/organizaciones/{organizacionId}/tareas`
	- Body JSON enviado:
		- `titulo`
		- `fechaInicio` (ISO UTC)
		- `fechaFin` (ISO UTC)
		- `usuarios` (lista de IDs)

### Actualizado en pantallas

- `lib/screens/organization_detail_screen.dart`

Cambios clave:

- Eliminada lista mock local de tareas.
- Integrado `FutureBuilder<List<Task>>` para cargar tareas reales.
- Estados de UI gestionados:
	- Cargando: `CircularProgressIndicator`.
	- Sin datos: "Aun no hay tareas en esta organizacion".
	- Con datos: `ListView.builder` + `Card` para cada tarea.
- Navegacion a crear tarea ahora pasa:
	- `organizacionId`
	- `usuarios`
- Al volver de formulario:
	- Si se creo tarea (`Navigator.pop(..., true)`), se recarga GET.

- `lib/screens/create_task_screen.dart`

Cambios clave:

- Sigue siendo `StatefulWidget` con `Form` y `GlobalKey<FormState>`.
- Validaciones locales:
	- Titulo obligatorio.
	- Fecha inicio obligatoria.
	- Fecha fin obligatoria.
	- Fecha fin >= fecha inicio.
- Uso de `TextEditingController` para titulo e inputs de fecha.
- Integracion con backend:
	- En submit valida formulario.
	- Llama a `createTaskByOrganization(...)`.
	- Si OK: `Navigator.pop(context, true)`.
	- Si error: `SnackBar` informativo.

## 4) Elementos clave de Flutter que han ayudado

### Gestion de UI reactiva

- `StatefulWidget`: necesario para manejar estado local (fechas, loading, future de tareas).
- `setState`: usado para refrescar UI tras cambios de estado.

### Formularios y validacion

- `Form` + `GlobalKey<FormState>`: base para validar de forma centralizada.
- `TextFormField` con `validator`: reglas de negocio locales inmediatas.
- `TextEditingController`: facilita lectura de valores y futura integracion con otras capas.

### Fechas

- `showDatePicker`: selector nativo y UX consistente en plataformas Flutter.
- Normalizacion de fecha para el payload del backend y envio en formato ISO UTC.

### Asincronia y datos remotos

- `Future<List<Task>>`: tipado fuerte para operaciones de red.
- `FutureBuilder`: simplifica renderizado declarativo de estados loading/error/data.
- `http` + `json.decode/json.encode`: cliente HTTP y serializacion del body/response.

### Navegacion y retorno de resultado

- `Navigator.push` para abrir formulario.
- `Navigator.pop(context, true)` para devolver exito.
- Patron de resultado booleano para decidir si refrescar en pantalla anterior.

## 5) Beneficio arquitectonico obtenido

La app ahora respeta mejor separacion de responsabilidades:

- Modelos en `lib/models`.
- Llamadas HTTP y transformacion de datos en `lib/services`.
- Renderizado y experiencia de usuario en `lib/screens`.

Esto facilita que futuras fases (estado global, cache, tests, backend real en produccion) se integren sin rehacer la UI.
