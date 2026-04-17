import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

// RUTAS RELATIVAS CORREGIDAS
import '../../../planning/logic/planning_controller.dart';
import '../../logic/pdf_generator_service.dart';

class ReportConfigScreen extends StatefulWidget {
  const ReportConfigScreen({super.key});

  @override
  State<ReportConfigScreen> createState() => _ReportConfigScreenState();
}

class _ReportConfigScreenState extends State<ReportConfigScreen> {
  // 0 = Semanal, 1 = Mensual
  int _reportTypeIndex = 0;

  // Variables Semanal
  DateTime _inicioSemana =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  // Variables Mensual
  DateTime _mesSeleccionado = DateTime.now();

  bool _isGenerating = false;

  final PdfGeneratorService _pdfService = PdfGeneratorService();

  Future<void> _generarYPrevisualizar() async {
    setState(() => _isGenerating = true);
    try {
      final controller = context.read<PlanningController>();

      // Lógica según tipo
      if (_reportTypeIndex == 0) {
        // --- REPORTE SEMANAL ---
        final data = await controller.generarPaqueteReporte(_inicioSemana);
        final config = data['config'];
        final items = data['items'] as List<ReporteDataDTO>;

        if (items.isEmpty && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("No hay actividades ordinarias en esta semana."),
              backgroundColor: Colors.orange));
        }

        final pdfBytes = await _pdfService.generateWeeklyReport(
          config: config,
          items: items,
          inicioSemana: _inicioSemana,
        );

        if (mounted) {
          await Printing.layoutPdf(
            onLayout: (format) async => pdfBytes,
            name:
                'Rol_Semanal_${DateFormat('dd-MM').format(_inicioSemana)}.pdf',
          );
        }
      } else {
        // --- REPORTE MENSUAL (PERNOCTAS) ---
        final data = await controller.generarReporteMensualPernoctas(
            _mesSeleccionado.year, _mesSeleccionado.month);
        final config = data['config'];
        final items = data['items'] as List<ReporteDataDTO>;

        if (items.isEmpty && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("No hay pernoctas en este mes."),
              backgroundColor: Colors.orange));
        }

        final pdfBytes = await _pdfService.generateMonthlyReport(
          config: config,
          items: items,
          month: _mesSeleccionado.month,
          year: _mesSeleccionado.year,
        );

        if (mounted) {
          await Printing.layoutPdf(
            onLayout: (format) async => pdfBytes,
            name:
                'Pernoctas_${DateFormat('MM-yyyy').format(_mesSeleccionado)}.pdf',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error generando PDF: $e"),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  void _seleccionarSemana() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _inicioSemana,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      helpText: "Seleccione un día (se ajustará al Lunes)",
    );
    if (picked != null) {
      setState(() {
        _inicioSemana = picked.subtract(Duration(days: picked.weekday - 1));
      });
    }
  }

  void _cambiarMes(int delta) {
    setState(() {
      _mesSeleccionado =
          DateTime(_mesSeleccionado.year, _mesSeleccionado.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekEnd = _inicioSemana.add(const Duration(days: 6));

    return Scaffold(
      appBar: AppBar(title: const Text("Generar Reportes PDF")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Selector de Tipo
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                    value: 0,
                    label: Text("Semanal (Ordinaria)"),
                    icon: Icon(Icons.calendar_view_week)),
                ButtonSegment(
                    value: 1,
                    label: Text("Mensual (Pernocta)"),
                    icon: Icon(Icons.calendar_month)),
              ],
              selected: {_reportTypeIndex},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() => _reportTypeIndex = newSelection.first);
              },
            ),
            const SizedBox(height: 30),

            // 2. Controles de Fecha (Dinámicos)
            if (_reportTypeIndex == 0) ...[
              // Controles SEMANAL
              Text("Seleccione la Semana:",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              InkWell(
                onTap: _seleccionarSemana,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Desde: ${DateFormat('dd/MM/yyyy').format(_inicioSemana)}"),
                          Text(
                              "Hasta: ${DateFormat('dd/MM/yyyy').format(weekEnd)}"),
                        ],
                      ),
                      const Icon(Icons.calendar_today, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Controles MENSUAL
              Text("Seleccione el Mes:",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => _cambiarMes(-1),
                        icon: const Icon(Icons.chevron_left)),
                    Text(
                      DateFormat('MMMM yyyy', 'es')
                          .format(_mesSeleccionado)
                          .toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () => _cambiarMes(1),
                        icon: const Icon(Icons.chevron_right)),
                  ],
                ),
              )
            ],

            const Spacer(),

            // 3. Botón de Acción
            SizedBox(
              height: 55,
              child: FilledButton.icon(
                onPressed: _isGenerating ? null : _generarYPrevisualizar,
                icon: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.print),
                label: Text(
                    _isGenerating ? "Generando..." : "VISUALIZAR E IMPRIMIR"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
