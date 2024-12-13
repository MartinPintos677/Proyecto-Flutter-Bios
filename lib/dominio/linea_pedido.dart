import 'package:formulario_basico/dominio/platos.dart';

class LineaPedido {
  Plato plato;
  int cantidad;

  LineaPedido({required this.plato, required this.cantidad});

  factory LineaPedido.fromMap(Map<String, Object?> mapa) {
    return LineaPedido(
      plato: Plato.fromMap(mapa['plato'] as Map<String, Object?>),
      cantidad: mapa['cantidad'] as int,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'idPlato': plato.idPlato, // Usamos idPlato, no el objeto completo
      'cantidad': cantidad,
    };
  }
}
