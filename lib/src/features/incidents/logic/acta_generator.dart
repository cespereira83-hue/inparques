import 'dart:typed_data';
import 'package:flutter/services.dart'
    show rootBundle; // Importación para cargar el logo
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

// CORRECCIÓN: Ruta ajustada para salir de 'features' y entrar a 'data' (hermana de 'core')
import '../../../data/local/app_database.dart';

class ActaGenerator {
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
      print("Advertencia: No se pudo cargar el logo_inparques.png - $e");
      return null;
    }
  }

  Future<Uint8List> generate(dynamic data) async {
    final pdf = pw.Document();

    final fontRegular = pw.Font.courier();
    final fontBold = pw.Font.courierBold();
    final fontItalic = pw.Font.courierOblique();

    // Cargamos el logo antes de construir la página
    final logoImage = await _loadLogo();

    final map = _normalizarDatos(data);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 50, vertical: 40),
        build: (pw.Context context) {
          return [
            _buildHeader(map, fontBold, logoImage), // Inyectamos el logo aquí
            pw.SizedBox(height: 20),
            _buildTitle(map, fontBold),
            pw.SizedBox(height: 30),
            _buildBodyLegal(map, fontRegular, fontBold),
            pw.SizedBox(height: 20),
            if (map['observaciones'] != null &&
                map['observaciones'].toString().isNotEmpty)
              _buildObservaciones(map['observaciones'], fontItalic),
            pw.SizedBox(height: 50),
            _buildSignatures(map, fontRegular, fontBold),
            pw.Spacer(),
            _buildFooter(fontRegular),
          ];
        },
      ),
    );

    return pdf.save();
  }

  Map<String, dynamic> _normalizarDatos(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    try {
      return {
        'config': (data as dynamic).config,
        'actividad': (data as dynamic).actividad,
        'incidencia': (data as dynamic).incidencia,
        'jefeServicio': (data as dynamic).jefeServicio,
        'testigo1': (data as dynamic).testigo1,
        'testigo2': (data as dynamic).testigo2,
        'inasistente': (data as dynamic).inasistente,
        'observaciones': (data as dynamic).incidencia.observaciones,
      };
    } catch (e) {
      return {};
    }
  }

  pw.Widget _buildHeader(
      Map<String, dynamic> map, pw.Font font, pw.ImageProvider? logo) {
    final config = map['config'] as ConfigSetting?;

    final sector = config?.sectorNombre?.toUpperCase() ?? "SECTOR NO DEFINIDO";
    final estado = config?.estado?.toUpperCase() ?? "ESTADO";

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // Si el logo existe, lo dibujamos a la izquierda
        if (logo != null) ...[
          pw.Image(logo, width: 60, height: 60),
          pw.SizedBox(width: 15),
        ],
        // Texto central institucional
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text("REPÚBLICA BOLIVARIANA DE VENEZUELA",
                  style: pw.TextStyle(font: font, fontSize: 9)),
              pw.Text("MINISTERIO DEL PODER POPULAR PARA EL ECOSOCIALISMO",
                  style: pw.TextStyle(font: font, fontSize: 9)),
              pw.Text("INSTITUTO NACIONAL DE PARQUES",
                  style: pw.TextStyle(font: font, fontSize: 9)),
              pw.Text("CUERPO CIVIL DE GUARDAPARQUES",
                  style: pw.TextStyle(font: font, fontSize: 9)),
              pw.SizedBox(height: 4),
              pw.Text(sector,
                  style: pw.TextStyle(
                      font: font,
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      decoration: pw.TextDecoration.underline)),
              pw.Text(estado, style: pw.TextStyle(font: font, fontSize: 8)),
              pw.SizedBox(height: 10),
            ],
          ),
        ),
        // Espaciador derecho para mantener el texto perfectamente centrado si hay logo
        if (logo != null) ...[
          pw.SizedBox(width: 75), // 60 de ancho de imagen + 15 de separación
        ]
      ],
    );
  }

  pw.Widget _buildTitle(Map<String, dynamic> map, pw.Font font) {
    final incidencia = map['incidencia'] as Incidencia?;
    final numero = incidencia?.id.toString().padLeft(4, '0') ?? "0000";
    final anio = DateTime.now().year;

    return pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.centerRight,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text("ACTA ADMINISTRATIVA DE NOVEDADES",
                style: pw.TextStyle(
                    font: font, fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Text("N° ACTA: $numero-$anio",
                style: pw.TextStyle(
                    font: font, fontSize: 10, color: PdfColors.red900)),
          ],
        ));
  }

  pw.Widget _buildBodyLegal(
      Map<String, dynamic> map, pw.Font regular, pw.Font bold) {
    final incidencia = map['incidencia'] as Incidencia?;
    final actividad = map['actividad'] as Actividade?;
    final inasistente = map['inasistente'] as Funcionario?;

    if (incidencia == null || actividad == null || inasistente == null) {
      return pw.Text("ERROR: Datos incompletos para generar el acta.");
    }

    final fechaAct = actividad.fecha;
    final dia = fechaAct.day;
    final mes = _nombreMes(fechaAct.month);
    final anio = fechaAct.year;

    final nombreFunc =
        "${inasistente.nombres} ${inasistente.apellidos}".toUpperCase();
    final cedulaFunc = inasistente.cedula;
    final rangoFunc = inasistente.rango ?? "Funcionario";

    final lugar = actividad.lugar;
    final tipoGuardia = map['tipoNombre'] ?? "Servicio Ordinario";
    final motivo = incidencia.descripcion;

    final texto = [
      pw.TextSpan(text: "En la localidad de "),
      pw.TextSpan(
          text: lugar.toUpperCase(),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(text: ", a los "),
      pw.TextSpan(
          text: "$dia", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(text: " días del mes de "),
      pw.TextSpan(
          text: mes.toUpperCase(),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(text: " del año "),
      pw.TextSpan(
          text: "$anio", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(
          text:
              ", quien suscribe, actuando en conformidad con las atribuciones conferidas por la Ley, procedo a dejar constancia formal de la siguiente novedad:\n\n"),
      pw.TextSpan(text: "Que el ciudadano(a) "),
      pw.TextSpan(
          text: nombreFunc,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(text: ", titular de la Cédula de Identidad N° "),
      pw.TextSpan(
          text: "V-$cedulaFunc",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(text: ", ostentando el rango de "),
      pw.TextSpan(text: rangoFunc.toUpperCase()),
      pw.TextSpan(text: ", "),
      pw.TextSpan(
          text: "NO SE PRESENTÓ",
          style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold, color: PdfColors.red)),
      pw.TextSpan(
          text:
              " a cumplir con sus deberes asignados correspondientes a la actividad denominada "),
      pw.TextSpan(
          text: "\"${actividad.nombreActividad}\"",
          style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
      pw.TextSpan(
          text:
              " ($tipoGuardia), la cual estaba pautada para dar inicio en la fecha señalada.\n\n"),
      pw.TextSpan(text: "Dicha ausencia se registra bajo la descripción: "),
      pw.TextSpan(
          text: motivo.toUpperCase(),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(text: "."),
    ];

    return pw.RichText(
      text: pw.TextSpan(
          children: texto,
          style: pw.TextStyle(font: regular, fontSize: 11, lineSpacing: 6)),
      textAlign: pw.TextAlign.justify,
    );
  }

  pw.Widget _buildObservaciones(String obs, pw.Font italic) {
    return pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            color: PdfColors.grey100),
        width: double.infinity,
        child: pw
            .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text("OBSERVACIONES ADICIONALES:",
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text(obs, style: pw.TextStyle(font: italic, fontSize: 10)),
        ]));
  }

  pw.Widget _buildSignatures(
      Map<String, dynamic> map, pw.Font regular, pw.Font bold) {
    final List<pw.Widget> firmas = [];
    final config = map['config'] as ConfigSetting?;

    final jefeServicio = map['jefeServicio'] as Funcionario?;
    final testigo1 = map['testigo1'] as Funcionario?;
    final testigo2 = map['testigo2'] as Funcionario?;

    bool hayTestigo1 = testigo1 != null;
    bool hayTestigo2 = testigo2 != null;

    if (!hayTestigo1 && !hayTestigo2) {
      if (config != null) {
        firmas.add(_signatureLine(
            config.jefeCargo,
            "GP/ ${config.nombreJefe} ${config.apellidoJefe ?? ''}", // Agregado GP/ para mantener la consistencia
            config.rangoJefe,
            "C.I. NO REGISTRADA",
            regular,
            bold));
      }
    } else {
      if (jefeServicio != null) {
        firmas.add(_signatureLine(
            "JEFE DE SERVICIOS",
            "GP/ ${jefeServicio.nombres} ${jefeServicio.apellidos}",
            jefeServicio.rango ?? 'S/R',
            "C.I. ${jefeServicio.cedula}",
            regular,
            bold));
      }

      if (hayTestigo1) {
        firmas.add(_signatureLine(
            "TESTIGO 1",
            "GP/ ${testigo1.nombres} ${testigo1.apellidos}",
            testigo1.rango ?? 'S/R',
            "C.I. ${testigo1.cedula}",
            regular,
            bold));
      }

      if (hayTestigo2) {
        firmas.add(_signatureLine(
            "TESTIGO 2",
            "GP/ ${testigo2.nombres} ${testigo2.apellidos}",
            testigo2.rango ?? 'S/R',
            "C.I. ${testigo2.cedula}",
            regular,
            bold));
      }
    }

    return pw.Wrap(
      spacing: 20,
      runSpacing: 30,
      alignment: pw.WrapAlignment.center,
      children: firmas,
    );
  }

  pw.Widget _signatureLine(String cargo, String nombre, String rango,
      String cedula, pw.Font reg, pw.Font bold) {
    return pw.Container(
      width: 180,
      child: pw.Column(
        children: [
          pw.Container(width: 140, height: 1, color: PdfColors.black),
          pw.SizedBox(height: 5),
          pw.Text(nombre.toUpperCase(),
              style: pw.TextStyle(font: bold, fontSize: 9),
              textAlign: pw.TextAlign.center),
          pw.Text(cedula, style: pw.TextStyle(font: reg, fontSize: 8)),
          pw.Text("$rango - $cargo",
              style: pw.TextStyle(font: reg, fontSize: 8),
              textAlign: pw.TextAlign.center),
          pw.SizedBox(height: 15),
          pw.Container(
              width: 50,
              height: 70,
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300, width: 1)),
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text("HUELLA",
                        style: const pw.TextStyle(
                            fontSize: 5, color: PdfColors.grey600)),
                    pw.SizedBox(height: 2),
                  ])),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Font font) {
    final fechaGen = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Documento generado electrónicamente - Sistema Inparques",
                style: pw.TextStyle(
                    font: font, fontSize: 7, color: PdfColors.grey700)),
            pw.Text(fechaGen,
                style: pw.TextStyle(
                    font: font, fontSize: 7, color: PdfColors.grey700)),
          ],
        )
      ],
    );
  }

  String _nombreMes(int mes) {
    const meses = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre"
    ];
    if (mes < 1 || mes > 12) return "Mes Desconocido";
    return meses[mes - 1];
  }
}
