import 'package:formulario_basico/dominio/linea_pedido.dart';

class Pedido {
  int? idPedido;
  DateTime fechaHoraRealizacion;
  String? observaciones;
  double importeTotal;
  String estadoEntrega;
  bool? cobrado;

  String clienteCedula; // Guardamos solo la cédula
  String? clienteNombre; // Nuevo campo para almacenar el nombre del cliente
  final List<LineaPedido>? lineasPedidos;

  Pedido({
    required this.idPedido,
    required this.fechaHoraRealizacion,
    this.observaciones,
    required this.importeTotal,
    required this.estadoEntrega,
    required this.cobrado,
    required this.clienteCedula,
    this.clienteNombre, // Inicializa el nuevo campo
    this.lineasPedidos,
  });

  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      idPedido: map['idPedido'] as int?,
      fechaHoraRealizacion:
          DateTime.parse(map['fechaHoraRealizacion'] as String),
      observaciones: map['observaciones'] as String?,
      importeTotal: (map['importeTotal'] as num).toDouble(),
      estadoEntrega: map['estadoEntrega'] as String,
      cobrado: map['cobrado'] == 1, // Convertir de 1 o 0 a true o false
      clienteCedula: map['cedula'] as String,
      clienteNombre: null, // Se asignará después de obtener del DAO de clientes
      lineasPedidos: null, // Cargar líneas por separado si es necesario
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idPedido': idPedido,
      'fechaHoraRealizacion': fechaHoraRealizacion.toIso8601String(),
      'observaciones': observaciones,
      'importeTotal': importeTotal,
      'estadoEntrega': estadoEntrega,
      'cobrado': cobrado == true ? 1 : 0, // Convertir bool a 1 o 0
      'cedula': clienteCedula, // Solo la cédula
    };
  }
}
