import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../data/local/app_database.dart';
import '../../planning/logic/planning_controller.dart';

class WeeklyReportGenerator {
  static const Map<int, String> _diasSemana = {
    1: 'LUNES',
    2: 'MARTES',
    3: 'MIERCOLES',
    4: 'JUEVES',
    5: 'VIERNES',
    6: 'SABADO',
    7: 'DOMINGO'
  };

  static const Map<int, String> _meses = {
    1: '01',
    2: '02',
    3: '03',
    4: '04',
    5: '05',
    6: '06',
    7: '07',
    8: '08',
    9: '09',
    10: '10',
    11: '11',
    12: '12'
  };

  Future<Uint8List> generate(
    Map<String, dynamic> dataPaquete,
    DateTime inicioSemana,
  ) async {
    WidgetsFlutterBinding.ensureInitialized();

    final config = dataPaquete['config'] as ConfigSetting?;
    final items = dataPaquete['items'] as List<ReporteDataDTO>;

    final fontRegular = pw.Font.courier();
    final fontBold = pw.Font.courierBold();
    final fontItalic = pw.Font.courierOblique();
    final fontBoldItalic = pw.Font.courierBoldOblique();

    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      italic: fontItalic,
      boldItalic: fontBoldItalic,
      icons: fontRegular,
    );

    final pdf = pw.Document(theme: theme);

