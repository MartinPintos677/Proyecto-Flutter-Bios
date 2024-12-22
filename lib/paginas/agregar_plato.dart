import 'package:flutter/material.dart';
import 'package:formulario_basico/daos/dao_platos.dart';
import 'package:formulario_basico/dominio/platos.dart';
import 'package:image_picker/image_picker.dart';

class PantallaAgregarPlato extends StatefulWidget {
  const PantallaAgregarPlato({super.key});

  @override
  State<PantallaAgregarPlato> createState() => _PantallaAgregarPlatoState();
}

class _PantallaAgregarPlatoState extends State<PantallaAgregarPlato> {
  final GlobalKey<FormState> _claveFormulario = GlobalKey<FormState>();

  Plato? _plato;
  late String _nombre;
  late double _precio;
  late bool _disponible;
  String? _fotoPath;

  final List<String> _diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];
  List<bool> _diasSeleccionados = List.generate(7, (index) => false);

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Si la variable _plato no es null, inicializa las variables con sus valores
    if (_plato != null) {
      _nombre = _plato!.nombre;
      _precio = _plato!.precio;
      _disponible = _plato!.activo;
    } else {
      // Si _plato es null, asigna valores predeterminados
      _nombre = '';
      _precio = 0.0;
      _disponible = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Recuperar el plato si existe
    _plato = ModalRoute.of(context)?.settings.arguments as Plato?;

    if (_plato != null) {
      _nombre = _plato?.nombre ?? '';
      _precio = _plato?.precio ?? 0.0;
      _disponible = _plato?.activo ?? true;

      // Convertimos los días disponibles del plato en una lista de booleanos
      final diasDisponiblesList = _plato?.diasDisponibles.split(',') ?? [];

      // Inicializamos _diasSeleccionados para que coincida con los días disponibles
      _diasSeleccionados = List.generate(7, (index) {
        return diasDisponiblesList.contains(_diasSemana[index]);
      });
      // Asignar la foto si existe
      _fotoPath = _plato?.foto ?? ''; // Si hay foto, se asigna
    } else {
      // Si no hay plato (es para agregar uno nuevo), los días estarán todos desmarcados
      _diasSeleccionados = List.generate(7, (index) => false);
    }
  }

  // Método para elegir foto (galería o cámara)
  Future<void> _elegirFoto() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona una fuente de la foto'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text('Cámara'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text('Galería'),
            ),
          ],
        );
      },
    );

    if (source != null) {
      final XFile? foto = await _picker.pickImage(source: source);

      if (foto != null) {
        setState(() {
          _fotoPath = foto.path;
        });
      }
    }
  }

  // Método para guardar o actualizar el plato
  void _guardarPlato() async {
    if (!_claveFormulario.currentState!.validate()) {
      return;
    }

    // Guardar los valores del formulario
    _claveFormulario.currentState?.save();

    // Validar precio
    if (_precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El precio debe ser mayor que 0')),
      );
      return;
    }

    // Los días seleccionados lo convertimos en una cadena string separada por ,
    final diasSeleccionados = _diasSemana
        .asMap()
        .entries
        .where((entry) => _diasSeleccionados[entry.key])
        .map((entry) => entry.value)
        .toList();

    final diasSeleccionadosString = diasSeleccionados.join(',');

    // Crear el objeto Plato
    final plato = Plato(
      idPlato: _plato?.idPlato ?? 0,
      nombre: _nombre,
      precio: _precio,
      activo: _disponible,
      diasDisponibles:
          diasSeleccionadosString, // Guardar los días seleccionados como una cadena
      foto: _fotoPath ?? null, // Si no hay foto, lo dejamos como null
    );

    // Guardar o actualizar en la base de datos
    final daoPlato = DaoPlato();
    String mensaje;
    try {
      if (_plato == null) {
        await daoPlato.agregarPlato(plato.toMap());
        mensaje = 'Plato agregado con éxito';
      } else {
        await daoPlato.actualizarPlato(plato);
        mensaje = 'Plato actualizado con éxito';
      }

      // Si el contexto está disponible, mostrar mensaje y regresar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensaje)),
        );
        Navigator.pop(context, true); // Volver a la pantalla anterior
      }
    } catch (e) {
      mensaje = 'Error: ${e.toString()}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.black,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  _plato == null ? 'Agregar Plato' : 'Modificar Plato',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/'),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset('assets/img/logo.jpg',
                          width: 50, height: 45),
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
          child: Form(
            key: _claveFormulario,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campo de Nombre
                TextFormField(
                  cursorColor: Colors.green,
                  initialValue: _nombre,
                  decoration: InputDecoration(
                    labelText: 'Nombre del Plato',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre del plato es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) => _nombre = value ?? '',
                ),
                const SizedBox(height: 15),

                // Campo de Precio
                TextFormField(
                  cursorColor: Colors.green,
                  initialValue: _precio.toString(),
                  decoration: InputDecoration(
                    labelText: 'Precio',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El precio es obligatorio';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Por favor ingresa un precio válido';
                    }
                    return null;
                  },
                  onSaved: (value) =>
                      _precio = double.tryParse(value ?? '') ?? 0.0,
                ),
                const SizedBox(height: 15),

                // Botón para Elegir Foto
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _elegirFoto,
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Foto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 44, 164, 50),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _fotoPath != null
                        ? Text('Foto seleccionada',
                            style: TextStyle(color: Colors.green[700]))
                        : const Text('No se ha seleccionado foto'),
                  ],
                ),
                const SizedBox(height: 15),

                // Días Disponibles (Checkboxes)
                Column(
                  children: _diasSemana.asMap().entries.map((entry) {
                    return CheckboxListTile(
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      side: const BorderSide(color: Colors.green),
                      title: Text(entry.value),
                      value: _diasSeleccionados[entry.key],
                      onChanged: (bool? value) {
                        setState(() {
                          _diasSeleccionados[entry.key] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Botón para Guardar
                Center(
                  child: ElevatedButton(
                    onPressed: _guardarPlato,
                    child: const Text('Guardar Plato'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 44, 164, 50),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
