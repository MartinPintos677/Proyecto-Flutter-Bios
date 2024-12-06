import 'package:flutter/material.dart';

class PantallaAgregarPlato extends StatefulWidget {
  const PantallaAgregarPlato({super.key});

  @override
  State<PantallaAgregarPlato> createState() => _PantallaAgregarPlatoState();
}

class _PantallaAgregarPlatoState extends State<PantallaAgregarPlato> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final List<bool> _diasSeleccionados =
      List.filled(7, false); // 7 días de la semana
  String? _fotoPath; // Ruta de la foto seleccionada

  final List<String> _diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  void _elegirFoto() async {
    final String? ruta = "ruta/foto/ejemplo.jpg"; // Reemplazar con la ruta real
    setState(() {
      _fotoPath = ruta;
    });
  }

  void _guardarPlato() {
    final nombre = _nombreController.text.trim();
    final precio = double.tryParse(_precioController.text.trim());
    final diasSeleccionados = _diasSeleccionados
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => _diasSemana[entry.key])
        .toList();

    if (nombre.isEmpty || precio == null || precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, completa los campos obligatorios')),
      );
      return;
    }

    print('Nombre: $nombre');
    print('Precio: $precio');
    print('Días disponibles: $diasSeleccionados');
    print('Foto: ${_fotoPath ?? "No se seleccionó una foto"}');

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
                  'Agregar Plato',
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
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Plato',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _precioController,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _elegirFoto,
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Elegir Foto'),
                  ),
                  const SizedBox(width: 10),
                  _fotoPath != null
                      ? Text(
                          'Foto seleccionada',
                          style: TextStyle(color: Colors.green[700]),
                        )
                      : const Text(
                          'No se seleccionó una foto',
                          style: TextStyle(color: Colors.grey),
                        ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'Días Disponibles:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Column(
                children: _diasSemana.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final String dia = entry.value;
                  return CheckboxListTile(
                    title: Text(dia),
                    value: _diasSeleccionados[index],
                    onChanged: (value) {
                      setState(() {
                        _diasSeleccionados[index] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _guardarPlato,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Guardar Plato'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
