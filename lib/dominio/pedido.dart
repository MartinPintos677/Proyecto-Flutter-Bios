import 'package:formulario_basico/dominio/linea_pedido.dart';

class Pedido {
  int? idPedido;
  DateTime fechaHoraRealizacion;
  String observaciones;
  double importeTotal;
  String estadoEntrega;
  bool cobrado;

  String clienteCedula; // Cambio aquí: solo guardamos la cédula
  final List<LineaPedido>? lineasPedidos;

  Pedido({
    required this.idPedido,
    required this.fechaHoraRealizacion,
    required this.observaciones,
    required this.importeTotal,
    required this.estadoEntrega,
    required this.cobrado,
    required this.clienteCedula,
    this.lineasPedidos,
  });

  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      idPedido: map['idPedido'] as int?,
      fechaHoraRealizacion: DateTime.parse(map["fechaHoraRealizacion"] as String),
      observaciones: map['observaciones'] as String,
      importeTotal: map['importeTotal']?.toDouble() ?? 0.0,
      estadoEntrega: map['estadoEntrega'] as String,
      cobrado: map["cobrado"] as int != 0,
      clienteCedula: map['cedula'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idPedido': idPedido,
      'fechaHoraRealizacion': fechaHoraRealizacion.toIso8601String(),
      'observaciones': observaciones,
      'importeTotal': importeTotal,
      'estadoEntrega': estadoEntrega,
      'cobrado': cobrado ? 1 : 0,
      'clienteCedula': clienteCedula, // Solo la cédula
      'lineasPedidos': lineasPedidos?.map((linea) => linea.toMap()).toList(),
    };
  }
}
