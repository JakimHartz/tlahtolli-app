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
  Map<String, dynamic> toMap() {
    return {
      if (idPalabra != null) 'id_palabra': idPalabra,
      'termino_espanol': terminoEspanol,
      'termino_nahuatl': terminoNahuatl,
      'transcripcion_fonetica': transcripcionFonetica,
    };
  }

  /// **2. De Map a Objeto (Deserialización desde SQLite)**
  factory PalabraModel.fromMap(Map<String, dynamic> map) {
    return PalabraModel(
      idPalabra: map['id_palabra'] as int?,
      terminoEspanol: map['termino_espanol'] as String,
      terminoNahuatl: map['termino_nahuatl'] as String,
      transcripcionFonetica: map['transcripcion_fonetica'] as String,
    );
  }

  /// **3. De JSON a Objeto (Deserialización desde la API REST)**
  ///
  /// CORREGIDO: antes se leía la llave 'transcripcion_fonetica', pero el
  /// diccionario del servicio (y ahora también la API real) puede variar
  /// el nombre de la llave. Usamos '??' para aceptar ambas variantes y
  /// evitar que un cambio de nombre en el backend vuelva a romper la app.
  factory PalabraModel.fromJson(Map<String, dynamic> json) {
    return PalabraModel(
      idPalabra: null, // Las palabras nuevas de la API no tienen ID local aún
      terminoEspanol: json['termino_espanol'] as String,
      terminoNahuatl: json['termino_nahuatl'] as String,
      transcripcionFonetica:
          (json['transcripcion_fonetica'] ?? json['transcripcion_foneticas'])
              as String,
    );
  }
}
