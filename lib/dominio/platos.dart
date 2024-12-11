class Plato {
  int idPlato;
  String nombre;
  double precio;
  String diasDisponibles;
  String? foto;
  bool activo;

  Plato({
    required this.idPlato,
    required this.nombre,
    required this.precio,
    required this.diasDisponibles,
    this.foto,
    required this.activo,
  });

  // Método para convertir de Map a Plato
  factory Plato.fromMap(Map<String, dynamic> map) {
    return Plato(
      idPlato: map['idPlato'],
      nombre: map['nombre'],
      precio: map['precio']?.toDouble() ?? 0.0, // Convierte a double
      diasDisponibles: map['diasDisponibles'],
      foto: map['foto'] ?? '',
      activo: map['activo'] == 1, // Activo cuando 1
    );
  }

  // Método para convertir Plato a Map (para insertar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'precio': precio,
      'diasDisponibles': diasDisponibles,
      'foto': foto,
      'activo': activo ? 1 : 0, // 1 para activo, 0 para inactivo
    };
  }
}
