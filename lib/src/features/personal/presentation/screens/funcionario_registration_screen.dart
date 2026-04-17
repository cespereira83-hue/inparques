import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/local/app_database.dart';
import '../../logic/personal_controller.dart';

class FuncionarioRegistrationScreen extends StatefulWidget {
  const FuncionarioRegistrationScreen({super.key});

  @override
  State<FuncionarioRegistrationScreen> createState() =>
      _FuncionarioRegistrationScreenState();
}

class _FuncionarioRegistrationScreenState
    extends State<FuncionarioRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _telefonoController = TextEditingController();

  List<Rango> _listaRangosDb = [];
  Rango? _rangoSeleccionadoObj;

  DateTime? _fechaNacimiento;
  DateTime? _fechaIngreso;

  File? _fotoPerfil;
  bool _isSaving = false;
  bool _isLoadingRangos = true;

  final Map<String, bool> _diasPreferencia = {
    'LUN': false,
    'MAR': false,
    'MIER': false,
    'JUE': false,
    'VIE': false,
    'SAB': false,
    'DOM': false,
  };

  final List<Map<String, dynamic>> _estudios = [];
  final List<Map<String, dynamic>> _cursos = [];
  final List<Map<String, dynamic>> _familiares = [];
  final List<Map<String, dynamic>> _hijos = [];

  @override
  void initState() {
    super.initState();
    _cargarRangosDesdeDb();
  }

  Future<void> _cargarRangosDesdeDb() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final List<Rango> rangos = await db.select(db.rangos).get();

    if (mounted) {
      setState(() {
        _listaRangosDb = rangos;
        _isLoadingRangos = false;
      });
    }
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _cedulaController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFoto() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar Foto'),
              onTap: () async {
                Navigator.pop(ctx);
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null && mounted) {
                  setState(() => _fotoPerfil = File(pickedFile.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () async {
                Navigator.pop(ctx);
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null && mounted) {
                  setState(() => _fotoPerfil = File(pickedFile.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _adjuntarArchivo(Map<String, dynamic> item) async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null && mounted) {
      setState(() => item['path'] = result.files.single.path);
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final controller = context.read<PersonalController>();

    final diasLibresString = _diasPreferencia.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .join(',');

    try {
      await controller.registrarFuncionarioCompleto(
        nombres: _nombresController.text.trim(),
        apellidos: _apellidosController.text.trim(),
        cedula: _cedulaController.text.trim(),
        rango: _rangoSeleccionadoObj?.nombre,
        rangoId: _rangoSeleccionadoObj?.id,
        fechaNacimiento: _fechaNacimiento,
        fechaIngreso: _fechaIngreso,
        telefono: _telefonoController.text.trim(),
        diasLibresPreferidos: diasLibresString,
        fotoPath: _fotoPerfil?.path,
        estudios: _estudios,
        cursos: _cursos,
        familiares: _familiares,
        hijos: _hijos,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Registrado correctamente"),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Funcionario")),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _seleccionarFoto,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _fotoPerfil != null
                            ? FileImage(_fotoPerfil!)
                            : null,
                        child: _fotoPerfil == null
                            ? const Icon(Icons.add_a_photo,
                                size: 40, color: Colors.grey)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSection("Datos Personales"),
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                              controller: _nombresController,
                              decoration: const InputDecoration(
                                  labelText: "Nombres *",
                                  border: OutlineInputBorder()),
                              validator: (v) =>
                                  v!.isEmpty ? "Requerido" : null)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: TextFormField(
                              controller: _apellidosController,
                              decoration: const InputDecoration(
                                  labelText: "Apellidos *",
                                  border: OutlineInputBorder()),
                              validator: (v) =>
                                  v!.isEmpty ? "Requerido" : null)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                      controller: _cedulaController,
                      decoration: const InputDecoration(
                          labelText: "Cédula *",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge)),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? "Requerido" : null),
                  const SizedBox(height: 10),
                  TextFormField(
                      controller: _telefonoController,
                      decoration: const InputDecoration(
                          labelText: "Teléfono (Opcional)",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone)),
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 20),
                  _buildSection("Información Laboral (Opcional)"),
                  if (_isLoadingRangos)
                    const LinearProgressIndicator()
                  else
                    DropdownButtonFormField<Rango>(
                      initialValue: _rangoSeleccionadoObj,
                      decoration: const InputDecoration(
                          labelText: "Rango / Jerarquía",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.security)),
                      items: _listaRangosDb
                          .map((r) => DropdownMenuItem(
                              value: r,
                              child: Text(r.nombre,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _rangoSeleccionadoObj = val),
                    ),
                  const SizedBox(height: 15),
                  const Text("Días solicitados libres/estudios:",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Wrap(
                    spacing: 5,
                    children: _diasPreferencia.keys
                        .map((dia) => ChoiceChip(
                              label: Text(dia),
                              selected: _diasPreferencia[dia]!,
                              onSelected: (val) =>
                                  setState(() => _diasPreferencia[dia] = val),
                              selectedColor: Colors.green[200],
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader(
                      "Títulos Académicos",
                      () => setState(
                          () => _estudios.add({'titulo': '', 'path': null}))),
                  ..._estudios.map((item) => _buildSimpleItemCard(
                      item, "Título Obtenido", Icons.school)),
                  const SizedBox(height: 10),
                  _buildSectionHeader(
                      "Cursos y Certificados",
                      () => setState(
                          () => _cursos.add({'nombre': '', 'path': null}))),
                  ..._cursos.map((item) => _buildSimpleItemCard(
                      item, "Nombre del Curso", Icons.workspace_premium)),
                  const SizedBox(height: 20),
                  _buildSectionHeader(
                      "Carga Familiar (Esposa/Padres)",
                      () => setState(() => _familiares.add({
                            'nombres': '',
                            'apellidos': '',
                            'cedula': '',
                            'edad': '',
                            'parentesco': 'Cónyuge',
                            'telefono': ''
                          }))),
                  ..._familiares.map(
                    (item) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: Colors.blue[50],
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Row(children: [
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'nombres', "Nombres")),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'apellidos', "Apellidos"))
                              ]),
                              const SizedBox(height: 5),
                              Row(children: [
                                Expanded(
                                    flex: 2,
                                    child: _buildCompactField(
                                        item, 'cedula', "Cédula")),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'edad', "Edad",
                                        isNumber: true))
                              ]),
                              const SizedBox(height: 5),
                              Row(children: [
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'parentesco', "Parentesco")),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'telefono', "Teléfono",
                                        isNumber: true))
                              ]),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red, size: 16),
                                      label: const Text("Eliminar",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 12)),
                                      onPressed: () => setState(
                                          () => _familiares.remove(item)))),
                            ]))),
                  ),
                  const SizedBox(height: 10),
                  _buildSectionHeader(
                      "Hijos",
                      () => setState(() => _hijos
                          .add({'nombres': '', 'apellidos': '', 'edad': ''}))),
                  ..._hijos.map(
                    (item) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: Colors.orange[50],
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Row(children: [
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'nombres', "Nombres")),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'apellidos', "Apellidos"))
                              ]),
                              const SizedBox(height: 5),
                              Row(children: [
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'edad', "Edad",
                                        isNumber: true)),
                                const Spacer(),
                                IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red, size: 20),
                                    onPressed: () =>
                                        setState(() => _hijos.remove(item)))
                              ])
                            ]))),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                      height: 50,
                      child: FilledButton.icon(
                          onPressed: _guardar,
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.green),
                          icon: const Icon(Icons.save),
                          label: const Text("GUARDAR REGISTRO"))),
                ],
              ),
            ),
    );
  }

  Widget _buildSection(String title) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)));

  Widget _buildSectionHeader(String title, VoidCallback onAdd) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green)),
        IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.green),
            onPressed: onAdd,
            tooltip: "Agregar")
      ]);

  Widget _buildSimpleItemCard(
      Map<String, dynamic> item, String hint, IconData icon) {
    final keyName = item.containsKey('titulo') ? 'titulo' : 'nombre';
    return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
            leading: Icon(icon, color: Colors.grey),
            title: TextFormField(
                initialValue: item[keyName],
                decoration:
                    InputDecoration(hintText: hint, border: InputBorder.none),
                onChanged: (v) => item[keyName] = v),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                  icon: Icon(Icons.upload_file,
                      color: item['path'] != null ? Colors.red : Colors.grey),
                  onPressed: () => _adjuntarArchivo(item),
                  tooltip: "Adjuntar PDF"),
              IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () => setState(() => keyName == 'titulo'
                      ? _estudios.remove(item)
                      : _cursos.remove(item)))
            ])));
  }

  Widget _buildCompactField(Map<String, dynamic> item, String key, String label,
          {bool isNumber = false}) =>
      TextFormField(
          initialValue: item[key],
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
              labelText: label,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: const OutlineInputBorder()),
          style: const TextStyle(fontSize: 13),
          onChanged: (v) => item[key] = v);
}
