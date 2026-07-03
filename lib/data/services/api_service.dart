import 'dart:convert';
import '../models/palabra_model.dart';

class ApiService {
  // Diccionario local estático de alta fidelidad para simular respuestas inmediatas de red
  final List<Map<String, dynamic>> _diccionarioServidor = [
    {
      "id_palabra": 301,
      "termino_espanol": "hola",
      "termino_nahuatl": "niltze",
      "transcripcion_fonetica": "[ˈnil.tse]"
    },
    {
      "id_palabra": 302,
      "termino_espanol": "maiz",
      "termino_nahuatl": "cintli",
      "transcripcion_fonetica": "[ˈsin.t͡ɬi]"
    },
    {
      "id_palabra": 303,
      "termino_espanol": "sol",
      "termino_nahuatl": "tonatiuh",
      "transcripcion_fonetica": "[toˈna.tiw]"
    },
    {
      "id_palabra": 304,
      "termino_espanol": "agua",
      "termino_nahuatl": "atl",
      "transcripcion_fonetica": "[ˈat͡ɬ]"
    },
    {
      "id_palabra": 305,
      "termino_espanol": "casa",
      "termino_nahuatl": "calli",
      "transcripcion_fonetica": "[ˈkal.li]"
    },
    {
      "id_palabra": 306,
      "termino_espanol": "madre",
      "termino_nahuatl": "nantli",
      "transcripcion_fonetica": "[ˈnan.t͡ɬi]"
    },
    {
      "id_palabra": 307,
      "termino_espanol": "perro",
      "termino_nahuatl": "chichi",
      "transcripcion_fonetica": "[ˈt͡ʃi.t͡ʃi]"
    },
    {
      "id_palabra": 308,
      "termino_espanol": "flor",
      "termino_nahuatl": "xochitl",
      "transcripcion_fonetica": "[ˈʃoː.t͡ʃit͡ɬ]"
    },
    {
      "id_palabra": 309,
      "termino_espanol": "tierra",
      "termino_nahuatl": "tlalli",
      "transcripcion_fonetica": "[ˈt͡ɬal.li]"
    },
    {
      "id_palabra": 310,
      "termino_espanol": "viento",
      "termino_nahuatl": "ehecatl",
      "transcripcion_fonetica": "[eˈe.kat͡ɬ]"
    }
  ];

  /*Future<List<PalabraModel>> buscarTraduccionEnNube(String texto, String direccion) async {
    // Simulamos un retraso de red de 400ms para mantener la UX de carga (Shimmer/CircularProgress)
    await Future.delayed(const Duration(milliseconds: 400));

    final String busqueda = texto.trim().toLowerCase();
    List<PalabraModel> resultados = [];

    for (var item in _diccionarioServidor) {
      if (direccion == 'es_to_nah') {
        if (item['termino_espanol'].toString().contains(busqueda)) {
          resultados.add(PalabraModel.fromJson(item));
        }
      } else {
        if (item['termino_nahuatl'].toString().contains(busqueda)) {
          resultados.add(PalabraModel.fromJson(item));
        }
      }
    }

    if (resultados.isNotEmpty) {
      return resultados;
    } else {
      throw Exception('No se encontraron coincidencias para esta búsqueda.');
    }
  }
}*/

  Future<List<PalabraModel>> buscarTraduccionEnNube(String texto,
      String direccion) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final String busqueda = texto.trim().toLowerCase();
// Convertimos a minúsculas y limpiamos guiones para evitar fallos de formato
    final String dirNormalizada = direccion.toLowerCase().replaceAll('-', '_');

    List<PalabraModel> resultados = [];

    for (var item in _diccionarioServidor) {
// Si la dirección contiene 'es' primero, asumimos Español a Náhuatl
      if (dirNormalizada.startsWith('es') ||
          dirNormalizada.contains('to_nah')) {
        if (item['termino_espanol'].toString().toLowerCase().contains(
            busqueda)) {
          resultados.add(PalabraModel.fromJson(item));
        }
      } else { // De lo contrario, asumimos Náhuatl a Español
        if (item['termino_nahuatl'].toString().toLowerCase().contains(
            busqueda)) {
          resultados.add(PalabraModel.fromJson(item));
        }
      }
    }

    if (resultados.isNotEmpty) {
      return resultados;
    } else {
      throw Exception('No se encontraron coincidencias para esta búsqueda.');
    }
  }
}