import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../data/local/app_database.dart';
import '../../logic/personal_controller.dart';

class FuncionarioEditScreen extends StatefulWidget {
  final Map<String, dynamic> dataInicial;

  const FuncionarioEditScreen({super.key, required this.dataInicial});

  @override
  State<FuncionarioEditScreen> createState() => _FuncionarioEditScreenState();
}

class _FuncionarioEditScreenState extends State<FuncionarioEditScreen> {
  late PersonalController _controller;
  final _formKey = GlobalKey<FormState>();

  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _telefonoController = TextEditingController();

  String? _rangoSeleccionado;

  // CAMBIO: Ahora son nulables
  DateTime? _fechaNacimiento;
  DateTime? _fechaIngreso;

  List<Map<String, dynamic>> _estudios = [];
  List<Map<String, dynamic>> _cursos = [];
  List<Map<String, dynamic>> _familiares = [];
  List<Map<String, dynamic>> _hijos = [];

  @override
  void initState() {
    super.initState();
    _controller = context.read<PersonalController>();
    _cargarDatos();
  }

  void _cargarDatos() {
    final f = widget.dataInicial['funcionario'] as Funcionario;
    _nombresController.text = f.nombres;
    _apellidosController.text = f.apellidos;
    _cedulaController.text = f.cedula;
    _telefonoController.text = f.telefono ?? '';

    // Manejo de nulos en la carga
    _rangoSeleccionado = f.rango ?? 'GP/.';
    _fechaNacimiento = f.fechaNacimiento;
    _fechaIngreso = f.fechaIngreso;

    // 1. Estudios
    _estudios = (widget.dataInicial['estudios'] as List<EstudiosAcademico>)
        .map((e) => {
              'grado': e.gradoInstruccion,
              'titulo': e.tituloObtenido,
              'path': e.rutaPdfTitulo
            })
        .toList();

    // 2. Cursos
    _cursos = (widget.dataInicial['cursos'] as List<CursosCertificado>)
        .map((c) =>
            {'nombre': c.nombreCertificado, 'path': c.rutaPdfCertificado})
        .toList();

    // 3. Familiares
    _familiares = (widget.dataInicial['familiares'] as List<Familiare>)
        .map((fam) => {
              'nombres': fam.nombres,
              'apellidos': fam.apellidos,
              'cedula': fam.cedula,
              'edad': fam.edad.toString(),
              'parentesco': fam.parentesco,
              'telefono': fam.telefono
            })
        .toList();

    // 4. Hijos
    _hijos = (widget.dataInicial['hijos'] as List<Hijo>)
        .map((h) => {
              'nombres': h.nombres,
              'apellidos': h.apellidos,
              'edad': h.edad.toString()
            })
        .toList();
  }

