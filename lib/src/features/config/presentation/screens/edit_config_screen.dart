import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../data/local/app_database.dart';
import '../../../auth/logic/auth_controller.dart'; // Importar AuthController

class EditConfigScreen extends StatefulWidget {
  const EditConfigScreen({super.key});

  @override
  State<EditConfigScreen> createState() => _EditConfigScreenState();
}

class _EditConfigScreenState extends State<EditConfigScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _sectorController = TextEditingController();
  final _municipioController = TextEditingController();
  final _jefeNombreController = TextEditingController();
  final _jefeApellidoController = TextEditingController();
  final _jefeRangoController = TextEditingController();
  final _jefeCargoController = TextEditingController();

  bool _isLoading = true;
  int? _configId;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  @override
  void dispose() {
    _sectorController.dispose();
    _municipioController.dispose();
    _jefeNombreController.dispose();
    _jefeApellidoController.dispose();
    _jefeRangoController.dispose();
    _jefeCargoController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentData() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final config =
        await (db.select(db.configSettings)..limit(1)).getSingleOrNull();

    if (config != null) {
      setState(() {
        _configId = config.id;
        _sectorController.text = config.sectorNombre ?? '';
        _municipioController.text = config.municipio ?? '';
        _jefeNombreController.text = config.nombreJefe;
        _jefeApellidoController.text = config.apellidoJefe ?? '';
        _jefeRangoController.text = config.rangoJefe;
        _jefeCargoController.text = config.jefeCargo;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    if (_configId == null) return;

    setState(() => _isLoading = true);
    final db = Provider.of<AppDatabase>(context, listen: false);

    final updatedConfig = ConfigSettingsCompanion(
      sectorNombre: drift.Value(_sectorController.text),
      municipio: drift.Value(_municipioController.text),
      nombreJefe: drift.Value(_jefeNombreController.text),
      apellidoJefe: drift.Value(_jefeApellidoController.text),
      rangoJefe: drift.Value(_jefeRangoController.text),
      jefeCargo: drift.Value(_jefeCargoController.text),
    );

    try {
      await (db.update(db.configSettings)
            ..where((t) => t.id.equals(_configId!)))
          .write(updatedConfig);

      // FIX DASHBOARD: Recargar configuración en memoria
      if (mounted) {
        await context
            .read<AuthController>()
            .checkInitialSetup(); // Forzar recarga

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Datos actualizados correctamente'),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos del Sector'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Información del Lugar',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    const Divider(),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _sectorController,
                      decoration: const InputDecoration(
                          labelText: 'Nombre del Sector / Parque',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.park, color: Colors.green)),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _municipioController,
                      decoration: const InputDecoration(
                          labelText: 'Municipio / Estado',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.map, color: Colors.green)),
                    ),
                    const SizedBox(height: 30),
                    const Text('Información del Jefe de Sector',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _jefeNombreController,
                            decoration: const InputDecoration(
                                labelText: 'Nombres',
                                border: OutlineInputBorder()),
                            validator: (v) => v!.isEmpty ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _jefeApellidoController,
                            decoration: const InputDecoration(
                                labelText: 'Apellidos',
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _jefeRangoController,
                            decoration: const InputDecoration(
                              labelText: 'Rango',
                              hintText: 'Ej: S/M',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.star, color: Colors.green),
                            ),
                            validator: (v) => v!.isEmpty ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _jefeCargoController,
                            decoration: const InputDecoration(
                              labelText: 'Cargo',
                              hintText: 'Ej: Jefe de Sector',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.work, color: Colors.green),
                            ),
                            validator: (v) => v!.isEmpty ? 'Requerido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: _saveData,
                        icon: const Icon(Icons.save),
                        label: const Text('GUARDAR CAMBIOS',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
