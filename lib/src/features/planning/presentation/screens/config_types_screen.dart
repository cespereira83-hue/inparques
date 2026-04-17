import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/config_types_controller.dart';
import '../../../../data/local/app_database.dart';

class ConfigTypesScreen extends StatefulWidget {
  const ConfigTypesScreen({super.key});

  @override
  State<ConfigTypesScreen> createState() => _ConfigTypesScreenState();
}

class _ConfigTypesScreenState extends State<ConfigTypesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfigTypesController>().cargarTipos();
    });
  }

  void _mostrarDialogo({TiposGuardiaData? tipoExistente}) {
    final controller = TextEditingController(text: tipoExistente?.nombre ?? '');
    final esEdicion = tipoExistente != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(esEdicion ? "Editar Tipo" : "Nuevo Tipo de Guardia"),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: "Nombre de la Guardia",
            hintText: "Ej: Recorrido Nocturno",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) {
                return;
              }

              final logic = context.read<ConfigTypesController>();
              bool exito;

              if (esEdicion) {
                exito = await logic.editarTipo(
                  tipoExistente.id,
                  controller.text,
                );
              } else {
                exito = await logic.crearTipo(controller.text);
              }

              if (context.mounted) {
                Navigator.pop(context);
                if (!exito) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Error: El nombre ya existe o es inválido"),
                    ),
                  );
                }
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ConfigTypesController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Catálogo de Guardias")),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.tipos.isEmpty
              ? const Center(
                  child: Text("No hay tipos definidos. Agregue uno."))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.tipos.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final tipo = controller.tipos[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            tipo.activo ? Colors.green[100] : Colors.grey[200],
                        child: Icon(
                          Icons.local_police,
                          color: tipo.activo ? Colors.green[800] : Colors.grey,
                        ),
                      ),
                      title: Text(
                        tipo.nombre,
                        style: TextStyle(
                          decoration:
                              tipo.activo ? null : TextDecoration.lineThrough,
                          color: tipo.activo ? Colors.black : Colors.grey,
                        ),
                      ),
                      subtitle: Text(tipo.activo ? "Activo" : "Deshabilitado"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _mostrarDialogo(tipoExistente: tipo),
                          ),
                          Switch(
                            value: tipo.activo,
                            activeThumbColor: Colors.green,
                            onChanged: (val) {
                              controller.toggleEstado(tipo.id, tipo.activo);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogo(),
        label: const Text("Nuevo Tipo"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }
}
