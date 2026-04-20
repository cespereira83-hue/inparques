import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../data/local/app_database.dart';
import '../../logic/planning_controller.dart';
import '../../../dashboard/logic/dashboard_controller.dart';
import '../../../config/presentation/screens/ubicaciones_screen.dart';

class CreateActivityScreen extends StatefulWidget {
  final int? actividadId;

  const CreateActivityScreen({super.key, this.actividadId});

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreActividadController = TextEditingController();
  final _lugarTextoController = TextEditingController();

  final _diasLaborarController = TextEditingController(text: "4");
  final _factorDescansoController = TextEditingController(text: "2");

  bool _esPernocta = false;
  bool _isLoading = true;
  bool _isEditing = false;

  // Fechas (Ordinaria)
  late DateTime _fechaActual;
  late DateTime _inicioSemana;
  Set<DateTime> _diasConGuardia = {};

  // Fechas (Pernocta)
  late DateTime _fechaInicio;
  late DateTime _fechaFin;

  int? _selectedUbicacionId;

  List<TiposGuardiaData> _tiposGuardia = [];
  List<Ubicacione> _ubicaciones = [];
  int? _selectedTipoGuardiaId;

  List<Map<String, dynamic>> _personalConMetadata = [];
  final Set<int> _seleccionadosIds = {};
  int? _jefeServicioId;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.actividadId != null;

    final controller = context.read<PlanningController>();
    final targetDate = controller.focusedDay;

    _inicioSemana = DateTime(targetDate.year, targetDate.month, targetDate.day)
        .subtract(Duration(days: targetDate.weekday - 1));
    _fechaActual = targetDate;

