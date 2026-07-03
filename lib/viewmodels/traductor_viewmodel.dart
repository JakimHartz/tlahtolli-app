import 'package:flutter/material.dart';
import '../data/models/palabra_model.dart';
import '../data/repositories/traductor_repository.dart';

class TraductorViewModel extends ChangeNotifier {
  final TraductorRepository _repository = TraductorRepository();

  // Estados de la aplicación
  List<PalabraModel> _resultados = [];
  List<PalabraModel> _historial = [];
  List<PalabraModel> _favoritos = [];
  
  bool _estaCargando = false;
  String _direccionTraduccion = 'es_to_nah'; // 'es_to_nah' o 'nah_to_es'
  bool _esPalabraFavorita = false;
  String? _mensajeError;

  // Getters públicos para que las Vistas puedan leer el estado sin modificarlo
  List<PalabraModel> get resultados => _resultados;
  List<PalabraModel> get historial => _historial;
  List<PalabraModel> get favoritos => _favoritos;
  bool get estaCargando => _estaCargando;
  String get direccionTraduccion => _direccionTraduccion;
  bool get esPalabraFavorita => _esPalabraFavorita;
  String? get mensajeError => _mensajeError;

  /// **1. Intercambiar Dirección de Traducción**
  void alternarDireccion() {
    if (_direccionTraduccion == 'es_to_nah') {
      _direccionTraduccion = 'nah_to_es';
    } else {
      _direccionTraduccion = 'es_to_nah';
    }
    _resultados.clear();
    _mensajeError = null;
    notifyListeners(); // Notifica a la UI para cambiar los labels o campos
  }

  /// **2. Lógica de Ejecución de Traducción**
  Future<void> ejecutarTraduccion(String texto, bool tieneInternet) async {
    if (texto.trim().isEmpty) return;

    _estaCargando = true;
    _mensajeError = null;
    _resultados.clear();
    notifyListeners();

    try {
      _resultados = await _repository.traducir(texto, _direccionTraduccion, tieneInternet);
      
      if (_resultados.isEmpty) {
        _mensajeError = 'No se encontraron coincidencias para esta búsqueda.';
      } else {
        // Si hay un resultado válido, verificamos de inmediato si está en favoritos
        if (_resultados.first.idPalabra != null) {
          await verificarFavoritoStatus(_resultados.first.idPalabra!);
        }
      }
    } catch (e) {
      _mensajeError = e.toString().replaceAll('Exception:', '');
      print("❌ ERROR REAL EN VIEWMODEL: $e");
    } finally {
      _estaCargando = false;
      notifyListeners();
      cargarHistorial(); // Refrescamos el historial automáticamente al buscar
    }
  }

  /// **3. Gestión del Historial**
  Future<void> cargarHistorial() async {
    _historial = await _repository.obtenerHistorialLocal();
    notifyListeners();
  }

  Future<void> borrarHistorial() async {
    await _repository.borrarTodoElHistorial();
    _historial.clear();
    notifyListeners();
  }

  /// **4. Gestión de Favoritos**
  Future<void> cargarFavoritos() async {
    _favoritos = await _repository.obtenerFavoritosLocal();
    notifyListeners();
  }

  Future<void> verificarFavoritoStatus(int idPalabra) async {
    _esPalabraFavorita = await _repository.verificarSiEsFavorito(idPalabra);
    notifyListeners();
  }

  Future<void> toggleFavorito(PalabraModel palabra) async {
    if (palabra.idPalabra == null) return;
    
    // Invertimos el estado lógico local primero (interfaz fluida)
    _esPalabraFavorita = !_esPalabraFavorita;
    notifyListeners();

    // Impactamos la Base de Datos SQLite de manera persistente
    await _repository.cambiarEstadoFavorito(palabra.idPalabra!, _esPalabraFavorita);
    
    // Refrescamos la lista general de la pestaña favoritos por si está abierta en segundo plano
    await cargarFavoritos();
  }
}