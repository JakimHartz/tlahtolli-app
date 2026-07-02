import '../database/db_helper.dart';
import '../models/palabra_model.dart';
import '../services/api_service.dart';

class TraductorRepository {
  final ApiService _apiService = ApiService();
  final DbHelper _dbHelper = DbHelper();

  /// **Método Core: Traducir Palabra (Estrategia Online / Offline)**
  /// [texto]: Palabra ingresada por el usuario.
  /// [direccion]: "es_to_nah" (Español a Náhuatl) o "nah_to_es" (Náhuatl a Español).
  /// [tieneInternet]: Bandera booleana que le pasa el ViewModel para conocer el estado de red.
  Future<List<PalabraModel>> traducir(String texto, String direccion, bool tieneInternet) async {
    final textoLimpio = texto.trim().toLowerCase();

    if (tieneInternet) {
      try {
        // 1. Buscamos el resultado en la API remota
        final List<PalabraModel> resultadosApi = await _apiService.buscarTraduccionEnNube(textoLimpio, direccion);

        if (resultadosApi.isNotEmpty) {
          for (var palabra in resultadosApi) {
            // 2. Guardamos la palabra en el diccionario local (si no existe) y obtenemos su ID
            final int idPalabra = await _dbHelper.insertarOObtenerPalabra(palabra);
            
            // 3. Registramos la consulta en la tabla de historial local
            await _dbHelper.agregarAlHistorial(idPalabra, direccion);
          }
        }
        return resultadosApi;
      } catch (e) {
        // Fallback: Si la API falla por alguna razón de red inesperada, intentamos buscar de forma local
        return await _buscarEnLocal(textoLimpio, direccion);
      }
    } else {
      // Si el dispositivo Android está completamente offline, buscamos directo en SQLite
      return await _buscarEnLocal(textoLimpio, direccion);
    }
  }

  /// **Búsqueda interna en SQLite cuando la app no tiene cobertura de red**
  Future<List<PalabraModel>> _buscarEnLocal(String texto, String direccion) async {
    final db = await _dbHelper.database;
    
    // Validamos la dirección de la traducción para saber en qué columna buscar en la BD local
    final String columnaBusqueda = (direccion == 'es_to_nah') ? 'termino_espanol' : 'termino_nahuatl';

    // Ejecutamos la consulta SQL buscando coincidencias exactas o parciales (LIKE)
    final List<Map<String, dynamic>> mapasLocal = await db.query(
      'palabra',
      where: '$columnaBusqueda LIKE ?',
      whereArgs: ['%$texto%'],
    );

    // Mapeamos los registros de la base de datos a objetos PalabraModel
    return mapasLocal.map((mapa) => PalabraModel.fromMap(mapa)).toList();
  }

  // =======================================================
  // REPASO DE MÉTODOS DE HISTORIAL Y FAVORITOS PARA LA UI
  // =======================================================

  // Obtener el historial formateado listo para las tarjetas de la interfaz
  Future<List<PalabraModel>> obtenerHistorialLocal() async {
    final List<Map<String, dynamic>> mapasHistorial = await _dbHelper.obtenerHistorial();
    return mapasHistorial.map((mapa) => PalabraModel.fromMap(mapa)).toList();
  }

  // Obtener la lista de favoritos de forma offline
  Future<List<PalabraModel>> obtenerFavoritosLocal() async {
    final List<Map<String, dynamic>> mapasFavoritos = await _dbHelper.obtenerFavoritos();
    return mapasFavoritos.map((mapa) => PalabraModel.fromMap(mapa)).toList();
  }

  // Alternar estado de favoritos desde la pantalla de Detalle
  Future<void> cambiarEstadoFavorito(int idPalabra, bool hacerFavorito) async {
    if (hacerFavorito) {
      await _dbHelper.agregarAFavoritos(idPalabra);
    } else {
      await _dbHelper.eliminarDeFavoritos(idPalabra);
    }
  }

  // Verificar si una palabra específica ya es favorita
  Future<bool> verificarSiEsFavorito(int idPalabra) async {
    return await _dbHelper.esFavorito(idPalabra);
  }

  // Limpiar historial desde la pantalla de configuración/historial
  Future<void> borrarTodoElHistorial() async {
    await _dbHelper.limpiarHistorial();
  }
}