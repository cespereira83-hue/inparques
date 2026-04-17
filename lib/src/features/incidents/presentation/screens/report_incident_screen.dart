import 'dart:io'; // Para guardar el archivo
import 'dart:typed_data'; // Para manejar los bytes del PDF
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart'; // Para PdfPageFormat
import 'package:file_picker/file_picker.dart'; // Súper Diálogo: Guardar Como
import 'package:path_provider/path_provider.dart'; // Súper Diálogo: Descarga Rápida
import 'package:path/path.dart' as p;

import '../../../../data/local/app_database.dart';
import '../../logic/incidents_controller.dart';
import '../../logic/acta_generator.dart';

// ============================================================================
// HELPER PARA EXPORTACIÓN: Súper Diálogo (Imprimir, Guardar Como, Descarga)
// ============================================================================
Future<void> _mostrarOpcionesSalidaPdf(
  BuildContext context,
  Uint8List bytes,
  String nombreArchivo, {
  PdfPageFormat format = PdfPageFormat.a4,
}) async {
  await showDialog(
    context: context,
    barrierDismissible:
        false, // Evita que se cierre tocando afuera para no perder el PDF
    builder: (ctx) => AlertDialog(
      title: const Text("Acta Generada con Éxito",
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text(
          "La inasistencia ha sido registrada.\n\n¿Qué deseas hacer con el archivo:\n$nombreArchivo?"),
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
              format: format,
            );
          },
        ),
        FilledButton.tonalIcon(
          icon: const Icon(Icons.folder_open),
          label: const Text("Elegir ubicación..."),
          onPressed: () async {
            Navigator.pop(ctx);
            String? outputFile = await FilePicker.platform.saveFile(
              dialogTitle: 'Guardar Acta en...',
              fileName: nombreArchivo,
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );

            if (outputFile != null) {
              if (!outputFile.toLowerCase().endsWith('.pdf')) {
                outputFile += '.pdf';
              }
              final file = File(outputFile);
              await file.writeAsBytes(bytes);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("✅ Acta guardada en:\n$outputFile"),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 4),
                  ),
                );
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("✅ Guardado automáticamente en:\n$filePath"),
                    backgroundColor: Colors.green.shade700,
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Error al guardar: $e"),
                      backgroundColor: Colors.red),
                );
              }
            }
          },
        ),
      ],
    ),
  );
}

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _observacionesController = TextEditingController();

  bool _isLoading = false;

  // --- ESTADO DE SELECCIÓN ---
  List<Actividade> _actividadesPasadas = [];
  List<Funcionario> _participantes = [];

  int? _selectedActividadId;
  int? _selectedInasistenteId;
  int? _selectedTestigo1Id;
  int? _selectedTestigo2Id;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarActividades();
    });
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  // --- CARGA DE DATOS ---

  Future<void> _cargarActividades() async {
    setState(() => _isLoading = true);
    try {
      final ctrl = context.read<IncidentsController>();
      final lista = await ctrl.obtenerActividadesPasadas();
      setState(() {
        _actividadesPasadas = lista;
      });
    } catch (e) {
      _showError("Error cargando actividades: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cargarParticipantes(int actividadId) async {
    setState(() => _isLoading = true);
    try {
      final ctrl = context.read<IncidentsController>();
      final lista = await ctrl.obtenerParticipantes(actividadId);
      setState(() {
        _participantes = lista;
        // Reset selecciones al cambiar actividad
        _selectedInasistenteId = null;
        _selectedTestigo1Id = null;
        _selectedTestigo2Id = null;
      });
    } catch (e) {
      _showError("Error cargando personal: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- ACCIONES ---

  Future<void> _generarActa() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedInasistenteId == null) {
      _showError("Debe seleccionar al funcionario inasistente.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final ctrl = context.read<IncidentsController>();

      // 1. Guardar en Base de Datos (Genera ID de incidencia y Redacción Automática)
      final incidenciaId = await ctrl.registrarInasistencia(
        actividadId: _selectedActividadId!,
        funcionarioId: _selectedInasistenteId!,
        testigo1Id: _selectedTestigo1Id,
        testigo2Id: _selectedTestigo2Id,
        observaciones: _observacionesController.text,
      );

      // 2. Preparar Datos Completos (DTO)
      final actaData = await ctrl.prepararDatosActa(incidenciaId);

      // 3. Generar PDF Vectorizado
      final pdfBytes = await ActaGenerator().generate(actaData);
      final nombreArchivo = 'Acta_Inasistencia_$incidenciaId.pdf';

      if (mounted) {
        // Apagamos el loading para que el diálogo se vea bien
        setState(() => _isLoading = false);

        // 4. Mostrar el Súper Diálogo de Exportación
        await _mostrarOpcionesSalidaPdf(context, pdfBytes, nombreArchivo);

        // 5. Cerrar la pantalla de registro después de interactuar con el diálogo
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        _showError("Error crítico generando acta: $e");
      }
    } finally {
      if (mounted && _isLoading) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  // --- FILTROS DE CASCADA PARA DROPDOWNS ---

  List<Funcionario> get _listaInasistentes => _participantes;

  List<Funcionario> get _listaTestigos1 {
    if (_selectedInasistenteId == null) return [];
    return _participantes.where((f) => f.id != _selectedInasistenteId).toList();
  }

  List<Funcionario> get _listaTestigos2 {
    if (_selectedInasistenteId == null) return [];
    return _participantes.where((f) {
      return f.id != _selectedInasistenteId && f.id != _selectedTestigo1Id;
    }).toList();
  }

  // --- UI BUILD ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Control de Inasistencias"),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
      ),
      body: _isLoading && _actividadesPasadas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    "PASO 1: Selección de Actividad",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    initialValue: _selectedActividadId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "Actividades Pasadas",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.history),
                    ),
                    items: _actividadesPasadas.map((a) {
                      final fecha = DateFormat('dd/MM/yyyy').format(a.fecha);
                      return DropdownMenuItem(
                        value: a.id,
                        child: Text("$fecha - ${a.nombreActividad}",
                            overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedActividadId = val);
                        _cargarParticipantes(val);
                      }
                    },
                    validator: (v) => v == null ? "Requerido" : null,
                  ),
                  if (_selectedActividadId != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      "PASO 2: Datos de la Falta",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),

                    // SELECCIÓN DEL INASISTENTE
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Funcionario Ausente (Inasistente):",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            initialValue: _selectedInasistenteId,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            items: _listaInasistentes.map((f) {
                              return DropdownMenuItem(
                                value: f.id,
                                child: Text(
                                    "${f.rango} ${f.nombres} ${f.apellidos}"),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedInasistenteId = val;
                                // Reset testigos si hay conflicto
                                if (_selectedTestigo1Id == val) {
                                  _selectedTestigo1Id = null;
                                }
                                if (_selectedTestigo2Id == val) {
                                  _selectedTestigo2Id = null;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      "PASO 3: Testigos (Para firma del Acta)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            initialValue: _selectedTestigo1Id,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: "Testigo 1 (Opcional)",
                              border: OutlineInputBorder(),
                            ),
                            items: _listaTestigos1.map((f) {
                              return DropdownMenuItem(
                                value: f.id,
                                child: Text("${f.nombres} ${f.apellidos}",
                                    overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedTestigo1Id = val;
                                if (_selectedTestigo2Id == val) {
                                  _selectedTestigo2Id = null;
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            initialValue: _selectedTestigo2Id,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: "Testigo 2 (Opcional)",
                              border: OutlineInputBorder(),
                            ),
                            items: _listaTestigos2.map((f) {
                              return DropdownMenuItem(
                                value: f.id,
                                child: Text("${f.nombres} ${f.apellidos}",
                                    overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => _selectedTestigo2Id = val),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _observacionesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Observaciones Adicionales (Opcional)",
                        border: OutlineInputBorder(),
                        hintText:
                            "Ej: Presentó justificativo médico posterior...",
                      ),
                    ),

                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade800,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _isLoading ? null : _generarActa,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white))
                            : const Icon(Icons.gavel),
                        label: const Text("GENERAR ACTA ADMINISTRATIVA"),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
