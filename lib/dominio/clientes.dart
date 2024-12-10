class Cliente {
  String cedula;
  String nombre;
  String direccion;
  String telefono;

  Cliente({
    required this.cedula,
    required this.nombre,
    required this.direccion,
    required this.telefono,
  });

// Convertimos un Cliente en un Map para insertarlo en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'cedula': cedula,
      'nombre': nombre,
      'direccionEntrega': direccion,
      'telefonoContacto': telefono,
    };
  }

  // Convertimos un Map en un Cliente
  static Cliente fromMap(Map<String, dynamic> map) {
    return Cliente(
      cedula: map['cedula'],
      nombre: map['nombre'],
      direccion: map['direccion'],
      telefono: map['telefono'],
    );
  }
}
