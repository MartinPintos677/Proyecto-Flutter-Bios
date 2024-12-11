import 'package:flutter/material.dart';
import 'package:formulario_basico/daos/dao_platos.dart';
import 'package:formulario_basico/dominio/platos.dart';

class PantallaGestionPlatos extends StatefulWidget {
  const PantallaGestionPlatos({super.key});

  @override
  State<PantallaGestionPlatos> createState() => _PantallaGestionPlatosState();
}

class _PantallaGestionPlatosState extends State<PantallaGestionPlatos> {
  final DaoPlato _daoPlato = DaoPlato();
  List<Plato> _platos = [];

  @override
  void initState() {
    super.initState();
    _cargarPlatos();
  }

  // Método para cargar los platos desde la base de datos
  Future<void> _cargarPlatos() async {
    final platos = await _daoPlato.obtenerPlatos();
    setState(() {
      _platos = platos;
    });
  }

  // Método para eliminar un plato
  Future<void> _eliminarPlato(int idPlato) async {
    await _daoPlato.eliminarPlato(idPlato);
    _cargarPlatos(); // Recargar la lista después de eliminar
  }

  // Método para navegar a la pantalla de agregar plato
  void _agregarPlato(BuildContext context) async {
    // Esperamos el valor retornado de la pantalla de agregar plato
    bool? result = await Navigator.pushNamed(context, '/agregar_plato');

    if (result == true) {
      // Si el resultado es true, significa que un plato fue agregado/actualizado
      _cargarPlatos(); // Recargar la lista después de agregar un plato
    }
  }

  // Método para editar un plato
  void _editarPlato(Plato plato) {
    Navigator.pushNamed(context, '/agregar_plato', arguments: plato).then((_) {
      _cargarPlatos(); // Recargar la lista después de editar
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
                // Lógica para filtrar la lista de platos
                // Esta parte podría ir aquí para filtrar según el texto ingresado
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Lógica para filtrar los platos disponibles hoy
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Disponibles Hoy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 44, 164, 50),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _platos.length,
                itemBuilder: (context, index) {
                  final plato = _platos[index];
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
                          plato.activo
                              ? Icons.check
                              : Icons.close, // Ícono según disponibilidad
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        plato.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Precio: \$${plato.precio}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min, // Minimiza el tamaño
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black),
                            onPressed: () {
                              // Lógica para editar el plato
                              _editarPlato(plato);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black),
                            onPressed: () async {
                              // Lógica para eliminar el plato
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
                                          Navigator.pop(
                                              context, false); // Cancelar
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context, true); // Confirmar
                                        },
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              // Si se confirma la eliminación, se elimina el plato
                              if (confirmDelete) {
                                await _eliminarPlato(
                                    plato.idPlato); // Llamar al método eliminar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Plato eliminado')),
                                );
                                setState(() {
                                  _platos.removeAt(
                                      index); // Actualiza la lista de platos
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
    );
  }
}
