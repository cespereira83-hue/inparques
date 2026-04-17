import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../data/local/app_database.dart';

class UbicacionesScreen extends StatefulWidget {
  const UbicacionesScreen({super.key});

  @override
  State<UbicacionesScreen> createState() => _UbicacionesScreenState();
}

class _UbicacionesScreenState extends State<UbicacionesScreen> {
  final _textController = TextEditingController();

  void _agregarUbicacion() async {
    if (_textController.text.isEmpty) return;
    final db = context.read<AppDatabase>();

    await db.into(db.ubicaciones).insert(
          UbicacionesCompanion(
            nombre: drift.Value(_textController.text),
            activo: const drift.Value(true),
          ),
        );
    _textController.clear();
    setState(() {}); // Recarga la lista
  }

  void _eliminar(Ubicacione u) async {
    final db = context.read<AppDatabase>();
    await (db.delete(db.ubicaciones)..where((t) => t.id.equals(u.id))).go();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Puestos/Ubicaciones")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: "Nuevo Puesto (Ej: Puesto La Silla)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _agregarUbicacion,
                )
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<Ubicacione>>(
              future: db.select(db.ubicaciones).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                final list = snapshot.data!;
                if (list.isEmpty) {
                  return const Center(child: Text("Sin puestos registrados"));
                }
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return ListTile(
                      leading: const Icon(Icons.place, color: Colors.indigo),
                      title: Text(item.nombre),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _eliminar(item),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
