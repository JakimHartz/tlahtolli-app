import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/constants.dart';
import '../models/palabra_model.dart';

/// Cliente HTTP que consume la API REST real (MockAPI por defecto).
///
/// El diccionario "hardcodeado" que tenía este archivo antes se eliminó:
/// esas mismas palabras (y muchas más) ahora viven en /api_server/diccionario.json,
/// listas para subirse a MockAPI con seed_mockapi.js. Un subconjunto también
/// vive sembrado directamente en `db_helper.dart` para que la app traduzca
/// sin internet desde el primer uso.
class ApiService {
  Future<List<PalabraModel>> buscarTraduccionEnNube(
      String texto, String direccion) async {
    final String busqueda = texto.trim().toLowerCase();
    final String dirNormalizada = direccion.toLowerCase().replaceAll('-', '_');

    // MockAPI: GET /palabras?search=texto
    // "search" busca coincidencias parciales en TODOS los campos de texto
    // del recurso (termino_espanol Y termino_nahuatl a la vez), así que
    // luego filtramos en el cliente para quedarnos solo con las coincidencias
    // del campo correcto según la dirección de traducción elegida.
    final uri = Uri.parse('${AppConstants.apiBaseUrl}/palabras').replace(
      queryParameters: {'search': busqueda},
    );

    final http.Response respuesta;
    try {
      respuesta = await http.get(uri).timeout(AppConstants.apiTimeout);
    } catch (e) {
      // Sin internet, servidor caído, timeout, DNS, URL mal configurada, etc.
      throw Exception('No se pudo conectar con el servidor.');
    }

    if (respuesta.statusCode != 200) {
      throw Exception(
          'El servidor respondió con un error (${respuesta.statusCode}).');
    }

    final List<dynamic> lista = jsonDecode(utf8.decode(respuesta.bodyBytes));

    final bool buscarEnEspanol =
        dirNormalizada.startsWith('es') || dirNormalizada.contains('to_nah');
    final String campo = buscarEnEspanol ? 'termino_espanol' : 'termino_nahuatl';

    final List<dynamic> coincidencias = lista.where((item) {
      final valor = (item[campo] ?? '').toString().toLowerCase();
      return valor.contains(busqueda);
    }).toList();

    if (coincidencias.isEmpty) {
      throw Exception('No se encontraron coincidencias para esta búsqueda.');
    }

    return coincidencias
        .map((item) => PalabraModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
