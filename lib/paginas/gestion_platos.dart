import 'package:flutter/material.dart';
import 'package:formulario_basico/daos/dao_platos.dart';
import 'package:formulario_basico/dominio/platos.dart';
import 'package:formulario_basico/paginas/agregar_plato.dart';
import 'package:intl/intl.dart';

class PantallaGestionPlatos extends StatefulWidget {
  const PantallaGestionPlatos({super.key});

  @override
  State<PantallaGestionPlatos> createState() => _PantallaGestionPlatosState();
}

class _PantallaGestionPlatosState extends State<PantallaGestionPlatos> {
  final DaoPlato _daoPlato = DaoPlato();
  List<Plato> _platos = [];
  List<Plato> _platosFiltrados = [];
  bool _FiltroPorHoy =
      false; // Variable para saber si estamos filtrando por hoy

  @override
  void initState() {
    super.initState();
    _cargarPlatos();
  }

  // Método para obtener el día de hoy en español
  String obtenerDiaHoyEnEspaniol() {
    final DateTime now = DateTime.now();
    // Obtenemos el día en inglés
    String diaIngles = DateFormat('EEEE', 'en_US').format(now).toLowerCase();

    // Mapa para traducir los días de inglés a español
    final Map<String, String> diasInglesAEspanol = {
      'monday': 'lunes',
      'tuesday': 'martes',
      'wednesday': 'miércoles',
      'thursday': 'jueves',
      'friday': 'viernes',
      'saturday': 'sábado',
      'sunday': 'domingo',
    };

    // Devolvemos el día en español
    return diasInglesAEspanol[diaIngles] ??
        ''; // Si no encuentra el día, retorna una cadena vacía
  }

  // Método para cargar los platos activos
  Future<void> _cargarPlatos() async {
    final platos = await _daoPlato.obtenerPlatos();
    setState(() {
      _platos = platos;
      _platosFiltrados = platos; // Inicialmente, mostrar todos los platos
    });
  }

// Método para filtrar los platos disponibles hoy
  void _filtrarPlatosDisponiblesHoy() {
    final diaHoy = obtenerDiaHoyEnEspaniol().toLowerCase();

    setState(() {
      _platosFiltrados = _platos.where((plato) {
        List<String> diasDisponibles = plato.diasDisponibles
            .split(',')
            .map((e) => e.trim().toLowerCase())
            .toList();

        return diasDisponibles.contains(diaHoy);
      }).toList();
      _FiltroPorHoy =
          true; // Actualizamos el estado para indicar que estamos filtrando por hoy
    });
  }

// Método para mostrar todos los platos
  void _mostrarTodosLosPlatos() {
    setState(() {
      _platosFiltrados = _platos; // Mostramos todos los platos
      _FiltroPorHoy = false; // Restablecemos el filtro
    });
  }

  // Método para eliminar un plato
  Future<void> _eliminarPlato(int idPlato) async {
    await _daoPlato.darBajaPlato(idPlato);
    _cargarPlatos(); // Recargar la lista después de eliminar
  }

  // Método para navegar a la pantalla de agregar plato
  void _agregarPlato(BuildContext context) async {
    // Esperamos el valor retornado de la pantalla de agregar plato
    final bool? result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const PantallaAgregarPlato()),
    );

    if (result == true) {
      _cargarPlatos(); // Recargar la lista después de agregar un plato
    }
  }

  // Método para editar un plato
  void _editarPlato(Plato plato) async {
    // Navegar a la pantalla de agregar plato con el plato seleccionado
    final bool? result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const PantallaAgregarPlato(),
        settings: RouteSettings(arguments: plato),
      ),
    );

    // Recarga la lista después de editar
    if (result == true) {
      _cargarPlatos();
    }
  }

  // Método para filtrar los platos por nombre
  void _filtrarPlatos(String query) {
    setState(() {
      _platosFiltrados = _platos
          .where((plato) =>
              plato.nombre.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Gestión de Platos',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/');
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
        child: Column(
          children: [
            // Barra de búsqueda
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Buscar plato...',
                labelStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: (value) {
                _filtrarPlatos(value);
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Si ya estamos filtrando por hoy, restauramos todos los platos
                    if (_FiltroPorHoy) {
                      _mostrarTodosLosPlatos();
                    } else {
                      // Si no estamos filtrando por hoy, aplicamos el filtro
                      _filtrarPlatosDisponiblesHoy();
                    }
                  },
                  icon: const Icon(Icons.filter_list),
                  label: Text(_FiltroPorHoy ? 'Ver Todos' : 'Disponibles Hoy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 44, 164, 50),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 80.0), // Espacio para el FAB
                child: ListView.builder(
                  itemCount: _platosFiltrados.length,
                  itemBuilder: (context, index) {
                    final plato = _platosFiltrados[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: plato.activo
                              ? const Color.fromARGB(255, 44, 164, 50)
                              : Colors.red,
                          child: Icon(
                            plato.activo ? Icons.check : Icons.close,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          plato.nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Precio: \$${plato.precio}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility,
                                  color: Colors.black),
                              tooltip: 'Ver ficha',
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/ficha_plato',
                                  arguments: plato,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.black),
                              onPressed: () {
                                _editarPlato(plato);
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.black),
                              onPressed: () async {
                                bool confirmDelete = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Eliminar Plato'),
                                          content: Text(
                                            '¿Estás seguro de eliminar el plato "${plato.nombre}"?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text('Eliminar'),
                                            ),
                                          ],
                                        );
                                      },
                                    ) ??
                                    false;

                                if (confirmDelete) {
                                  await _eliminarPlato(plato.idPlato);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Plato eliminado')),
                                  );
                                  setState(() {
                                    _platosFiltrados.removeAt(index);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _agregarPlato(context);
        },
        backgroundColor: const Color.fromARGB(255, 44, 164, 50),
        child: const Icon(Icons.add),
        tooltip: 'Agregar Plato',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
