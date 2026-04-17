import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../data/local/app_database.dart';
import '../../logic/planning_controller.dart';
import '../../../dashboard/logic/dashboard_controller.dart';

class ActividadFormScreen extends StatefulWidget {
  const ActividadFormScreen({super.key});

  @override
  State<ActividadFormScreen> createState() => _ActividadFormScreenState();
}

class _ActividadFormScreenState extends State<ActividadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();

  final List<String> _puestos = [
    'Puesto de Control Loma del Viento',
    'Puesto de Control Estribo de Hierro',
    'Puesto de Control Los Venados',
    'Puesto de Control Galipán',
    'Sede Administrativa',
  ];

  String? _puestoSeleccionado;
  DateTime _fechaInicio = DateTime.now();

  bool _esPernocta = false;
  int _duracionDias = 7;
  int _factorCompensacion = 2;

  List<Map<String, dynamic>> _personalData = [];
  final List<int> _seleccionadosIds = [];
  bool _cargandoPersonal = true;

  @override
  void initState() {
    super.initState();
    _puestoSeleccionado = _puestos.first;
    WidgetsBinding.instance.addPostFrameCallback((_) => _obtenerDisponibles());
  }

  DateTime get _fechaFinGuardia {
    if (!_esPernocta) return _fechaInicio;
    return _fechaInicio.add(Duration(days: _duracionDias - 1));
  }

  DateTime? get _fechaDesbloqueo {
    if (!_esPernocta) return null;
    final diasLibres = _duracionDias * _factorCompensacion;
    return _fechaFinGuardia.add(Duration(days: diasLibres));
  }

  Future<void> _obtenerDisponibles() async {
    setState(() => _cargandoPersonal = true);

    final data = await context
        .read<PlanningController>()
        .obtenerPersonalConMetadata(fecha: _fechaInicio);

    if (mounted) {
      setState(() {
        _personalData = data;
        _cargandoPersonal = false;
        _seleccionadosIds.removeWhere(
          (id) => !data.any((d) => (d['funcionario'] as Funcionario).id == id),
        );
      });
    }
  }

  Future<void> _procesarGuardado() async {
    if (!_formKey.currentState!.validate() || _seleccionadosIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleccione al menos un funcionario")),
      );
      return;
    }

    try {
      final db = context.read<AppDatabase>();
      final planning = context.read<PlanningController>();

      final idActividad = await db.into(db.actividades).insert(
            ActividadesCompanion.insert(
              nombreActividad: _nombreController.text,
              categoria: drift.Value(_esPernocta ? 'Pernocta' : 'Normal'),
              fecha: _fechaInicio,
              fechaFin: drift.Value(_fechaFinGuardia),
              lugar: _puestoSeleccionado ?? 'No especificado',
            ),
          );

      await planning.asignarGuardia(
        actividadId: idActividad,
        funcionariosIds: _seleccionadosIds,
        fechaActividad: _fechaInicio,
        fechaBloqueoHasta: _fechaDesbloqueo,
      );

      if (!mounted) return;
      context.read<DashboardController>().actualizarDashboard();
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text("Programar Actividad")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                  labelText: "Nombre Actividad", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Requerido" : null,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _puestoSeleccionado,
              items: _puestos
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (val) => setState(() => _puestoSeleccionado = val),
              decoration: const InputDecoration(
                  labelText: "Puesto", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text("Fecha de Inicio"),
              subtitle: Text(dateFormat.format(_fechaInicio)),
              trailing: const Icon(Icons.calendar_today),
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onTap: () async {
                final pick = await showDatePicker(
                  context: context,
                  initialDate: _fechaInicio,
                  firstDate: DateTime.now().subtract(const Duration(days: 1)),
                  lastDate: DateTime(2030),
                );
                if (pick != null) {
                  setState(() => _fechaInicio = pick);
                  _obtenerDisponibles();
                }
              },
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              color: _esPernocta ? Colors.green[50] : Colors.grey[50],
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: _esPernocta ? Colors.green : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text("¿Es Guardia de Pernocta?"),
                      value: _esPernocta,
                      activeThumbColor: Colors.green,
                      onChanged: (val) => setState(() => _esPernocta = val),
                    ),
                    if (_esPernocta) ...[
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<int>(
                              value: _duracionDias,
                              isExpanded: true,
                              items: List.generate(30, (i) => i + 1)
                                  .map((d) => DropdownMenuItem(
                                      value: d, child: Text("$d días")))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _duracionDias = v!),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: DropdownButton<int>(
                              value: _factorCompensacion,
                              isExpanded: true,
                              items: [1, 2, 3]
                                  .map((f) => DropdownMenuItem(
                                      value: f, child: Text("x$f Libres")))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _factorCompensacion = v!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text("Personal Disponible:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            if (_cargandoPersonal)
              const Center(child: CircularProgressIndicator())
            else if (_personalData.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Nadie disponible.", textAlign: TextAlign.center))
            else
              // CORRECCIÓN: Eliminadas las llaves {} que creaban un Set
              ..._personalData.map((data) {
                final f = data['funcionario'] as Funcionario;
                final severity = data['severity'] as int;
                final saldo = data['saldo'] as int;
                Color textColor = severity == 2
                    ? Colors.red
                    : (severity == 1 ? Colors.orange : Colors.black);

                return Card(
                  child: CheckboxListTile(
                    title: Text(
                        "${f.nombres} ${f.apellidos} ${saldo > 0 ? '(+$saldo)' : ''}",
                        style: TextStyle(
                            color: textColor, fontWeight: FontWeight.bold)),
                    subtitle:
                        Text("${f.rango} • Carga: ${data['cargaSemanal']}"),
                    value: _seleccionadosIds.contains(f.id),
                    onChanged: (bool? val) {
                      setState(() {
                        if (val == true) {
                          _seleccionadosIds.add(f.id);
                        } else {
                          _seleccionadosIds.remove(f.id);
                        }
                      });
                    },
                  ),
                );
              }),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _procesarGuardado,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green),
              child: const Text("REGISTRAR ACTIVIDAD"),
            ),
          ],
        ),
      ),
    );
  }
}