    _fechaInicio = targetDate;
    _fechaFin = targetDate.add(const Duration(days: 3));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatosIniciales();
    });
  }

  @override
  void dispose() {
    _nombreActividadController.dispose();
    _lugarTextoController.dispose();
    _diasLaborarController.dispose();
    _factorDescansoController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatosIniciales() async {
    setState(() => _isLoading = true);
    try {
      final controller = context.read<PlanningController>();

      _tiposGuardia = await controller.obtenerTiposGuardia();
      await _recargarUbicaciones();
      if (_tiposGuardia.isNotEmpty) {
        _selectedTipoGuardiaId = _tiposGuardia.first.id;
      }

      if (_isEditing) {
        await _cargarDatosEdicion(widget.actividadId!);
      }

      if (!_esPernocta) {
        _inicioSemana =
            _fechaActual.subtract(Duration(days: _fechaActual.weekday - 1));
        await _actualizarEstadoSemanal();
      }

      await _refrescarPersonal();
    } catch (e) {
      debugPrint("Error cargando datos: $e");
      if (mounted) _showError("Error al cargar datos: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _cargarDatosEdicion(int id) async {
    final controller = context.read<PlanningController>();
    final detalle = await controller.obtenerActividadPorId(id);

    if (detalle != null) {
      final act = detalle.actividad;

      _nombreActividadController.text = act.nombreActividad;
      _lugarTextoController.text = act.lugar;
      _esPernocta = act.esPernocta;

      if (_tiposGuardia.any((t) => t.id == act.tipoGuardiaId)) {
        _selectedTipoGuardiaId = act.tipoGuardiaId;
      }

      if (_esPernocta) {
        try {
          final ubi = _ubicaciones.firstWhere((u) => u.nombre == act.lugar);
          _selectedUbicacionId = ubi.id;
        } catch (_) {}
        _fechaInicio = act.fecha;
        _fechaFin = act.fechaFin ?? act.fecha;

        if (act.diasDescansoGenerados > 0) {
          final diasGuardia = _fechaFin.difference(_fechaInicio).inDays;
          if (diasGuardia > 0) {
            final factor = (act.diasDescansoGenerados / diasGuardia).round();
            _factorDescansoController.text = factor.toString();
          }
        }
      } else {
        _fechaActual = act.fecha;
      }

      _seleccionadosIds.clear();
      for (var f in detalle.funcionarios) {
        _seleccionadosIds.add(f.id);
      }
      if (detalle.jefeServicio != null) {
        _jefeServicioId = detalle.jefeServicio!.id;
      } else if (act.jefeServicioId != null) {
        _jefeServicioId = act.jefeServicioId;
        _seleccionadosIds.add(act.jefeServicioId!);
      }
    }
  }

  Future<void> _recargarUbicaciones() async {
    final controller = context.read<PlanningController>();
    final ubi = await controller.obtenerUbicaciones();
    setState(() => _ubicaciones = ubi);
  }

  Future<void> _actualizarEstadoSemanal() async {
    final controller = context.read<PlanningController>();
    final dias = await controller.obtenerDiasConGuardiaEnSemana(_inicioSemana);
    setState(() {
      _diasConGuardia = dias;
    });
  }

  Future<void> _refrescarPersonal() async {
    final controller = context.read<PlanningController>();
    int? cupoOverride = int.tryParse(_diasLaborarController.text);
    final fechaConsulta = _esPernocta ? _fechaInicio : _fechaActual;

    final lista = await controller.obtenerPersonalConMetadata(
      fecha: fechaConsulta,
      esPernocta: _esPernocta,
      cupoOverride: cupoOverride,
      actividadEditandoId: widget.actividadId,
    );

    if (mounted) {
      setState(() {
        _personalConMetadata = lista;
      });
    }
  }

  void _cambiarSemanaBase() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => const _TacticalCalendarDialog(),
    );

    if (picked != null) {
      setState(() {
        _inicioSemana = picked.subtract(Duration(days: picked.weekday - 1));
        _fechaActual = picked;
        context.read<PlanningController>().setFocusedDay(_fechaActual);
      });
      await _actualizarEstadoSemanal();
      await _refrescarPersonal();
    }
  }

  void _seleccionarRangoPernocta() async {
    final DateTimeRange? picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) => _TacticalRangeCalendarDialog(
        initialDate: _fechaInicio,
      ),
    );

    if (picked != null) {
      setState(() {
        _fechaInicio = picked.start;
        _fechaFin = picked.end;
      });
      _refrescarPersonal();
    }
  }

  void _seleccionarDiaSemana(int diaIndex) async {
    final nuevaFecha = _inicioSemana.add(Duration(days: diaIndex));
    setState(() {
      _fechaActual = nuevaFecha;
      context.read<PlanningController>().setFocusedDay(_fechaActual);
    });
    await _refrescarPersonal();
  }

  void _toggleMode(bool isOvernight) {
    if (_isEditing) {
      _showError("No se puede cambiar el tipo de guardia al editar.");
      return;
    }
    setState(() {
      _esPernocta = isOvernight;
      if (isOvernight) {
        _fechaInicio = _fechaActual;
        _fechaFin = _fechaActual.add(const Duration(days: 3));
      } else {
        _fechaActual = _inicioSemana;
      }
    });
    _refrescarPersonal();
  }

  void _toggleSeleccion(int id) {
    setState(() {
      if (_seleccionadosIds.contains(id)) {
        _seleccionadosIds.remove(id);
        if (_jefeServicioId == id) {
          _jefeServicioId = null;
        }
      } else {
        _seleccionadosIds.add(id);
        if (_seleccionadosIds.length == 1) {
          _jefeServicioId = id;
        }
      }
    });
  }

  void _setJefe(int id) {
    if (!_seleccionadosIds.contains(id)) return;
    setState(() {
      _jefeServicioId = id;
    });
  }

  String get _textoCalculoBloqueo {
    if (!_esPernocta) return "Sin bloqueo obligatorio.";

    final noches = _fechaFin.difference(_fechaInicio).inDays;
    final factor = int.tryParse(_factorDescansoController.text) ?? 2;
    final diasDescanso = noches * factor;
    final fechaDesbloqueo = _fechaFin.add(Duration(days: diasDescanso));

    return "Duración: $noches Noches.\nGenera $diasDescanso días libres.\nDesbloqueo: ${DateFormat('dd/MM').format(fechaDesbloqueo)}";
  }

  Future<void> _guardar({bool avanzarDia = false}) async {
    if (!_formKey.currentState!.validate()) return;
    if (_seleccionadosIds.isEmpty) {
      _showError("Seleccione personal.");
      return;
    }
    if (_jefeServicioId == null) {
      _showError("Designe un Jefe.");
      return;
    }
    if (_esPernocta && _selectedUbicacionId == null) {
      _showError("Seleccione un Puesto/Ubicación.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final planning = context.read<PlanningController>();
      final dash = context.read<DashboardController>();

      String lugarFinal = _lugarTextoController.text;
      if (_esPernocta && _selectedUbicacionId != null) {
        final ubi =
            _ubicaciones.firstWhere((u) => u.id == _selectedUbicacionId);
        lugarFinal = ubi.nombre;
      }

      DateTime fInicio;
      DateTime fFin;
      int diasGen = 0;

      if (_esPernocta) {
        fInicio = _fechaInicio;
        fFin = _fechaFin;
        final noches = fFin.difference(fInicio).inDays;
        final factor = int.tryParse(_factorDescansoController.text) ?? 2;
        diasGen = noches * factor;
      } else {
        fInicio = _fechaActual;
        fFin = _fechaActual;
      }

      if (_isEditing) {
        await planning.editarActividad(
          actividadIdOriginal: widget.actividadId!,
          nombre: _nombreActividadController.text,
          tipoGuardiaId: _selectedTipoGuardiaId ?? 1,
          fechaInicio: fInicio,
          fechaFin: fFin,
          lugar: lugarFinal,
          funcionariosIds: _seleccionadosIds.toList(),
          jefeServicioId: _jefeServicioId!,
          esPernocta: _esPernocta,
          diasDescansoGenerados: diasGen,
        );
      } else {
        await planning.guardarActividadCompleta(
          nombre: _nombreActividadController.text,
          tipoGuardiaId: _selectedTipoGuardiaId ?? 1,
          fechaInicio: fInicio,
          fechaFin: fFin,
          lugar: lugarFinal,
          funcionariosIds: _seleccionadosIds.toList(),
          jefeServicioId: _jefeServicioId!,
          esPernocta: _esPernocta,
          diasDescansoGenerados: diasGen,
        );
      }

      dash.actualizarDashboard();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing
                ? "✅ Actividad Actualizada"
                : "✅ Turno Guardado Exitosamente"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        if (_isEditing || _esPernocta) {
          setState(() => _isLoading = false);
          Navigator.pop(context);
        } else {
          setState(() {
            _seleccionadosIds.clear();
            _jefeServicioId = null;
            _nombreActividadController.clear();
            _lugarTextoController.clear();

            if (avanzarDia) {
              _fechaActual = _fechaActual.add(const Duration(days: 1));
              planning.setFocusedDay(_fechaActual);

              if (_fechaActual.weekday == DateTime.monday) {
                _inicioSemana = _fechaActual;
              }
            }
          });

          await _actualizarEstadoSemanal();
          await _refrescarPersonal();
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError("Error: $e");
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  String _getDayLabel(int weekday) {
    const d = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];
    return d[weekday - 1];
  }

  String _getShortDayLabel(int weekday) {
    const d = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    return d[weekday - 1];
  }

  Widget _buildWeekNavigator() {
    final DateFormat formatter = DateFormat('dd MMM');
    final String labelSemana = "Semana del ${formatter.format(_inicioSemana)}";

    return Column(
      children: [
        InkWell(
          onTap: _cambiarSemanaBase,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_month, color: Colors.indigo),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    labelSemana,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final diaFecha = _inicioSemana.add(Duration(days: index));
              final diaFechaNorm =
                  DateTime(diaFecha.year, diaFecha.month, diaFecha.day);

              final bool isSelected = _fechaActual.day == diaFecha.day &&
                  _fechaActual.month == diaFecha.month;
              final bool isPlanned =
                  _diasConGuardia.any((d) => d.isAtSameMomentAs(diaFechaNorm));

              return GestureDetector(
                onTap: () => _seleccionarDiaSemana(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.indigo
                            : (isPlanned
                                ? Colors.green.shade100
                                : Colors.grey.shade200),
                        shape: BoxShape.circle,
                        border: isPlanned
                            ? Border.all(color: Colors.green, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: isPlanned && !isSelected
                            ? const Icon(Icons.check,
                                size: 20, color: Colors.green)
                            : Text(
                                _getShortDayLabel(index + 1),
                                style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${diaFecha.day}",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildBottomActionButtons() {
    if (_isEditing) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade700,
          foregroundColor: Colors.white,
        ),
        onPressed: () => _guardar(),
        child: const Text("ACTUALIZAR ACTIVIDAD"),
      );
    }

    if (_esPernocta) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        onPressed: () => _guardar(),
        child: const Text("CONFIRMAR PERNOCTA"),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Tooltip(
            message: "Guardar este turno y añadir otro en este mismo día",
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.indigo,
                  side: const BorderSide(color: Colors.indigo),
                  padding: const EdgeInsets.symmetric(vertical: 12)),
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text("Mismo\nDía",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
              onPressed: () => _guardar(avanzarDia: false),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12)),
            icon: const Icon(Icons.arrow_forward),
            label: const Text("Siguiente Día"),
            onPressed: () => _guardar(avanzarDia: true),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Variable global de la vista para leer el límite de cupo actual ingresado
    final int limiteCupo = int.tryParse(_diasLaborarController.text) ?? 4;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing
            ? "Editar Actividad"
            : (_esPernocta
                ? "Planificar Pernocta"
                : "Planificando ${_getDayLabel(_fechaActual.weekday)} ${_fechaActual.day}")),
        actions: [
          if (_esPernocta)
            IconButton(
              icon: const Icon(Icons.settings_input_component),
              tooltip: "Gestionar Puestos",
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const UbicacionesScreen()));
                _recargarUbicaciones();
              },
            )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        IgnorePointer(
                          ignoring: _isEditing,
                          child: Opacity(
                            opacity: _isEditing ? 0.6 : 1.0,
                            child: SegmentedButton<bool>(
                              segments: const [
                                ButtonSegment(
                                  value: false,
                                  label: Text("Ordinaria"),
                                  icon: Icon(Icons.shield_outlined),
                                ),
                                ButtonSegment(
                                  value: true,
                                  label: Text("Pernocta"),
                                  icon: Icon(Icons.night_shelter_outlined),
                                ),
                              ],
                              selected: {_esPernocta},
                              onSelectionChanged: (Set<bool> newSelection) {
                                _toggleMode(newSelection.first);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (_esPernocta) ...[
                          InkWell(
                            onTap: _seleccionarRangoPernocta,
                            child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: "Periodo de Pernocta",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.date_range,
                                      color: Colors.indigo),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${DateFormat('dd/MM').format(_fechaInicio)} al ${DateFormat('dd/MM').format(_fechaFin)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(Icons.edit,
                                        size: 16, color: Colors.grey)
                                  ],
                                )),
                          ),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                              flex: 3,
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                initialValue: _selectedUbicacionId,
                                decoration: const InputDecoration(
                                  labelText: "Puesto / Ubicación",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.map),
                                ),
                                items: _ubicaciones.map((u) {
                                  return DropdownMenuItem(
                                      value: u.id,
                                      child: Text(
                                        u.nombre,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ));
                                }).toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedUbicacionId = val),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: _factorDescansoController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    labelText: "Factor",
                                    border: OutlineInputBorder(),
                                    hintText: "x2",
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ))
                          ]),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.indigo.shade100)),
                            child: Row(
                              children: [
                                const Icon(Icons.info, color: Colors.indigo),
                                const SizedBox(width: 10),
                                Expanded(child: Text(_textoCalculoBloqueo)),
                              ],
                            ),
                          ),
                        ] else ...[
                          _buildWeekNavigator(),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _diasLaborarController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: "Días a laborar",
                                      border: OutlineInputBorder()),
                                  onChanged: (_) => _refrescarPersonal(),
                                )),
                            const SizedBox(width: 10),
                            Expanded(
                                flex: 3,
                                child: DropdownButtonFormField<int>(
                                  isExpanded: true,
                                  initialValue: _selectedTipoGuardiaId,
                                  items: _tiposGuardia
                                      .map((t) => DropdownMenuItem(
                                          value: t.id,
                                          child: Text(
                                            t.nombre,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )))
                                      .toList(),
                                  onChanged: (v) => setState(
                                      () => _selectedTipoGuardiaId = v),
                                  decoration: const InputDecoration(
                                      labelText: "Actividad",
                                      border: OutlineInputBorder()),
                                ))
                          ]),
                          const SizedBox(height: 10),
                          TextFormField(
                              controller: _nombreActividadController,
                              decoration: const InputDecoration(
                                  labelText: "Detalle",
                                  border: OutlineInputBorder())),
                          const SizedBox(height: 10),
                          TextFormField(
                              controller: _lugarTextoController,
                              decoration: const InputDecoration(
                                  labelText: "Lugar",
                                  border: OutlineInputBorder())),
                        ],
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Equipo (${_seleccionadosIds.length})",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            if (_jefeServicioId == null &&
                                _seleccionadosIds.isNotEmpty)
                              const Flexible(
                                child: Text(
                                  "¡Designe un Líder! ★",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                        const Divider(),
                        if (_personalConMetadata.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(
                                child: Text(
                                    "No hay personal disponible en este rango")),
                          ),
                        ..._personalConMetadata.map((meta) {
                          final f = meta['funcionario'] as Funcionario;
                          final severity = meta['severity'] as int;
                          final statusText = meta['statusText'] as String;
                          final ultimaPernocta =
                              meta['ultimaPernocta'] as DateTime?;
                          final cargaSemanal = meta['cargaSemanal'] as int;

                          final isSelected = _seleccionadosIds.contains(f.id);
                          final isLeader = _jefeServicioId == f.id;

                          Color cardColor = Colors.white;
                          if (severity == 2) cardColor = Colors.red.shade50;
                          if (severity == 1) cardColor = Colors.amber.shade50;
                          if (isSelected) cardColor = Colors.green.shade50;

                          String subtitulo = f.rango ?? 'S/R';
                          if (_esPernocta) {
                            if (ultimaPernocta == null) {
                              subtitulo += " • Nunca (PRIORIDAD)";
                            } else {
                              final dias = DateTime.now()
                                  .difference(ultimaPernocta)
                                  .inDays;
                              if (dias < 30) {
                                subtitulo += " • Hace $dias días";
                              } else {
                                final meses = (dias / 30).floor();
                                subtitulo += " • Hace $meses meses";
                              }
                            }
                          } else {
                            subtitulo += " • $statusText";
                          }

                          // CÁLCULOS DEL BADGE UX D1
                          final int restantes = limiteCupo - cargaSemanal > 0
                              ? limiteCupo - cargaSemanal
                              : 0;
                          final bool cupoLleno = cargaSemanal >= limiteCupo;

                          return Card(
                            color: cardColor,
                            elevation: isSelected ? 2 : 0,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                  color: isSelected
                                      ? Colors.green
                                      : Colors.transparent,
                                  width: 1.5),
                            ),
                            child: InkWell(
                              onTap: severity == 2
                                  ? null
                                  : () => _toggleSeleccion(f.id),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: isSelected
                                          ? Colors.green
                                          : Colors.grey.shade300,
                                      foregroundColor: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      child: Text(f.nombres.isNotEmpty
                                          ? f.nombres[0]
                                          : "?"),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${f.nombres} ${f.apellidos}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: severity == 2
                                                  ? Colors.grey
                                                  : Colors.black,
                                              decoration: severity == 2
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            subtitulo,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: severity == 2
                                                  ? Colors.red
                                                  : Colors.grey.shade700,
                                              fontWeight: severity == 2
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),

                                          // --- BADGE VISUAL DE CARGA DE TRABAJO (SOLO PARA D1) ---
                                          if (!_esPernocta &&
                                              severity != 2) ...[
                                            const SizedBox(height: 4),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                  color: cupoLleno
                                                      ? Colors.red.shade100
                                                      : Colors.blue.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                      color: cupoLleno
                                                          ? Colors.red.shade300
                                                          : Colors
                                                              .blue.shade200)),
                                              child: Text(
                                                cupoLleno
                                                    ? "[$cargaSemanal/$limiteCupo] Cupo Lleno"
                                                    : "[$cargaSemanal/$limiteCupo] Faltan: $restantes",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: cupoLleno
                                                        ? Colors.red.shade800
                                                        : Colors.blue.shade800),
                                              ),
                                            ),
                                          ],
                                          // -------------------------------------------------------
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      IconButton(
                                        icon: Icon(
                                          isLeader
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: isLeader
                                              ? Colors.orange
                                              : Colors.grey,
                                          size: 28,
                                        ),
                                        onPressed: () => _setJefe(f.id),
                                        tooltip: "Líder",
                                      ),
                                    if (severity == 2)
                                      const Icon(Icons.lock,
                                          color: Colors.red, size: 20)
                                    else
                                      Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: isSelected
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        )
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: _buildBottomActionButtons(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _TacticalCalendarDialog extends StatefulWidget {
  const _TacticalCalendarDialog();

  @override
  State<_TacticalCalendarDialog> createState() =>
      _TacticalCalendarDialogState();
}

class _TacticalCalendarDialogState extends State<_TacticalCalendarDialog> {
  DateTime _currentMonth = DateTime.now();
  Set<int> _occupiedDays = {};

  @override
  void initState() {
    super.initState();
    _loadOccupation();
  }

  void _loadOccupation() async {
    final controller = context.read<PlanningController>();
    final days = await controller.obtenerDiasOcupadosEnMes(
        _currentMonth.year, _currentMonth.month);
    if (mounted) {
      setState(() => _occupiedDays = days);
    }
  }

  void _changeMonth(int increment) {
    setState(() {
      _currentMonth =
          DateTime(_currentMonth.year, _currentMonth.month + increment);
    });
    _loadOccupation();
  }

  @override
  Widget build(BuildContext context) {
    final title = DateFormat('MMMM yyyy').format(_currentMonth).toUpperCase();
    final daysInMonth =
        DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstDayOffset =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday - 1;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _changeMonth(-1)),
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _changeMonth(1)),
        ],
      ),
      content: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['L', 'M', 'M', 'J', 'V', 'S', 'D']
                  .map((d) => Text(d,
                      style: const TextStyle(fontWeight: FontWeight.bold)))
                  .toList(),
            ),
            const Divider(),
            Expanded(
              child: GridView.builder(
                itemCount: daysInMonth + firstDayOffset,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7),
                itemBuilder: (ctx, index) {
                  if (index < firstDayOffset) return const SizedBox();
                  final day = index - firstDayOffset + 1;
                  final hasGuard = _occupiedDays.contains(day);

                  return InkWell(
                    onTap: () {
                      final selectedDate = DateTime(
                          _currentMonth.year, _currentMonth.month, day);
                      Navigator.pop(context, selectedDate);
                    },
                    child: Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: hasGuard
                              ? Colors.green.shade100
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border:
                              hasGuard ? Border.all(color: Colors.green) : null,
                        ),
                        child: Center(
                          child: Text(
                            "$day",
                            style: TextStyle(
                                color:
                                    hasGuard ? Colors.green[800] : Colors.black,
                                fontWeight: hasGuard
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green))),
                const SizedBox(width: 5),
                const Text("Con Guardia", style: TextStyle(fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _TacticalRangeCalendarDialog extends StatefulWidget {
  final DateTime initialDate;
  const _TacticalRangeCalendarDialog({required this.initialDate});

  @override
  State<_TacticalRangeCalendarDialog> createState() =>
      _TacticalRangeCalendarDialogState();
}

class _TacticalRangeCalendarDialogState
    extends State<_TacticalRangeCalendarDialog> {
  late DateTime _currentMonth;
  List<DateTimeRange> _occupiedRanges = [];

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialDate;
    _loadOccupation();
  }

  void _loadOccupation() async {
    final controller = context.read<PlanningController>();
    final ranges = await controller.obtenerPernoctasDelMes(
        _currentMonth.year, _currentMonth.month);
    if (mounted) {
      setState(() => _occupiedRanges = ranges);
    }
  }

  void _changeMonth(int increment) {
    setState(() {
      _currentMonth =
          DateTime(_currentMonth.year, _currentMonth.month + increment);
    });
    _loadOccupation();
  }

  void _onDayTap(DateTime date) {
    if (_startDate == null || (_startDate != null && _endDate != null)) {
      setState(() {
        _startDate = date;
        _endDate = null;
      });
    } else {
      if (date.isBefore(_startDate!)) {
        setState(() => _startDate = date);
      } else {
        setState(() => _endDate = date);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = DateFormat('MMMM yyyy').format(_currentMonth).toUpperCase();
    final daysInMonth =
        DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstDayOffset =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday - 1;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _changeMonth(-1)),
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _changeMonth(1)),
        ],
      ),
      content: SizedBox(
        width: 300,
        height: 350,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['L', 'M', 'M', 'J', 'V', 'S', 'D']
                  .map((d) => Text(d,
                      style: const TextStyle(fontWeight: FontWeight.bold)))
                  .toList(),
            ),
            const Divider(),
            Expanded(
              child: GridView.builder(
                itemCount: daysInMonth + firstDayOffset,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7),
                itemBuilder: (ctx, index) {
                  if (index < firstDayOffset) return const SizedBox();
                  final day = index - firstDayOffset + 1;
                  final date =
                      DateTime(_currentMonth.year, _currentMonth.month, day);

                  bool isOccupied = false;
                  for (var r in _occupiedRanges) {
                    final start =
                        DateTime(r.start.year, r.start.month, r.start.day);
                    final end = DateTime(r.end.year, r.end.month, r.end.day);

                    if (!date.isBefore(start) && !date.isAfter(end)) {
                      isOccupied = true;
                      break;
                    }
                  }

                  bool isSelected = false;
                  if (_startDate != null) {
                    if (_endDate == null) {
                      isSelected = date.isAtSameMomentAs(_startDate!);
                    } else {
                      isSelected = !date.isBefore(_startDate!) &&
                          !date.isAfter(_endDate!);
                    }
                  }

                  return InkWell(
                    onTap: () => _onDayTap(date),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.indigo
                              : (isOccupied ? Colors.amber.shade200 : null),
                          borderRadius: BorderRadius.circular(4),
                          border: (isSelected || isOccupied)
                              ? null
                              : Border.all(color: Colors.grey.shade200)),
                      child: Center(
                          child: Text("$day",
                              style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: (isSelected || isOccupied)
                                      ? FontWeight.bold
                                      : FontWeight.normal))),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        FilledButton(
            onPressed: (_startDate != null && _endDate != null)
                ? () => Navigator.pop(
                    context, DateTimeRange(start: _startDate!, end: _endDate!))
                : null,
            child: const Text("Confirmar"))
      ],
    );
  }
}
