import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/palabra_model.dart';

class DbHelper {
  // Instancia interna única (Patrón Singleton)
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  // Constructor privado
  DbHelper._internal();

  // Factoría para retornar la misma instancia siempre
  factory DbHelper() => _instance;

  // Getter asíncrono para obtener la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicialización de la Base de Datos en el dispositivo Android
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tlahtolli_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Creación de las tablas (Esquema DDL relacional con llaves foráneas)
  Future<void> _onCreate(Database db, int version) async {
    // 1. Tabla Palabra
    await db.execute('''
      CREATE TABLE palabra (
        id_palabra INTEGER PRIMARY KEY AUTOINCREMENT,
        termino_espanol TEXT NOT NULL,
        termino_nahuatl TEXT NOT NULL,
        transcripcion_fonetica TEXT NOT NULL
      )
    ''');

    // 2. Tabla Favorito (Uso sin internet)
    await db.execute('''
      CREATE TABLE favorito (
        id_favorito INTEGER PRIMARY KEY AUTOINCREMENT,
        id_palabra INTEGER NOT NULL,
        fecha_guardado TEXT NOT NULL,
        FOREIGN KEY (id_palabra) REFERENCES palabra (id_palabra) ON DELETE CASCADE
      )
    ''');

    // 3. Tabla Historial
    await db.execute('''
      CREATE TABLE historial (
        id_historial INTEGER PRIMARY KEY AUTOINCREMENT,
        id_palabra INTEGER NOT NULL,
        fecha_consulta TEXT NOT NULL,
        direccion_trubuck TEXT NOT NULL,
        FOREIGN KEY (id_palabra) REFERENCES palabra (id_palabra) ON DELETE CASCADE
      )
    ''');

    // 4. NUEVO: Sembrado inicial del diccionario local.
    // Así la app puede traducir SIN internet desde la primera vez que se abre,
    // sin depender de que el usuario haya hecho antes una consulta en línea.
    await _sembrarDiccionarioInicial(db);
  }

  Future<void> _sembrarDiccionarioInicial(Database db) async {
    final List<Map<String, String>> diccionarioBase = [
      {'termino_espanol': 'hola', 'termino_nahuatl': 'niltze', 'transcripcion_fonetica': '[ˈnil.tse]'},
      {'termino_espanol': 'maiz', 'termino_nahuatl': 'cintli', 'transcripcion_fonetica': '[ˈsin.t͡ɬi]'},
      {'termino_espanol': 'sol', 'termino_nahuatl': 'tonatiuh', 'transcripcion_fonetica': '[toˈna.tiw]'},
      {'termino_espanol': 'agua', 'termino_nahuatl': 'atl', 'transcripcion_fonetica': '[ˈat͡ɬ]'},
      {'termino_espanol': 'casa', 'termino_nahuatl': 'calli', 'transcripcion_fonetica': '[ˈkal.li]'},
      {'termino_espanol': 'madre', 'termino_nahuatl': 'nantli', 'transcripcion_fonetica': '[ˈnan.t͡ɬi]'},
      {'termino_espanol': 'padre', 'termino_nahuatl': 'tahtli', 'transcripcion_fonetica': '[ˈtaʔ.t͡ɬi]'},
      {'termino_espanol': 'perro', 'termino_nahuatl': 'chichi', 'transcripcion_fonetica': '[ˈt͡ʃi.t͡ʃi]'},
      {'termino_espanol': 'flor', 'termino_nahuatl': 'xochitl', 'transcripcion_fonetica': '[ˈʃoː.t͡ʃit͡ɬ]'},
      {'termino_espanol': 'tierra', 'termino_nahuatl': 'tlalli', 'transcripcion_fonetica': '[ˈt͡ɬal.li]'},
      {'termino_espanol': 'viento', 'termino_nahuatl': 'ehecatl', 'transcripcion_fonetica': '[eˈe.kat͡ɬ]'},
      {'termino_espanol': 'luna', 'termino_nahuatl': 'metztli', 'transcripcion_fonetica': '[ˈmets.t͡ɬi]'},
      {'termino_espanol': 'estrella', 'termino_nahuatl': 'citlalin', 'transcripcion_fonetica': '[siˈtɬa.lin]'},
      {'termino_espanol': 'cielo', 'termino_nahuatl': 'ilhuicatl', 'transcripcion_fonetica': '[ilˈwi.kat͡ɬ]'},
      {'termino_espanol': 'arbol', 'termino_nahuatl': 'cuahuitl', 'transcripcion_fonetica': '[ˈkʷa.wit͡ɬ]'},
      {'termino_espanol': 'piedra', 'termino_nahuatl': 'tetl', 'transcripcion_fonetica': '[ˈtet͡ɬ]'},
      {'termino_espanol': 'fuego', 'termino_nahuatl': 'tletl', 'transcripcion_fonetica': '[ˈtlet͡ɬ]'},
      {'termino_espanol': 'dia', 'termino_nahuatl': 'tonalli', 'transcripcion_fonetica': '[toˈnal.li]'},
      {'termino_espanol': 'noche', 'termino_nahuatl': 'yohualli', 'transcripcion_fonetica': '[joˈwal.li]'},
      {'termino_espanol': 'amigo', 'termino_nahuatl': 'icniuhtli', 'transcripcion_fonetica': '[ikˈnjuʔ.t͡ɬi]'},
      {'termino_espanol': 'bueno', 'termino_nahuatl': 'cualli', 'transcripcion_fonetica': '[ˈkwal.li]'},
      {'termino_espanol': 'grande', 'termino_nahuatl': 'hueyi', 'transcripcion_fonetica': '[ˈwe.ji]'},
      {'termino_espanol': 'hablar', 'termino_nahuatl': 'tlahtoa', 'transcripcion_fonetica': '[t͡ɬaʔˈto.a]'},
      {'termino_espanol': 'comer', 'termino_nahuatl': 'tlacua', 'transcripcion_fonetica': '[ˈt͡ɬa.kʷa]'},
      {'termino_espanol': 'conejo', 'termino_nahuatl': 'tochtli', 'transcripcion_fonetica': '[ˈtot͡ʃ.t͡ɬi]'},
    ];

    for (final palabra in diccionarioBase) {
      await db.insert('palabra', palabra);
    }
  }