  Future<void> _seleccionarArchivo(Map<String, dynamic> item) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        item['path'] = result.files.single.path;
      });
    }
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      try {
        final f = widget.dataInicial['funcionario'] as Funcionario;
        await _controller.actualizarFuncionarioCompleto(
          id: f.id,
          nombres: _nombresController.text,
          apellidos: _apellidosController.text,
          cedula: _cedulaController.text,
          rango: _rangoSeleccionado,
          rangoId: f.rangoId,
          fechaNacimiento: _fechaNacimiento,
          fechaIngreso: _fechaIngreso,
          telefono: _telefonoController.text,
          diasLaboralesSemanales: f.diasLaboralesSemanales,
          diasLibresPreferidos: f.diasLibresPreferidos,
          fotoPath: f.fotoPath,
          estudios: _estudios,
          cursos: _cursos,
          familiares: _familiares,
          hijos: _hijos,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Expediente actualizado exitosamente"),
            backgroundColor: Colors.green));
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error al guardar: $e"),
            backgroundColor: Colors.red));
      }
    }
  }

  // --- WIDGETS DE UI ---

  // Widget para seleccionar fecha que soporta nulos
  Widget _buildDatePicker(
      String label, DateTime? fecha, Function(DateTime) onSelect) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: fecha ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) onSelect(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          fecha != null
              ? DateFormat('dd/MM/yyyy').format(fecha)
              : 'Sin definir',
          style: TextStyle(color: fecha != null ? Colors.black : Colors.grey),
        ),
      ),
    );
  }

  Widget _buildFileStatus(Map<String, dynamic> item) {
    bool hasFile = item['path'] != null;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(hasFile ? Icons.picture_as_pdf : Icons.picture_as_pdf_outlined,
              color: hasFile ? Colors.red : Colors.grey),
          const SizedBox(width: 12),
          Expanded(
              child: Text(hasFile ? "Documento Adjunto" : "Sin Documento",
                  style: const TextStyle(fontSize: 12))),
          if (hasFile)
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.blue),
              onPressed: () => _controller.abrirDocumento(item['path']),
              tooltip: "Ver",
            ),
          TextButton(
            onPressed: () => _seleccionarArchivo(item),
            child: Text(hasFile ? "Cambiar" : "Subir"),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactField(Map<String, dynamic> item, String key, String label,
      {bool isNumber = false}) {
    return TextFormField(
      initialValue: item[key],
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: const OutlineInputBorder(),
      ),
      style: const TextStyle(fontSize: 13),
      onChanged: (v) => item[key] = v,
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
          IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: onAdd),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Expediente"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: _guardarCambios,
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text("GUARDAR", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text("DATOS BÁSICOS",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green)),
            const Divider(),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                        controller: _nombresController,
                        decoration: const InputDecoration(
                            labelText: "Nombres",
                            border: OutlineInputBorder()))),
                const SizedBox(width: 10),
                Expanded(
                    child: TextFormField(
                        controller: _apellidosController,
                        decoration: const InputDecoration(
                            labelText: "Apellidos",
                            border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                        controller: _cedulaController,
                        decoration: const InputDecoration(
                            labelText: "Cédula",
                            border: OutlineInputBorder()))),
                const SizedBox(width: 10),
                Expanded(
                    child: TextFormField(
                        controller: _telefonoController,
                        decoration: const InputDecoration(
                            labelText: "Teléfono",
                            border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 10),

            // CAMBIO: Selectores de fecha ajustados para nulos
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker("Fecha Nacimiento", _fechaNacimiento,
                      (d) => setState(() => _fechaNacimiento = d)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDatePicker("Fecha Ingreso", _fechaIngreso,
                      (d) => setState(() => _fechaIngreso = d)),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // FORMACIÓN
            _buildSectionHeader(
                "ESTUDIOS",
                () => setState(
                    () => _estudios.add({'titulo': '', 'path': null}))),
            ..._estudios.map((item) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: item['titulo'],
                          decoration: const InputDecoration(
                              labelText: "Título Obtenido"),
                          onChanged: (v) => item['titulo'] = v,
                        ),
                        _buildFileStatus(item),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: const Text("Eliminar",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () =>
                                setState(() => _estudios.remove(item)),
                          ),
                        )
                      ],
                    ),
                  ),
                )),

            _buildSectionHeader(
                "CURSOS",
                () =>
                    setState(() => _cursos.add({'nombre': '', 'path': null}))),
            ..._cursos.map((item) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: item['nombre'],
                          decoration: const InputDecoration(
                              labelText: "Nombre del Curso"),
                          onChanged: (v) => item['nombre'] = v,
                        ),
                        _buildFileStatus(item),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: const Text("Eliminar",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () =>
                                setState(() => _cursos.remove(item)),
                          ),
                        )
                      ],
                    ),
                  ),
                )),

            // FAMILIARES
            _buildSectionHeader(
                "CARGA FAMILIAR",
                () => setState(() => _familiares.add({
                      'nombres': '',
                      'apellidos': '',
                      'cedula': '',
                      'edad': '',
                      'parentesco': 'Cónyuge'
                    }))),
            ..._familiares.map((item) => Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(
                              child: _buildCompactField(
                                  item, 'nombres', "Nombres")),
                          const SizedBox(width: 5),
                          Expanded(
                              child: _buildCompactField(
                                  item, 'apellidos', "Apellidos")),
                        ]),
                        const SizedBox(height: 5),
                        Row(children: [
                          Expanded(
                              child:
                                  _buildCompactField(item, 'cedula', "Cédula")),
                          const SizedBox(width: 5),
                          Expanded(
                              child: _buildCompactField(item, 'edad', "Edad",
                                  isNumber: true)),
                        ]),
                        const SizedBox(height: 5),
                        _buildCompactField(
                            item, 'parentesco', "Parentesco (Ej: Esposa)"),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: const Text("Eliminar",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () =>
                                setState(() => _familiares.remove(item)),
                          ),
                        )
                      ],
                    ),
                  ),
                )),

            // HIJOS
            _buildSectionHeader(
                "HIJOS",
                () => setState(() =>
                    _hijos.add({'nombres': '', 'apellidos': '', 'edad': ''}))),
            ..._hijos.map((item) => Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(
                              child: _buildCompactField(
                                  item, 'nombres', "Nombres")),
                          const SizedBox(width: 5),
                          Expanded(
                              child: _buildCompactField(
                                  item, 'apellidos', "Apellidos")),
                        ]),
                        const SizedBox(height: 5),
                        Row(children: [
                          Expanded(
                              child: _buildCompactField(item, 'edad', "Edad",
                                  isNumber: true)),
                          const Spacer(),
                          TextButton(
                            child: const Text("Eliminar",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () =>
                                setState(() => _hijos.remove(item)),
                          ),
                        ]),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
