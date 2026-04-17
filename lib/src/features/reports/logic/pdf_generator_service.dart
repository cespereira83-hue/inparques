import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../planning/logic/planning_controller.dart';
import '../../../data/local/app_database.dart';

class PdfGeneratorService {
  // ============================================================================
  // HELPER: Carga el logo desde los assets de forma segura
  // ============================================================================
  Future<pw.ImageProvider?> _loadLogo() async {
    try {
      final ByteData bytes =
          await rootBundle.load('assets/images/logo_inparques.png');
      final Uint8List logoBytes = bytes.buffer.asUint8List();
      return pw.MemoryImage(logoBytes);
    } catch (e) {
      // Si la imagen no existe o hay error, retorna nulo para no romper el PDF
      print("Advertencia: No se pudo cargar el logo_inparques.png - $e");
      return null;
    }
  }

  Future<Uint8List> generateWeeklyReport({
    required ConfigSetting? config,
    required List<ReporteDataDTO> items,
    required DateTime inicioSemana,
  }) async {
    final doc = pw.Document();

    final font = await PdfGoogleFonts.nunitoExtraLight();
    final fontBold = await PdfGoogleFonts.nunitoBold();

    // Cargamos el logo antes de construir las páginas
    final logoImage = await _loadLogo();

    final finSemana = inicioSemana.add(const Duration(days: 6));
    final periodoStr =
        "SEMANA DEL ${DateFormat('dd/MM/yyyy').format(inicioSemana)} AL ${DateFormat('dd/MM/yyyy').format(finSemana)}";

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(
          context: context,
          config: config,
          tituloReporte: "ROL DE GUARDIAS ORDINARIAS",
          subtitulo: periodoStr,
          font: font,
          fontBold: fontBold,
          logo: logoImage,
        ),
        build: (context) => [
          pw.SizedBox(height: 20),
          _buildWeeklyTable(items, font, fontBold),
        ],
        footer: (context) => _buildFooter(context, font),
      ),
    );

    return doc.save();
  }

  Future<Uint8List> generateMonthlyReport({
    required ConfigSetting? config,
    required List<ReporteDataDTO> items,
    required int month,
    required int year,
  }) async {
    final doc = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final fontBold = await PdfGoogleFonts.nunitoBold();

    // Cargamos el logo antes de construir las páginas
    final logoImage = await _loadLogo();

    final mesStr = DateFormat('MMMM yyyy', 'es').format(DateTime(year, month));
    final tituloPeriodo = "PERÍODO: ${mesStr.toUpperCase()}";

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(
          context: context,
          config: config,
          tituloReporte: "ROL DE PERNOCTAS",
          subtitulo: tituloPeriodo,
          font: font,
          fontBold: fontBold,
          logo: logoImage,
        ),
        build: (context) => [
          pw.SizedBox(height: 20),
          _buildMonthlyTable(items, font, fontBold),
        ],
        footer: (context) => _buildFooter(context, font),
      ),
    );

    return doc.save();
  }

  pw.Widget _buildHeader({
    required pw.Context context,
    required ConfigSetting? config,
    required String tituloReporte,
    required String subtitulo,
    required pw.Font font,
    required pw.Font fontBold,
    required pw.ImageProvider? logo,
  }) {
    // PREPARACIÓN DE DATOS
    String nombreCompletoJefe = "INPARQUES";
    if (config != null) {
      // MODIFICACIÓN: Inclusión de las siglas GP/ antes del rango y el nombre
      nombreCompletoJefe =
          "GP/ ${config.rangoJefe} ${config.nombreJefe} ${config.apellidoJefe ?? ''}"
              .toUpperCase();
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // 1. Institución / Parque (CON LOGO)
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Si el logo existe, lo dibujamos a la izquierda
              if (logo != null) ...[
                pw.Image(logo, width: 60, height: 60),
                pw.SizedBox(width: 15),
              ],
              // Texto centrado
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      config?.nombreInstitucion.toUpperCase() ?? "INPARQUES",
                      style: pw.TextStyle(font: fontBold, fontSize: 16),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      "${config?.municipio ?? ''} - ${config?.estado ?? ''}"
                          .toUpperCase(),
                      style: pw.TextStyle(font: font, fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Espacio vacío a la derecha para equilibrar y mantener el texto en el centro exacto
              if (logo != null) ...[
                pw.SizedBox(width: 75),
              ]
            ]),
        pw.SizedBox(height: 15),

        // 2. Título del Reporte
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            children: [
              pw.Text(tituloReporte,
                  style: pw.TextStyle(font: fontBold, fontSize: 14)),
              pw.Text(subtitulo,
                  style: pw.TextStyle(font: fontBold, fontSize: 12)),
            ],
          ),
        ),
        pw.SizedBox(height: 10),

        // 3. Datos del Jefe de Sector
        if (config != null)
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(5),
            color: PdfColors.grey200,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text("JEFE DE SECTOR: ",
                    style: pw.TextStyle(font: fontBold, fontSize: 10)),
                pw.Text(
                  nombreCompletoJefe,
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
              ],
            ),
          ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _buildWeeklyTable(
      List<ReporteDataDTO> items, pw.Font font, pw.Font fontBold) {
    if (items.isEmpty) {
      return pw.Center(child: pw.Text("SIN ACTIVIDADES REGISTRADAS"));
    }

    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(60),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(3),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _cellHeader("FECHA", fontBold),
            _cellHeader("ACTIVIDAD / LUGAR", fontBold),
            _cellHeader("JEFE DE SERVICIO", fontBold),
            _cellHeader("PERSONAL ASIGNADO", fontBold),
          ],
        ),
        ...items.map((item) {
          final dateStr = DateFormat('EEE dd/MM', 'es')
              .format(item.actividad.fecha)
              .toUpperCase();
          final jefeStr = item.jefeServicio != null
              ? "${item.jefeServicio!.rango ?? ''} ${item.jefeServicio!.nombres} ${item.jefeServicio!.apellidos}"
              : "SIN ASIGNAR";

          final personalList = item.funcionarios
              .where((f) => f.id != item.jefeServicio?.id)
              .map((f) => "• ${f.rango ?? ''} ${f.nombres} ${f.apellidos}")
              .join("\n");

          return pw.TableRow(
            verticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: [
              _cell(dateStr, font, align: pw.TextAlign.center),
              _cell(
                  "${item.actividad.nombreActividad}\n(${item.actividad.lugar})",
                  font),
              _cell(jefeStr, font),
              _cell(personalList.isEmpty ? "(Solo Jefe)" : personalList, font),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildMonthlyTable(
      List<ReporteDataDTO> items, pw.Font font, pw.Font fontBold) {
    if (items.isEmpty) {
      return pw.Center(child: pw.Text("SIN PERNOCTAS REGISTRADAS"));
    }

    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(80),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(3),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _cellHeader("PERIODO", fontBold),
            _cellHeader("PUESTO / UBICACIÓN", fontBold),
            _cellHeader("JEFE DE SERVICIO", fontBold),
            _cellHeader("PERSONAL ASIGNADO", fontBold),
          ],
        ),
        ...items.map((item) {
          final inicio = DateFormat('dd/MM').format(item.actividad.fecha);
          final fin = item.actividad.fechaFin != null
              ? DateFormat('dd/MM').format(item.actividad.fechaFin!)
              : "?";
          final periodo = "$inicio AL $fin";

          final jefeStr = item.jefeServicio != null
              ? "${item.jefeServicio!.rango ?? ''} ${item.jefeServicio!.nombres} ${item.jefeServicio!.apellidos}"
              : "SIN ASIGNAR";

          final personalList = item.funcionarios
              .where((f) => f.id != item.jefeServicio?.id)
              .map((f) => "• ${f.rango ?? ''} ${f.nombres} ${f.apellidos}")
              .join("\n");

          return pw.TableRow(
            verticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: [
              _cell(periodo, font, align: pw.TextAlign.center),
              _cell(item.actividad.lugar, font, align: pw.TextAlign.center),
              _cell(jefeStr, font),
              _cell(personalList.isEmpty ? "(Solo Jefe)" : personalList, font),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _cellHeader(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
            font: font, fontSize: 9, fontWeight: pw.FontWeight.bold),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _cell(String text, pw.Font font,
      {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: 9),
        textAlign: align,
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context, pw.Font font) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        "Página ${context.pageNumber} de ${context.pagesCount} - Generado el ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}",
        style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey),
      ),
    );
  }
}
