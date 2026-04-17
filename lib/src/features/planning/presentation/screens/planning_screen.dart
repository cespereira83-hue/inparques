import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:collection/collection.dart'; // Vital para agrupar por días

import '../../../../data/local/app_database.dart';
import '../../logic/planning_controller.dart';
import '../../../reports/logic/pdf_generator_service.dart';
import 'create_activity_screen.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  // Navegar entre semanas usando la memoria del controlador
  void _cambiarSemana(int semanas) {
    final controller = context.read<PlanningController>();
    final nuevoFoco = controller.focusedDay.add(Duration(days: 7 * semanas));
    controller.setFocusedDay(nuevoFoco);
  }

  // Volver a la semana actual
  void _irHoy() {
    context.read<PlanningController>().setFocusedDay(DateTime.now());
  }

  // Generar PDF de la semana que estamos viendo
  Future<void> _imprimirReporteActual(DateTime inicioSemana) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final controller = context.read<PlanningController>();
      final pdfService = PdfGeneratorService();

      final dataPaquete = await controller.generarPaqueteReporte(inicioSemana);
      final config = dataPaquete['config'] as ConfigSetting?;
      final items = dataPaquete['items'] as List<ReporteDataDTO>;

      final bytes = await pdfService.generateWeeklyReport(
        config: config,
        items: items,
        inicioSemana: inicioSemana,
      );

      if (mounted) {
        Navigator.pop(context); // Cerrar loading
        await Printing.layoutPdf(
          onLayout: (format) async => bytes,
          name: 'Rol_Semanal_${DateFormat('dd_MM').format(inicioSemana)}.pdf',
          format: PdfPageFormat.a4.landscape,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error generando PDF: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Escuchar al controlador para saber qué semana mostrar
    final controller = context.watch<PlanningController>();
    final focusedDay = controller.focusedDay;

    // 2. Calcular inicio (Lunes) y fin (Domingo) de la semana en foco
    final inicioSemana =
        focusedDay.subtract(Duration(days: focusedDay.weekday - 1));
    final finSemana = inicioSemana.add(const Duration(days: 6));

    // Texto del rango (Ej: 10 Feb - 16 Feb 2026)
    final rangoTexto =
        "${DateFormat('d MMM').format(inicioSemana)} - ${DateFormat('d MMM yyyy').format(finSemana)}";

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text("Planificador Semanal", style: TextStyle(fontSize: 18)),
            Text(
              rangoTexto.toUpperCase(),
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: "Ir a Hoy",
            onPressed: _irHoy,
          ),
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: "Imprimir esta semana",
            onPressed: () => _imprimirReporteActual(inicioSemana),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- BARRA DE NAVEGACIÓN SEMANAL ---
          Container(
            color: Colors.green.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.green),
                  onPressed: () => _cambiarSemana(-1),
                ),
                Text(
                  "SEMANA ${DateFormat('w').format(inicioSemana)}", // Número de semana
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.green),
                  onPressed: () => _cambiarSemana(1),
                ),
              ],
            ),
          ),

          // --- LISTA DE ACTIVIDADES (VISTA DIARIA) ---
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: controller.generarPaqueteReporte(inicioSemana),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items =
                    (snapshot.data?['items'] as List<ReporteDataDTO>?) ?? [];

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy,
                            size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 10),
                        Text(
                          "Sin actividades planificadas",
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  );
                }

                // Agrupar por día para mostrar cabeceras (Lunes, Martes...)
                final agrupado = groupBy(items, (item) {
                  return DateFormat('EEEE d', 'es_ES')
                      .format(item.actividad.fecha);
                });

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: agrupado.length,
                  itemBuilder: (context, index) {
                    final diaKey = agrupado.keys.elementAt(index);
                    final actividadesDia = agrupado[diaKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cabecera del Día
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            diaKey.toUpperCase(),
                            style: TextStyle(
                              color: Colors.indigo.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        // Lista de tarjetas del día
                        ...actividadesDia.map((dto) => _ActivityCard(dto: dto)),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Botón flotante para agregar actividad (pasa la fecha actual del foco)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navegamos pasando la fecha de la semana que estamos mirando
          Navigator.pushNamed(
            context,
            '/create_activity',
            // Opcional: Podrías pasar arguments: controller.focusedDay
            // Pero como CreateActivityScreen es independiente, al guardar
            // actualizará la memoria del controller y al volver aquí se refrescará solo.
          );
        },
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Planificar", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// Widget auxiliar para cada tarjeta de actividad
class _ActivityCard extends StatelessWidget {
  final ReporteDataDTO dto;

  const _ActivityCard({required this.dto});

  @override
  Widget build(BuildContext context) {
    final act = dto.actividad;
    final personalCount = dto.funcionarios.length;
    final jefe = dto.jefeServicio;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              act.esPernocta ? Colors.purple.shade50 : Colors.blue.shade50,
          child: Icon(
            act.esPernocta ? Icons.night_shelter : Icons.shield,
            color: act.esPernocta ? Colors.purple : Colors.blue,
            size: 20,
          ),
        ),
        title: Text(
          act.nombreActividad,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(act.lugar, maxLines: 1, overflow: TextOverflow.ellipsis),
            if (jefe != null)
              Text("Líder: ${jefe.nombres} ${jefe.apellidos}",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
          ],
        ),
        trailing: Chip(
          label: Text("$personalCount"),
          avatar: const Icon(Icons.people, size: 14),
          visualDensity: VisualDensity.compact,
          backgroundColor: Colors.grey.shade100,
        ),
        onTap: () {
          // Navegar a editar (reutilizando pantalla de creación)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateActivityScreen(actividadId: act.id),
            ),
          );
        },
      ),
    );
  }
}