  // ==========================================
  // OPERACIONES CRUD: PALABRAS / TRADUCCIONES
  // ==========================================

  // Inserta una palabra si no existe, o devuelve el ID si ya existe
  Future<int> insertarOObtenerPalabra(PalabraModel palabra) async {
    final db = await database;

    // Verificar si la palabra exacta ya existe para no duplicar en el diccionario local
    final List<Map<String, dynamic>> coincidencia = await db.query(
      'palabra',
      where: 'termino_espanol = ? AND termino_nahuatl = ?',
      whereArgs: [palabra.terminoEspanol, palabra.terminoNahuatl],
    );

    if (coincidencia.isNotEmpty) {
      return coincidencia.first['id_palabra'] as int;
    }

    // Si no existe, se inserta limpia
    return await db.insert('palabra', palabra.toMap());
  }

  // ==========================================
  // OPERACIONES CRUD: HISTORIAL
  // ==========================================

  // Agregar una consulta al historial
  Future<void> agregarAlHistorial(int idPalabra, String direccion) async {
    final db = await database;
    final fechaActual = DateTime.now().toIso8601String();

    await db.insert('historial', {
      'id_palabra': idPalabra,
      'fecha_consulta': fechaActual,
      'direccion_trubuck': direccion,
    });
  }

  // Obtener el historial completo ordenado por la consulta más reciente (Uso de INNER JOIN)
  Future<List<Map<String, dynamic>>> obtenerHistorial() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT h.id_historial, h.fecha_consulta, h.direccion_trubuck, 
             p.id_palabra, p.termino_espanol, p.termino_nahuatl, p.transcripcion_fonetica
      FROM historial h
      INNER JOIN palabra p ON h.id_palabra = p.id_palabra
      ORDER BY h.fecha_consulta DESC
    ''');
  }

  // Limpiar todo el historial de búsquedas
  Future<void> limpiarHistorial() async {
    final db = await database;
    await db.delete('historial');
  }

  // ==========================================
  // OPERACIONES CRUD: FAVORITOS
  // ==========================================

  // Marcar una palabra como favorita
  Future<int> agregarAFavoritos(int idPalabra) async {
    final db = await database;

    // Validar primero si ya está agregada para evitar duplicar la tarjeta
    final List<Map<String, dynamic>> existe = await db.query(
      'favorito',
      where: 'id_palabra = ?',
      whereArgs: [idPalabra],
    );

    if (existe.isNotEmpty) return existe.first['id_favorito'] as int;

    final fechaActual = DateTime.now().toIso8601String();
    return await db.insert('favorito', {
      'id_palabra': idPalabra,
      'fecha_guardado': fechaActual,
    });
  }

  // Eliminar una palabra de favoritos
  Future<void> eliminarDeFavoritos(int idPalabra) async {
    final db = await database;
    await db.delete(
      'favorito',
      where: 'id_palabra = ?',
      whereArgs: [idPalabra],
    );
  }

  // Verificar el estado de favorito de una palabra específica (para pintar la estrella en la UI)
  Future<bool> esFavorito(int idPalabra) async {
    final db = await database;
    final List<Map<String, dynamic>> resultado = await db.query(
      'favorito',
      where: 'id_palabra = ?',
      whereArgs: [idPalabra],
    );
    return resultado.isNotEmpty;
  }

  // Obtener la lista completa de favoritos (Uso de INNER JOIN para visualización offline)
  Future<List<Map<String, dynamic>>> obtenerFavoritos() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT f.id_favorito, f.fecha_guardado, 
             p.id_palabra, p.termino_espanol, p.termino_nahuatl, p.transcripcion_fonetica
      FROM favorito f
      INNER JOIN palabra p ON f.id_palabra = p.id_palabra
      ORDER BY f.fecha_guardado DESC
    ''');
  }
}
