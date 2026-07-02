class PalabraModel {
  final int? idPalabra;
  final String terminoEspanol;
  final String terminoNahuatl;
  final String transcripcionFonetica;

  PalabraModel({
    this.idPalabra,
    required this.terminoEspanol,
    required this.terminoNahuatl,
    required this.transcripcionFonetica,
  });

  /// **1. De Objeto a Map (Serialización para SQLite)**
  /// Transforma las propiedades de la clase a un mapa de datos compatible 
  /// con los campos de la tabla `palabra` en sqflite.
  Map<String, dynamic> toMap() {
    return {
      if (idPalabra != null) 'id_palabra': idPalabra,
      'termino_espanol': terminoEspanol,
      'termino_nahuatl': terminoNahuatl,
      'transcripcion_fonetica': transcripcionFonetica,
    };
  }

  /// **2. De Map a Objeto (Deserialización desde SQLite)**
  /// Construye una instancia limpia de PalabraModel usando los datos extraídos 
  /// tras una consulta relacional en la base de datos local.
  factory PalabraModel.fromMap(Map<String, dynamic> map) {
    return PalabraModel(
      idPalabra: map['id_palabra'] as int?,
      terminoEspanol: map['termino_espanol'] as String,
      terminoNahuatl: map['termino_nahuatl'] as String,
      transcripcionFonetica: map['transcripcion_fonetica'] as String,
    );
  }

  /// **3. De JSON a Objeto (Deserialización desde la API REST)**
  /// Lee la estructura interna del payload JSON devuelto por el servidor cloud.
  /// Mapea de forma segura los atributos externos con las propiedades de Flutter.
  factory PalabraModel.fromJson(Map<String, dynamic> json) {
    return PalabraModel(
      idPalabra: null, // Las palabras nuevas de la API no tienen ID local asignado aún
      terminoEspanol: json['termino_espanol'] as String,
      terminoNahuatl: json['termino_nahuatl'] as String,
      transcripcionFonetica: json['transcripcion_fonetica'] as String,
    );
  }
}