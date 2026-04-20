import 'dart:io'; // Agregado para manejo de archivos
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../../../data/local/app_database.dart';
import '../../../core/utils/file_helper.dart'; // INYECTAMOS EL HELPER

class IncidentGenerator {
  static Future<void> generarActaInasistencia({
    required ConfigSetting config,
    required Funcionario inasistente,
    required String motivo,
    required DateTime fechaFalta,
    required List<Funcionario> testigos,
    required Funcionario? jefeServicio,
  }) async {
    final pdf = pw.Document();
    final dateStr = DateFormat('dd/MM/yyyy').format(fechaFalta);
    final hourStr = DateFormat('hh:mm a').format(fechaFalta);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("REPÚBLICA BOLIVARIANA DE VENEZUELA",
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          "MINISTERIO DEL PODER POPULAR PARA EL ECOSOCIALISMO",
                          style: const pw.TextStyle(fontSize: 9)),
                      pw.Text("INSTITUTO NACIONAL DE PARQUES (INPARQUES)",
                          style: pw.TextStyle(
                              fontSize: 9, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          "SECTOR: ${config.sectorNombre?.toUpperCase() ?? 'NO DEFINIDO'}",
                          style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                  pw.Text("ACTA N°: ${fechaFalta.millisecondsSinceEpoch}",
                      style: const pw.TextStyle(color: PdfColors.grey700)),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Center(
                child: pw.Text("ACTA DE INASISTENCIA LABORAL",
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline)),
              ),
              pw.SizedBox(height: 30),
              pw.Text(
                "En la fecha $dateStr, siendo las $hourStr, se deja constancia formal de la inasistencia del ciudadano(a) "
                "${inasistente.nombres.toUpperCase()} ${inasistente.apellidos.toUpperCase()}, titular de la cédula de identidad "
                "V-${inasistente.cedula}, quien desempeña el cargo de ${inasistente.rango}. Motivo informado: $motivo.",
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(fontSize: 12, lineSpacing: 1.5),
              ),
              pw.Spacer(),
              _buildFirmasCascada(jefeServicio, testigos, config),
            ],
          );
        },
      ),
    );

    // NUEVA LÓGICA DE GUARDADO Y COMPARTIR
    final pdfBytes = await pdf.save();
    final nombreArchivo =
        'Acta_Inasistencia_${inasistente.cedula}_${fechaFalta.millisecondsSinceEpoch}.pdf';

    // 1. Obtener la carpeta pública
    final rutaCarpeta = await FileHelper.obtenerCarpetaPublicaInparques();
    final rutaCompleta = '$rutaCarpeta/$nombreArchivo';

    // 2. Guardar el archivo físicamente
    final archivoFisico = File(rutaCompleta);
    await archivoFisico.writeAsBytes(pdfBytes);

    // 3. Compartir el archivo automáticamente
    await FileHelper.compartirArchivo(rutaCompleta, nombreArchivo);
  }

  static pw.Widget _buildFirmasCascada(Funcionario? jefeServicio,
      List<Funcionario> testigos, ConfigSetting config) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            if (jefeServicio != null)
              _buildFirmaIndividual(
                  "${jefeServicio.nombres} ${jefeServicio.apellidos}",
                  jefeServicio.cedula,
                  "JEFE DE SERVICIO")
            else
              _buildFirmaIndividual(
                  config.nombreJefe, "ADMIN", "${config.rangoJefe} (SISTEMA)"),
            if (testigos.isNotEmpty)
              _buildFirmaIndividual(
                  "${testigos[0].nombres} ${testigos[0].apellidos}",
                  testigos[0].cedula,
                  "TESTIGO 1"),
          ],
        ),
        if (testigos.length >= 2) ...[
          pw.SizedBox(height: 40),
          pw.Center(
            child: _buildFirmaIndividual(
                "${testigos[1].nombres} ${testigos[1].apellidos}",
                testigos[1].cedula,
                "TESTIGO 2"),
          ),
        ]
      ],
    );
  }

  static pw.Widget _buildFirmaIndividual(
      String nombre, String cedula, String cargo) {
    return pw.Column(
      children: [
        pw.Container(
            width: 180,
            decoration: const pw.BoxDecoration(
                border: pw.Border(top: pw.BorderSide(width: 1)))),
        pw.Text(nombre.toUpperCase(),
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
        pw.Text("V-$cedula", style: const pw.TextStyle(fontSize: 9)),
        pw.Text(cargo, style: const pw.TextStyle(fontSize: 8)),
      ],
    );
  }
}
