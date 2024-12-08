import 'package:flutter/material.dart';

class PantallaAgregarCliente extends StatefulWidget {
  const PantallaAgregarCliente({super.key});

  @override
  State<PantallaAgregarCliente> createState() => _PantallaAgregarClienteState();
}

class _PantallaAgregarClienteState extends State<PantallaAgregarCliente> {
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  void _guardarCliente() {
    final cedula = _cedulaController.text.trim();
    final nombre = _nombreController.text.trim();
    final direccion = _direccionController.text.trim();
    final telefono = _telefonoController.text.trim();

    if (cedula.isEmpty ||
        nombre.isEmpty ||
        direccion.isEmpty ||
        telefono.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos obligatorios'),
        ),
      );
      return;
    }

    // Lógica para guardar el cliente
    print('Cédula: $cedula');
    print('Nombre: $nombre');
    print('Dirección: $direccion');
    print('Teléfono: $telefono');

    // Volver a la pantalla anterior
    Navigator.pop(context);
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para la cédula
              TextField(
                controller: _cedulaController,
                decoration: InputDecoration(
                  labelText: 'Cédula',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Campo para el nombre
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Campo para la dirección
              TextField(
                controller: _direccionController,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Campo para el teléfono
              TextField(
                controller: _telefonoController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              // Botón para guardar
              Center(
                child: ElevatedButton(
                  onPressed: _guardarCliente,
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
    );
  }
}
