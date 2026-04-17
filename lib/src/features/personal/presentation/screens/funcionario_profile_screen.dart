import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/personal_controller.dart';
import '../../../../data/local/app_database.dart';

class FuncionarioProfileScreen extends StatefulWidget {
  final int funcionarioId;

  const FuncionarioProfileScreen({super.key, required this.funcionarioId});

  @override
  State<FuncionarioProfileScreen> createState() =>
      _FuncionarioProfileScreenState();
}

class _FuncionarioProfileScreenState extends State<FuncionarioProfileScreen> {
  late Future<Map<String, dynamic>> _expedienteFuture;

  @override
  void initState() {
    super.initState();
    _cargarExpediente();
  }

  void _cargarExpediente() {
    _expedienteFuture = context
        .read<PersonalController>()
        .obtenerExpedienteCompleto(widget.funcionarioId);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<PersonalController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil del Funcionario"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _expedienteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error al cargar el expediente"));
          }

          final data = snapshot.data!;
          final Funcionario f = data['funcionario'];
          final List<EstudiosAcademico> estudios = data['estudios'];
          final List<CursosCertificado> cursos = data['cursos'];

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildHeader(f),
              const SizedBox(height: 24),
              _buildSectionTitle("Formación Académica"),
              if (estudios.isEmpty)
                const Text("No registra títulos cargados",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              ...estudios.map((e) => _buildDocTile(
                    title: e.tituloObtenido,
                    subtitle: e.gradoInstruccion,
                    path: e.rutaPdfTitulo,
                    onOpen: () => controller.abrirDocumento(e.rutaPdfTitulo),
                  )),
              const SizedBox(height: 24),
              _buildSectionTitle("Cursos y Certificaciones"),
              if (cursos.isEmpty)
                const Text("No registra certificados cargados",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              ...cursos.map((c) => _buildDocTile(
                    title: c.nombreCertificado,
                    subtitle: "Certificado de Formación",
                    path: c.rutaPdfCertificado,
                    onOpen: () =>
                        controller.abrirDocumento(c.rutaPdfCertificado),
                  )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(Funcionario f) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green.shade100,
              child: const Icon(Icons.person, size: 50, color: Colors.green),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${f.nombres} ${f.apellidos}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("C.I: ${f.cedula}",
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // FIX: Manejo de nulo en visualización de Rango
                    child: Text(f.rango ?? "Sin Rango",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
          const Divider(thickness: 1),
        ],
      ),
    );
  }

  Widget _buildDocTile(
      {required String title,
      required String subtitle,
      String? path,
      required VoidCallback onOpen}) {
    final bool hasFile = path != null && path.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.picture_as_pdf,
            color: hasFile ? Colors.red : Colors.grey),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: hasFile
            ? IconButton(
                icon: const Icon(Icons.open_in_new, color: Colors.blue),
                onPressed: onOpen,
                tooltip: "Ver Documento",
              )
            : const Icon(Icons.help_outline, color: Colors.grey),
      ),
    );
  }
}
