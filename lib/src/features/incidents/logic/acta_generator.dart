import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ActaGenerator {
  Future<Uint8List> generate(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    debugPrint("Generando Acta de Inasistencia Legal (1 Hoja)...");

    // 1. Extracción de Datos
    final incidencia = data['incidencia'];
    final actividad = data['actividad'];
    final inasistente = data['inasistente'];
    final config = data['config'];
    final t1 = data['testigo1'];
    final t2 = data['testigo2'];
    final jefe = data['jefeServicio'];

    // 2. Formateo de Fechas
    final fechaActa = incidencia.fechaHoraRegistro as DateTime;
    final diaActa = DateFormat('d').format(fechaActa);
    final mesActa = DateFormat('MMMM', 'es').format(fechaActa);
    final anioActa = DateFormat('yyyy').format(fechaActa);
    final horaActa = DateFormat('HH:mm').format(fechaActa);

    // 3. Lógica de Redacción (Ordinaria vs Pernocta)
    String duracionTexto = "";
    String periodoTexto = "";

    if (actividad.esPernocta == true) {
      final fechaInicio = actividad.fecha as DateTime;
      final fechaFin = actividad.fechaFin as DateTime? ??
          fechaInicio.add(const Duration(days: 1));

      final horas = fechaFin.difference(fechaInicio).inHours;
      final horasLetras = _horasALetras(horas);

      duracionTexto =
          "$horasLetras (${horas.toString().padLeft(2, '0')}) horas";
      periodoTexto =
          "del período desde el ${DateFormat('dd/MM/yyyy').format(fechaInicio)} hasta el ${DateFormat('dd/MM/yyyy').format(fechaFin)}";
    } else {
      duracionTexto = "ocho (08) horas";
      periodoTexto =
          "del día ${DateFormat('dd/MM/yyyy').format(actividad.fecha)}";
    }

    // 4. Variables Auxiliares con Fallbacks
    final ciudad = config?.ciudad ?? "_______________";
    final municipio = config?.municipio ?? "_______________";
    final estado = config?.estado ?? "_______________";

    final jNombre = jefe != null
        ? "${jefe.nombres} ${jefe.apellidos}"
        : "_______________________";
    // Si no tiene rango, por defecto colocamos GP/. para evitar el espacio vacío
    final jRango = jefe?.rango ?? "GP/.";
    final jCedula = jefe?.cedula ?? "____________";

    final t1Nombre = t1 != null
        ? "${t1.nombres} ${t1.apellidos}"
        : "_______________________";
    final t1Rango = t1?.rango ?? "GP/.";
    final t1Cedula = t1?.cedula ?? "____________";

    final t2Nombre = t2 != null
        ? "${t2.nombres} ${t2.apellidos}"
        : "_______________________";
    final t2Rango = t2?.rango ?? "GP/.";
    final t2Cedula = t2?.cedula ?? "____________";

    final iNombre = "${inasistente.nombres} ${inasistente.apellidos}";
    final iCedula = inasistente.cedula;
    final iParque = config?.parqueNombre ?? "_______________";
    final iSector = config?.sectorNombre ?? "_______________";

    // 5. Cargar Logo
    pw.MemoryImage? logoImage;
    try {
      final ByteData bytes =
          await rootBundle.load('assets/images/logo_inparques.png');
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (e) {
      debugPrint("Advertencia: No se pudo cargar el logo para el Acta: $e");
    }

    // 6. Construcción del PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        // Ajustamos márgenes para maximizar el espacio vertical
        margin:
            const pw.EdgeInsets.only(left: 50, right: 50, top: 40, bottom: 40),
        header: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topLeft,
                      child: logoImage != null
                          ? pw.Image(logoImage, width: 60, height: 60)
                          : pw.SizedBox(),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text(
                              "MINISTERIO DEL PODER POPULAR PARA EL ECOSOCIALISMO",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10)),
                          pw.Text("INSTITUTO NACIONAL DE PARQUES",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10)),
                          pw.SizedBox(height: 4),
                          pw.Text(
                              "JEFATURA NACIONAL CUERPO CIVIL DE GUARDAPARQUES",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10)),
                          // FIX UX/Legal: Limpiado el caracter especial (guión largo) por un guión normal espaciado.
                          pw.Text("Caracas - Venezuela",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                    pw.Container(width: 60), // Balanceador
                  ]),
              pw.SizedBox(height: 20),
              pw.Text("ACTA DE INASISTENCIA",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                      decoration: pw.TextDecoration.underline)),
              pw.SizedBox(height: 15),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            // CUERPO DEL ACTA
            pw.RichText(
              textAlign: pw.TextAlign.justify,
              text: pw.TextSpan(
                style: const pw.TextStyle(fontSize: 12, lineSpacing: 1.5),
                children: [
                  const pw.TextSpan(text: "En el día de hoy, "),
                  pw.TextSpan(
                      text: diaActa,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(text: " de "),
                  pw.TextSpan(
                      text: mesActa,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(text: " de "),
                  pw.TextSpan(
                      text: anioActa,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(text: ", siendo las "),
                  pw.TextSpan(
                      text: horaActa,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(text: " horas, ubicados en: "),
                  pw.TextSpan(
                      text: "$ciudad, Municipio $municipio, Estado $estado",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

                  const pw.TextSpan(
                      text:
                          ", quien suscribe la presente acta, el funcionario(a) "),
                  pw.TextSpan(
                      text: jNombre,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(text: ", con cargo de "),
                  pw.TextSpan(
                      text: jRango,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(
                      text: " portador(a) de la cédula de identidad V-"),
                  pw.TextSpan(
                      text: jCedula,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

                  const pw.TextSpan(text: ", y los testigos, "),
                  pw.TextSpan(
                      text: t1Nombre,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(text: " con cargo de "),
                  pw.TextSpan(
                      text: t1Rango,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(
                      text: ", portador(a) de la cédula de identidad V-"),
                  pw.TextSpan(
                      text: t1Cedula,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

                  const pw.TextSpan(text: ", y "),
                  pw.TextSpan(
                      text: t2Nombre,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(text: ", con cargo de "),
                  pw.TextSpan(
                      text: t2Rango,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(
                      text: " portador(a) de la cédula de identidad V-"),
                  pw.TextSpan(
                      text: t2Cedula,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

                  // FIX Legal 1: Se forzó "Región Táchira" en lugar de inyectar la variable $estado para ajustarse a tu solicitud exacta.
                  const pw.TextSpan(
                      text:
                          ", todos trabajadores(as) activos(as) de la Región Táchira, a fines de dejar constancia de los hechos que a continuación se narran: el funcionario(a) "),
                  pw.TextSpan(
                      text: iNombre,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(
                      text: " portador(a) de la cédula de identidad V-"),
                  pw.TextSpan(
                      text: iCedula,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

                  // FIX Legal 2: Mejora en la concatenación de la asignación del funcionario (Agregado "al Parque Nacional", "Municipio" y "Edo.")
                  const pw.TextSpan(
                      text:
                          " , quien se desempeña actualmente con el cargo de Guardaparques, asignado al Parque Nacional "),
                  pw.TextSpan(
                      text:
                          "$iParque, sector $iSector, $ciudad, Municipio $municipio, Edo. $estado",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(text: " en un rol de guardia de "),
                  pw.TextSpan(
                      text: duracionTexto,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(text: ", "),
                  pw.TextSpan(
                      text: periodoTexto,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  const pw.TextSpan(
                      text:
                          " no se presentó a su puesto de trabajo. Siendo esto todo, terminó, se leyó y estando conformes firman."),
                ],
              ),
            ),

            pw.SizedBox(height: 35),

            // ÁREA DE FIRMAS
            pw.Center(
                child: _buildSignatureBlock(
                    "Guardaparques (Jefe/a de servicio)", jRango, jCedula)),
            pw.SizedBox(height: 25),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _buildSignatureBlock("Guardaparques", t1Rango, t1Cedula),
                  _buildSignatureBlock("Guardaparques", t2Rango, t2Cedula),
                ]),
          ];
        },
        footer: (pw.Context context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Divider(thickness: 1, color: PdfColors.black),
                pw.SizedBox(height: 5),
                pw.Text("JEFATURA NACIONAL DEL CUERPO CIVIL DE GUARDAPARQUES",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8)),
                pw.Text(
                    "DIRECCIÓN: Sede Nacional del Cuerpo Civil de Guardaparques, Avenida Rómulo Gallegos.",
                    style: const pw.TextStyle(fontSize: 8)),
                pw.Text(
                    "Teléfono: 0212-3683142 Correo Electrónico: ccgpnacional@gmail.com",
                    style: const pw.TextStyle(fontSize: 8)),
              ]);
        },
      ),
    );

    return pdf.save();
  }

  // Helper para crear los bloques de firmas con huella
  pw.Widget _buildSignatureBlock(String titulo, String rango, String cedula) {
    return pw.Container(
        width: 180,
        child: pw
            .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Center(
              child: pw.Text(titulo,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 11))),
          pw.SizedBox(height: 20),
          pw.Text("Firma: ____________________",
              style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 8),
          pw.Text(rango, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 8),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("CI. $cedula", style: const pw.TextStyle(fontSize: 11)),
                pw.Container(
                  width: 40,
                  height: 50,
                  decoration: pw.BoxDecoration(
                      border:
                          pw.Border.all(color: PdfColors.black, width: 0.5)),
                  alignment: pw.Alignment.bottomCenter,
                  child: pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 2),
                      child: pw.Text("Huella",
                          style: const pw.TextStyle(
                              fontSize: 8, color: PdfColors.grey700))),
                )
              ])
        ]));
  }

  // Helper para convertir las horas comunes a letras
  String _horasALetras(int horas) {
    switch (horas) {
      case 8:
        return "ocho";
      case 12:
        return "doce";
      case 24:
        return "veinticuatro";
      case 48:
        return "cuarenta y ocho";
      case 72:
        return "setenta y dos";
      case 96:
        return "noventa y seis";
      case 120:
        return "ciento veinte";
      default:
        return horas.toString();
    }
  }
}
