/// Configuración centralizada de la app.
///
/// Usamos MockAPI (https://mockapi.io) como backend: es gratuito, queda
/// en línea todo el tiempo (no depende de tu laptop encendida) y entrega
/// HTTPS listo para usar en un celular físico sin configurar IPs locales.
///
/// CÓMO OBTENER TU URL:
/// 1. Sigue las instrucciones de /api_server/README.md (sección MockAPI)
///    para crear el recurso "palabras" y subir el diccionario con
///    seed_mockapi.js.
/// 2. Copia la URL base de tu proyecto MockAPI, algo como:
///      https://<TU_PROJECT_ID>.mockapi.io/api/v1
/// 3. Pégala abajo, SIN "/palabras" al final (eso ya lo agrega el código).
class AppConstants {
  static const String apiBaseUrl =
      "https://6a472839abfcbaade118073b.mockapi.io/api/v1";

  // Tiempo máximo de espera antes de considerar que no hay internet /
  // el servidor no responde, y hacer fallback a la base local (SQLite).
  static const Duration apiTimeout = Duration(seconds: 6);
}

// ¿Prefieres correr tu propio servidor Node.js en vez de MockAPI?
// Usa la carpeta /api_server tal cual (server.js) y cambia apiBaseUrl por
// algo como "http://10.0.2.2:3000" (emulador) — ver instrucciones en su
// README. Ambas opciones funcionan con el mismo api_service.dart si ajustas
// la forma de la respuesta; el código actual está preparado para MockAPI
// (arreglo JSON plano), que es la opción recomendada por comodidad.
