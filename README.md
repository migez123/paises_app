# Países App

App en Flutter que consume la API de [REST Countries](https://restcountries.com) (v5) y muestra la lista de países y el detalle de cada uno.

## Funcionalidades

- **Lista de países** con bandera, nombre, capital y región.
- **Paginación automática**: la API entrega máximo 100 países por página, y al acercarse al final se piden los siguientes.
- **Buscador** por nombre o capital.
- **Detalle**: bandera grande, nombre común y oficial, capital, región, población, área, idiomas, monedas y fronteras.
- **Fronteras navegables**: al tocar un país vecino se abre su detalle.
- Estados de **cargando**, **éxito** y **error** (con botón "Reintentar"), y deslizar hacia abajo para recargar.
- Tema Material 3 con **modo claro y oscuro**, y animación Hero de la bandera.

## Tecnologías

| Paquete | Uso |
|---|---|
| `flutter_bloc` + `equatable` | Manejo de estado (BLoC) |
| `go_router` | Rutas `/` y `/country/:code` |
| `dio` | Peticiones HTTP a la API |

## Arquitectura

```
lib/
├── blocs/       # CountriesBloc (lista) y CountryDetailBloc (detalle)
├── config/      # API, cliente Dio, rutas, tema y formateadores
├── entities/    # Country: el país como lo usa la app
├── mappers/     # Convierte el modelo de la API en la entidad
├── models/      # Copia fiel del JSON de la API
├── screens/     # Pantalla de lista y de detalle
├── services/    # CountriesService: único acceso a la API
├── widgets/     # Componentes reutilizables
└── main.dart
```

Flujo de datos:

```
Pantalla → evento → BLoC → Service → API (Dio)
                                        ↓ JSON
Pantalla ← estado ← BLoC ← Entidad ← Mapper ← Modelo
```

## Cómo ejecutarla

1. Crea una API key gratuita en restcountries.com.
2. Copia `env.example.json` como `env.json` y pega tu key. `env.json` está en `.gitignore`, así que no se sube al repositorio.
3. Instala las dependencias y ejecuta:

```bash
flutter pub get
flutter run --dart-define-from-file=env.json
```
