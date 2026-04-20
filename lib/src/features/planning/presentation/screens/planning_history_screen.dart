import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../logic/planning_controller.dart';
import '../../../../data/local/app_database.dart';
import '../../../incidents/logic/acta_generator.dart';
import '../../../reports/logic/weekly_report_generator.dart';
import 'create_activity_screen.dart';

// ============================================================================
// HELPER PARA EXPORTACIÓN
// ============================================================================
Future<void> _mostrarOpcionesSalidaPdf(
  BuildContext context,
  Uint8List bytes,
  String nombreArchivo, {
  PdfPageFormat format = PdfPageFormat.a4,
}) async {
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Documento Generado",
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text("¿Qué deseas hacer con el archivo:\n\n$nombreArchivo?"),
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowDirection: VerticalDirection.down,
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.print, color: Colors.blue),
          label: const Text("Imprimir"),
          onPressed: () {
            Navigator.pop(ctx);
            Printing.layoutPdf(
                onLayout: (_) async => bytes,
                name: nombreArchivo,
                format: format);
          },
        ),
        FilledButton.tonalIcon(
          icon: const Icon(Icons.folder_open),
          label: const Text("Elegir ubicación..."),
          onPressed: () async {
            Navigator.pop(ctx);
            String? outputFile = await FilePicker.platform.saveFile(
              dialogTitle: 'Guardar PDF en...',
              fileName: nombreArchivo,
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );

            if (outputFile != null) {
              if (!outputFile.toLowerCase().endsWith('.pdf'))
                outputFile += '.pdf';
              final file = File(outputFile);
              await file.writeAsBytes(bytes);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("✅ Archivo guardado en:\n$outputFile"),
                    backgroundColor: Colors.green));
              }
            }
          },
        ),
        FilledButton.icon(
          icon: const Icon(Icons.download),
          label: const Text("Descarga Rápida"),
          style: FilledButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () async {
            Navigator.pop(ctx);
            try {
              Directory? directory = await getDownloadsDirectory();
              directory ??= await getApplicationDocumentsDirectory();

              final String filePath = p.join(directory.path, nombreArchivo);
              final file = File(filePath);
              await file.writeAsBytes(bytes);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("✅ Guardado en:\n$filePath"),
                    backgroundColor: Colors.green.shade700));
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Error al guardar: $e"),
                    backgroundColor: Colors.red));
              }
            }
          },
        ),
      ],
    ),
  );
}

class PlanningHistoryScreen extends StatefulWidget {
  const PlanningHistoryScreen({super.key});

  @override
  State<PlanningHistoryScreen> createState() => _PlanningHistoryScreenState();
}

class _PlanningHistoryScreenState extends State<PlanningHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(
          () => _searchQuery = _searchController.text.toLowerCase().trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Gestión de Actividades"),
          backgroundColor: Colors.green.shade800,
          foregroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Buscar por detalle, lugar o funcionario...",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: const Icon(Icons.search,
                            color: Colors.green, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: Colors.grey, size: 20),
                                onPressed: () => _searchController.clear())
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                        icon: Icon(Icons.calendar_view_week),
                        text: "Ordinarias"),
                    Tab(icon: Icon(Icons.calendar_month), text: "Pernoctas"),
                    Tab(icon: Icon(Icons.gavel), text: "Actas"),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _OrdinariasTab(searchQuery: _searchQuery),
            _PernoctasTab(searchQuery: _searchQuery),
            _IncidenciasTab(searchQuery: _searchQuery),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TAB 1: ORDINARIAS
// ============================================================================

class _OrdinariasTab extends StatefulWidget {
  final String searchQuery;
  const _OrdinariasTab({required this.searchQuery});

  @override
  State<_OrdinariasTab> createState() => _OrdinariasTabState();
}

class _OrdinariasTabState extends State<_OrdinariasTab> {
  DateTime _getMonday(DateTime date) =>
      date.subtract(Duration(days: date.weekday - 1));