    const pageFormat = PdfPageFormat(
        21.0 * PdfPageFormat.cm, 29.7 * PdfPageFormat.cm,
        marginAll: 1.5 * PdfPageFormat.cm);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        build: (pw.Context context) {
          return [
            pw.DefaultTextStyle(
              style: pw.TextStyle(font: fontRegular, fontSize: 10),
              child: pw.Column(
                children: [
                  _buildHeader(config, inicioSemana, fontBold, fontRegular),
                  pw.SizedBox(height: 10),
                  if (items.isEmpty)
                    pw.Center(
                        child: pw.Text("SIN ACTIVIDADES PROGRAMADAS",
                            style: pw.TextStyle(font: fontBold, fontSize: 18)))
                  else
                    pw.Column(
                      children: items
                          .map((item) => pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 12),
                                child: _buildActivityCard(
                                    item, fontRegular, fontBold, fontItalic),
                              ))
                          .toList(),
                    ),
                  pw.SizedBox(height: 15),
                  _buildFooter(config, fontRegular),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  String _clean(String input) {
    var text = input.toUpperCase();
    text = text
        .replaceAll('Á', 'A')
        .replaceAll('É', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll('Ñ', 'N');
    return text;
  }

  String _formatDate(DateTime date) {
    final diaNombre = _diasSemana[date.weekday] ?? 'DIA';
    final diaNum = date.day.toString().padLeft(2, '0');
    return "$diaNombre $diaNum";
  }

  pw.Widget _buildHeader(ConfigSetting? config, DateTime inicio,
      pw.Font fontBold, pw.Font fontRegular) {
    final fin = inicio.add(const Duration(days: 6));
    final diaInicio = inicio.day.toString().padLeft(2, '0');
    final diaFin = fin.day.toString().padLeft(2, '0');
    final mes = _meses[fin.month] ?? '01';
    final anio = fin.year.toString();

    final textoPeriodo = "PERIODO $diaInicio-$diaFin-$mes-$anio";
    final rangoJefe = _clean(config?.rangoJefe ?? "");
    final nombreJefe = _clean(config?.nombreJefe ?? "ADMINISTRADOR");
    final apellidoJefe = _clean(config?.apellidoJefe ?? "");
    final datosJefe = "$rangoJefe $nombreJefe $apellidoJefe".trim();
    final nombreSector = _clean(config?.sectorNombre ?? "INPARQUES");

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(datosJefe, style: pw.TextStyle(font: fontBold, fontSize: 14)),
        pw.Text(nombreSector,
            style: pw.TextStyle(font: fontRegular, fontSize: 12)),
        pw.Divider(thickness: 1, height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("ROL DE GUARDIAS",
                style: pw.TextStyle(font: fontBold, fontSize: 16)),
            pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius: pw.BorderRadius.circular(4)),
              child: pw.Text(textoPeriodo, style: pw.TextStyle(font: fontBold)),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildActivityCard(ReporteDataDTO item, pw.Font fontReg,
      pw.Font fontBold, pw.Font fontItalic) {
    final fecha = _formatDate(item.actividad.fecha);
    final esPernocta = item.actividad.esPernocta;

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey600),
        borderRadius: pw.BorderRadius.circular(4),
        color: esPernocta ? PdfColors.grey100 : PdfColors.white,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(children: [
            pw.Text("FECHA: ",
                style: pw.TextStyle(font: fontBold, fontSize: 10)),
            pw.Text(fecha, style: pw.TextStyle(font: fontReg, fontSize: 10)),
            if (esPernocta) ...[
              pw.SizedBox(width: 10),
              pw.Container(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                color: PdfColors.black,
                child: pw.Text("PERNOCTA",
                    style: pw.TextStyle(
                        font: fontBold, color: PdfColors.white, fontSize: 8)),
              )
            ]
          ]),
          pw.SizedBox(height: 2),
          pw.Row(children: [
            pw.Text("ACTIVIDAD: ",
                style: pw.TextStyle(font: fontBold, fontSize: 10)),
            pw.Text(_clean(item.tipoNombre),
                style: pw.TextStyle(font: fontReg, fontSize: 10)),
          ]),
          pw.SizedBox(height: 2),
          if (item.actividad.nombreActividad.isNotEmpty)
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text("DETALLE: ",
                  style: pw.TextStyle(font: fontBold, fontSize: 10)),
              pw.Expanded(
                  child: pw.Text(_clean(item.actividad.nombreActividad),
                      style: pw.TextStyle(font: fontItalic, fontSize: 10))),
            ]),
          pw.SizedBox(height: 2),
          pw.Row(children: [
            pw.Text("LUGAR: ",
                style: pw.TextStyle(font: fontBold, fontSize: 10)),
            pw.Text(_clean(item.actividad.lugar),
                style: pw.TextStyle(font: fontReg, fontSize: 10)),
          ]),
          pw.Divider(height: 8, thickness: 0.5, color: PdfColors.grey400),
          if (item.jefeServicio != null)
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.SizedBox(
                  width: 120,
                  child: pw.Text("JEFE DE SERVICIO:",
                      style: pw.TextStyle(font: fontBold, fontSize: 10))),
              pw.Expanded(
                  child: pw.Text(_formatFuncionario(item.jefeServicio!),
                      style: pw.TextStyle(font: fontReg, fontSize: 10))),
            ]),
          if (item.funcionarios.any((f) => f.id != item.jefeServicio?.id)) ...[
            pw.SizedBox(height: 4),
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.SizedBox(
                  width: 120,
                  child: pw.Text("PERSONAL ASIGNADO:",
                      style: pw.TextStyle(font: fontBold, fontSize: 10))),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: item.funcionarios
                      .where((f) => f.id != item.jefeServicio?.id)
                      .map((f) => pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 2),
                          child: pw.Text("- ${_formatFuncionario(f)}",
                              style:
                                  pw.TextStyle(font: fontReg, fontSize: 10))))
                      .toList(),
                ),
              ),
            ]),
          ]
        ],
      ),
    );
  }

  String _formatFuncionario(Funcionario f) {
    final r = f.rango ?? "";
    final n = f.nombres;
    final a = f.apellidos;
    // Eliminado el check de 'is not null' innecesario para cedula ya que es un String robusto
    final cedulaTexto = " (C.I. ${f.cedula})";
    return _clean("$r $n $a$cedulaTexto").trim();
  }

  pw.Widget _buildFooter(ConfigSetting? config, pw.Font font) {
    final nombreJefeCompleto = _clean(
        "${config?.nombreJefe ?? 'ADMINISTRADOR'} ${config?.apellidoJefe ?? ''}"
            .trim());
    final cargoJefe = _clean((config?.jefeCargo ?? "JEFE DE SECTOR"));

    return pw.Column(
      children: [
        pw.Divider(thickness: 1),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("ELABORADO POR:",
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.SizedBox(height: 25),
                  pw.Text(nombreJefeCompleto,
                      style: pw.TextStyle(
                          font: font,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10)),
                  pw.Text(cargoJefe,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
            ),
            pw.SizedBox(width: 40),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("RECIBIDO POR:",
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.SizedBox(height: 25),
                  pw.Container(height: 1, color: PdfColors.black),
                  pw.Text("FECHA Y HORA",
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
