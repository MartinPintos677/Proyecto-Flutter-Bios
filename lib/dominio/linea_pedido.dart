import 'package:formulario_basico/dominio/platos.dart';

class LineaPedido {
  Plato plato;
  int cantidad;

  LineaPedido({required this.plato, required this.cantidad});

  factory LineaPedido.fromMap(Map<String, dynamic> map) {
    return LineaPedido(
      plato: Plato.fromMap(map),
      cantidad: map['cantidad'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idPlato': plato.idPlato,
      'cantidad': cantidad,
    };
  }
}
