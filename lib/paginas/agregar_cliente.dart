import 'package:flutter/material.dart';
import 'package:formulario_basico/daos/dao_clientes.dart';
import 'package:formulario_basico/dominio/clientes.dart';

class PantallaAgregarCliente extends StatefulWidget {
  const PantallaAgregarCliente({super.key});

  @override
  State<PantallaAgregarCliente> createState() => _PantallaAgregarClienteState();
}

class _PantallaAgregarClienteState extends State<PantallaAgregarCliente> {
  final GlobalKey<FormState> _claveFormulario = GlobalKey<FormState>();

  Cliente? _cliente;
  late String? _cedula;
  late String? _nombre;
  late String? _direccion;
  late String? _telefono;

  @override
  void didChangeDependencies() {
    //Esta se ejecuta inmedietamente despues del initState
    _cliente = ModalRoute.of(context)?.settings.arguments
        as Cliente?; //Si al final todo es null, significa que estamos en un agregar

    _cedula = _cliente?.cedula;
    _nombre = _cliente?.nombre;
    _direccion = _cliente?.direccion;
    _telefono = _cliente?.telefono;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Altura personalizada
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.black, // Fondo negro
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón de retroceso
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Vuelve a la página anterior
                  },
                ),
                // Título centrado
                const Text(
                  'Agregar Cliente',
                  style: TextStyle(
                    color: Colors.white, // Texto blanco
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                // Logo en la derecha con cursor "dedito"
                MouseRegion(
                  cursor: SystemMouseCursors.click, // Cursor dedito
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/'); // Redirige a inicio
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/img/logo.jpg',
                        width: 50,
                        height: 45,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Form(
              key: _claveFormulario,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo para la cédula
                  TextFormField(
                    cursorColor: Colors.green,
                    enabled: _cliente != null ? false : true,
                    decoration: InputDecoration(
                      labelText: 'Cédula',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    initialValue: _cedula,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La cédula no debe quedar vacía';
                      }

                      // Validar que la cédula tenga 8 caracteres y sea numérica
                      if (value.length != 8) {
                        return 'La cédula debe tener 8 caracteres';
                      }

                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'La cédula debe ser numérica';
                      }

                      return null; // Todo OK
                    },
                    onSaved: (newValue) {
                      _cedula = newValue!;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Campo para el nombre
                  TextFormField(
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    initialValue: _nombre,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre no debe quedar vacío';
                      }

                      if (value.length > 100) {
                        return 'El nombre no debe tener más de 100 caracteres';
                      }
                      return null; //Todo Ok
                    },
                    onSaved: (newValue) {
                      _nombre = newValue!;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Campo para la dirección
                  TextFormField(
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      labelText: 'Dirección',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    initialValue: _direccion,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La dirección no debe quedar vacía';
                      }

                      if (value.length > 100) {
                        return 'La dirección no debe tener más de 100 caracteres';
                      }
                      return null; //Todo Ok
                    },
                    onSaved: (newValue) {
                      _direccion = newValue!;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Campo para el teléfono
                  TextFormField(
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    initialValue: _telefono,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El telefono no debe quedar vacío';
                      }
                      return null; //Todo Ok
                    },
                    onSaved: (newValue) {
                      _telefono = newValue!;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Botón para guardar
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_claveFormulario.currentState?.validate() ??
                            false) {
                          _claveFormulario.currentState?.save();

                          String mensaje;

                          try {
                            if (_cliente == null) {
                              await DaoClientes().insertCliente(Cliente(
                                  cedula: _cedula!,
                                  nombre: _nombre!,
                                  direccion: _direccion!,
                                  telefono: _telefono!));
                            } else {
                              await DaoClientes().updateCliente(Cliente(
                                  cedula: _cedula!,
                                  nombre: _nombre!,
                                  direccion: _direccion!,
                                  telefono: _telefono!));
                            }

                            mensaje =
                                'Cliente ${_cliente == null ? 'Agregado' : 'Modificado'} con éxito';

                            if (context.mounted)
                              Navigator.of(context).pop(true);
                          } on Exception catch (e) {
                            mensaje =
                                'Error ${e.toString().startsWith('Exception: ') ? e.toString().substring(11) : e.toString()}';
                          }

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  mensaje,
                                  textAlign: TextAlign.center,
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor:
                                    const Color.fromARGB(128, 64, 64, 64),
                                shape: const StadiumBorder(),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 44, 164, 50),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Guardar Cliente'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
