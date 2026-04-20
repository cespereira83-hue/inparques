import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:flutter/services.dart' show rootBundle; // Para cargar el logo
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// ============================================================================
// DTOs (Data Transfer Objects)
// ============================================================================

class FuncionarioReporteDTO {
  final String nombreCompleto;
  final String cedula;
  final String rango;

  FuncionarioReporteDTO({
    required this.nombreCompleto,
    required this.cedula,
    required this.rango,
  });
}

class ActividadReporteDTO {
  final DateTime fecha;
  final String nombreActividad;
  final String lugar;
  final String jefeServicioNombre;
  final String jefeServicioCedula;
  final List<FuncionarioReporteDTO> funcionarios;

  ActividadReporteDTO({
    required this.fecha,
    required this.nombreActividad,
    required this.lugar,
    required this.jefeServicioNombre,
    required this.jefeServicioCedula,
    required this.funcionarios,
  });
}

class PlanificacionReporteDTO {
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String parqueNombre;
  final String sectorNombre;
  final String ciudad;
  final String municipio;
  final String estado;
  final String jefeNombre;
  final String jefeRango;
  final List<ActividadReporteDTO> actividades;

  PlanificacionReporteDTO({
    required this.fechaInicio,
    required this.fechaFin,
    required this.parqueNombre,
    required this.sectorNombre,
    required this.ciudad,
    required this.municipio,
    required this.estado,
    required this.jefeNombre,
    required this.jefeRango,
    required this.actividades,
  });
}

// ============================================================================
// GENERADORES PDF (ORDINARIA Y PERNOCTA)
// ============================================================================

class WeeklyReportGenerator {
  // 1. REPORTE SEMANAL (ORDINARIO)
  static Future<Uint8List> generarReporte(PlanificacionReporteDTO data) async {
    return _construirEstructuraPdf(
      data: data,
      tituloReporte: "PLANIFICACIÓN DEL PERSONAL",
      subtitulo:
          "Semana: ${DateFormat('dd/MM/yyyy').format(data.fechaInicio)} al ${DateFormat('dd/MM/yyyy').format(data.fechaFin)}",
    );
  }

  // 2. REPORTE MENSUAL (PERNOCTA)
  static Future<Uint8List> generarReportePernocta(
      PlanificacionReporteDTO data, String mesTexto) async {
    return _construirEstructuraPdf(
      data: data,
      tituloReporte: "PLANIFICACIÓN DE GUARDIAS DE PERNOCTA",
      subtitulo: "Mes: $mesTexto",
    );
  }

