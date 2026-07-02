import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/palabra_model.dart';

class ApiService {
  // URL base de la API remota (puedes cambiarla por tu servidor o mock en el futuro)
  static const String _baseUrl = 'https://api.tlahtolli-diccionario.com/v1';

  /// **Consumir la API para traducir un término**
  /// [texto]: La palabra que escribió el usuario (ej: "hablar" o "tlahtoa").
  /// [direccion]: Indica el flujo, ej: "es_to_nah" o "nah_to_es".
  Future<List<PalabraModel>> buscarTraduccionEnNube(String texto, String direccion) async {
    // Construimos la URL con los parámetros de búsqueda requeridos
    final url = Uri.parse('$_baseUrl/traducir?query=$texto&dir=$direccion');

    try {
      // Realizamos la petición GET asíncrona con un tiempo límite de espera (timeout)
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      // Código 200 significa que el servidor respondió exitosamente
      if (response.statusCode == 200) {
        // Parseamos el cuerpo de la respuesta que viene codificado en UTF-8 (crucial para los acentos y caracteres heridos del Náhuatl)
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        
        // Siguiendo la estructura del JSON diseñada en la documentación:
        final List<dynamic> coincidencias = data['coincidencias'] ?? [];

        // Mapeamos la lista de JSONs a una lista de objetos de tipo PalabraModel
        return coincidencias.map((jsonItem) => PalabraModel.fromJson(jsonItem)).toList();
      } else {
        // Si el servidor responde con un error (ej: 404 o 500)
        throw Exception('Error en el servidor remoto: ${response.statusCode}');
      }
    } on http.ClientException {
      // Error de cliente HTTP (ej: el servidor no existe o problemas de DNS)
      throw Exception('No se pudo establecer conexión con el servidor.');
    } catch (e) {
      // Captura timeouts o cualquier otra excepción de red
      throw Exception('Fallo de red al intentar traducir en la nube.');
    }
  }
}