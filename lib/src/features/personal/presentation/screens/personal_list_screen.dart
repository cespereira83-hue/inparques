import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/personal_controller.dart';
import '../../../../data/local/app_database.dart';
import 'funcionario_registration_screen.dart';
import 'funcionario_profile_screen.dart';
import 'funcionario_edit_screen.dart';

class PersonalListScreen extends StatefulWidget {
  const PersonalListScreen({super.key});

  @override
  State<PersonalListScreen> createState() => _PersonalListScreenState();
}

class _PersonalListScreenState extends State<PersonalListScreen> {
  // CONTROLADORES DE BÚSQUEDA
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Escuchador para hacer la búsqueda reactiva (en tiempo real)
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase().trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _irARegistro() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (context) => const FuncionarioRegistrationScreen()),
    );
    if (result == true && mounted) {
      setState(() {}); // Refresca la lista al volver
    }
  }

  void _editar(PersonalController controller, int id) async {
    final data = await controller.obtenerExpedienteCompleto(id);
    if (!mounted) return;

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (context) => FuncionarioEditScreen(dataInicial: data)),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  void _confirmarBorrado(PersonalController controller, Funcionario f) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Eliminar Registro"),
        content: Text("¿Dar de baja a ${f.nombres}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CANCELAR"),
          ),
          TextButton(
            onPressed: () async {
              // Realizamos la operación lógica
              await controller.desactivarFuncionario(f.id);

              // Verificamos si el contexto del DIÁLOGO sigue montado
              if (!ctx.mounted) return;
              Navigator.pop(ctx);

              // Refrescamos la lista
              if (mounted) {
                setState(() {});
              }
            },
            child: const Text("BORRAR", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PersonalController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Fondo suave UI/UX
      appBar: AppBar(
        title: const Text("Gestión de Personal"),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // =========================================================
          // BUSCADOR INTELIGENTE
          // =========================================================
          Container(
            color: Colors.green.shade800,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Buscar por nombre, cédula o rango...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  // Botón "X" para limpiar que solo aparece si hay texto
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            // El foco se mantiene, pero el texto se borra
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // =========================================================
          // LISTA DE RESULTADOS
          // =========================================================
          Expanded(
            child: FutureBuilder<List<Funcionario>>(
              future: controller.listarPersonal(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final listaOriginal = snapshot.data ?? [];

                // Lógica de Filtro Inteligente
                final listaFiltrada = listaOriginal.where((f) {
                  if (_searchQuery.isEmpty) return true;

                  final nombres = f.nombres.toLowerCase();
                  final apellidos = f.apellidos.toLowerCase();
                  final cedula = f.cedula.toLowerCase();
                  final rango = (f.rango ?? '').toLowerCase();

                  return nombres.contains(_searchQuery) ||
                      apellidos.contains(_searchQuery) ||
                      cedula.contains(_searchQuery) ||
                      rango.contains(_searchQuery);
                }).toList();

                // ESTADOS VACÍOS
                if (listaOriginal.isEmpty) {
                  return const Center(
                    child: Text(
                      "No hay personal registrado aún.",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                if (listaFiltrada.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 10),
                        Text(
                          "No se encontraron resultados para\n'$_searchQuery'",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                // RESULTADOS
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  itemCount: listaFiltrada.length,
                  itemBuilder: (context, i) {
                    final f = listaFiltrada[i];

                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          foregroundColor: Colors.green.shade800,
                          child:
                              Text(f.nombres.isNotEmpty ? f.nombres[0] : '?'),
                        ),
                        title: Text(
                          "${f.nombres} ${f.apellidos}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("C.I: ${f.cedula}"),
                            if (f.rango != null && f.rango!.isNotEmpty)
                              Text(
                                f.rango!,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                              ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: Colors.grey),
                          onSelected: (val) {
                            if (val == 'edit') _editar(controller, f.id);
                            if (val == 'del') _confirmarBorrado(controller, f);
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                                value: 'edit', child: Text("Editar")),
                            const PopupMenuItem(
                              value: 'del',
                              child: Text("Dar de baja",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                FuncionarioProfileScreen(funcionarioId: f.id),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _irARegistro,
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text("Nuevo Ingreso"),
      ),
    );
  }
}