  // MÉTODO PRIVADO REUTILIZABLE PARA NO REPETIR CÓDIGO
  static Future<Uint8List> _construirEstructuraPdf({
    required PlanificacionReporteDTO data,
    required String tituloReporte,
    required String subtitulo,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final fontNormal = pw.Font.helvetica();
    final fontBold = pw.Font.helveticaBold();

    // 1. CARGAMOS EL LOGO DE INPARQUES DESDE LOS ASSETS
    pw.MemoryImage? logoImage;
    try {
      final ByteData bytes =
          await rootBundle.load('assets/images/logo_inparques.png');
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (e) {
      debugPrint(
          "Advertencia: No se pudo cargar el logo de inparques para el PDF: $e");
    }

    final headers = [
      'Fecha',
      'Actividad',
      'Lugar',
      'Jefe de Servicio\n(Cédula)',
      'Funcionarios Asignados\n(Cédulas)'
    ];

    final tableData = data.actividades.map((act) {
      final fechaStr = dateFormat.format(act.fecha);

      final jefeStr = act.jefeServicioNombre.isNotEmpty &&
              act.jefeServicioNombre != "No asignado"
          ? "${act.jefeServicioNombre}\nC.I: ${act.jefeServicioCedula}"
          : "No asignado";

      final funcionariosStr = act.funcionarios.isEmpty
          ? "Sin personal asignado"
          : act.funcionarios
              .map(
                  (f) => "- ${f.rango} ${f.nombreCompleto}\n  C.I: ${f.cedula}")
              .join('\n');

      return [
        fechaStr,
        act.nombreActividad,
        act.lugar,
        jefeStr,
        funcionariosStr
      ];
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.all(40),
        header: (pw.Context context) {
          return pw.Column(
            children: [
              // ENCABEZADO CON LOGO Y TEXTO CENTRADO
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Lado Izquierdo: Logo
                    pw.Container(
                      width: 70, // Ancho fijo para balancear
                      alignment: pw.Alignment.topLeft,
                      child: logoImage != null
                          ? pw.Image(logoImage, width: 65, height: 65)
                          : pw.SizedBox(),
                    ),

                    // Centro: Textos expandidos para forzar el centro perfecto
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text("REPÚBLICA BOLIVARIANA DE VENEZUELA",
                              textAlign: pw.TextAlign.center,
                              style:
                                  pw.TextStyle(font: fontBold, fontSize: 10)),
                          pw.Text(
                              "MINISTERIO DEL PODER POPULAR PARA EL ECOSOCIALISMO",
                              textAlign: pw.TextAlign.center,
                              style:
                                  pw.TextStyle(font: fontBold, fontSize: 10)),
                          pw.Text("INSTITUTO NACIONAL DE PARQUES",
                              textAlign: pw.TextAlign.center,
                              style:
                                  pw.TextStyle(font: fontBold, fontSize: 11)),
                          pw.SizedBox(height: 10),
                          pw.Text("PARQUE: ${data.parqueNombre.toUpperCase()}",
                              textAlign: pw.TextAlign.center,
                              style:
                                  pw.TextStyle(font: fontNormal, fontSize: 10)),
                          pw.Text("SECTOR: ${data.sectorNombre.toUpperCase()}",
                              textAlign: pw.TextAlign.center,
                              style:
                                  pw.TextStyle(font: fontNormal, fontSize: 10)),
                          pw.Text(
                              "UBICACIÓN: ${data.ciudad}, MUN. ${data.municipio.toUpperCase()}, EDO. ${data.estado.toUpperCase()}",
                              textAlign: pw.TextAlign.center,
                              style:
                                  pw.TextStyle(font: fontNormal, fontSize: 9)),
                          pw.SizedBox(height: 5),
                          pw.Text(
                              "RESPONSABLE DEL SECTOR: ${data.jefeRango} ${data.jefeNombre.toUpperCase()}",
                              textAlign: pw.TextAlign.center,
                              style:
                                  pw.TextStyle(font: fontBold, fontSize: 10)),
                        ],
                      ),
                    ),

                    // Lado Derecho: Contenedor vacío del mismo tamaño del logo
                    // (Esto garantiza que el texto del centro no se desplace)
                    pw.Container(width: 70),
                  ]),

              // TÍTULOS DEL DOCUMENTO
              pw.SizedBox(height: 20),
              pw.Text(tituloReporte,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: fontBold, fontSize: 14)),
              pw.SizedBox(height: 5),
              pw.Text(subtitulo,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: fontNormal, fontSize: 12)),
              pw.SizedBox(height: 20),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: tableData,
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
              headerStyle: pw.TextStyle(
                  font: fontBold, fontSize: 10, color: PdfColors.white),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColor.fromInt(0xFF2E7D32)),
              cellStyle: pw.TextStyle(font: fontNormal, fontSize: 9),
              cellPadding: const pw.EdgeInsets.all(6),
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.center,
                4: pw.Alignment.centerLeft,
              },
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(2),
                4: const pw.FlexColumnWidth(3),
              },
            ),
          ];
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
                'Página ${context.pageNumber} de ${context.pagesCount}',
                style: pw.TextStyle(
                    font: fontNormal, fontSize: 8, color: PdfColors.grey)),
          );
        },
      ),
    );

    return pdf.save();
  }
}