  Future<void> _imprimirSemana(BuildContext context, DateTime lunes) async {
    final domingoSugerido = lunes.add(const Duration(days: 6));
    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: lunes, end: domingoSugerido),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      helpText: "CONFIRMAR SEMANA A EXPORTAR",
      saveText: "GENERAR ROL",
      locale: const Locale('es', 'ES'),
      builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                  primary: Color(0xFF2E7D32), onPrimary: Colors.white)),
          child: child!),
    );

    if (pickedRange == null || !mounted) return;
    final picked = _getMonday(pickedRange.start);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      final dto = await context
          .read<PlanningController>()
          .prepararDatosReporteSemanal(picked);
      if (!mounted) return;
      if (dto == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Error recolectando datos"),
            backgroundColor: Colors.red));
        return;
      }
      final bytes = await WeeklyReportGenerator.generarReporte(dto);
      if (mounted) {
        Navigator.pop(context);
        final domingo = picked.add(const Duration(days: 6));
        final formatInicio =
            DateFormat('dd_MMM', 'es').format(picked).replaceAll('.', '');
        final formatFin =
            DateFormat('dd_MMM_yyyy', 'es').format(domingo).replaceAll('.', '');
        await _mostrarOpcionesSalidaPdf(
            context, bytes, 'Rol_Semanal_${formatInicio}_al_$formatFin.pdf',
            format: PdfPageFormat.letter.landscape);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PlanningController>();
    return FutureBuilder<List<ReporteDataDTO>>(
      future: controller.listarHistorial(esPernocta: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return const Center(
              child: Text("No hay guardias ordinarias registradas."));

        final itemsFiltrados = snapshot.data!.where((dto) {
          if (widget.searchQuery.isEmpty) return true;
          final lugar = dto.actividad.lugar.toLowerCase();
          final detalle = dto.actividad.nombreActividad.toLowerCase();
          final jefe = dto.jefeServicio != null
              ? "${dto.jefeServicio!.nombres} ${dto.jefeServicio!.apellidos}"
                  .toLowerCase()
              : "";
          return lugar.contains(widget.searchQuery) ||
              detalle.contains(widget.searchQuery) ||
              jefe.contains(widget.searchQuery);
        }).toList();

        if (itemsFiltrados.isEmpty)
          return const Center(child: Text("Ninguna guardia coincide."));

        final agrupado = groupBy(itemsFiltrados, (item) {
          final lunes = _getMonday(item.actividad.fecha);
          return DateTime(lunes.year, lunes.month, lunes.day);
        });

        final semanasOrdenadas = agrupado.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: semanasOrdenadas.length,
          itemBuilder: (context, index) {
            final lunes = semanasOrdenadas[index];
            final domingo = lunes.add(const Duration(days: 6));
            final actividadesDeSemana = agrupado[lunes]!;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                initiallyExpanded: widget.searchQuery.isNotEmpty || index == 0,
                leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.date_range, color: Colors.blue)),
                title: Text(
                    "Semana del ${DateFormat('d MMM').format(lunes)} al ${DateFormat('d MMM yyyy').format(domingo)}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${actividadesDeSemana.length} actividades"),
                trailing: IconButton(
                    icon: const Icon(Icons.print, color: Colors.grey),
                    onPressed: () => _imprimirSemana(context, lunes)),
                children: actividadesDeSemana
                    .map((dto) => _ActividadTile(
                        dto: dto,
                        color: Colors.blue.shade50,
                        iconColor: Colors.blue))
                    .toList(),
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================================
// TAB 2: PERNOCTAS
// ============================================================================

class _PernoctasTab extends StatefulWidget {
  final String searchQuery;
  const _PernoctasTab({required this.searchQuery});

  @override
  State<_PernoctasTab> createState() => _PernoctasTabState();
}

class _PernoctasTabState extends State<_PernoctasTab> {
  Future<void> _imprimirMes(BuildContext context, DateTime mesDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: mesDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      helpText: "CONFIRMAR MES",
      locale: const Locale('es', 'ES'),
      builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                  primary: Color(0xFF2E7D32), onPrimary: Colors.white)),
          child: child!),
    );

    if (picked == null || !mounted) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      final dto = await context
          .read<PlanningController>()
          .prepararDatosReporteMensualPernocta(picked.year, picked.month);
      if (!mounted) return;
      if (dto == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Error recolectando datos"),
            backgroundColor: Colors.red));
        return;
      }
      final mesTexto =
          DateFormat('MMMM yyyy', 'es').format(picked).toUpperCase();
      final bytes =
          await WeeklyReportGenerator.generarReportePernocta(dto, mesTexto);
      if (mounted) {
        Navigator.pop(context);
        await _mostrarOpcionesSalidaPdf(
            context, bytes, 'Rol_Pernoctas_${picked.month}_${picked.year}.pdf',
            format: PdfPageFormat.letter.landscape);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PlanningController>();

    return FutureBuilder<List<ReporteDataDTO>>(
      future: controller.listarHistorial(esPernocta: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return const Center(child: Text("No hay pernoctas registradas."));

        final itemsFiltrados = snapshot.data!.where((dto) {
          if (widget.searchQuery.isEmpty) return true;
          final lugar = dto.actividad.lugar.toLowerCase();
          final detalle = dto.actividad.nombreActividad.toLowerCase();
          final jefe = dto.jefeServicio != null
              ? "${dto.jefeServicio!.nombres} ${dto.jefeServicio!.apellidos}"
                  .toLowerCase()
              : "";
          return lugar.contains(widget.searchQuery) ||
              detalle.contains(widget.searchQuery) ||
              jefe.contains(widget.searchQuery);
        }).toList();

        if (itemsFiltrados.isEmpty)
          return const Center(child: Text("Ninguna pernocta coincide."));

        final agrupado = groupBy(
            itemsFiltrados,
            (item) => DateTime(
                item.actividad.fecha.year, item.actividad.fecha.month, 1));
        final mesesOrdenados = agrupado.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: mesesOrdenados.length,
          itemBuilder: (context, index) {
            final mesDate = mesesOrdenados[index];
            final actividadesDelMes = agrupado[mesDate]!;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                initiallyExpanded: widget.searchQuery.isNotEmpty || index == 0,
                leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8)),
                    child:
                        const Icon(Icons.night_shelter, color: Colors.purple)),
                title: Text(
                    DateFormat('MMMM yyyy').format(mesDate).toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${actividadesDelMes.length} guardias"),
                trailing: IconButton(
                    icon: const Icon(Icons.print, color: Colors.grey),
                    onPressed: () => _imprimirMes(context, mesDate)),
                children: actividadesDelMes
                    .map((dto) => _ActividadTile(
                        dto: dto,
                        color: Colors.purple.shade50,
                        iconColor: Colors.purple))
                    .toList(),
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================================
// TAB 3: INCIDENCIAS / ACTAS
// ============================================================================

class _IncidenciasTab extends StatelessWidget {
  final String searchQuery;
  const _IncidenciasTab({required this.searchQuery});

  Future<void> _verActa(BuildContext context, int incidenciaId) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()));
    try {
      final controller = context.read<PlanningController>();
      final data = await controller.obtenerDatosActaCompleta(incidenciaId);
      final bytes = await ActaGenerator().generate(data);
      if (context.mounted) {
        Navigator.pop(context);
        await _mostrarOpcionesSalidaPdf(
            context, bytes, 'Acta_Inasistencia_$incidenciaId.pdf');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error abriendo acta: $e"),
            backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PlanningController>();

    return FutureBuilder<List<IncidenciaDataDTO>>(
      future: controller.listarIncidencias(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.gavel, size: 60, color: Colors.grey.shade300),
                const SizedBox(height: 10),
                Text("No hay actas registradas",
                    style: TextStyle(color: Colors.grey.shade500))
              ],
            ),
          );
        }

        final actasFiltradas = snapshot.data!.where((item) {
          if (searchQuery.isEmpty) return true;
          return "${item.inasistente.nombres} ${item.inasistente.apellidos}"
                  .toLowerCase()
                  .contains(searchQuery) ||
              item.incidencia.id.toString().contains(searchQuery);
        }).toList();

        if (actasFiltradas.isEmpty)
          return const Center(child: Text("Ningún acta coincide."));

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: actasFiltradas.length,
          itemBuilder: (context, index) {
            final item = actasFiltradas[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.red.shade50, shape: BoxShape.circle),
                    child: Icon(Icons.description, color: Colors.red.shade800)),
                title: Text("Acta de Inasistencia #${item.incidencia.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                        "Funcionario: ${item.inasistente.nombres} ${item.inasistente.apellidos}"),
                    Text(
                        "Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(item.incidencia.fechaHoraRegistro)}",
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
                trailing: IconButton(
                    icon: const Icon(Icons.print),
                    color: Colors.grey.shade700,
                    onPressed: () => _verActa(context, item.incidencia.id)),
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================================
// WIDGET COMPARTIDO: Tile de Actividad (AHORA CON MENÚ DE FALTAS MASIVAS)
// ============================================================================

class _ActividadTile extends StatelessWidget {
  final ReporteDataDTO dto;
  final Color color;
  final Color iconColor;

  const _ActividadTile(
      {required this.dto, required this.color, required this.iconColor});

  void _navegarAEditar(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                CreateActivityScreen(actividadId: dto.actividad.id)));
  }

  void _confirmarEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("¿Eliminar Actividad?"),
        content: const Text(
            "Esta acción borrará la planificación y liberará al personal asignado.\n\n⚠️ No se puede deshacer."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancelar")),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ctx
                    .read<PlanningController>()
                    .eliminarActividad(dto.actividad.id);
              } catch (e) {}
            },
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  // --- LÓGICA DE SELECCIÓN MÚLTIPLE DE INASISTENTES ---
  void _mostrarDialogoFaltas(BuildContext context) {
    if (dto.funcionarios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No hay personal asignado a esta guardia."),
          backgroundColor: Colors.orange));
      return;
    }

    List<int> seleccionadosIds = [];
    final TextEditingController descController = TextEditingController(
        text: "Inasistencia injustificada al rol de guardia asignado.");

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                const SizedBox(width: 8),
                const Text("Reportar Inasistencias"),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      "Marque los funcionarios que NO se presentaron a la guardia:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // Renderiza Checkboxes por cada funcionario asignado
                  ...dto.funcionarios
                      .map((f) => CheckboxListTile(
                            title: Text("${f.nombres} ${f.apellidos}"),
                            subtitle:
                                Text("CI: ${f.cedula} | ${f.rango ?? 'S/R'}"),
                            value: seleccionadosIds.contains(f.id),
                            activeColor: Colors.orange.shade800,
                            dense: true,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  seleccionadosIds.add(f.id);
                                } else {
                                  seleccionadosIds.remove(f.id);
                                }
                              });
                            },
                          ))
                      .toList(),
                  const Divider(height: 30),
                  TextField(
                    controller: descController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Motivo / Descripción que saldrá en el acta",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancelar")),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.orange.shade800),
                onPressed: () async {
                  if (seleccionadosIds.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text("Debe seleccionar al menos a una persona."),
                        backgroundColor: Colors.red));
                    return;
                  }
                  Navigator.pop(ctx); // Cerrar dialogo

                  // Llamar al Controlador
                  try {
                    await context
                        .read<PlanningController>()
                        .registrarInasistenciaMasiva(dto.actividad.id,
                            seleccionadosIds, descController.text);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "✅ Actas creadas. Revise la pestaña 'Actas' para imprimir."),
                          backgroundColor: Colors.green));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Error al registrar faltas: $e"),
                          backgroundColor: Colors.red));
                    }
                  }
                },
                child: const Text("Generar Actas"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEEE d', 'es').format(dto.actividad.fecha);
    final jefeName = dto.jefeServicio != null
        ? "${dto.jefeServicio!.nombres} ${dto.jefeServicio!.apellidos}"
        : "Sin Jefe Asignado";

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.circle, size: 12, color: iconColor),
          if (dto.actividad.fechaFin != null) ...[
            Container(
                height: 10, width: 2, color: iconColor.withValues(alpha: 0.3)),
            Icon(Icons.circle,
                size: 8, color: iconColor.withValues(alpha: 0.5)),
          ]
        ],
      ),
      title: Text("${dto.tipoNombre} (${dateStr.toUpperCase()})",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dto.actividad.nombreActividad.isNotEmpty)
            Text("Detalle: ${dto.actividad.nombreActividad}",
                style: const TextStyle(
                    color: Colors.black87, fontStyle: FontStyle.italic)),
          Text("Lugar: ${dto.actividad.lugar}",
              maxLines: 1, overflow: TextOverflow.ellipsis),
          Text("Líder: $jefeName",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ],
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
        onSelected: (value) {
          if (value == 'edit') _navegarAEditar(context);
          if (value == 'delete') _confirmarEliminar(context);
          if (value == 'falta')
            _mostrarDialogoFaltas(context); // Llama al nuevo Dialog
        },
        itemBuilder: (ctx) => [
          const PopupMenuItem(value: 'edit', child: Text('Editar')),
          const PopupMenuItem(
              value: 'falta',
              child: Text('Reportar Inasistencia',
                  style: TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.bold))),
          const PopupMenuItem(
              value: 'delete',
              child: Text('Eliminar Guardia',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
      onTap: () => _navegarAEditar(context),
    );
  }
}
