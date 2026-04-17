import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inparques/src/data/local/app_database.dart';
import 'package:inparques/src/features/calendar/logic/calendar_controller.dart';

class VacationSetupScreen extends StatefulWidget {
  const VacationSetupScreen({super.key});

  @override
  State<VacationSetupScreen> createState() => _VacationSetupScreenState();
}

class _VacationSetupScreenState extends State<VacationSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _motivoController = TextEditingController();
  int? _funcionarioId;
  DateTimeRange? _rangoFechas;
  String _tipoAusencia = 'vacaciones';
  bool _isSaving = false;

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }

  Future<void> _guardarAusencia() async {
    if (_funcionarioId == null || _rangoFechas == null) return;

    setState(() => _isSaving = true);
    final controller = context.read<CalendarController>();

    try {
      await controller.registrarAusencia(
        funcionarioId: _funcionarioId!,
        fechaInicio: _rangoFechas!.start,
        fechaFin: _rangoFechas!.end,
        motivo: _motivoController.text.isEmpty
            ? "Sin descripción"
            : _motivoController.text,
        tipo: _tipoAusencia,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Ausencia registrada con éxito"),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error al registrar: $e"),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Ausencias"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Text("Seleccione al Funcionario",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    FutureBuilder<List<Funcionario>>(
                      future: (db.select(db.funcionarios)
                            ..where((t) => t.estaActivo.equals(true)))
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const LinearProgressIndicator();
                        }

                        return DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person)),
                          initialValue: _funcionarioId,
                          hint: const Text("Seleccionar Funcionario"),
                          items: snapshot.data!
                              .map((f) => DropdownMenuItem(
                                    value: f.id,
                                    child: Text("${f.nombres} ${f.apellidos}"),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() => _funcionarioId = val);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text("Tipo de Ausencia",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                            value: 'vacaciones',
                            label: Text('Vacaciones'),
                            icon: Icon(Icons.beach_access)),
                        ButtonSegment(
                            value: 'reposo',
                            label: Text('Reposo'),
                            icon: Icon(Icons.medical_services)),
                        ButtonSegment(
                            value: 'permiso',
                            label: Text('Permiso'),
                            icon: Icon(Icons.assignment_ind)),
                      ],
                      selected: {_tipoAusencia},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() => _tipoAusencia = newSelection.first);
                      },
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      title: const Text("Periodo de Ausencia"),
                      subtitle: Text(_rangoFechas == null
                          ? "Tocar para seleccionar calendario"
                          : "${_rangoFechas!.start.day}/${_rangoFechas!.start.month} al ${_rangoFechas!.end.day}/${_rangoFechas!.end.month}"),
                      trailing: const Icon(Icons.calendar_month,
                          color: Colors.orange),
                      onTap: () async {
                        final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                            builder: (context, child) {
                              return Theme(
                                  data: ThemeData.light().copyWith(
                                      colorScheme: const ColorScheme.light(
                                          primary: Colors.orange)),
                                  child: child!);
                            });
                        if (picked != null) {
                          setState(() => _rangoFechas = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _motivoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          labelText: "Observaciones / Motivo",
                          border: OutlineInputBorder(),
                          hintText:
                              "Ej: Vacaciones anuales correspondientes al periodo 2024..."),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed:
                            _rangoFechas == null || _funcionarioId == null
                                ? null
                                : _guardarAusencia,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white),
                        icon: const Icon(Icons.save),
                        label: const Text("REGISTRAR AUSENCIA",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
