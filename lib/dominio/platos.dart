class Plato {
  int idPlato;
  String nombre;
  double precio;
  String diasDisponibles;
  String? foto; // Mantener como opcional (nullable)
  bool activo;

  Plato({
    required this.idPlato,
    required this.nombre,
    required this.precio,
    required this.diasDisponibles,
    this.foto, // Foto opcional
    required this.activo,
  });

  // Método para convertir de Map a Plato
  factory Plato.fromMap(Map<String, dynamic> map) {
    return Plato(
      idPlato: map['idPlato'],
      nombre: map['nombre'],
      precio: map['precio']?.toDouble() ?? 0.0, // Convierte a double
      diasDisponibles: map['diasDisponibles'],
      foto: map[
          'foto'], // No asignamos una cadena vacía, dejamos que sea null si no existe
      activo: map['activo'] == 1, // Activo cuando 1
    );
  }

  // Método para convertir Plato a Map
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'precio': precio,
      'diasDisponibles': diasDisponibles,
      'foto': foto ?? null, // Si no hay foto, lo dejamos como null
      'activo': activo ? 1 : 0, // 1 para activo, 0 para inactivo
    };
  }
}
