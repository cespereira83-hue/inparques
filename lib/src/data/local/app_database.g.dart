// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsuariosSistemaTable extends UsuariosSistema
    with TableInfo<$UsuariosSistemaTable, UsuariosSistemaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosSistemaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usuarioMeta =
      const VerificationMeta('usuario');
  @override
  late final GeneratedColumn<String> usuario = GeneratedColumn<String>(
      'usuario', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rolMeta = const VerificationMeta('rol');
  @override
  late final GeneratedColumn<String> rol = GeneratedColumn<String>(
      'rol', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Operador'));
  static const VerificationMeta _preguntaSeguridadMeta =
      const VerificationMeta('preguntaSeguridad');
  @override
  late final GeneratedColumn<String> preguntaSeguridad =
      GeneratedColumn<String>('pregunta_seguridad', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _respuestaSeguridadMeta =
      const VerificationMeta('respuestaSeguridad');
  @override
  late final GeneratedColumn<String> respuestaSeguridad =
      GeneratedColumn<String>('respuesta_seguridad', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, usuario, password, rol, preguntaSeguridad, respuestaSeguridad];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios_sistema';
  @override
  VerificationContext validateIntegrity(
      Insertable<UsuariosSistemaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('usuario')) {
      context.handle(_usuarioMeta,
          usuario.isAcceptableOrUnknown(data['usuario']!, _usuarioMeta));
    } else if (isInserting) {
      context.missing(_usuarioMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('rol')) {
      context.handle(
          _rolMeta, rol.isAcceptableOrUnknown(data['rol']!, _rolMeta));
    }
    if (data.containsKey('pregunta_seguridad')) {
      context.handle(
          _preguntaSeguridadMeta,
          preguntaSeguridad.isAcceptableOrUnknown(
              data['pregunta_seguridad']!, _preguntaSeguridadMeta));
    }
    if (data.containsKey('respuesta_seguridad')) {
      context.handle(
          _respuestaSeguridadMeta,
          respuestaSeguridad.isAcceptableOrUnknown(
              data['respuesta_seguridad']!, _respuestaSeguridadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsuariosSistemaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsuariosSistemaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      usuario: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      rol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rol'])!,
      preguntaSeguridad: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}pregunta_seguridad']),
      respuestaSeguridad: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}respuesta_seguridad']),
    );
  }

  @override
  $UsuariosSistemaTable createAlias(String alias) {
    return $UsuariosSistemaTable(attachedDatabase, alias);
  }
}

class UsuariosSistemaData extends DataClass
    implements Insertable<UsuariosSistemaData> {
  final int id;
  final String usuario;
  final String password;
  final String rol;
  final String? preguntaSeguridad;
  final String? respuestaSeguridad;
  const UsuariosSistemaData(
      {required this.id,
      required this.usuario,
      required this.password,
      required this.rol,
      this.preguntaSeguridad,
      this.respuestaSeguridad});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usuario'] = Variable<String>(usuario);
    map['password'] = Variable<String>(password);
    map['rol'] = Variable<String>(rol);
    if (!nullToAbsent || preguntaSeguridad != null) {
      map['pregunta_seguridad'] = Variable<String>(preguntaSeguridad);
    }
    if (!nullToAbsent || respuestaSeguridad != null) {
      map['respuesta_seguridad'] = Variable<String>(respuestaSeguridad);
    }
    return map;
  }

  UsuariosSistemaCompanion toCompanion(bool nullToAbsent) {
    return UsuariosSistemaCompanion(
      id: Value(id),
      usuario: Value(usuario),
      password: Value(password),
      rol: Value(rol),
      preguntaSeguridad: preguntaSeguridad == null && nullToAbsent
          ? const Value.absent()
          : Value(preguntaSeguridad),
      respuestaSeguridad: respuestaSeguridad == null && nullToAbsent
          ? const Value.absent()
          : Value(respuestaSeguridad),
    );
  }

  factory UsuariosSistemaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsuariosSistemaData(
      id: serializer.fromJson<int>(json['id']),
      usuario: serializer.fromJson<String>(json['usuario']),
      password: serializer.fromJson<String>(json['password']),
      rol: serializer.fromJson<String>(json['rol']),
      preguntaSeguridad:
          serializer.fromJson<String?>(json['preguntaSeguridad']),
      respuestaSeguridad:
          serializer.fromJson<String?>(json['respuestaSeguridad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usuario': serializer.toJson<String>(usuario),
      'password': serializer.toJson<String>(password),
      'rol': serializer.toJson<String>(rol),
      'preguntaSeguridad': serializer.toJson<String?>(preguntaSeguridad),
      'respuestaSeguridad': serializer.toJson<String?>(respuestaSeguridad),
    };
  }

  UsuariosSistemaData copyWith(
          {int? id,
          String? usuario,
          String? password,
          String? rol,
          Value<String?> preguntaSeguridad = const Value.absent(),
          Value<String?> respuestaSeguridad = const Value.absent()}) =>
      UsuariosSistemaData(
        id: id ?? this.id,
        usuario: usuario ?? this.usuario,
        password: password ?? this.password,
        rol: rol ?? this.rol,
        preguntaSeguridad: preguntaSeguridad.present
            ? preguntaSeguridad.value
            : this.preguntaSeguridad,
        respuestaSeguridad: respuestaSeguridad.present
            ? respuestaSeguridad.value
            : this.respuestaSeguridad,
      );
  UsuariosSistemaData copyWithCompanion(UsuariosSistemaCompanion data) {
    return UsuariosSistemaData(
      id: data.id.present ? data.id.value : this.id,
      usuario: data.usuario.present ? data.usuario.value : this.usuario,
      password: data.password.present ? data.password.value : this.password,
      rol: data.rol.present ? data.rol.value : this.rol,
      preguntaSeguridad: data.preguntaSeguridad.present
          ? data.preguntaSeguridad.value
          : this.preguntaSeguridad,
      respuestaSeguridad: data.respuestaSeguridad.present
          ? data.respuestaSeguridad.value
          : this.respuestaSeguridad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosSistemaData(')
          ..write('id: $id, ')
          ..write('usuario: $usuario, ')
          ..write('password: $password, ')
          ..write('rol: $rol, ')
          ..write('preguntaSeguridad: $preguntaSeguridad, ')
          ..write('respuestaSeguridad: $respuestaSeguridad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, usuario, password, rol, preguntaSeguridad, respuestaSeguridad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsuariosSistemaData &&
          other.id == this.id &&
          other.usuario == this.usuario &&
          other.password == this.password &&
          other.rol == this.rol &&
          other.preguntaSeguridad == this.preguntaSeguridad &&
          other.respuestaSeguridad == this.respuestaSeguridad);
}

class UsuariosSistemaCompanion extends UpdateCompanion<UsuariosSistemaData> {
  final Value<int> id;
  final Value<String> usuario;
  final Value<String> password;
  final Value<String> rol;
  final Value<String?> preguntaSeguridad;
  final Value<String?> respuestaSeguridad;
  const UsuariosSistemaCompanion({
    this.id = const Value.absent(),
    this.usuario = const Value.absent(),
    this.password = const Value.absent(),
    this.rol = const Value.absent(),
    this.preguntaSeguridad = const Value.absent(),
    this.respuestaSeguridad = const Value.absent(),
  });
  UsuariosSistemaCompanion.insert({
    this.id = const Value.absent(),
    required String usuario,
    required String password,
    this.rol = const Value.absent(),
    this.preguntaSeguridad = const Value.absent(),
    this.respuestaSeguridad = const Value.absent(),
  })  : usuario = Value(usuario),
        password = Value(password);
  static Insertable<UsuariosSistemaData> custom({
    Expression<int>? id,
    Expression<String>? usuario,
    Expression<String>? password,
    Expression<String>? rol,
    Expression<String>? preguntaSeguridad,
    Expression<String>? respuestaSeguridad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuario != null) 'usuario': usuario,
      if (password != null) 'password': password,
      if (rol != null) 'rol': rol,
      if (preguntaSeguridad != null) 'pregunta_seguridad': preguntaSeguridad,
      if (respuestaSeguridad != null) 'respuesta_seguridad': respuestaSeguridad,
    });
  }

  UsuariosSistemaCompanion copyWith(
      {Value<int>? id,
      Value<String>? usuario,
      Value<String>? password,
      Value<String>? rol,
      Value<String?>? preguntaSeguridad,
      Value<String?>? respuestaSeguridad}) {
    return UsuariosSistemaCompanion(
      id: id ?? this.id,
      usuario: usuario ?? this.usuario,
      password: password ?? this.password,
      rol: rol ?? this.rol,
      preguntaSeguridad: preguntaSeguridad ?? this.preguntaSeguridad,
      respuestaSeguridad: respuestaSeguridad ?? this.respuestaSeguridad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (usuario.present) {
      map['usuario'] = Variable<String>(usuario.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (rol.present) {
      map['rol'] = Variable<String>(rol.value);
    }
    if (preguntaSeguridad.present) {
      map['pregunta_seguridad'] = Variable<String>(preguntaSeguridad.value);
    }
    if (respuestaSeguridad.present) {
      map['respuesta_seguridad'] = Variable<String>(respuestaSeguridad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosSistemaCompanion(')
          ..write('id: $id, ')
          ..write('usuario: $usuario, ')
          ..write('password: $password, ')
          ..write('rol: $rol, ')
          ..write('preguntaSeguridad: $preguntaSeguridad, ')
          ..write('respuestaSeguridad: $respuestaSeguridad')
          ..write(')'))
        .toString();
  }
}

class $ConfigSettingsTable extends ConfigSettings
    with TableInfo<$ConfigSettingsTable, ConfigSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfigSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreInstitucionMeta =
      const VerificationMeta('nombreInstitucion');
  @override
  late final GeneratedColumn<String> nombreInstitucion =
      GeneratedColumn<String>('nombre_institucion', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('INPARQUES'));
  static const VerificationMeta _parqueNombreMeta =
      const VerificationMeta('parqueNombre');
  @override
  late final GeneratedColumn<String> parqueNombre = GeneratedColumn<String>(
      'parque_nombre', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sectorNombreMeta =
      const VerificationMeta('sectorNombre');
  @override
  late final GeneratedColumn<String> sectorNombre = GeneratedColumn<String>(
      'sector_nombre', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ciudadMeta = const VerificationMeta('ciudad');
  @override
  late final GeneratedColumn<String> ciudad = GeneratedColumn<String>(
      'ciudad', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _municipioMeta =
      const VerificationMeta('municipio');
  @override
  late final GeneratedColumn<String> municipio = GeneratedColumn<String>(
      'municipio', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nombreJefeMeta =
      const VerificationMeta('nombreJefe');
  @override
  late final GeneratedColumn<String> nombreJefe = GeneratedColumn<String>(
      'nombre_jefe', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _apellidoJefeMeta =
      const VerificationMeta('apellidoJefe');
  @override
  late final GeneratedColumn<String> apellidoJefe = GeneratedColumn<String>(
      'apellido_jefe', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rangoJefeMeta =
      const VerificationMeta('rangoJefe');
  @override
  late final GeneratedColumn<String> rangoJefe = GeneratedColumn<String>(
      'rango_jefe', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _jefeCargoMeta =
      const VerificationMeta('jefeCargo');
  @override
  late final GeneratedColumn<String> jefeCargo = GeneratedColumn<String>(
      'jefe_cargo', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Jefe de Sector'));
  static const VerificationMeta _usuarioMeta =
      const VerificationMeta('usuario');
  @override
  late final GeneratedColumn<String> usuario = GeneratedColumn<String>(
      'usuario', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _preguntaSeguridadMeta =
      const VerificationMeta('preguntaSeguridad');
  @override
  late final GeneratedColumn<String> preguntaSeguridad =
      GeneratedColumn<String>('pregunta_seguridad', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _respuestaSeguridadMeta =
      const VerificationMeta('respuestaSeguridad');
  @override
  late final GeneratedColumn<String> respuestaSeguridad =
      GeneratedColumn<String>('respuesta_seguridad', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nombreInstitucion,
        parqueNombre,
        sectorNombre,
        ciudad,
        municipio,
        estado,
        nombreJefe,
        apellidoJefe,
        rangoJefe,
        jefeCargo,
        usuario,
        password,
        preguntaSeguridad,
        respuestaSeguridad
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'config_settings';
  @override
  VerificationContext validateIntegrity(Insertable<ConfigSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre_institucion')) {
      context.handle(
          _nombreInstitucionMeta,
          nombreInstitucion.isAcceptableOrUnknown(
              data['nombre_institucion']!, _nombreInstitucionMeta));
    }
    if (data.containsKey('parque_nombre')) {
      context.handle(
          _parqueNombreMeta,
          parqueNombre.isAcceptableOrUnknown(
              data['parque_nombre']!, _parqueNombreMeta));
    }
    if (data.containsKey('sector_nombre')) {
      context.handle(
          _sectorNombreMeta,
          sectorNombre.isAcceptableOrUnknown(
              data['sector_nombre']!, _sectorNombreMeta));
    }
    if (data.containsKey('ciudad')) {
      context.handle(_ciudadMeta,
          ciudad.isAcceptableOrUnknown(data['ciudad']!, _ciudadMeta));
    }
    if (data.containsKey('municipio')) {
      context.handle(_municipioMeta,
          municipio.isAcceptableOrUnknown(data['municipio']!, _municipioMeta));
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    }
    if (data.containsKey('nombre_jefe')) {
      context.handle(
          _nombreJefeMeta,
          nombreJefe.isAcceptableOrUnknown(
              data['nombre_jefe']!, _nombreJefeMeta));
    } else if (isInserting) {
      context.missing(_nombreJefeMeta);
    }
    if (data.containsKey('apellido_jefe')) {
      context.handle(
          _apellidoJefeMeta,
          apellidoJefe.isAcceptableOrUnknown(
              data['apellido_jefe']!, _apellidoJefeMeta));
    }
    if (data.containsKey('rango_jefe')) {
      context.handle(_rangoJefeMeta,
          rangoJefe.isAcceptableOrUnknown(data['rango_jefe']!, _rangoJefeMeta));
    } else if (isInserting) {
      context.missing(_rangoJefeMeta);
    }
    if (data.containsKey('jefe_cargo')) {
      context.handle(_jefeCargoMeta,
          jefeCargo.isAcceptableOrUnknown(data['jefe_cargo']!, _jefeCargoMeta));
    }
    if (data.containsKey('usuario')) {
      context.handle(_usuarioMeta,
          usuario.isAcceptableOrUnknown(data['usuario']!, _usuarioMeta));
    } else if (isInserting) {
      context.missing(_usuarioMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('pregunta_seguridad')) {
      context.handle(
          _preguntaSeguridadMeta,
          preguntaSeguridad.isAcceptableOrUnknown(
              data['pregunta_seguridad']!, _preguntaSeguridadMeta));
    }
    if (data.containsKey('respuesta_seguridad')) {
      context.handle(
          _respuestaSeguridadMeta,
          respuestaSeguridad.isAcceptableOrUnknown(
              data['respuesta_seguridad']!, _respuestaSeguridadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfigSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfigSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombreInstitucion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}nombre_institucion'])!,
      parqueNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parque_nombre']),
      sectorNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sector_nombre']),
      ciudad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ciudad']),
      municipio: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}municipio']),
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado']),
      nombreJefe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre_jefe'])!,
      apellidoJefe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}apellido_jefe']),
      rangoJefe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rango_jefe'])!,
      jefeCargo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}jefe_cargo'])!,
      usuario: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      preguntaSeguridad: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}pregunta_seguridad']),
      respuestaSeguridad: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}respuesta_seguridad']),
    );
  }

  @override
  $ConfigSettingsTable createAlias(String alias) {
    return $ConfigSettingsTable(attachedDatabase, alias);
  }
}

class ConfigSetting extends DataClass implements Insertable<ConfigSetting> {
  final int id;
  final String nombreInstitucion;
  final String? parqueNombre;
  final String? sectorNombre;
  final String? ciudad;
  final String? municipio;
  final String? estado;
  final String nombreJefe;
  final String? apellidoJefe;
  final String rangoJefe;
  final String jefeCargo;
  final String usuario;
  final String password;
  final String? preguntaSeguridad;
  final String? respuestaSeguridad;
  const ConfigSetting(
      {required this.id,
      required this.nombreInstitucion,
      this.parqueNombre,
      this.sectorNombre,
      this.ciudad,
      this.municipio,
      this.estado,
      required this.nombreJefe,
      this.apellidoJefe,
      required this.rangoJefe,
      required this.jefeCargo,
      required this.usuario,
      required this.password,
      this.preguntaSeguridad,
      this.respuestaSeguridad});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre_institucion'] = Variable<String>(nombreInstitucion);
    if (!nullToAbsent || parqueNombre != null) {
      map['parque_nombre'] = Variable<String>(parqueNombre);
    }
    if (!nullToAbsent || sectorNombre != null) {
      map['sector_nombre'] = Variable<String>(sectorNombre);
    }
    if (!nullToAbsent || ciudad != null) {
      map['ciudad'] = Variable<String>(ciudad);
    }
    if (!nullToAbsent || municipio != null) {
      map['municipio'] = Variable<String>(municipio);
    }
    if (!nullToAbsent || estado != null) {
      map['estado'] = Variable<String>(estado);
    }
    map['nombre_jefe'] = Variable<String>(nombreJefe);
    if (!nullToAbsent || apellidoJefe != null) {
      map['apellido_jefe'] = Variable<String>(apellidoJefe);
    }
    map['rango_jefe'] = Variable<String>(rangoJefe);
    map['jefe_cargo'] = Variable<String>(jefeCargo);
    map['usuario'] = Variable<String>(usuario);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || preguntaSeguridad != null) {
      map['pregunta_seguridad'] = Variable<String>(preguntaSeguridad);
    }
    if (!nullToAbsent || respuestaSeguridad != null) {
      map['respuesta_seguridad'] = Variable<String>(respuestaSeguridad);
    }
    return map;
  }

  ConfigSettingsCompanion toCompanion(bool nullToAbsent) {
    return ConfigSettingsCompanion(
      id: Value(id),
      nombreInstitucion: Value(nombreInstitucion),
      parqueNombre: parqueNombre == null && nullToAbsent
          ? const Value.absent()
          : Value(parqueNombre),
      sectorNombre: sectorNombre == null && nullToAbsent
          ? const Value.absent()
          : Value(sectorNombre),
      ciudad:
          ciudad == null && nullToAbsent ? const Value.absent() : Value(ciudad),
      municipio: municipio == null && nullToAbsent
          ? const Value.absent()
          : Value(municipio),
      estado:
          estado == null && nullToAbsent ? const Value.absent() : Value(estado),
      nombreJefe: Value(nombreJefe),
      apellidoJefe: apellidoJefe == null && nullToAbsent
          ? const Value.absent()
          : Value(apellidoJefe),
      rangoJefe: Value(rangoJefe),
      jefeCargo: Value(jefeCargo),
      usuario: Value(usuario),
      password: Value(password),
      preguntaSeguridad: preguntaSeguridad == null && nullToAbsent
          ? const Value.absent()
          : Value(preguntaSeguridad),
      respuestaSeguridad: respuestaSeguridad == null && nullToAbsent
          ? const Value.absent()
          : Value(respuestaSeguridad),
    );
  }

  factory ConfigSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfigSetting(
      id: serializer.fromJson<int>(json['id']),
      nombreInstitucion: serializer.fromJson<String>(json['nombreInstitucion']),
      parqueNombre: serializer.fromJson<String?>(json['parqueNombre']),
      sectorNombre: serializer.fromJson<String?>(json['sectorNombre']),
      ciudad: serializer.fromJson<String?>(json['ciudad']),
      municipio: serializer.fromJson<String?>(json['municipio']),
      estado: serializer.fromJson<String?>(json['estado']),
      nombreJefe: serializer.fromJson<String>(json['nombreJefe']),
      apellidoJefe: serializer.fromJson<String?>(json['apellidoJefe']),
      rangoJefe: serializer.fromJson<String>(json['rangoJefe']),
      jefeCargo: serializer.fromJson<String>(json['jefeCargo']),
      usuario: serializer.fromJson<String>(json['usuario']),
      password: serializer.fromJson<String>(json['password']),
      preguntaSeguridad:
          serializer.fromJson<String?>(json['preguntaSeguridad']),
      respuestaSeguridad:
          serializer.fromJson<String?>(json['respuestaSeguridad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombreInstitucion': serializer.toJson<String>(nombreInstitucion),
      'parqueNombre': serializer.toJson<String?>(parqueNombre),
      'sectorNombre': serializer.toJson<String?>(sectorNombre),
      'ciudad': serializer.toJson<String?>(ciudad),
      'municipio': serializer.toJson<String?>(municipio),
      'estado': serializer.toJson<String?>(estado),
      'nombreJefe': serializer.toJson<String>(nombreJefe),
      'apellidoJefe': serializer.toJson<String?>(apellidoJefe),
      'rangoJefe': serializer.toJson<String>(rangoJefe),
      'jefeCargo': serializer.toJson<String>(jefeCargo),
      'usuario': serializer.toJson<String>(usuario),
      'password': serializer.toJson<String>(password),
      'preguntaSeguridad': serializer.toJson<String?>(preguntaSeguridad),
      'respuestaSeguridad': serializer.toJson<String?>(respuestaSeguridad),
    };
  }

  ConfigSetting copyWith(
          {int? id,
          String? nombreInstitucion,
          Value<String?> parqueNombre = const Value.absent(),
          Value<String?> sectorNombre = const Value.absent(),
          Value<String?> ciudad = const Value.absent(),
          Value<String?> municipio = const Value.absent(),
          Value<String?> estado = const Value.absent(),
          String? nombreJefe,
          Value<String?> apellidoJefe = const Value.absent(),
          String? rangoJefe,
          String? jefeCargo,
          String? usuario,
          String? password,
          Value<String?> preguntaSeguridad = const Value.absent(),
          Value<String?> respuestaSeguridad = const Value.absent()}) =>
      ConfigSetting(
        id: id ?? this.id,
        nombreInstitucion: nombreInstitucion ?? this.nombreInstitucion,
        parqueNombre:
            parqueNombre.present ? parqueNombre.value : this.parqueNombre,
        sectorNombre:
            sectorNombre.present ? sectorNombre.value : this.sectorNombre,
        ciudad: ciudad.present ? ciudad.value : this.ciudad,
        municipio: municipio.present ? municipio.value : this.municipio,
        estado: estado.present ? estado.value : this.estado,
        nombreJefe: nombreJefe ?? this.nombreJefe,
        apellidoJefe:
            apellidoJefe.present ? apellidoJefe.value : this.apellidoJefe,
        rangoJefe: rangoJefe ?? this.rangoJefe,
        jefeCargo: jefeCargo ?? this.jefeCargo,
        usuario: usuario ?? this.usuario,
        password: password ?? this.password,
        preguntaSeguridad: preguntaSeguridad.present
            ? preguntaSeguridad.value
            : this.preguntaSeguridad,
        respuestaSeguridad: respuestaSeguridad.present
            ? respuestaSeguridad.value
            : this.respuestaSeguridad,
      );
  ConfigSetting copyWithCompanion(ConfigSettingsCompanion data) {
    return ConfigSetting(
      id: data.id.present ? data.id.value : this.id,
      nombreInstitucion: data.nombreInstitucion.present
          ? data.nombreInstitucion.value
          : this.nombreInstitucion,
      parqueNombre: data.parqueNombre.present
          ? data.parqueNombre.value
          : this.parqueNombre,
      sectorNombre: data.sectorNombre.present
          ? data.sectorNombre.value
          : this.sectorNombre,
      ciudad: data.ciudad.present ? data.ciudad.value : this.ciudad,
      municipio: data.municipio.present ? data.municipio.value : this.municipio,
      estado: data.estado.present ? data.estado.value : this.estado,
      nombreJefe:
          data.nombreJefe.present ? data.nombreJefe.value : this.nombreJefe,
      apellidoJefe: data.apellidoJefe.present
          ? data.apellidoJefe.value
          : this.apellidoJefe,
      rangoJefe: data.rangoJefe.present ? data.rangoJefe.value : this.rangoJefe,
      jefeCargo: data.jefeCargo.present ? data.jefeCargo.value : this.jefeCargo,
      usuario: data.usuario.present ? data.usuario.value : this.usuario,
      password: data.password.present ? data.password.value : this.password,
      preguntaSeguridad: data.preguntaSeguridad.present
          ? data.preguntaSeguridad.value
          : this.preguntaSeguridad,
      respuestaSeguridad: data.respuestaSeguridad.present
          ? data.respuestaSeguridad.value
          : this.respuestaSeguridad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfigSetting(')
          ..write('id: $id, ')
          ..write('nombreInstitucion: $nombreInstitucion, ')
          ..write('parqueNombre: $parqueNombre, ')
          ..write('sectorNombre: $sectorNombre, ')
          ..write('ciudad: $ciudad, ')
          ..write('municipio: $municipio, ')
          ..write('estado: $estado, ')
          ..write('nombreJefe: $nombreJefe, ')
          ..write('apellidoJefe: $apellidoJefe, ')
          ..write('rangoJefe: $rangoJefe, ')
          ..write('jefeCargo: $jefeCargo, ')
          ..write('usuario: $usuario, ')
          ..write('password: $password, ')
          ..write('preguntaSeguridad: $preguntaSeguridad, ')
          ..write('respuestaSeguridad: $respuestaSeguridad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      nombreInstitucion,
      parqueNombre,
      sectorNombre,
      ciudad,
      municipio,
      estado,
      nombreJefe,
      apellidoJefe,
      rangoJefe,
      jefeCargo,
      usuario,
      password,
      preguntaSeguridad,
      respuestaSeguridad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfigSetting &&
          other.id == this.id &&
          other.nombreInstitucion == this.nombreInstitucion &&
          other.parqueNombre == this.parqueNombre &&
          other.sectorNombre == this.sectorNombre &&
          other.ciudad == this.ciudad &&
          other.municipio == this.municipio &&
          other.estado == this.estado &&
          other.nombreJefe == this.nombreJefe &&
          other.apellidoJefe == this.apellidoJefe &&
          other.rangoJefe == this.rangoJefe &&
          other.jefeCargo == this.jefeCargo &&
          other.usuario == this.usuario &&
          other.password == this.password &&
          other.preguntaSeguridad == this.preguntaSeguridad &&
          other.respuestaSeguridad == this.respuestaSeguridad);
}

class ConfigSettingsCompanion extends UpdateCompanion<ConfigSetting> {
  final Value<int> id;
  final Value<String> nombreInstitucion;
  final Value<String?> parqueNombre;
  final Value<String?> sectorNombre;
  final Value<String?> ciudad;
  final Value<String?> municipio;
  final Value<String?> estado;
  final Value<String> nombreJefe;
  final Value<String?> apellidoJefe;
  final Value<String> rangoJefe;
  final Value<String> jefeCargo;
  final Value<String> usuario;
  final Value<String> password;
  final Value<String?> preguntaSeguridad;
  final Value<String?> respuestaSeguridad;
  const ConfigSettingsCompanion({
    this.id = const Value.absent(),
    this.nombreInstitucion = const Value.absent(),
    this.parqueNombre = const Value.absent(),
    this.sectorNombre = const Value.absent(),
    this.ciudad = const Value.absent(),
    this.municipio = const Value.absent(),
    this.estado = const Value.absent(),
    this.nombreJefe = const Value.absent(),
    this.apellidoJefe = const Value.absent(),
    this.rangoJefe = const Value.absent(),
    this.jefeCargo = const Value.absent(),
    this.usuario = const Value.absent(),
    this.password = const Value.absent(),
    this.preguntaSeguridad = const Value.absent(),
    this.respuestaSeguridad = const Value.absent(),
  });
  ConfigSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.nombreInstitucion = const Value.absent(),
    this.parqueNombre = const Value.absent(),
    this.sectorNombre = const Value.absent(),
    this.ciudad = const Value.absent(),
    this.municipio = const Value.absent(),
    this.estado = const Value.absent(),
    required String nombreJefe,
    this.apellidoJefe = const Value.absent(),
    required String rangoJefe,
    this.jefeCargo = const Value.absent(),
    required String usuario,
    required String password,
    this.preguntaSeguridad = const Value.absent(),
    this.respuestaSeguridad = const Value.absent(),
  })  : nombreJefe = Value(nombreJefe),
        rangoJefe = Value(rangoJefe),
        usuario = Value(usuario),
        password = Value(password);
  static Insertable<ConfigSetting> custom({
    Expression<int>? id,
    Expression<String>? nombreInstitucion,
    Expression<String>? parqueNombre,
    Expression<String>? sectorNombre,
    Expression<String>? ciudad,
    Expression<String>? municipio,
    Expression<String>? estado,
    Expression<String>? nombreJefe,
    Expression<String>? apellidoJefe,
    Expression<String>? rangoJefe,
    Expression<String>? jefeCargo,
    Expression<String>? usuario,
    Expression<String>? password,
    Expression<String>? preguntaSeguridad,
    Expression<String>? respuestaSeguridad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombreInstitucion != null) 'nombre_institucion': nombreInstitucion,
      if (parqueNombre != null) 'parque_nombre': parqueNombre,
      if (sectorNombre != null) 'sector_nombre': sectorNombre,
      if (ciudad != null) 'ciudad': ciudad,
      if (municipio != null) 'municipio': municipio,
      if (estado != null) 'estado': estado,
      if (nombreJefe != null) 'nombre_jefe': nombreJefe,
      if (apellidoJefe != null) 'apellido_jefe': apellidoJefe,
      if (rangoJefe != null) 'rango_jefe': rangoJefe,
      if (jefeCargo != null) 'jefe_cargo': jefeCargo,
      if (usuario != null) 'usuario': usuario,
      if (password != null) 'password': password,
      if (preguntaSeguridad != null) 'pregunta_seguridad': preguntaSeguridad,
      if (respuestaSeguridad != null) 'respuesta_seguridad': respuestaSeguridad,
    });
  }

  ConfigSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombreInstitucion,
      Value<String?>? parqueNombre,
      Value<String?>? sectorNombre,
      Value<String?>? ciudad,
      Value<String?>? municipio,
      Value<String?>? estado,
      Value<String>? nombreJefe,
      Value<String?>? apellidoJefe,
      Value<String>? rangoJefe,
      Value<String>? jefeCargo,
      Value<String>? usuario,
      Value<String>? password,
      Value<String?>? preguntaSeguridad,
      Value<String?>? respuestaSeguridad}) {
    return ConfigSettingsCompanion(
      id: id ?? this.id,
      nombreInstitucion: nombreInstitucion ?? this.nombreInstitucion,
      parqueNombre: parqueNombre ?? this.parqueNombre,
      sectorNombre: sectorNombre ?? this.sectorNombre,
      ciudad: ciudad ?? this.ciudad,
      municipio: municipio ?? this.municipio,
      estado: estado ?? this.estado,
      nombreJefe: nombreJefe ?? this.nombreJefe,
      apellidoJefe: apellidoJefe ?? this.apellidoJefe,
      rangoJefe: rangoJefe ?? this.rangoJefe,
      jefeCargo: jefeCargo ?? this.jefeCargo,
      usuario: usuario ?? this.usuario,
      password: password ?? this.password,
      preguntaSeguridad: preguntaSeguridad ?? this.preguntaSeguridad,
      respuestaSeguridad: respuestaSeguridad ?? this.respuestaSeguridad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombreInstitucion.present) {
      map['nombre_institucion'] = Variable<String>(nombreInstitucion.value);
    }
    if (parqueNombre.present) {
      map['parque_nombre'] = Variable<String>(parqueNombre.value);
    }
    if (sectorNombre.present) {
      map['sector_nombre'] = Variable<String>(sectorNombre.value);
    }
    if (ciudad.present) {
      map['ciudad'] = Variable<String>(ciudad.value);
    }
    if (municipio.present) {
      map['municipio'] = Variable<String>(municipio.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (nombreJefe.present) {
      map['nombre_jefe'] = Variable<String>(nombreJefe.value);
    }
    if (apellidoJefe.present) {
      map['apellido_jefe'] = Variable<String>(apellidoJefe.value);
    }
    if (rangoJefe.present) {
      map['rango_jefe'] = Variable<String>(rangoJefe.value);
    }
    if (jefeCargo.present) {
      map['jefe_cargo'] = Variable<String>(jefeCargo.value);
    }
    if (usuario.present) {
      map['usuario'] = Variable<String>(usuario.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (preguntaSeguridad.present) {
      map['pregunta_seguridad'] = Variable<String>(preguntaSeguridad.value);
    }
    if (respuestaSeguridad.present) {
      map['respuesta_seguridad'] = Variable<String>(respuestaSeguridad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfigSettingsCompanion(')
          ..write('id: $id, ')
          ..write('nombreInstitucion: $nombreInstitucion, ')
          ..write('parqueNombre: $parqueNombre, ')
          ..write('sectorNombre: $sectorNombre, ')
          ..write('ciudad: $ciudad, ')
          ..write('municipio: $municipio, ')
          ..write('estado: $estado, ')
          ..write('nombreJefe: $nombreJefe, ')
          ..write('apellidoJefe: $apellidoJefe, ')
          ..write('rangoJefe: $rangoJefe, ')
          ..write('jefeCargo: $jefeCargo, ')
          ..write('usuario: $usuario, ')
          ..write('password: $password, ')
          ..write('preguntaSeguridad: $preguntaSeguridad, ')
          ..write('respuestaSeguridad: $respuestaSeguridad')
          ..write(')'))
        .toString();
  }
}

class $RangosTable extends Rangos with TableInfo<$RangosTable, Rango> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RangosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _prioridadMeta =
      const VerificationMeta('prioridad');
  @override
  late final GeneratedColumn<int> prioridad = GeneratedColumn<int>(
      'prioridad', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(99));
  @override
  List<GeneratedColumn> get $columns => [id, nombre, descripcion, prioridad];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rangos';
  @override
  VerificationContext validateIntegrity(Insertable<Rango> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    }
    if (data.containsKey('prioridad')) {
      context.handle(_prioridadMeta,
          prioridad.isAcceptableOrUnknown(data['prioridad']!, _prioridadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rango map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rango(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion']),
      prioridad: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}prioridad'])!,
    );
  }

  @override
  $RangosTable createAlias(String alias) {
    return $RangosTable(attachedDatabase, alias);
  }
}

class Rango extends DataClass implements Insertable<Rango> {
  final int id;
  final String nombre;
  final String? descripcion;
  final int prioridad;
  const Rango(
      {required this.id,
      required this.nombre,
      this.descripcion,
      required this.prioridad});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['prioridad'] = Variable<int>(prioridad);
    return map;
  }

  RangosCompanion toCompanion(bool nullToAbsent) {
    return RangosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      prioridad: Value(prioridad),
    );
  }

  factory Rango.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rango(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      prioridad: serializer.fromJson<int>(json['prioridad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'prioridad': serializer.toJson<int>(prioridad),
    };
  }

  Rango copyWith(
          {int? id,
          String? nombre,
          Value<String?> descripcion = const Value.absent(),
          int? prioridad}) =>
      Rango(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        descripcion: descripcion.present ? descripcion.value : this.descripcion,
        prioridad: prioridad ?? this.prioridad,
      );
  Rango copyWithCompanion(RangosCompanion data) {
    return Rango(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      prioridad: data.prioridad.present ? data.prioridad.value : this.prioridad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rango(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('prioridad: $prioridad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, descripcion, prioridad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rango &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.prioridad == this.prioridad);
}

class RangosCompanion extends UpdateCompanion<Rango> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<int> prioridad;
  const RangosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.prioridad = const Value.absent(),
  });
  RangosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.descripcion = const Value.absent(),
    this.prioridad = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Rango> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<int>? prioridad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (prioridad != null) 'prioridad': prioridad,
    });
  }

  RangosCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<String?>? descripcion,
      Value<int>? prioridad}) {
    return RangosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      prioridad: prioridad ?? this.prioridad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (prioridad.present) {
      map['prioridad'] = Variable<int>(prioridad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RangosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('prioridad: $prioridad')
          ..write(')'))
        .toString();
  }
}

class $TiposGuardiaTable extends TiposGuardia
    with TableInfo<$TiposGuardiaTable, TiposGuardiaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TiposGuardiaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, nombre, descripcion, activo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tipos_guardia';
  @override
  VerificationContext validateIntegrity(Insertable<TiposGuardiaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TiposGuardiaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TiposGuardiaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion']),
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
    );
  }

  @override
  $TiposGuardiaTable createAlias(String alias) {
    return $TiposGuardiaTable(attachedDatabase, alias);
  }
}

class TiposGuardiaData extends DataClass
    implements Insertable<TiposGuardiaData> {
  final int id;
  final String nombre;
  final String? descripcion;
  final bool activo;
  const TiposGuardiaData(
      {required this.id,
      required this.nombre,
      this.descripcion,
      required this.activo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  TiposGuardiaCompanion toCompanion(bool nullToAbsent) {
    return TiposGuardiaCompanion(
      id: Value(id),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      activo: Value(activo),
    );
  }

  factory TiposGuardiaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TiposGuardiaData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  TiposGuardiaData copyWith(
          {int? id,
          String? nombre,
          Value<String?> descripcion = const Value.absent(),
          bool? activo}) =>
      TiposGuardiaData(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        descripcion: descripcion.present ? descripcion.value : this.descripcion,
        activo: activo ?? this.activo,
      );
  TiposGuardiaData copyWithCompanion(TiposGuardiaCompanion data) {
    return TiposGuardiaData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TiposGuardiaData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, descripcion, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TiposGuardiaData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.activo == this.activo);
}

class TiposGuardiaCompanion extends UpdateCompanion<TiposGuardiaData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<bool> activo;
  const TiposGuardiaCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.activo = const Value.absent(),
  });
  TiposGuardiaCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.descripcion = const Value.absent(),
    this.activo = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<TiposGuardiaData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (activo != null) 'activo': activo,
    });
  }

  TiposGuardiaCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<String?>? descripcion,
      Value<bool>? activo}) {
    return TiposGuardiaCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TiposGuardiaCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $UbicacionesTable extends Ubicaciones
    with TableInfo<$UbicacionesTable, Ubicacione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UbicacionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, nombre, descripcion, activo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ubicaciones';
  @override
  VerificationContext validateIntegrity(Insertable<Ubicacione> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ubicacione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ubicacione(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion']),
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
    );
  }

  @override
  $UbicacionesTable createAlias(String alias) {
    return $UbicacionesTable(attachedDatabase, alias);
  }
}

class Ubicacione extends DataClass implements Insertable<Ubicacione> {
  final int id;
  final String nombre;
  final String? descripcion;
  final bool activo;
  const Ubicacione(
      {required this.id,
      required this.nombre,
      this.descripcion,
      required this.activo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  UbicacionesCompanion toCompanion(bool nullToAbsent) {
    return UbicacionesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      activo: Value(activo),
    );
  }

  factory Ubicacione.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ubicacione(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  Ubicacione copyWith(
          {int? id,
          String? nombre,
          Value<String?> descripcion = const Value.absent(),
          bool? activo}) =>
      Ubicacione(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        descripcion: descripcion.present ? descripcion.value : this.descripcion,
        activo: activo ?? this.activo,
      );
  Ubicacione copyWithCompanion(UbicacionesCompanion data) {
    return Ubicacione(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ubicacione(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, descripcion, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ubicacione &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.activo == this.activo);
}

class UbicacionesCompanion extends UpdateCompanion<Ubicacione> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<bool> activo;
  const UbicacionesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.activo = const Value.absent(),
  });
  UbicacionesCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.descripcion = const Value.absent(),
    this.activo = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Ubicacione> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (activo != null) 'activo': activo,
    });
  }

  UbicacionesCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<String?>? descripcion,
      Value<bool>? activo}) {
    return UbicacionesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UbicacionesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $PlanificacionesSemanalesTable extends PlanificacionesSemanales
    with TableInfo<$PlanificacionesSemanalesTable, PlanificacionesSemanale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanificacionesSemanalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _fechaInicioMeta =
      const VerificationMeta('fechaInicio');
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
      'fecha_inicio', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _fechaFinMeta =
      const VerificationMeta('fechaFin');
  @override
  late final GeneratedColumn<DateTime> fechaFin = GeneratedColumn<DateTime>(
      'fecha_fin', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
      'codigo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cerradaMeta =
      const VerificationMeta('cerrada');
  @override
  late final GeneratedColumn<bool> cerrada = GeneratedColumn<bool>(
      'cerrada', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("cerrada" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, fechaInicio, fechaFin, codigo, cerrada];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planificaciones_semanales';
  @override
  VerificationContext validateIntegrity(
      Insertable<PlanificacionesSemanale> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
          _fechaInicioMeta,
          fechaInicio.isAcceptableOrUnknown(
              data['fecha_inicio']!, _fechaInicioMeta));
    } else if (isInserting) {
      context.missing(_fechaInicioMeta);
    }
    if (data.containsKey('fecha_fin')) {
      context.handle(_fechaFinMeta,
          fechaFin.isAcceptableOrUnknown(data['fecha_fin']!, _fechaFinMeta));
    } else if (isInserting) {
      context.missing(_fechaFinMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(_codigoMeta,
          codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta));
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('cerrada')) {
      context.handle(_cerradaMeta,
          cerrada.isAcceptableOrUnknown(data['cerrada']!, _cerradaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanificacionesSemanale map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanificacionesSemanale(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fechaInicio: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_inicio'])!,
      fechaFin: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_fin'])!,
      codigo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo'])!,
      cerrada: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}cerrada'])!,
    );
  }

  @override
  $PlanificacionesSemanalesTable createAlias(String alias) {
    return $PlanificacionesSemanalesTable(attachedDatabase, alias);
  }
}

class PlanificacionesSemanale extends DataClass
    implements Insertable<PlanificacionesSemanale> {
  final int id;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String codigo;
  final bool cerrada;
  const PlanificacionesSemanale(
      {required this.id,
      required this.fechaInicio,
      required this.fechaFin,
      required this.codigo,
      required this.cerrada});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    map['fecha_fin'] = Variable<DateTime>(fechaFin);
    map['codigo'] = Variable<String>(codigo);
    map['cerrada'] = Variable<bool>(cerrada);
    return map;
  }

  PlanificacionesSemanalesCompanion toCompanion(bool nullToAbsent) {
    return PlanificacionesSemanalesCompanion(
      id: Value(id),
      fechaInicio: Value(fechaInicio),
      fechaFin: Value(fechaFin),
      codigo: Value(codigo),
      cerrada: Value(cerrada),
    );
  }

  factory PlanificacionesSemanale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanificacionesSemanale(
      id: serializer.fromJson<int>(json['id']),
      fechaInicio: serializer.fromJson<DateTime>(json['fechaInicio']),
      fechaFin: serializer.fromJson<DateTime>(json['fechaFin']),
      codigo: serializer.fromJson<String>(json['codigo']),
      cerrada: serializer.fromJson<bool>(json['cerrada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fechaInicio': serializer.toJson<DateTime>(fechaInicio),
      'fechaFin': serializer.toJson<DateTime>(fechaFin),
      'codigo': serializer.toJson<String>(codigo),
      'cerrada': serializer.toJson<bool>(cerrada),
    };
  }

  PlanificacionesSemanale copyWith(
          {int? id,
          DateTime? fechaInicio,
          DateTime? fechaFin,
          String? codigo,
          bool? cerrada}) =>
      PlanificacionesSemanale(
        id: id ?? this.id,
        fechaInicio: fechaInicio ?? this.fechaInicio,
        fechaFin: fechaFin ?? this.fechaFin,
        codigo: codigo ?? this.codigo,
        cerrada: cerrada ?? this.cerrada,
      );
  PlanificacionesSemanale copyWithCompanion(
      PlanificacionesSemanalesCompanion data) {
    return PlanificacionesSemanale(
      id: data.id.present ? data.id.value : this.id,
      fechaInicio:
          data.fechaInicio.present ? data.fechaInicio.value : this.fechaInicio,
      fechaFin: data.fechaFin.present ? data.fechaFin.value : this.fechaFin,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      cerrada: data.cerrada.present ? data.cerrada.value : this.cerrada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanificacionesSemanale(')
          ..write('id: $id, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('codigo: $codigo, ')
          ..write('cerrada: $cerrada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fechaInicio, fechaFin, codigo, cerrada);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanificacionesSemanale &&
          other.id == this.id &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaFin == this.fechaFin &&
          other.codigo == this.codigo &&
          other.cerrada == this.cerrada);
}

class PlanificacionesSemanalesCompanion
    extends UpdateCompanion<PlanificacionesSemanale> {
  final Value<int> id;
  final Value<DateTime> fechaInicio;
  final Value<DateTime> fechaFin;
  final Value<String> codigo;
  final Value<bool> cerrada;
  const PlanificacionesSemanalesCompanion({
    this.id = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.codigo = const Value.absent(),
    this.cerrada = const Value.absent(),
  });
  PlanificacionesSemanalesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String codigo,
    this.cerrada = const Value.absent(),
  })  : fechaInicio = Value(fechaInicio),
        fechaFin = Value(fechaFin),
        codigo = Value(codigo);
  static Insertable<PlanificacionesSemanale> custom({
    Expression<int>? id,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? fechaFin,
    Expression<String>? codigo,
    Expression<bool>? cerrada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaFin != null) 'fecha_fin': fechaFin,
      if (codigo != null) 'codigo': codigo,
      if (cerrada != null) 'cerrada': cerrada,
    });
  }

  PlanificacionesSemanalesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? fechaInicio,
      Value<DateTime>? fechaFin,
      Value<String>? codigo,
      Value<bool>? cerrada}) {
    return PlanificacionesSemanalesCompanion(
      id: id ?? this.id,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      codigo: codigo ?? this.codigo,
      cerrada: cerrada ?? this.cerrada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (fechaFin.present) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (cerrada.present) {
      map['cerrada'] = Variable<bool>(cerrada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanificacionesSemanalesCompanion(')
          ..write('id: $id, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('codigo: $codigo, ')
          ..write('cerrada: $cerrada')
          ..write(')'))
        .toString();
  }
}

class $FuncionariosTable extends Funcionarios
    with TableInfo<$FuncionariosTable, Funcionario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuncionariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombresMeta =
      const VerificationMeta('nombres');
  @override
  late final GeneratedColumn<String> nombres = GeneratedColumn<String>(
      'nombres', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _apellidosMeta =
      const VerificationMeta('apellidos');
  @override
  late final GeneratedColumn<String> apellidos = GeneratedColumn<String>(
      'apellidos', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cedulaMeta = const VerificationMeta('cedula');
  @override
  late final GeneratedColumn<String> cedula = GeneratedColumn<String>(
      'cedula', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 6, maxTextLength: 12),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _rangoMeta = const VerificationMeta('rango');
  @override
  late final GeneratedColumn<String> rango = GeneratedColumn<String>(
      'rango', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rangoIdMeta =
      const VerificationMeta('rangoId');
  @override
  late final GeneratedColumn<int> rangoId = GeneratedColumn<int>(
      'rango_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES rangos (id)'));
  static const VerificationMeta _fechaNacimientoMeta =
      const VerificationMeta('fechaNacimiento');
  @override
  late final GeneratedColumn<DateTime> fechaNacimiento =
      GeneratedColumn<DateTime>('fecha_nacimiento', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _fechaIngresoMeta =
      const VerificationMeta('fechaIngreso');
  @override
  late final GeneratedColumn<DateTime> fechaIngreso = GeneratedColumn<DateTime>(
      'fecha_ingreso', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _telefonoMeta =
      const VerificationMeta('telefono');
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
      'telefono', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _diasLaboralesSemanalesMeta =
      const VerificationMeta('diasLaboralesSemanales');
  @override
  late final GeneratedColumn<int> diasLaboralesSemanales = GeneratedColumn<int>(
      'dias_laborales_semanales', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _diasLibresPreferidosMeta =
      const VerificationMeta('diasLibresPreferidos');
  @override
  late final GeneratedColumn<String> diasLibresPreferidos =
      GeneratedColumn<String>('dias_libres_preferidos', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _saldoCompensacionMeta =
      const VerificationMeta('saldoCompensacion');
  @override
  late final GeneratedColumn<int> saldoCompensacion = GeneratedColumn<int>(
      'saldo_compensacion', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _estaActivoMeta =
      const VerificationMeta('estaActivo');
  @override
  late final GeneratedColumn<bool> estaActivo = GeneratedColumn<bool>(
      'esta_activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("esta_activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _fotoPathMeta =
      const VerificationMeta('fotoPath');
  @override
  late final GeneratedColumn<String> fotoPath = GeneratedColumn<String>(
      'foto_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ultimaFechaPernoctaMeta =
      const VerificationMeta('ultimaFechaPernocta');
  @override
  late final GeneratedColumn<DateTime> ultimaFechaPernocta =
      GeneratedColumn<DateTime>('ultima_fecha_pernocta', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nombres,
        apellidos,
        cedula,
        rango,
        rangoId,
        fechaNacimiento,
        fechaIngreso,
        telefono,
        diasLaboralesSemanales,
        diasLibresPreferidos,
        saldoCompensacion,
        estaActivo,
        fotoPath,
        ultimaFechaPernocta
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'funcionarios';
  @override
  VerificationContext validateIntegrity(Insertable<Funcionario> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombres')) {
      context.handle(_nombresMeta,
          nombres.isAcceptableOrUnknown(data['nombres']!, _nombresMeta));
    } else if (isInserting) {
      context.missing(_nombresMeta);
    }
    if (data.containsKey('apellidos')) {
      context.handle(_apellidosMeta,
          apellidos.isAcceptableOrUnknown(data['apellidos']!, _apellidosMeta));
    } else if (isInserting) {
      context.missing(_apellidosMeta);
    }
    if (data.containsKey('cedula')) {
      context.handle(_cedulaMeta,
          cedula.isAcceptableOrUnknown(data['cedula']!, _cedulaMeta));
    } else if (isInserting) {
      context.missing(_cedulaMeta);
    }
    if (data.containsKey('rango')) {
      context.handle(
          _rangoMeta, rango.isAcceptableOrUnknown(data['rango']!, _rangoMeta));
    }
    if (data.containsKey('rango_id')) {
      context.handle(_rangoIdMeta,
          rangoId.isAcceptableOrUnknown(data['rango_id']!, _rangoIdMeta));
    }
    if (data.containsKey('fecha_nacimiento')) {
      context.handle(
          _fechaNacimientoMeta,
          fechaNacimiento.isAcceptableOrUnknown(
              data['fecha_nacimiento']!, _fechaNacimientoMeta));
    }
    if (data.containsKey('fecha_ingreso')) {
      context.handle(
          _fechaIngresoMeta,
          fechaIngreso.isAcceptableOrUnknown(
              data['fecha_ingreso']!, _fechaIngresoMeta));
    }
    if (data.containsKey('telefono')) {
      context.handle(_telefonoMeta,
          telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta));
    }
    if (data.containsKey('dias_laborales_semanales')) {
      context.handle(
          _diasLaboralesSemanalesMeta,
          diasLaboralesSemanales.isAcceptableOrUnknown(
              data['dias_laborales_semanales']!, _diasLaboralesSemanalesMeta));
    }
    if (data.containsKey('dias_libres_preferidos')) {
      context.handle(
          _diasLibresPreferidosMeta,
          diasLibresPreferidos.isAcceptableOrUnknown(
              data['dias_libres_preferidos']!, _diasLibresPreferidosMeta));
    }
    if (data.containsKey('saldo_compensacion')) {
      context.handle(
          _saldoCompensacionMeta,
          saldoCompensacion.isAcceptableOrUnknown(
              data['saldo_compensacion']!, _saldoCompensacionMeta));
    }
    if (data.containsKey('esta_activo')) {
      context.handle(
          _estaActivoMeta,
          estaActivo.isAcceptableOrUnknown(
              data['esta_activo']!, _estaActivoMeta));
    }
    if (data.containsKey('foto_path')) {
      context.handle(_fotoPathMeta,
          fotoPath.isAcceptableOrUnknown(data['foto_path']!, _fotoPathMeta));
    }
    if (data.containsKey('ultima_fecha_pernocta')) {
      context.handle(
          _ultimaFechaPernoctaMeta,
          ultimaFechaPernocta.isAcceptableOrUnknown(
              data['ultima_fecha_pernocta']!, _ultimaFechaPernoctaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Funcionario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Funcionario(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombres: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombres'])!,
      apellidos: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}apellidos'])!,
      cedula: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cedula'])!,
      rango: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rango']),
      rangoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rango_id']),
      fechaNacimiento: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_nacimiento']),
      fechaIngreso: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_ingreso']),
      telefono: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefono']),
      diasLaboralesSemanales: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}dias_laborales_semanales'])!,
      diasLibresPreferidos: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}dias_libres_preferidos']),
      saldoCompensacion: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}saldo_compensacion'])!,
      estaActivo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}esta_activo'])!,
      fotoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}foto_path']),
      ultimaFechaPernocta: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}ultima_fecha_pernocta']),
    );
  }

  @override
  $FuncionariosTable createAlias(String alias) {
    return $FuncionariosTable(attachedDatabase, alias);
  }
}

class Funcionario extends DataClass implements Insertable<Funcionario> {
  final int id;
  final String nombres;
  final String apellidos;
  final String cedula;
  final String? rango;
  final int? rangoId;
  final DateTime? fechaNacimiento;
  final DateTime? fechaIngreso;
  final String? telefono;
  final int diasLaboralesSemanales;
  final String? diasLibresPreferidos;
  final int saldoCompensacion;
  final bool estaActivo;
  final String? fotoPath;
  final DateTime? ultimaFechaPernocta;
  const Funcionario(
      {required this.id,
      required this.nombres,
      required this.apellidos,
      required this.cedula,
      this.rango,
      this.rangoId,
      this.fechaNacimiento,
      this.fechaIngreso,
      this.telefono,
      required this.diasLaboralesSemanales,
      this.diasLibresPreferidos,
      required this.saldoCompensacion,
      required this.estaActivo,
      this.fotoPath,
      this.ultimaFechaPernocta});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombres'] = Variable<String>(nombres);
    map['apellidos'] = Variable<String>(apellidos);
    map['cedula'] = Variable<String>(cedula);
    if (!nullToAbsent || rango != null) {
      map['rango'] = Variable<String>(rango);
    }
    if (!nullToAbsent || rangoId != null) {
      map['rango_id'] = Variable<int>(rangoId);
    }
    if (!nullToAbsent || fechaNacimiento != null) {
      map['fecha_nacimiento'] = Variable<DateTime>(fechaNacimiento);
    }
    if (!nullToAbsent || fechaIngreso != null) {
      map['fecha_ingreso'] = Variable<DateTime>(fechaIngreso);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    map['dias_laborales_semanales'] = Variable<int>(diasLaboralesSemanales);
    if (!nullToAbsent || diasLibresPreferidos != null) {
      map['dias_libres_preferidos'] = Variable<String>(diasLibresPreferidos);
    }
    map['saldo_compensacion'] = Variable<int>(saldoCompensacion);
    map['esta_activo'] = Variable<bool>(estaActivo);
    if (!nullToAbsent || fotoPath != null) {
      map['foto_path'] = Variable<String>(fotoPath);
    }
    if (!nullToAbsent || ultimaFechaPernocta != null) {
      map['ultima_fecha_pernocta'] = Variable<DateTime>(ultimaFechaPernocta);
    }
    return map;
  }

  FuncionariosCompanion toCompanion(bool nullToAbsent) {
    return FuncionariosCompanion(
      id: Value(id),
      nombres: Value(nombres),
      apellidos: Value(apellidos),
      cedula: Value(cedula),
      rango:
          rango == null && nullToAbsent ? const Value.absent() : Value(rango),
      rangoId: rangoId == null && nullToAbsent
          ? const Value.absent()
          : Value(rangoId),
      fechaNacimiento: fechaNacimiento == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaNacimiento),
      fechaIngreso: fechaIngreso == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaIngreso),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      diasLaboralesSemanales: Value(diasLaboralesSemanales),
      diasLibresPreferidos: diasLibresPreferidos == null && nullToAbsent
          ? const Value.absent()
          : Value(diasLibresPreferidos),
      saldoCompensacion: Value(saldoCompensacion),
      estaActivo: Value(estaActivo),
      fotoPath: fotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoPath),
      ultimaFechaPernocta: ultimaFechaPernocta == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimaFechaPernocta),
    );
  }

  factory Funcionario.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Funcionario(
      id: serializer.fromJson<int>(json['id']),
      nombres: serializer.fromJson<String>(json['nombres']),
      apellidos: serializer.fromJson<String>(json['apellidos']),
      cedula: serializer.fromJson<String>(json['cedula']),
      rango: serializer.fromJson<String?>(json['rango']),
      rangoId: serializer.fromJson<int?>(json['rangoId']),
      fechaNacimiento: serializer.fromJson<DateTime?>(json['fechaNacimiento']),
      fechaIngreso: serializer.fromJson<DateTime?>(json['fechaIngreso']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      diasLaboralesSemanales:
          serializer.fromJson<int>(json['diasLaboralesSemanales']),
      diasLibresPreferidos:
          serializer.fromJson<String?>(json['diasLibresPreferidos']),
      saldoCompensacion: serializer.fromJson<int>(json['saldoCompensacion']),
      estaActivo: serializer.fromJson<bool>(json['estaActivo']),
      fotoPath: serializer.fromJson<String?>(json['fotoPath']),
      ultimaFechaPernocta:
          serializer.fromJson<DateTime?>(json['ultimaFechaPernocta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombres': serializer.toJson<String>(nombres),
      'apellidos': serializer.toJson<String>(apellidos),
      'cedula': serializer.toJson<String>(cedula),
      'rango': serializer.toJson<String?>(rango),
      'rangoId': serializer.toJson<int?>(rangoId),
      'fechaNacimiento': serializer.toJson<DateTime?>(fechaNacimiento),
      'fechaIngreso': serializer.toJson<DateTime?>(fechaIngreso),
      'telefono': serializer.toJson<String?>(telefono),
      'diasLaboralesSemanales': serializer.toJson<int>(diasLaboralesSemanales),
      'diasLibresPreferidos': serializer.toJson<String?>(diasLibresPreferidos),
      'saldoCompensacion': serializer.toJson<int>(saldoCompensacion),
      'estaActivo': serializer.toJson<bool>(estaActivo),
      'fotoPath': serializer.toJson<String?>(fotoPath),
      'ultimaFechaPernocta': serializer.toJson<DateTime?>(ultimaFechaPernocta),
    };
  }

  Funcionario copyWith(
          {int? id,
          String? nombres,
          String? apellidos,
          String? cedula,
          Value<String?> rango = const Value.absent(),
          Value<int?> rangoId = const Value.absent(),
          Value<DateTime?> fechaNacimiento = const Value.absent(),
          Value<DateTime?> fechaIngreso = const Value.absent(),
          Value<String?> telefono = const Value.absent(),
          int? diasLaboralesSemanales,
          Value<String?> diasLibresPreferidos = const Value.absent(),
          int? saldoCompensacion,
          bool? estaActivo,
          Value<String?> fotoPath = const Value.absent(),
          Value<DateTime?> ultimaFechaPernocta = const Value.absent()}) =>
      Funcionario(
        id: id ?? this.id,
        nombres: nombres ?? this.nombres,
        apellidos: apellidos ?? this.apellidos,
        cedula: cedula ?? this.cedula,
        rango: rango.present ? rango.value : this.rango,
        rangoId: rangoId.present ? rangoId.value : this.rangoId,
        fechaNacimiento: fechaNacimiento.present
            ? fechaNacimiento.value
            : this.fechaNacimiento,
        fechaIngreso:
            fechaIngreso.present ? fechaIngreso.value : this.fechaIngreso,
        telefono: telefono.present ? telefono.value : this.telefono,
        diasLaboralesSemanales:
            diasLaboralesSemanales ?? this.diasLaboralesSemanales,
        diasLibresPreferidos: diasLibresPreferidos.present
            ? diasLibresPreferidos.value
            : this.diasLibresPreferidos,
        saldoCompensacion: saldoCompensacion ?? this.saldoCompensacion,
        estaActivo: estaActivo ?? this.estaActivo,
        fotoPath: fotoPath.present ? fotoPath.value : this.fotoPath,
        ultimaFechaPernocta: ultimaFechaPernocta.present
            ? ultimaFechaPernocta.value
            : this.ultimaFechaPernocta,
      );
  Funcionario copyWithCompanion(FuncionariosCompanion data) {
    return Funcionario(
      id: data.id.present ? data.id.value : this.id,
      nombres: data.nombres.present ? data.nombres.value : this.nombres,
      apellidos: data.apellidos.present ? data.apellidos.value : this.apellidos,
      cedula: data.cedula.present ? data.cedula.value : this.cedula,
      rango: data.rango.present ? data.rango.value : this.rango,
      rangoId: data.rangoId.present ? data.rangoId.value : this.rangoId,
      fechaNacimiento: data.fechaNacimiento.present
          ? data.fechaNacimiento.value
          : this.fechaNacimiento,
      fechaIngreso: data.fechaIngreso.present
          ? data.fechaIngreso.value
          : this.fechaIngreso,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      diasLaboralesSemanales: data.diasLaboralesSemanales.present
          ? data.diasLaboralesSemanales.value
          : this.diasLaboralesSemanales,
      diasLibresPreferidos: data.diasLibresPreferidos.present
          ? data.diasLibresPreferidos.value
          : this.diasLibresPreferidos,
      saldoCompensacion: data.saldoCompensacion.present
          ? data.saldoCompensacion.value
          : this.saldoCompensacion,
      estaActivo:
          data.estaActivo.present ? data.estaActivo.value : this.estaActivo,
      fotoPath: data.fotoPath.present ? data.fotoPath.value : this.fotoPath,
      ultimaFechaPernocta: data.ultimaFechaPernocta.present
          ? data.ultimaFechaPernocta.value
          : this.ultimaFechaPernocta,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Funcionario(')
          ..write('id: $id, ')
          ..write('nombres: $nombres, ')
          ..write('apellidos: $apellidos, ')
          ..write('cedula: $cedula, ')
          ..write('rango: $rango, ')
          ..write('rangoId: $rangoId, ')
          ..write('fechaNacimiento: $fechaNacimiento, ')
          ..write('fechaIngreso: $fechaIngreso, ')
          ..write('telefono: $telefono, ')
          ..write('diasLaboralesSemanales: $diasLaboralesSemanales, ')
          ..write('diasLibresPreferidos: $diasLibresPreferidos, ')
          ..write('saldoCompensacion: $saldoCompensacion, ')
          ..write('estaActivo: $estaActivo, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('ultimaFechaPernocta: $ultimaFechaPernocta')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      nombres,
      apellidos,
      cedula,
      rango,
      rangoId,
      fechaNacimiento,
      fechaIngreso,
      telefono,
      diasLaboralesSemanales,
      diasLibresPreferidos,
      saldoCompensacion,
      estaActivo,
      fotoPath,
      ultimaFechaPernocta);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Funcionario &&
          other.id == this.id &&
          other.nombres == this.nombres &&
          other.apellidos == this.apellidos &&
          other.cedula == this.cedula &&
          other.rango == this.rango &&
          other.rangoId == this.rangoId &&
          other.fechaNacimiento == this.fechaNacimiento &&
          other.fechaIngreso == this.fechaIngreso &&
          other.telefono == this.telefono &&
          other.diasLaboralesSemanales == this.diasLaboralesSemanales &&
          other.diasLibresPreferidos == this.diasLibresPreferidos &&
          other.saldoCompensacion == this.saldoCompensacion &&
          other.estaActivo == this.estaActivo &&
          other.fotoPath == this.fotoPath &&
          other.ultimaFechaPernocta == this.ultimaFechaPernocta);
}

class FuncionariosCompanion extends UpdateCompanion<Funcionario> {
  final Value<int> id;
  final Value<String> nombres;
  final Value<String> apellidos;
  final Value<String> cedula;
  final Value<String?> rango;
  final Value<int?> rangoId;
  final Value<DateTime?> fechaNacimiento;
  final Value<DateTime?> fechaIngreso;
  final Value<String?> telefono;
  final Value<int> diasLaboralesSemanales;
  final Value<String?> diasLibresPreferidos;
  final Value<int> saldoCompensacion;
  final Value<bool> estaActivo;
  final Value<String?> fotoPath;
  final Value<DateTime?> ultimaFechaPernocta;
  const FuncionariosCompanion({
    this.id = const Value.absent(),
    this.nombres = const Value.absent(),
    this.apellidos = const Value.absent(),
    this.cedula = const Value.absent(),
    this.rango = const Value.absent(),
    this.rangoId = const Value.absent(),
    this.fechaNacimiento = const Value.absent(),
    this.fechaIngreso = const Value.absent(),
    this.telefono = const Value.absent(),
    this.diasLaboralesSemanales = const Value.absent(),
    this.diasLibresPreferidos = const Value.absent(),
    this.saldoCompensacion = const Value.absent(),
    this.estaActivo = const Value.absent(),
    this.fotoPath = const Value.absent(),
    this.ultimaFechaPernocta = const Value.absent(),
  });
  FuncionariosCompanion.insert({
    this.id = const Value.absent(),
    required String nombres,
    required String apellidos,
    required String cedula,
    this.rango = const Value.absent(),
    this.rangoId = const Value.absent(),
    this.fechaNacimiento = const Value.absent(),
    this.fechaIngreso = const Value.absent(),
    this.telefono = const Value.absent(),
    this.diasLaboralesSemanales = const Value.absent(),
    this.diasLibresPreferidos = const Value.absent(),
    this.saldoCompensacion = const Value.absent(),
    this.estaActivo = const Value.absent(),
    this.fotoPath = const Value.absent(),
    this.ultimaFechaPernocta = const Value.absent(),
  })  : nombres = Value(nombres),
        apellidos = Value(apellidos),
        cedula = Value(cedula);
  static Insertable<Funcionario> custom({
    Expression<int>? id,
    Expression<String>? nombres,
    Expression<String>? apellidos,
    Expression<String>? cedula,
    Expression<String>? rango,
    Expression<int>? rangoId,
    Expression<DateTime>? fechaNacimiento,
    Expression<DateTime>? fechaIngreso,
    Expression<String>? telefono,
    Expression<int>? diasLaboralesSemanales,
    Expression<String>? diasLibresPreferidos,
    Expression<int>? saldoCompensacion,
    Expression<bool>? estaActivo,
    Expression<String>? fotoPath,
    Expression<DateTime>? ultimaFechaPernocta,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombres != null) 'nombres': nombres,
      if (apellidos != null) 'apellidos': apellidos,
      if (cedula != null) 'cedula': cedula,
      if (rango != null) 'rango': rango,
      if (rangoId != null) 'rango_id': rangoId,
      if (fechaNacimiento != null) 'fecha_nacimiento': fechaNacimiento,
      if (fechaIngreso != null) 'fecha_ingreso': fechaIngreso,
      if (telefono != null) 'telefono': telefono,
      if (diasLaboralesSemanales != null)
        'dias_laborales_semanales': diasLaboralesSemanales,
      if (diasLibresPreferidos != null)
        'dias_libres_preferidos': diasLibresPreferidos,
      if (saldoCompensacion != null) 'saldo_compensacion': saldoCompensacion,
      if (estaActivo != null) 'esta_activo': estaActivo,
      if (fotoPath != null) 'foto_path': fotoPath,
      if (ultimaFechaPernocta != null)
        'ultima_fecha_pernocta': ultimaFechaPernocta,
    });
  }

  FuncionariosCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombres,
      Value<String>? apellidos,
      Value<String>? cedula,
      Value<String?>? rango,
      Value<int?>? rangoId,
      Value<DateTime?>? fechaNacimiento,
      Value<DateTime?>? fechaIngreso,
      Value<String?>? telefono,
      Value<int>? diasLaboralesSemanales,
      Value<String?>? diasLibresPreferidos,
      Value<int>? saldoCompensacion,
      Value<bool>? estaActivo,
      Value<String?>? fotoPath,
      Value<DateTime?>? ultimaFechaPernocta}) {
    return FuncionariosCompanion(
      id: id ?? this.id,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      cedula: cedula ?? this.cedula,
      rango: rango ?? this.rango,
      rangoId: rangoId ?? this.rangoId,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      telefono: telefono ?? this.telefono,
      diasLaboralesSemanales:
          diasLaboralesSemanales ?? this.diasLaboralesSemanales,
      diasLibresPreferidos: diasLibresPreferidos ?? this.diasLibresPreferidos,
      saldoCompensacion: saldoCompensacion ?? this.saldoCompensacion,
      estaActivo: estaActivo ?? this.estaActivo,
      fotoPath: fotoPath ?? this.fotoPath,
      ultimaFechaPernocta: ultimaFechaPernocta ?? this.ultimaFechaPernocta,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombres.present) {
      map['nombres'] = Variable<String>(nombres.value);
    }
    if (apellidos.present) {
      map['apellidos'] = Variable<String>(apellidos.value);
    }
    if (cedula.present) {
      map['cedula'] = Variable<String>(cedula.value);
    }
    if (rango.present) {
      map['rango'] = Variable<String>(rango.value);
    }
    if (rangoId.present) {
      map['rango_id'] = Variable<int>(rangoId.value);
    }
    if (fechaNacimiento.present) {
      map['fecha_nacimiento'] = Variable<DateTime>(fechaNacimiento.value);
    }
    if (fechaIngreso.present) {
      map['fecha_ingreso'] = Variable<DateTime>(fechaIngreso.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (diasLaboralesSemanales.present) {
      map['dias_laborales_semanales'] =
          Variable<int>(diasLaboralesSemanales.value);
    }
    if (diasLibresPreferidos.present) {
      map['dias_libres_preferidos'] =
          Variable<String>(diasLibresPreferidos.value);
    }
    if (saldoCompensacion.present) {
      map['saldo_compensacion'] = Variable<int>(saldoCompensacion.value);
    }
    if (estaActivo.present) {
      map['esta_activo'] = Variable<bool>(estaActivo.value);
    }
    if (fotoPath.present) {
      map['foto_path'] = Variable<String>(fotoPath.value);
    }
    if (ultimaFechaPernocta.present) {
      map['ultima_fecha_pernocta'] =
          Variable<DateTime>(ultimaFechaPernocta.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FuncionariosCompanion(')
          ..write('id: $id, ')
          ..write('nombres: $nombres, ')
          ..write('apellidos: $apellidos, ')
          ..write('cedula: $cedula, ')
          ..write('rango: $rango, ')
          ..write('rangoId: $rangoId, ')
          ..write('fechaNacimiento: $fechaNacimiento, ')
          ..write('fechaIngreso: $fechaIngreso, ')
          ..write('telefono: $telefono, ')
          ..write('diasLaboralesSemanales: $diasLaboralesSemanales, ')
          ..write('diasLibresPreferidos: $diasLibresPreferidos, ')
          ..write('saldoCompensacion: $saldoCompensacion, ')
          ..write('estaActivo: $estaActivo, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('ultimaFechaPernocta: $ultimaFechaPernocta')
          ..write(')'))
        .toString();
  }
}

class $EstudiosAcademicosTable extends EstudiosAcademicos
    with TableInfo<$EstudiosAcademicosTable, EstudiosAcademico> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EstudiosAcademicosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _funcionarioIdMeta =
      const VerificationMeta('funcionarioId');
  @override
  late final GeneratedColumn<int> funcionarioId = GeneratedColumn<int>(
      'funcionario_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES funcionarios (id)'));
  static const VerificationMeta _gradoInstruccionMeta =
      const VerificationMeta('gradoInstruccion');
  @override
  late final GeneratedColumn<String> gradoInstruccion = GeneratedColumn<String>(
      'grado_instruccion', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tituloObtenidoMeta =
      const VerificationMeta('tituloObtenido');
  @override
  late final GeneratedColumn<String> tituloObtenido = GeneratedColumn<String>(
      'titulo_obtenido', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rutaPdfTituloMeta =
      const VerificationMeta('rutaPdfTitulo');
  @override
  late final GeneratedColumn<String> rutaPdfTitulo = GeneratedColumn<String>(
      'ruta_pdf_titulo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, funcionarioId, gradoInstruccion, tituloObtenido, rutaPdfTitulo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'estudios_academicos';
  @override
  VerificationContext validateIntegrity(Insertable<EstudiosAcademico> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('funcionario_id')) {
      context.handle(
          _funcionarioIdMeta,
          funcionarioId.isAcceptableOrUnknown(
              data['funcionario_id']!, _funcionarioIdMeta));
    } else if (isInserting) {
      context.missing(_funcionarioIdMeta);
    }
    if (data.containsKey('grado_instruccion')) {
      context.handle(
          _gradoInstruccionMeta,
          gradoInstruccion.isAcceptableOrUnknown(
              data['grado_instruccion']!, _gradoInstruccionMeta));
    } else if (isInserting) {
      context.missing(_gradoInstruccionMeta);
    }
    if (data.containsKey('titulo_obtenido')) {
      context.handle(
          _tituloObtenidoMeta,
          tituloObtenido.isAcceptableOrUnknown(
              data['titulo_obtenido']!, _tituloObtenidoMeta));
    } else if (isInserting) {
      context.missing(_tituloObtenidoMeta);
    }
    if (data.containsKey('ruta_pdf_titulo')) {
      context.handle(
          _rutaPdfTituloMeta,
          rutaPdfTitulo.isAcceptableOrUnknown(
              data['ruta_pdf_titulo']!, _rutaPdfTituloMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EstudiosAcademico map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EstudiosAcademico(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      funcionarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}funcionario_id'])!,
      gradoInstruccion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}grado_instruccion'])!,
      tituloObtenido: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}titulo_obtenido'])!,
      rutaPdfTitulo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ruta_pdf_titulo']),
    );
  }

  @override
  $EstudiosAcademicosTable createAlias(String alias) {
    return $EstudiosAcademicosTable(attachedDatabase, alias);
  }
}

class EstudiosAcademico extends DataClass
    implements Insertable<EstudiosAcademico> {
  final int id;
  final int funcionarioId;
  final String gradoInstruccion;
  final String tituloObtenido;
  final String? rutaPdfTitulo;
  const EstudiosAcademico(
      {required this.id,
      required this.funcionarioId,
      required this.gradoInstruccion,
      required this.tituloObtenido,
      this.rutaPdfTitulo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['funcionario_id'] = Variable<int>(funcionarioId);
    map['grado_instruccion'] = Variable<String>(gradoInstruccion);
    map['titulo_obtenido'] = Variable<String>(tituloObtenido);
    if (!nullToAbsent || rutaPdfTitulo != null) {
      map['ruta_pdf_titulo'] = Variable<String>(rutaPdfTitulo);
    }
    return map;
  }

  EstudiosAcademicosCompanion toCompanion(bool nullToAbsent) {
    return EstudiosAcademicosCompanion(
      id: Value(id),
      funcionarioId: Value(funcionarioId),
      gradoInstruccion: Value(gradoInstruccion),
      tituloObtenido: Value(tituloObtenido),
      rutaPdfTitulo: rutaPdfTitulo == null && nullToAbsent
          ? const Value.absent()
          : Value(rutaPdfTitulo),
    );
  }

  factory EstudiosAcademico.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EstudiosAcademico(
      id: serializer.fromJson<int>(json['id']),
      funcionarioId: serializer.fromJson<int>(json['funcionarioId']),
      gradoInstruccion: serializer.fromJson<String>(json['gradoInstruccion']),
      tituloObtenido: serializer.fromJson<String>(json['tituloObtenido']),
      rutaPdfTitulo: serializer.fromJson<String?>(json['rutaPdfTitulo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'funcionarioId': serializer.toJson<int>(funcionarioId),
      'gradoInstruccion': serializer.toJson<String>(gradoInstruccion),
      'tituloObtenido': serializer.toJson<String>(tituloObtenido),
      'rutaPdfTitulo': serializer.toJson<String?>(rutaPdfTitulo),
    };
  }

  EstudiosAcademico copyWith(
          {int? id,
          int? funcionarioId,
          String? gradoInstruccion,
          String? tituloObtenido,
          Value<String?> rutaPdfTitulo = const Value.absent()}) =>
      EstudiosAcademico(
        id: id ?? this.id,
        funcionarioId: funcionarioId ?? this.funcionarioId,
        gradoInstruccion: gradoInstruccion ?? this.gradoInstruccion,
        tituloObtenido: tituloObtenido ?? this.tituloObtenido,
        rutaPdfTitulo:
            rutaPdfTitulo.present ? rutaPdfTitulo.value : this.rutaPdfTitulo,
      );
  EstudiosAcademico copyWithCompanion(EstudiosAcademicosCompanion data) {
    return EstudiosAcademico(
      id: data.id.present ? data.id.value : this.id,
      funcionarioId: data.funcionarioId.present
          ? data.funcionarioId.value
          : this.funcionarioId,
      gradoInstruccion: data.gradoInstruccion.present
          ? data.gradoInstruccion.value
          : this.gradoInstruccion,
      tituloObtenido: data.tituloObtenido.present
          ? data.tituloObtenido.value
          : this.tituloObtenido,
      rutaPdfTitulo: data.rutaPdfTitulo.present
          ? data.rutaPdfTitulo.value
          : this.rutaPdfTitulo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EstudiosAcademico(')
          ..write('id: $id, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('gradoInstruccion: $gradoInstruccion, ')
          ..write('tituloObtenido: $tituloObtenido, ')
          ..write('rutaPdfTitulo: $rutaPdfTitulo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, funcionarioId, gradoInstruccion, tituloObtenido, rutaPdfTitulo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EstudiosAcademico &&
          other.id == this.id &&
          other.funcionarioId == this.funcionarioId &&
          other.gradoInstruccion == this.gradoInstruccion &&
          other.tituloObtenido == this.tituloObtenido &&
          other.rutaPdfTitulo == this.rutaPdfTitulo);
}

class EstudiosAcademicosCompanion extends UpdateCompanion<EstudiosAcademico> {
  final Value<int> id;
  final Value<int> funcionarioId;
  final Value<String> gradoInstruccion;
  final Value<String> tituloObtenido;
  final Value<String?> rutaPdfTitulo;
  const EstudiosAcademicosCompanion({
    this.id = const Value.absent(),
    this.funcionarioId = const Value.absent(),
    this.gradoInstruccion = const Value.absent(),
    this.tituloObtenido = const Value.absent(),
    this.rutaPdfTitulo = const Value.absent(),
  });
  EstudiosAcademicosCompanion.insert({
    this.id = const Value.absent(),
    required int funcionarioId,
    required String gradoInstruccion,
    required String tituloObtenido,
    this.rutaPdfTitulo = const Value.absent(),
  })  : funcionarioId = Value(funcionarioId),
        gradoInstruccion = Value(gradoInstruccion),
        tituloObtenido = Value(tituloObtenido);
  static Insertable<EstudiosAcademico> custom({
    Expression<int>? id,
    Expression<int>? funcionarioId,
    Expression<String>? gradoInstruccion,
    Expression<String>? tituloObtenido,
    Expression<String>? rutaPdfTitulo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (funcionarioId != null) 'funcionario_id': funcionarioId,
      if (gradoInstruccion != null) 'grado_instruccion': gradoInstruccion,
      if (tituloObtenido != null) 'titulo_obtenido': tituloObtenido,
      if (rutaPdfTitulo != null) 'ruta_pdf_titulo': rutaPdfTitulo,
    });
  }

  EstudiosAcademicosCompanion copyWith(
      {Value<int>? id,
      Value<int>? funcionarioId,
      Value<String>? gradoInstruccion,
      Value<String>? tituloObtenido,
      Value<String?>? rutaPdfTitulo}) {
    return EstudiosAcademicosCompanion(
      id: id ?? this.id,
      funcionarioId: funcionarioId ?? this.funcionarioId,
      gradoInstruccion: gradoInstruccion ?? this.gradoInstruccion,
      tituloObtenido: tituloObtenido ?? this.tituloObtenido,
      rutaPdfTitulo: rutaPdfTitulo ?? this.rutaPdfTitulo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (funcionarioId.present) {
      map['funcionario_id'] = Variable<int>(funcionarioId.value);
    }
    if (gradoInstruccion.present) {
      map['grado_instruccion'] = Variable<String>(gradoInstruccion.value);
    }
    if (tituloObtenido.present) {
      map['titulo_obtenido'] = Variable<String>(tituloObtenido.value);
    }
    if (rutaPdfTitulo.present) {
      map['ruta_pdf_titulo'] = Variable<String>(rutaPdfTitulo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EstudiosAcademicosCompanion(')
          ..write('id: $id, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('gradoInstruccion: $gradoInstruccion, ')
          ..write('tituloObtenido: $tituloObtenido, ')
          ..write('rutaPdfTitulo: $rutaPdfTitulo')
          ..write(')'))
        .toString();
  }
}

class $CursosCertificadosTable extends CursosCertificados
    with TableInfo<$CursosCertificadosTable, CursosCertificado> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CursosCertificadosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _funcionarioIdMeta =
      const VerificationMeta('funcionarioId');
  @override
  late final GeneratedColumn<int> funcionarioId = GeneratedColumn<int>(
      'funcionario_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES funcionarios (id)'));
  static const VerificationMeta _nombreCertificadoMeta =
      const VerificationMeta('nombreCertificado');
  @override
  late final GeneratedColumn<String> nombreCertificado =
      GeneratedColumn<String>('nombre_certificado', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rutaPdfCertificadoMeta =
      const VerificationMeta('rutaPdfCertificado');
  @override
  late final GeneratedColumn<String> rutaPdfCertificado =
      GeneratedColumn<String>('ruta_pdf_certificado', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, funcionarioId, nombreCertificado, rutaPdfCertificado];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cursos_certificados';
  @override
  VerificationContext validateIntegrity(Insertable<CursosCertificado> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('funcionario_id')) {
      context.handle(
          _funcionarioIdMeta,
          funcionarioId.isAcceptableOrUnknown(
              data['funcionario_id']!, _funcionarioIdMeta));
    } else if (isInserting) {
      context.missing(_funcionarioIdMeta);
    }
    if (data.containsKey('nombre_certificado')) {
      context.handle(
          _nombreCertificadoMeta,
          nombreCertificado.isAcceptableOrUnknown(
              data['nombre_certificado']!, _nombreCertificadoMeta));
    } else if (isInserting) {
      context.missing(_nombreCertificadoMeta);
    }
    if (data.containsKey('ruta_pdf_certificado')) {
      context.handle(
          _rutaPdfCertificadoMeta,
          rutaPdfCertificado.isAcceptableOrUnknown(
              data['ruta_pdf_certificado']!, _rutaPdfCertificadoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CursosCertificado map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CursosCertificado(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      funcionarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}funcionario_id'])!,
      nombreCertificado: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}nombre_certificado'])!,
      rutaPdfCertificado: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ruta_pdf_certificado']),
    );
  }

  @override
  $CursosCertificadosTable createAlias(String alias) {
    return $CursosCertificadosTable(attachedDatabase, alias);
  }
}

class CursosCertificado extends DataClass
    implements Insertable<CursosCertificado> {
  final int id;
  final int funcionarioId;
  final String nombreCertificado;
  final String? rutaPdfCertificado;
  const CursosCertificado(
      {required this.id,
      required this.funcionarioId,
      required this.nombreCertificado,
      this.rutaPdfCertificado});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['funcionario_id'] = Variable<int>(funcionarioId);
    map['nombre_certificado'] = Variable<String>(nombreCertificado);
    if (!nullToAbsent || rutaPdfCertificado != null) {
      map['ruta_pdf_certificado'] = Variable<String>(rutaPdfCertificado);
    }
    return map;
  }

  CursosCertificadosCompanion toCompanion(bool nullToAbsent) {
    return CursosCertificadosCompanion(
      id: Value(id),
      funcionarioId: Value(funcionarioId),
      nombreCertificado: Value(nombreCertificado),
      rutaPdfCertificado: rutaPdfCertificado == null && nullToAbsent
          ? const Value.absent()
          : Value(rutaPdfCertificado),
    );
  }

  factory CursosCertificado.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CursosCertificado(
      id: serializer.fromJson<int>(json['id']),
      funcionarioId: serializer.fromJson<int>(json['funcionarioId']),
      nombreCertificado: serializer.fromJson<String>(json['nombreCertificado']),
      rutaPdfCertificado:
          serializer.fromJson<String?>(json['rutaPdfCertificado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'funcionarioId': serializer.toJson<int>(funcionarioId),
      'nombreCertificado': serializer.toJson<String>(nombreCertificado),
      'rutaPdfCertificado': serializer.toJson<String?>(rutaPdfCertificado),
    };
  }

  CursosCertificado copyWith(
          {int? id,
          int? funcionarioId,
          String? nombreCertificado,
          Value<String?> rutaPdfCertificado = const Value.absent()}) =>
      CursosCertificado(
        id: id ?? this.id,
        funcionarioId: funcionarioId ?? this.funcionarioId,
        nombreCertificado: nombreCertificado ?? this.nombreCertificado,
        rutaPdfCertificado: rutaPdfCertificado.present
            ? rutaPdfCertificado.value
            : this.rutaPdfCertificado,
      );
  CursosCertificado copyWithCompanion(CursosCertificadosCompanion data) {
    return CursosCertificado(
      id: data.id.present ? data.id.value : this.id,
      funcionarioId: data.funcionarioId.present
          ? data.funcionarioId.value
          : this.funcionarioId,
      nombreCertificado: data.nombreCertificado.present
          ? data.nombreCertificado.value
          : this.nombreCertificado,
      rutaPdfCertificado: data.rutaPdfCertificado.present
          ? data.rutaPdfCertificado.value
          : this.rutaPdfCertificado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CursosCertificado(')
          ..write('id: $id, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('nombreCertificado: $nombreCertificado, ')
          ..write('rutaPdfCertificado: $rutaPdfCertificado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, funcionarioId, nombreCertificado, rutaPdfCertificado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CursosCertificado &&
          other.id == this.id &&
          other.funcionarioId == this.funcionarioId &&
          other.nombreCertificado == this.nombreCertificado &&
          other.rutaPdfCertificado == this.rutaPdfCertificado);
}

class CursosCertificadosCompanion extends UpdateCompanion<CursosCertificado> {
  final Value<int> id;
  final Value<int> funcionarioId;
  final Value<String> nombreCertificado;
  final Value<String?> rutaPdfCertificado;
  const CursosCertificadosCompanion({
    this.id = const Value.absent(),
    this.funcionarioId = const Value.absent(),
    this.nombreCertificado = const Value.absent(),
    this.rutaPdfCertificado = const Value.absent(),
  });
  CursosCertificadosCompanion.insert({
    this.id = const Value.absent(),
    required int funcionarioId,
    required String nombreCertificado,
    this.rutaPdfCertificado = const Value.absent(),
  })  : funcionarioId = Value(funcionarioId),
        nombreCertificado = Value(nombreCertificado);
  static Insertable<CursosCertificado> custom({
    Expression<int>? id,
    Expression<int>? funcionarioId,
    Expression<String>? nombreCertificado,
    Expression<String>? rutaPdfCertificado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (funcionarioId != null) 'funcionario_id': funcionarioId,
      if (nombreCertificado != null) 'nombre_certificado': nombreCertificado,
      if (rutaPdfCertificado != null)
        'ruta_pdf_certificado': rutaPdfCertificado,
    });
  }

  CursosCertificadosCompanion copyWith(
      {Value<int>? id,
      Value<int>? funcionarioId,
      Value<String>? nombreCertificado,
      Value<String?>? rutaPdfCertificado}) {
    return CursosCertificadosCompanion(
      id: id ?? this.id,
      funcionarioId: funcionarioId ?? this.funcionarioId,
      nombreCertificado: nombreCertificado ?? this.nombreCertificado,
      rutaPdfCertificado: rutaPdfCertificado ?? this.rutaPdfCertificado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (funcionarioId.present) {
      map['funcionario_id'] = Variable<int>(funcionarioId.value);
    }
    if (nombreCertificado.present) {
      map['nombre_certificado'] = Variable<String>(nombreCertificado.value);
    }
    if (rutaPdfCertificado.present) {
      map['ruta_pdf_certificado'] = Variable<String>(rutaPdfCertificado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CursosCertificadosCompanion(')
          ..write('id: $id, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('nombreCertificado: $nombreCertificado, ')
          ..write('rutaPdfCertificado: $rutaPdfCertificado')
          ..write(')'))
        .toString();
  }
}

class $FamiliaresTable extends Familiares
    with TableInfo<$FamiliaresTable, Familiare> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamiliaresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _funcionarioIdMeta =
      const VerificationMeta('funcionarioId');
  @override
  late final GeneratedColumn<int> funcionarioId = GeneratedColumn<int>(
      'funcionario_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES funcionarios (id)'));
  static const VerificationMeta _nombresMeta =
      const VerificationMeta('nombres');
  @override
  late final GeneratedColumn<String> nombres = GeneratedColumn<String>(
      'nombres', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _apellidosMeta =
      const VerificationMeta('apellidos');
  @override
  late final GeneratedColumn<String> apellidos = GeneratedColumn<String>(
      'apellidos', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cedulaMeta = const VerificationMeta('cedula');
  @override
  late final GeneratedColumn<String> cedula = GeneratedColumn<String>(
      'cedula', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _edadMeta = const VerificationMeta('edad');
  @override
  late final GeneratedColumn<int> edad = GeneratedColumn<int>(
      'edad', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _telefonoMeta =
      const VerificationMeta('telefono');
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
      'telefono', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parentescoMeta =
      const VerificationMeta('parentesco');
  @override
  late final GeneratedColumn<String> parentesco = GeneratedColumn<String>(
      'parentesco', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Cónyuge'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        funcionarioId,
        nombres,
        apellidos,
        cedula,
        edad,
        telefono,
        parentesco
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'familiares';
  @override
  VerificationContext validateIntegrity(Insertable<Familiare> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('funcionario_id')) {
      context.handle(
          _funcionarioIdMeta,
          funcionarioId.isAcceptableOrUnknown(
              data['funcionario_id']!, _funcionarioIdMeta));
    } else if (isInserting) {
      context.missing(_funcionarioIdMeta);
    }
    if (data.containsKey('nombres')) {
      context.handle(_nombresMeta,
          nombres.isAcceptableOrUnknown(data['nombres']!, _nombresMeta));
    } else if (isInserting) {
      context.missing(_nombresMeta);
    }
    if (data.containsKey('apellidos')) {
      context.handle(_apellidosMeta,
          apellidos.isAcceptableOrUnknown(data['apellidos']!, _apellidosMeta));
    } else if (isInserting) {
      context.missing(_apellidosMeta);
    }
    if (data.containsKey('cedula')) {
      context.handle(_cedulaMeta,
          cedula.isAcceptableOrUnknown(data['cedula']!, _cedulaMeta));
    } else if (isInserting) {
      context.missing(_cedulaMeta);
    }
    if (data.containsKey('edad')) {
      context.handle(
          _edadMeta, edad.isAcceptableOrUnknown(data['edad']!, _edadMeta));
    } else if (isInserting) {
      context.missing(_edadMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(_telefonoMeta,
          telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta));
    }
    if (data.containsKey('parentesco')) {
      context.handle(
          _parentescoMeta,
          parentesco.isAcceptableOrUnknown(
              data['parentesco']!, _parentescoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Familiare map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Familiare(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      funcionarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}funcionario_id'])!,
      nombres: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombres'])!,
      apellidos: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}apellidos'])!,
      cedula: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cedula'])!,
      edad: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}edad'])!,
      telefono: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefono']),
      parentesco: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parentesco'])!,
    );
  }

  @override
  $FamiliaresTable createAlias(String alias) {
    return $FamiliaresTable(attachedDatabase, alias);
  }
}

class Familiare extends DataClass implements Insertable<Familiare> {
  final int id;
  final int funcionarioId;
  final String nombres;
  final String apellidos;
  final String cedula;
  final int edad;
  final String? telefono;
  final String parentesco;
  const Familiare(
      {required this.id,
      required this.funcionarioId,
      required this.nombres,
      required this.apellidos,
      required this.cedula,
      required this.edad,
      this.telefono,
      required this.parentesco});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['funcionario_id'] = Variable<int>(funcionarioId);
    map['nombres'] = Variable<String>(nombres);
    map['apellidos'] = Variable<String>(apellidos);
    map['cedula'] = Variable<String>(cedula);
    map['edad'] = Variable<int>(edad);
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    map['parentesco'] = Variable<String>(parentesco);
    return map;
  }

  FamiliaresCompanion toCompanion(bool nullToAbsent) {
    return FamiliaresCompanion(
      id: Value(id),
      funcionarioId: Value(funcionarioId),
      nombres: Value(nombres),
      apellidos: Value(apellidos),
      cedula: Value(cedula),
      edad: Value(edad),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      parentesco: Value(parentesco),
    );
  }

  factory Familiare.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Familiare(
      id: serializer.fromJson<int>(json['id']),
      funcionarioId: serializer.fromJson<int>(json['funcionarioId']),
      nombres: serializer.fromJson<String>(json['nombres']),
      apellidos: serializer.fromJson<String>(json['apellidos']),
      cedula: serializer.fromJson<String>(json['cedula']),
      edad: serializer.fromJson<int>(json['edad']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      parentesco: serializer.fromJson<String>(json['parentesco']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'funcionarioId': serializer.toJson<int>(funcionarioId),
      'nombres': serializer.toJson<String>(nombres),
      'apellidos': serializer.toJson<String>(apellidos),
      'cedula': serializer.toJson<String>(cedula),
      'edad': serializer.toJson<int>(edad),
      'telefono': serializer.toJson<String?>(telefono),
      'parentesco': serializer.toJson<String>(parentesco),
    };
  }

  Familiare copyWith(
          {int? id,
          int? funcionarioId,
          String? nombres,
          String? apellidos,
          String? cedula,
          int? edad,
          Value<String?> telefono = const Value.absent(),
          String? parentesco}) =>
      Familiare(
        id: id ?? this.id,
        funcionarioId: funcionarioId ?? this.funcionarioId,
        nombres: nombres ?? this.nombres,
        apellidos: apellidos ?? this.apellidos,
        cedula: cedula ?? this.cedula,
        edad: edad ?? this.edad,
        telefono: telefono.present ? telefono.value : this.telefono,
        parentesco: parentesco ?? this.parentesco,
      );
  Familiare copyWithCompanion(FamiliaresCompanion data) {
    return Familiare(
      id: data.id.present ? data.id.value : this.id,
      funcionarioId: data.funcionarioId.present
          ? data.funcionarioId.value
          : this.funcionarioId,
      nombres: data.nombres.present ? data.nombres.value : this.nombres,
      apellidos: data.apellidos.present ? data.apellidos.value : this.apellidos,
      cedula: data.cedula.present ? data.cedula.value : this.cedula,
      edad: data.edad.present ? data.edad.value : this.edad,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      parentesco:
          data.parentesco.present ? data.parentesco.value : this.parentesco,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Familiare(')
          ..write('id: $id, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('nombres: $nombres, ')
          ..write('apellidos: $apellidos, ')
          ..write('cedula: $cedula, ')
          ..write('edad: $edad, ')
          ..write('telefono: $telefono, ')
          ..write('parentesco: $parentesco')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, funcionarioId, nombres, apellidos, cedula,
      edad, telefono, parentesco);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Familiare &&
          other.id == this.id &&
          other.funcionarioId == this.funcionarioId &&
          other.nombres == this.nombres &&
          other.apellidos == this.apellidos &&
          other.cedula == this.cedula &&
          other.edad == this.edad &&
          other.telefono == this.telefono &&
          other.parentesco == this.parentesco);
}

class FamiliaresCompanion extends UpdateCompanion<Familiare> {
  final Value<int> id;
  final Value<int> funcionarioId;
  final Value<String> nombres;
  final Value<String> apellidos;
  final Value<String> cedula;
  final Value<int> edad;
  final Value<String?> telefono;
  final Value<String> parentesco;
  const FamiliaresCompanion({
    this.id = const Value.absent(),
    this.funcionarioId = const Value.absent(),
    this.nombres = const Value.absent(),
    this.apellidos = const Value.absent(),
    this.cedula = const Value.absent(),
    this.edad = const Value.absent(),
    this.telefono = const Value.absent(),
    this.parentesco = const Value.absent(),
  });
  FamiliaresCompanion.insert({
    this.id = const Value.absent(),
    required int funcionarioId,
    required String nombres,
    required String apellidos,
    required String cedula,
    required int edad,
    this.telefono = const Value.absent(),
    this.parentesco = const Value.absent(),
  })  : funcionarioId = Value(funcionarioId),
        nombres = Value(nombres),
        apellidos = Value(apellidos),
        cedula = Value(cedula),
        edad = Value(edad);
  static Insertable<Familiare> custom({
    Expression<int>? id,
    Expression<int>? funcionarioId,
    Expression<String>? nombres,
    Expression<String>? apellidos,
    Expression<String>? cedula,
    Expression<int>? edad,
    Expression<String>? telefono,
    Expression<String>? parentesco,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (funcionarioId != null) 'funcionario_id': funcionarioId,
      if (nombres != null) 'nombres': nombres,
      if (apellidos != null) 'apellidos': apellidos,
      if (cedula != null) 'cedula': cedula,
      if (edad != null) 'edad': edad,
      if (telefono != null) 'telefono': telefono,
      if (parentesco != null) 'parentesco': parentesco,
    });
  }

  FamiliaresCompanion copyWith(
      {Value<int>? id,
      Value<int>? funcionarioId,
      Value<String>? nombres,
      Value<String>? apellidos,
      Value<String>? cedula,
      Value<int>? edad,
      Value<String?>? telefono,
      Value<String>? parentesco}) {
    return FamiliaresCompanion(
      id: id ?? this.id,
      funcionarioId: funcionarioId ?? this.funcionarioId,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      cedula: cedula ?? this.cedula,
      edad: edad ?? this.edad,
      telefono: telefono ?? this.telefono,
      parentesco: parentesco ?? this.parentesco,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (funcionarioId.present) {
      map['funcionario_id'] = Variable<int>(funcionarioId.value);
    }
    if (nombres.present) {
      map['nombres'] = Variable<String>(nombres.value);
    }
    if (apellidos.present) {
      map['apellidos'] = Variable<String>(apellidos.value);
    }
    if (cedula.present) {
      map['cedula'] = Variable<String>(cedula.value);
    }
    if (edad.present) {
      map['edad'] = Variable<int>(edad.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (parentesco.present) {
      map['parentesco'] = Variable<String>(parentesco.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamiliaresCompanion(')
          ..write('id: $id, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('nombres: $nombres, ')
          ..write('apellidos: $apellidos, ')
          ..write('cedula: $cedula, ')
          ..write('edad: $edad, ')
          ..write('telefono: $telefono, ')
          ..write('parentesco: $parentesco')
          ..write(')'))
        .toString();
  }
}

class $HijosTable extends Hijos with TableInfo<$HijosTable, Hijo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HijosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _funcionarioIdMeta =
      const VerificationMeta('funcionarioId');
  @override
  late final GeneratedColumn<int> funcionarioId = GeneratedColumn<int>(
      'funcionario_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES funcionarios (id)'));
  static const VerificationMeta _nombresMeta =
      const VerificationMeta('nombres');
  @override
  late final GeneratedColumn<String> nombres = GeneratedColumn<String>(
      'nombres', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _apellidosMeta =
      const VerificationMeta('apellidos');
  @override
  late final GeneratedColumn<String> apellidos = GeneratedColumn<String>(
      'apellidos', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _edadMeta = const VerificationMeta('edad');
  @override
  late final GeneratedColumn<int> edad = GeneratedColumn<int>(
      'edad', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, funcionarioId, nombres, apellidos, edad];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hijos';
  @override
  VerificationContext validateIntegrity(Insertable<Hijo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('funcionario_id')) {
      context.handle(
          _funcionarioIdMeta,
          funcionarioId.isAcceptableOrUnknown(
              data['funcionario_id']!, _funcionarioIdMeta));
    } else if (isInserting) {
      context.missing(_funcionarioIdMeta);
    }
    if (data.containsKey('nombres')) {
      context.handle(_nombresMeta,
          nombres.isAcceptableOrUnknown(data['nombres']!, _nombresMeta));
    } else if (isInserting) {
      context.missing(_nombresMeta);
    }
    if (data.containsKey('apellidos')) {
      context.handle(_apellidosMeta,
          apellidos.isAcceptableOrUnknown(data['apellidos']!, _apellidosMeta));
    } else if (isInserting) {
      context.missing(_apellidosMeta);
    }
    if (data.containsKey('edad')) {
      context.handle(
          _edadMeta, edad.isAcceptableOrUnknown(data['edad']!, _edadMeta));
    } else if (isInserting) {
      context.missing(_edadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Hijo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hijo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      funcionarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}funcionario_id'])!,
      nombres: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombres'])!,
      apellidos: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}apellidos'])!,
      edad: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}edad'])!,
    );
  }

  @override
  $HijosTable createAlias(String alias) {
    return $HijosTable(attachedDatabase, alias);
  }
}

class Hijo extends DataClass implements Insertable<Hijo> {
  final int id;
  final int funcionarioId;
  final String nombres;
  final String apellidos;
  final int edad;
  const Hijo(
      {required this.id,
      required this.funcionarioId,
      required this.nombres,
      required this.apellidos,
      required this.edad});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['funcionario_id'] = Variable<int>(funcionarioId);
    map['nombres'] = Variable<String>(nombres);
    map['apellidos'] = Variable<String>(apellidos);
    map['edad'] = Variable<int>(edad);
    return map;
  }

  HijosCompanion toCompanion(bool nullToAbsent) {
    return HijosCompanion(
      id: Value(id),
      funcionarioId: Value(funcionarioId),
      nombres: Value(nombres),
      apellidos: Value(apellidos),
      edad: Value(edad),
    );
  }

  factory Hijo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Hijo(
      id: serializer.fromJson<int>(json['id']),
      funcionarioId: serializer.fromJson<int>(json['funcionarioId']),
      nombres: serializer.fromJson<String>(json['nombres']),
      apellidos: serializer.fromJson<String>(json['apellidos']),
      edad: serializer.fromJson<int>(json['edad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'funcionarioId': serializer.toJson<int>(funcionarioId),
      'nombres': serializer.toJson<String>(nombres),
      'apellidos': serializer.toJson<String>(apellidos),
      'edad': serializer.toJson<int>(edad),
    };
  }

  Hijo copyWith(
          {int? id,
          int? funcionarioId,
          String? nombres,
          String? apellidos,
          int? edad}) =>
      Hijo(
        id: id ?? this.id,
        funcionarioId: funcionarioId ?? this.funcionarioId,
        nombres: nombres ?? this.nombres,
        apellidos: apellidos ?? this.apellidos,
        edad: edad ?? this.edad,
      );
  Hijo copyWithCompanion(HijosCompanion data) {
    return Hijo(
      id: data.id.present ? data.id.value : this.id,
      funcionarioId: data.funcionarioId.present
          ? data.funcionarioId.value
          : this.funcionarioId,
      nombres: data.nombres.present ? data.nombres.value : this.nombres,
      apellidos: data.apellidos.present ? data.apellidos.value : this.apellidos,
      edad: data.edad.present ? data.edad.value : this.edad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Hijo(')
          ..write('id: $id, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('nombres: $nombres, ')
          ..write('apellidos: $apellidos, ')
          ..write('edad: $edad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, funcionarioId, nombres, apellidos, edad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hijo &&
          other.id == this.id &&
          other.funcionarioId == this.funcionarioId &&
          other.nombres == this.nombres &&
          other.apellidos == this.apellidos &&
          other.edad == this.edad);
}

class HijosCompanion extends UpdateCompanion<Hijo> {
  final Value<int> id;
  final Value<int> funcionarioId;
  final Value<String> nombres;
  final Value<String> apellidos;
  final Value<int> edad;
  const HijosCompanion({
    this.id = const Value.absent(),
    this.funcionarioId = const Value.absent(),
    this.nombres = const Value.absent(),
    this.apellidos = const Value.absent(),
    this.edad = const Value.absent(),
  });
  HijosCompanion.insert({
    this.id = const Value.absent(),
    required int funcionarioId,
    required String nombres,
    required String apellidos,
    required int edad,
  })  : funcionarioId = Value(funcionarioId),
        nombres = Value(nombres),
        apellidos = Value(apellidos),
        edad = Value(edad);
  static Insertable<Hijo> custom({
    Expression<int>? id,
    Expression<int>? funcionarioId,
    Expression<String>? nombres,
    Expression<String>? apellidos,
    Expression<int>? edad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (funcionarioId != null) 'funcionario_id': funcionarioId,
      if (nombres != null) 'nombres': nombres,
      if (apellidos != null) 'apellidos': apellidos,
      if (edad != null) 'edad': edad,
    });
  }

  HijosCompanion copyWith(
      {Value<int>? id,
      Value<int>? funcionarioId,
      Value<String>? nombres,
      Value<String>? apellidos,
      Value<int>? edad}) {
    return HijosCompanion(
      id: id ?? this.id,
      funcionarioId: funcionarioId ?? this.funcionarioId,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      edad: edad ?? this.edad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (funcionarioId.present) {
      map['funcionario_id'] = Variable<int>(funcionarioId.value);
    }
    if (nombres.present) {
      map['nombres'] = Variable<String>(nombres.value);
    }
    if (apellidos.present) {
      map['apellidos'] = Variable<String>(apellidos.value);
    }
    if (edad.present) {
      map['edad'] = Variable<int>(edad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HijosCompanion(')
          ..write('id: $id, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('nombres: $nombres, ')
          ..write('apellidos: $apellidos, ')
          ..write('edad: $edad')
          ..write(')'))
        .toString();
  }
}

class $ActividadesTable extends Actividades
    with TableInfo<$ActividadesTable, Actividade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActividadesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _planificacionIdMeta =
      const VerificationMeta('planificacionId');
  @override
  late final GeneratedColumn<int> planificacionId = GeneratedColumn<int>(
      'planificacion_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES planificaciones_semanales (id)'));
  static const VerificationMeta _tipoGuardiaIdMeta =
      const VerificationMeta('tipoGuardiaId');
  @override
  late final GeneratedColumn<int> tipoGuardiaId = GeneratedColumn<int>(
      'tipo_guardia_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tipos_guardia (id)'));
  static const VerificationMeta _nombreActividadMeta =
      const VerificationMeta('nombreActividad');
  @override
  late final GeneratedColumn<String> nombreActividad = GeneratedColumn<String>(
      'nombre_actividad', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
      'fecha', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _fechaFinMeta =
      const VerificationMeta('fechaFin');
  @override
  late final GeneratedColumn<DateTime> fechaFin = GeneratedColumn<DateTime>(
      'fecha_fin', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lugarMeta = const VerificationMeta('lugar');
  @override
  late final GeneratedColumn<String> lugar = GeneratedColumn<String>(
      'lugar', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoriaMeta =
      const VerificationMeta('categoria');
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
      'categoria', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Normal'));
  static const VerificationMeta _jefeServicioIdMeta =
      const VerificationMeta('jefeServicioId');
  @override
  late final GeneratedColumn<int> jefeServicioId = GeneratedColumn<int>(
      'jefe_servicio_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES funcionarios (id)'));
  static const VerificationMeta _esPernoctaMeta =
      const VerificationMeta('esPernocta');
  @override
  late final GeneratedColumn<bool> esPernocta = GeneratedColumn<bool>(
      'es_pernocta', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("es_pernocta" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _diasDescansoGeneradosMeta =
      const VerificationMeta('diasDescansoGenerados');
  @override
  late final GeneratedColumn<int> diasDescansoGenerados = GeneratedColumn<int>(
      'dias_descanso_generados', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        planificacionId,
        tipoGuardiaId,
        nombreActividad,
        fecha,
        fechaFin,
        lugar,
        categoria,
        jefeServicioId,
        esPernocta,
        diasDescansoGenerados
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'actividades';
  @override
  VerificationContext validateIntegrity(Insertable<Actividade> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('planificacion_id')) {
      context.handle(
          _planificacionIdMeta,
          planificacionId.isAcceptableOrUnknown(
              data['planificacion_id']!, _planificacionIdMeta));
    }
    if (data.containsKey('tipo_guardia_id')) {
      context.handle(
          _tipoGuardiaIdMeta,
          tipoGuardiaId.isAcceptableOrUnknown(
              data['tipo_guardia_id']!, _tipoGuardiaIdMeta));
    }
    if (data.containsKey('nombre_actividad')) {
      context.handle(
          _nombreActividadMeta,
          nombreActividad.isAcceptableOrUnknown(
              data['nombre_actividad']!, _nombreActividadMeta));
    } else if (isInserting) {
      context.missing(_nombreActividadMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('fecha_fin')) {
      context.handle(_fechaFinMeta,
          fechaFin.isAcceptableOrUnknown(data['fecha_fin']!, _fechaFinMeta));
    }
    if (data.containsKey('lugar')) {
      context.handle(
          _lugarMeta, lugar.isAcceptableOrUnknown(data['lugar']!, _lugarMeta));
    } else if (isInserting) {
      context.missing(_lugarMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(_categoriaMeta,
          categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta));
    }
    if (data.containsKey('jefe_servicio_id')) {
      context.handle(
          _jefeServicioIdMeta,
          jefeServicioId.isAcceptableOrUnknown(
              data['jefe_servicio_id']!, _jefeServicioIdMeta));
    }
    if (data.containsKey('es_pernocta')) {
      context.handle(
          _esPernoctaMeta,
          esPernocta.isAcceptableOrUnknown(
              data['es_pernocta']!, _esPernoctaMeta));
    }
    if (data.containsKey('dias_descanso_generados')) {
      context.handle(
          _diasDescansoGeneradosMeta,
          diasDescansoGenerados.isAcceptableOrUnknown(
              data['dias_descanso_generados']!, _diasDescansoGeneradosMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Actividade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Actividade(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      planificacionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}planificacion_id']),
      tipoGuardiaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tipo_guardia_id']),
      nombreActividad: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}nombre_actividad'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha'])!,
      fechaFin: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_fin']),
      lugar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lugar'])!,
      categoria: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}categoria'])!,
      jefeServicioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jefe_servicio_id']),
      esPernocta: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}es_pernocta'])!,
      diasDescansoGenerados: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}dias_descanso_generados'])!,
    );
  }

  @override
  $ActividadesTable createAlias(String alias) {
    return $ActividadesTable(attachedDatabase, alias);
  }
}

class Actividade extends DataClass implements Insertable<Actividade> {
  final int id;
  final int? planificacionId;
  final int? tipoGuardiaId;
  final String nombreActividad;
  final DateTime fecha;
  final DateTime? fechaFin;
  final String lugar;
  final String categoria;
  final int? jefeServicioId;
  final bool esPernocta;
  final int diasDescansoGenerados;
  const Actividade(
      {required this.id,
      this.planificacionId,
      this.tipoGuardiaId,
      required this.nombreActividad,
      required this.fecha,
      this.fechaFin,
      required this.lugar,
      required this.categoria,
      this.jefeServicioId,
      required this.esPernocta,
      required this.diasDescansoGenerados});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || planificacionId != null) {
      map['planificacion_id'] = Variable<int>(planificacionId);
    }
    if (!nullToAbsent || tipoGuardiaId != null) {
      map['tipo_guardia_id'] = Variable<int>(tipoGuardiaId);
    }
    map['nombre_actividad'] = Variable<String>(nombreActividad);
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || fechaFin != null) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin);
    }
    map['lugar'] = Variable<String>(lugar);
    map['categoria'] = Variable<String>(categoria);
    if (!nullToAbsent || jefeServicioId != null) {
      map['jefe_servicio_id'] = Variable<int>(jefeServicioId);
    }
    map['es_pernocta'] = Variable<bool>(esPernocta);
    map['dias_descanso_generados'] = Variable<int>(diasDescansoGenerados);
    return map;
  }

  ActividadesCompanion toCompanion(bool nullToAbsent) {
    return ActividadesCompanion(
      id: Value(id),
      planificacionId: planificacionId == null && nullToAbsent
          ? const Value.absent()
          : Value(planificacionId),
      tipoGuardiaId: tipoGuardiaId == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoGuardiaId),
      nombreActividad: Value(nombreActividad),
      fecha: Value(fecha),
      fechaFin: fechaFin == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaFin),
      lugar: Value(lugar),
      categoria: Value(categoria),
      jefeServicioId: jefeServicioId == null && nullToAbsent
          ? const Value.absent()
          : Value(jefeServicioId),
      esPernocta: Value(esPernocta),
      diasDescansoGenerados: Value(diasDescansoGenerados),
    );
  }

  factory Actividade.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Actividade(
      id: serializer.fromJson<int>(json['id']),
      planificacionId: serializer.fromJson<int?>(json['planificacionId']),
      tipoGuardiaId: serializer.fromJson<int?>(json['tipoGuardiaId']),
      nombreActividad: serializer.fromJson<String>(json['nombreActividad']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      fechaFin: serializer.fromJson<DateTime?>(json['fechaFin']),
      lugar: serializer.fromJson<String>(json['lugar']),
      categoria: serializer.fromJson<String>(json['categoria']),
      jefeServicioId: serializer.fromJson<int?>(json['jefeServicioId']),
      esPernocta: serializer.fromJson<bool>(json['esPernocta']),
      diasDescansoGenerados:
          serializer.fromJson<int>(json['diasDescansoGenerados']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planificacionId': serializer.toJson<int?>(planificacionId),
      'tipoGuardiaId': serializer.toJson<int?>(tipoGuardiaId),
      'nombreActividad': serializer.toJson<String>(nombreActividad),
      'fecha': serializer.toJson<DateTime>(fecha),
      'fechaFin': serializer.toJson<DateTime?>(fechaFin),
      'lugar': serializer.toJson<String>(lugar),
      'categoria': serializer.toJson<String>(categoria),
      'jefeServicioId': serializer.toJson<int?>(jefeServicioId),
      'esPernocta': serializer.toJson<bool>(esPernocta),
      'diasDescansoGenerados': serializer.toJson<int>(diasDescansoGenerados),
    };
  }

  Actividade copyWith(
          {int? id,
          Value<int?> planificacionId = const Value.absent(),
          Value<int?> tipoGuardiaId = const Value.absent(),
          String? nombreActividad,
          DateTime? fecha,
          Value<DateTime?> fechaFin = const Value.absent(),
          String? lugar,
          String? categoria,
          Value<int?> jefeServicioId = const Value.absent(),
          bool? esPernocta,
          int? diasDescansoGenerados}) =>
      Actividade(
        id: id ?? this.id,
        planificacionId: planificacionId.present
            ? planificacionId.value
            : this.planificacionId,
        tipoGuardiaId:
            tipoGuardiaId.present ? tipoGuardiaId.value : this.tipoGuardiaId,
        nombreActividad: nombreActividad ?? this.nombreActividad,
        fecha: fecha ?? this.fecha,
        fechaFin: fechaFin.present ? fechaFin.value : this.fechaFin,
        lugar: lugar ?? this.lugar,
        categoria: categoria ?? this.categoria,
        jefeServicioId:
            jefeServicioId.present ? jefeServicioId.value : this.jefeServicioId,
        esPernocta: esPernocta ?? this.esPernocta,
        diasDescansoGenerados:
            diasDescansoGenerados ?? this.diasDescansoGenerados,
      );
  Actividade copyWithCompanion(ActividadesCompanion data) {
    return Actividade(
      id: data.id.present ? data.id.value : this.id,
      planificacionId: data.planificacionId.present
          ? data.planificacionId.value
          : this.planificacionId,
      tipoGuardiaId: data.tipoGuardiaId.present
          ? data.tipoGuardiaId.value
          : this.tipoGuardiaId,
      nombreActividad: data.nombreActividad.present
          ? data.nombreActividad.value
          : this.nombreActividad,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      fechaFin: data.fechaFin.present ? data.fechaFin.value : this.fechaFin,
      lugar: data.lugar.present ? data.lugar.value : this.lugar,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      jefeServicioId: data.jefeServicioId.present
          ? data.jefeServicioId.value
          : this.jefeServicioId,
      esPernocta:
          data.esPernocta.present ? data.esPernocta.value : this.esPernocta,
      diasDescansoGenerados: data.diasDescansoGenerados.present
          ? data.diasDescansoGenerados.value
          : this.diasDescansoGenerados,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Actividade(')
          ..write('id: $id, ')
          ..write('planificacionId: $planificacionId, ')
          ..write('tipoGuardiaId: $tipoGuardiaId, ')
          ..write('nombreActividad: $nombreActividad, ')
          ..write('fecha: $fecha, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('lugar: $lugar, ')
          ..write('categoria: $categoria, ')
          ..write('jefeServicioId: $jefeServicioId, ')
          ..write('esPernocta: $esPernocta, ')
          ..write('diasDescansoGenerados: $diasDescansoGenerados')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      planificacionId,
      tipoGuardiaId,
      nombreActividad,
      fecha,
      fechaFin,
      lugar,
      categoria,
      jefeServicioId,
      esPernocta,
      diasDescansoGenerados);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Actividade &&
          other.id == this.id &&
          other.planificacionId == this.planificacionId &&
          other.tipoGuardiaId == this.tipoGuardiaId &&
          other.nombreActividad == this.nombreActividad &&
          other.fecha == this.fecha &&
          other.fechaFin == this.fechaFin &&
          other.lugar == this.lugar &&
          other.categoria == this.categoria &&
          other.jefeServicioId == this.jefeServicioId &&
          other.esPernocta == this.esPernocta &&
          other.diasDescansoGenerados == this.diasDescansoGenerados);
}

class ActividadesCompanion extends UpdateCompanion<Actividade> {
  final Value<int> id;
  final Value<int?> planificacionId;
  final Value<int?> tipoGuardiaId;
  final Value<String> nombreActividad;
  final Value<DateTime> fecha;
  final Value<DateTime?> fechaFin;
  final Value<String> lugar;
  final Value<String> categoria;
  final Value<int?> jefeServicioId;
  final Value<bool> esPernocta;
  final Value<int> diasDescansoGenerados;
  const ActividadesCompanion({
    this.id = const Value.absent(),
    this.planificacionId = const Value.absent(),
    this.tipoGuardiaId = const Value.absent(),
    this.nombreActividad = const Value.absent(),
    this.fecha = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.lugar = const Value.absent(),
    this.categoria = const Value.absent(),
    this.jefeServicioId = const Value.absent(),
    this.esPernocta = const Value.absent(),
    this.diasDescansoGenerados = const Value.absent(),
  });
  ActividadesCompanion.insert({
    this.id = const Value.absent(),
    this.planificacionId = const Value.absent(),
    this.tipoGuardiaId = const Value.absent(),
    required String nombreActividad,
    required DateTime fecha,
    this.fechaFin = const Value.absent(),
    required String lugar,
    this.categoria = const Value.absent(),
    this.jefeServicioId = const Value.absent(),
    this.esPernocta = const Value.absent(),
    this.diasDescansoGenerados = const Value.absent(),
  })  : nombreActividad = Value(nombreActividad),
        fecha = Value(fecha),
        lugar = Value(lugar);
  static Insertable<Actividade> custom({
    Expression<int>? id,
    Expression<int>? planificacionId,
    Expression<int>? tipoGuardiaId,
    Expression<String>? nombreActividad,
    Expression<DateTime>? fecha,
    Expression<DateTime>? fechaFin,
    Expression<String>? lugar,
    Expression<String>? categoria,
    Expression<int>? jefeServicioId,
    Expression<bool>? esPernocta,
    Expression<int>? diasDescansoGenerados,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planificacionId != null) 'planificacion_id': planificacionId,
      if (tipoGuardiaId != null) 'tipo_guardia_id': tipoGuardiaId,
      if (nombreActividad != null) 'nombre_actividad': nombreActividad,
      if (fecha != null) 'fecha': fecha,
      if (fechaFin != null) 'fecha_fin': fechaFin,
      if (lugar != null) 'lugar': lugar,
      if (categoria != null) 'categoria': categoria,
      if (jefeServicioId != null) 'jefe_servicio_id': jefeServicioId,
      if (esPernocta != null) 'es_pernocta': esPernocta,
      if (diasDescansoGenerados != null)
        'dias_descanso_generados': diasDescansoGenerados,
    });
  }

  ActividadesCompanion copyWith(
      {Value<int>? id,
      Value<int?>? planificacionId,
      Value<int?>? tipoGuardiaId,
      Value<String>? nombreActividad,
      Value<DateTime>? fecha,
      Value<DateTime?>? fechaFin,
      Value<String>? lugar,
      Value<String>? categoria,
      Value<int?>? jefeServicioId,
      Value<bool>? esPernocta,
      Value<int>? diasDescansoGenerados}) {
    return ActividadesCompanion(
      id: id ?? this.id,
      planificacionId: planificacionId ?? this.planificacionId,
      tipoGuardiaId: tipoGuardiaId ?? this.tipoGuardiaId,
      nombreActividad: nombreActividad ?? this.nombreActividad,
      fecha: fecha ?? this.fecha,
      fechaFin: fechaFin ?? this.fechaFin,
      lugar: lugar ?? this.lugar,
      categoria: categoria ?? this.categoria,
      jefeServicioId: jefeServicioId ?? this.jefeServicioId,
      esPernocta: esPernocta ?? this.esPernocta,
      diasDescansoGenerados:
          diasDescansoGenerados ?? this.diasDescansoGenerados,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planificacionId.present) {
      map['planificacion_id'] = Variable<int>(planificacionId.value);
    }
    if (tipoGuardiaId.present) {
      map['tipo_guardia_id'] = Variable<int>(tipoGuardiaId.value);
    }
    if (nombreActividad.present) {
      map['nombre_actividad'] = Variable<String>(nombreActividad.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (fechaFin.present) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin.value);
    }
    if (lugar.present) {
      map['lugar'] = Variable<String>(lugar.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (jefeServicioId.present) {
      map['jefe_servicio_id'] = Variable<int>(jefeServicioId.value);
    }
    if (esPernocta.present) {
      map['es_pernocta'] = Variable<bool>(esPernocta.value);
    }
    if (diasDescansoGenerados.present) {
      map['dias_descanso_generados'] =
          Variable<int>(diasDescansoGenerados.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActividadesCompanion(')
          ..write('id: $id, ')
          ..write('planificacionId: $planificacionId, ')
          ..write('tipoGuardiaId: $tipoGuardiaId, ')
          ..write('nombreActividad: $nombreActividad, ')
          ..write('fecha: $fecha, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('lugar: $lugar, ')
          ..write('categoria: $categoria, ')
          ..write('jefeServicioId: $jefeServicioId, ')
          ..write('esPernocta: $esPernocta, ')
          ..write('diasDescansoGenerados: $diasDescansoGenerados')
          ..write(')'))
        .toString();
  }
}

class $AsignacionesTable extends Asignaciones
    with TableInfo<$AsignacionesTable, Asignacione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AsignacionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _funcionarioIdMeta =
      const VerificationMeta('funcionarioId');
  @override
  late final GeneratedColumn<int> funcionarioId = GeneratedColumn<int>(
      'funcionario_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES funcionarios (id)'));
  static const VerificationMeta _actividadIdMeta =
      const VerificationMeta('actividadId');
  @override
  late final GeneratedColumn<int> actividadId = GeneratedColumn<int>(
      'actividad_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES actividades (id)'));
  static const VerificationMeta _fechaAsignacionMeta =
      const VerificationMeta('fechaAsignacion');
  @override
  late final GeneratedColumn<DateTime> fechaAsignacion =
      GeneratedColumn<DateTime>('fecha_asignacion', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _fechaBloqueoHastaMeta =
      const VerificationMeta('fechaBloqueoHasta');
  @override
  late final GeneratedColumn<DateTime> fechaBloqueoHasta =
      GeneratedColumn<DateTime>('fecha_bloqueo_hasta', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _esCompensadaMeta =
      const VerificationMeta('esCompensada');
  @override
  late final GeneratedColumn<bool> esCompensada = GeneratedColumn<bool>(
      'es_compensada', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("es_compensada" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _esJefeServicioMeta =
      const VerificationMeta('esJefeServicio');
  @override
  late final GeneratedColumn<bool> esJefeServicio = GeneratedColumn<bool>(
      'es_jefe_servicio', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("es_jefe_servicio" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        funcionarioId,
        actividadId,
        fechaAsignacion,
        fechaBloqueoHasta,
        esCompensada,
        esJefeServicio
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asignaciones';
  @override
  VerificationContext validateIntegrity(Insertable<Asignacione> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('funcionario_id')) {
      context.handle(
          _funcionarioIdMeta,
          funcionarioId.isAcceptableOrUnknown(
              data['funcionario_id']!, _funcionarioIdMeta));
    } else if (isInserting) {
      context.missing(_funcionarioIdMeta);
    }
    if (data.containsKey('actividad_id')) {
      context.handle(
          _actividadIdMeta,
          actividadId.isAcceptableOrUnknown(
              data['actividad_id']!, _actividadIdMeta));
    } else if (isInserting) {
      context.missing(_actividadIdMeta);
    }
    if (data.containsKey('fecha_asignacion')) {
      context.handle(
          _fechaAsignacionMeta,
          fechaAsignacion.isAcceptableOrUnknown(
              data['fecha_asignacion']!, _fechaAsignacionMeta));
    }
    if (data.containsKey('fecha_bloqueo_hasta')) {
      context.handle(
          _fechaBloqueoHastaMeta,
          fechaBloqueoHasta.isAcceptableOrUnknown(
              data['fecha_bloqueo_hasta']!, _fechaBloqueoHastaMeta));
    }
    if (data.containsKey('es_compensada')) {
      context.handle(
          _esCompensadaMeta,
          esCompensada.isAcceptableOrUnknown(
              data['es_compensada']!, _esCompensadaMeta));
    }
    if (data.containsKey('es_jefe_servicio')) {
      context.handle(
          _esJefeServicioMeta,
          esJefeServicio.isAcceptableOrUnknown(
              data['es_jefe_servicio']!, _esJefeServicioMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Asignacione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Asignacione(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      funcionarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}funcionario_id'])!,
      actividadId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}actividad_id'])!,
      fechaAsignacion: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_asignacion'])!,
      fechaBloqueoHasta: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_bloqueo_hasta']),
      esCompensada: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}es_compensada'])!,
      esJefeServicio: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}es_jefe_servicio'])!,
    );
  }

  @override
  $AsignacionesTable createAlias(String alias) {
    return $AsignacionesTable(attachedDatabase, alias);
  }
}

class Asignacione extends DataClass implements Insertable<Asignacione> {
  final int id;
  final int funcionarioId;
  final int actividadId;
  final DateTime fechaAsignacion;
  final DateTime? fechaBloqueoHasta;
  final bool esCompensada;
  final bool esJefeServicio;
  const Asignacione(
      {required this.id,
      required this.funcionarioId,
      required this.actividadId,
      required this.fechaAsignacion,
      this.fechaBloqueoHasta,
      required this.esCompensada,
      required this.esJefeServicio});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['funcionario_id'] = Variable<int>(funcionarioId);
    map['actividad_id'] = Variable<int>(actividadId);
    map['fecha_asignacion'] = Variable<DateTime>(fechaAsignacion);
    if (!nullToAbsent || fechaBloqueoHasta != null) {
      map['fecha_bloqueo_hasta'] = Variable<DateTime>(fechaBloqueoHasta);
    }
    map['es_compensada'] = Variable<bool>(esCompensada);
    map['es_jefe_servicio'] = Variable<bool>(esJefeServicio);
    return map;
  }

  AsignacionesCompanion toCompanion(bool nullToAbsent) {
    return AsignacionesCompanion(
      id: Value(id),
      funcionarioId: Value(funcionarioId),
      actividadId: Value(actividadId),
      fechaAsignacion: Value(fechaAsignacion),
      fechaBloqueoHasta: fechaBloqueoHasta == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaBloqueoHasta),
      esCompensada: Value(esCompensada),
      esJefeServicio: Value(esJefeServicio),
    );
  }

  factory Asignacione.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Asignacione(
      id: serializer.fromJson<int>(json['id']),
      funcionarioId: serializer.fromJson<int>(json['funcionarioId']),
      actividadId: serializer.fromJson<int>(json['actividadId']),
      fechaAsignacion: serializer.fromJson<DateTime>(json['fechaAsignacion']),
      fechaBloqueoHasta:
          serializer.fromJson<DateTime?>(json['fechaBloqueoHasta']),
      esCompensada: serializer.fromJson<bool>(json['esCompensada']),
      esJefeServicio: serializer.fromJson<bool>(json['esJefeServicio']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'funcionarioId': serializer.toJson<int>(funcionarioId),
      'actividadId': serializer.toJson<int>(actividadId),
      'fechaAsignacion': serializer.toJson<DateTime>(fechaAsignacion),
      'fechaBloqueoHasta': serializer.toJson<DateTime?>(fechaBloqueoHasta),
      'esCompensada': serializer.toJson<bool>(esCompensada),
      'esJefeServicio': serializer.toJson<bool>(esJefeServicio),
    };
  }

  Asignacione copyWith(
          {int? id,
          int? funcionarioId,
          int? actividadId,
          DateTime? fechaAsignacion,
          Value<DateTime?> fechaBloqueoHasta = const Value.absent(),
          bool? esCompensada,
          bool? esJefeServicio}) =>
      Asignacione(
        id: id ?? this.id,
        funcionarioId: funcionarioId ?? this.funcionarioId,
        actividadId: actividadId ?? this.actividadId,
        fechaAsignacion: fechaAsignacion ?? this.fechaAsignacion,
        fechaBloqueoHasta: fechaBloqueoHasta.present
            ? fechaBloqueoHasta.value
            : this.fechaBloqueoHasta,
        esCompensada: esCompensada ?? this.esCompensada,
        esJefeServicio: esJefeServicio ?? this.esJefeServicio,
      );
  Asignacione copyWithCompanion(AsignacionesCompanion data) {
    return Asignacione(
      id: data.id.present ? data.id.value : this.id,
      funcionarioId: data.funcionarioId.present
          ? data.funcionarioId.value
          : this.funcionarioId,
      actividadId:
          data.actividadId.present ? data.actividadId.value : this.actividadId,
      fechaAsignacion: data.fechaAsignacion.present
          ? data.fechaAsignacion.value
          : this.fechaAsignacion,
      fechaBloqueoHasta: data.fechaBloqueoHasta.present
          ? data.fechaBloqueoHasta.value
          : this.fechaBloqueoHasta,
      esCompensada: data.esCompensada.present
          ? data.esCompensada.value
          : this.esCompensada,
      esJefeServicio: data.esJefeServicio.present
          ? data.esJefeServicio.value
          : this.esJefeServicio,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Asignacione(')
          ..write('id: $id, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('actividadId: $actividadId, ')
          ..write('fechaAsignacion: $fechaAsignacion, ')
          ..write('fechaBloqueoHasta: $fechaBloqueoHasta, ')
          ..write('esCompensada: $esCompensada, ')
          ..write('esJefeServicio: $esJefeServicio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, funcionarioId, actividadId,
      fechaAsignacion, fechaBloqueoHasta, esCompensada, esJefeServicio);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Asignacione &&
          other.id == this.id &&
          other.funcionarioId == this.funcionarioId &&
          other.actividadId == this.actividadId &&
          other.fechaAsignacion == this.fechaAsignacion &&
          other.fechaBloqueoHasta == this.fechaBloqueoHasta &&
          other.esCompensada == this.esCompensada &&
          other.esJefeServicio == this.esJefeServicio);
}

class AsignacionesCompanion extends UpdateCompanion<Asignacione> {
  final Value<int> id;
  final Value<int> funcionarioId;
  final Value<int> actividadId;
  final Value<DateTime> fechaAsignacion;
  final Value<DateTime?> fechaBloqueoHasta;
  final Value<bool> esCompensada;
  final Value<bool> esJefeServicio;
  const AsignacionesCompanion({
    this.id = const Value.absent(),
    this.funcionarioId = const Value.absent(),
    this.actividadId = const Value.absent(),
    this.fechaAsignacion = const Value.absent(),
    this.fechaBloqueoHasta = const Value.absent(),
    this.esCompensada = const Value.absent(),
    this.esJefeServicio = const Value.absent(),
  });
  AsignacionesCompanion.insert({
    this.id = const Value.absent(),
    required int funcionarioId,
    required int actividadId,
    this.fechaAsignacion = const Value.absent(),
    this.fechaBloqueoHasta = const Value.absent(),
    this.esCompensada = const Value.absent(),
    this.esJefeServicio = const Value.absent(),
  })  : funcionarioId = Value(funcionarioId),
        actividadId = Value(actividadId);
  static Insertable<Asignacione> custom({
    Expression<int>? id,
    Expression<int>? funcionarioId,
    Expression<int>? actividadId,
    Expression<DateTime>? fechaAsignacion,
    Expression<DateTime>? fechaBloqueoHasta,
    Expression<bool>? esCompensada,
    Expression<bool>? esJefeServicio,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (funcionarioId != null) 'funcionario_id': funcionarioId,
      if (actividadId != null) 'actividad_id': actividadId,
      if (fechaAsignacion != null) 'fecha_asignacion': fechaAsignacion,
      if (fechaBloqueoHasta != null) 'fecha_bloqueo_hasta': fechaBloqueoHasta,
      if (esCompensada != null) 'es_compensada': esCompensada,
      if (esJefeServicio != null) 'es_jefe_servicio': esJefeServicio,
    });
  }

  AsignacionesCompanion copyWith(
      {Value<int>? id,
      Value<int>? funcionarioId,
      Value<int>? actividadId,
      Value<DateTime>? fechaAsignacion,
      Value<DateTime?>? fechaBloqueoHasta,
      Value<bool>? esCompensada,
      Value<bool>? esJefeServicio}) {
    return AsignacionesCompanion(
      id: id ?? this.id,
      funcionarioId: funcionarioId ?? this.funcionarioId,
      actividadId: actividadId ?? this.actividadId,
      fechaAsignacion: fechaAsignacion ?? this.fechaAsignacion,
      fechaBloqueoHasta: fechaBloqueoHasta ?? this.fechaBloqueoHasta,
      esCompensada: esCompensada ?? this.esCompensada,
      esJefeServicio: esJefeServicio ?? this.esJefeServicio,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (funcionarioId.present) {
      map['funcionario_id'] = Variable<int>(funcionarioId.value);
    }
    if (actividadId.present) {
      map['actividad_id'] = Variable<int>(actividadId.value);
    }
    if (fechaAsignacion.present) {
      map['fecha_asignacion'] = Variable<DateTime>(fechaAsignacion.value);
    }
    if (fechaBloqueoHasta.present) {
      map['fecha_bloqueo_hasta'] = Variable<DateTime>(fechaBloqueoHasta.value);
    }
    if (esCompensada.present) {
      map['es_compensada'] = Variable<bool>(esCompensada.value);
    }
    if (esJefeServicio.present) {
      map['es_jefe_servicio'] = Variable<bool>(esJefeServicio.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AsignacionesCompanion(')
          ..write('id: $id, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('actividadId: $actividadId, ')
          ..write('fechaAsignacion: $fechaAsignacion, ')
          ..write('fechaBloqueoHasta: $fechaBloqueoHasta, ')
          ..write('esCompensada: $esCompensada, ')
          ..write('esJefeServicio: $esJefeServicio')
          ..write(')'))
        .toString();
  }
}

class $AusenciasTable extends Ausencias
    with TableInfo<$AusenciasTable, Ausencia> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AusenciasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _funcionarioIdMeta =
      const VerificationMeta('funcionarioId');
  @override
  late final GeneratedColumn<int> funcionarioId = GeneratedColumn<int>(
      'funcionario_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES funcionarios (id)'));
  static const VerificationMeta _fechaInicioMeta =
      const VerificationMeta('fechaInicio');
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
      'fecha_inicio', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _fechaFinMeta =
      const VerificationMeta('fechaFin');
  @override
  late final GeneratedColumn<DateTime> fechaFin = GeneratedColumn<DateTime>(
      'fecha_fin', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _motivoMeta = const VerificationMeta('motivo');
  @override
  late final GeneratedColumn<String> motivo = GeneratedColumn<String>(
      'motivo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('vacaciones'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, funcionarioId, fechaInicio, fechaFin, motivo, tipo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ausencias';
  @override
  VerificationContext validateIntegrity(Insertable<Ausencia> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('funcionario_id')) {
      context.handle(
          _funcionarioIdMeta,
          funcionarioId.isAcceptableOrUnknown(
              data['funcionario_id']!, _funcionarioIdMeta));
    } else if (isInserting) {
      context.missing(_funcionarioIdMeta);
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
          _fechaInicioMeta,
          fechaInicio.isAcceptableOrUnknown(
              data['fecha_inicio']!, _fechaInicioMeta));
    } else if (isInserting) {
      context.missing(_fechaInicioMeta);
    }
    if (data.containsKey('fecha_fin')) {
      context.handle(_fechaFinMeta,
          fechaFin.isAcceptableOrUnknown(data['fecha_fin']!, _fechaFinMeta));
    } else if (isInserting) {
      context.missing(_fechaFinMeta);
    }
    if (data.containsKey('motivo')) {
      context.handle(_motivoMeta,
          motivo.isAcceptableOrUnknown(data['motivo']!, _motivoMeta));
    } else if (isInserting) {
      context.missing(_motivoMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ausencia map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ausencia(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      funcionarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}funcionario_id'])!,
      fechaInicio: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_inicio'])!,
      fechaFin: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_fin'])!,
      motivo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}motivo'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
    );
  }

  @override
  $AusenciasTable createAlias(String alias) {
    return $AusenciasTable(attachedDatabase, alias);
  }
}

class Ausencia extends DataClass implements Insertable<Ausencia> {
  final int id;
  final int funcionarioId;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String motivo;
  final String tipo;
  const Ausencia(
      {required this.id,
      required this.funcionarioId,
      required this.fechaInicio,
      required this.fechaFin,
      required this.motivo,
      required this.tipo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['funcionario_id'] = Variable<int>(funcionarioId);
    map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    map['fecha_fin'] = Variable<DateTime>(fechaFin);
    map['motivo'] = Variable<String>(motivo);
    map['tipo'] = Variable<String>(tipo);
    return map;
  }

  AusenciasCompanion toCompanion(bool nullToAbsent) {
    return AusenciasCompanion(
      id: Value(id),
      funcionarioId: Value(funcionarioId),
      fechaInicio: Value(fechaInicio),
      fechaFin: Value(fechaFin),
      motivo: Value(motivo),
      tipo: Value(tipo),
    );
  }

  factory Ausencia.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ausencia(
      id: serializer.fromJson<int>(json['id']),
      funcionarioId: serializer.fromJson<int>(json['funcionarioId']),
      fechaInicio: serializer.fromJson<DateTime>(json['fechaInicio']),
      fechaFin: serializer.fromJson<DateTime>(json['fechaFin']),
      motivo: serializer.fromJson<String>(json['motivo']),
      tipo: serializer.fromJson<String>(json['tipo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'funcionarioId': serializer.toJson<int>(funcionarioId),
      'fechaInicio': serializer.toJson<DateTime>(fechaInicio),
      'fechaFin': serializer.toJson<DateTime>(fechaFin),
      'motivo': serializer.toJson<String>(motivo),
      'tipo': serializer.toJson<String>(tipo),
    };
  }

  Ausencia copyWith(
          {int? id,
          int? funcionarioId,
          DateTime? fechaInicio,
          DateTime? fechaFin,
          String? motivo,
          String? tipo}) =>
      Ausencia(
        id: id ?? this.id,
        funcionarioId: funcionarioId ?? this.funcionarioId,
        fechaInicio: fechaInicio ?? this.fechaInicio,
        fechaFin: fechaFin ?? this.fechaFin,
        motivo: motivo ?? this.motivo,
        tipo: tipo ?? this.tipo,
      );
  Ausencia copyWithCompanion(AusenciasCompanion data) {
    return Ausencia(
      id: data.id.present ? data.id.value : this.id,
      funcionarioId: data.funcionarioId.present
          ? data.funcionarioId.value
          : this.funcionarioId,
      fechaInicio:
          data.fechaInicio.present ? data.fechaInicio.value : this.fechaInicio,
      fechaFin: data.fechaFin.present ? data.fechaFin.value : this.fechaFin,
      motivo: data.motivo.present ? data.motivo.value : this.motivo,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ausencia(')
          ..write('id: $id, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('motivo: $motivo, ')
          ..write('tipo: $tipo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, funcionarioId, fechaInicio, fechaFin, motivo, tipo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ausencia &&
          other.id == this.id &&
          other.funcionarioId == this.funcionarioId &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaFin == this.fechaFin &&
          other.motivo == this.motivo &&
          other.tipo == this.tipo);
}

class AusenciasCompanion extends UpdateCompanion<Ausencia> {
  final Value<int> id;
  final Value<int> funcionarioId;
  final Value<DateTime> fechaInicio;
  final Value<DateTime> fechaFin;
  final Value<String> motivo;
  final Value<String> tipo;
  const AusenciasCompanion({
    this.id = const Value.absent(),
    this.funcionarioId = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.motivo = const Value.absent(),
    this.tipo = const Value.absent(),
  });
  AusenciasCompanion.insert({
    this.id = const Value.absent(),
    required int funcionarioId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String motivo,
    this.tipo = const Value.absent(),
  })  : funcionarioId = Value(funcionarioId),
        fechaInicio = Value(fechaInicio),
        fechaFin = Value(fechaFin),
        motivo = Value(motivo);
  static Insertable<Ausencia> custom({
    Expression<int>? id,
    Expression<int>? funcionarioId,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? fechaFin,
    Expression<String>? motivo,
    Expression<String>? tipo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (funcionarioId != null) 'funcionario_id': funcionarioId,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaFin != null) 'fecha_fin': fechaFin,
      if (motivo != null) 'motivo': motivo,
      if (tipo != null) 'tipo': tipo,
    });
  }

  AusenciasCompanion copyWith(
      {Value<int>? id,
      Value<int>? funcionarioId,
      Value<DateTime>? fechaInicio,
      Value<DateTime>? fechaFin,
      Value<String>? motivo,
      Value<String>? tipo}) {
    return AusenciasCompanion(
      id: id ?? this.id,
      funcionarioId: funcionarioId ?? this.funcionarioId,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      motivo: motivo ?? this.motivo,
      tipo: tipo ?? this.tipo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (funcionarioId.present) {
      map['funcionario_id'] = Variable<int>(funcionarioId.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (fechaFin.present) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin.value);
    }
    if (motivo.present) {
      map['motivo'] = Variable<String>(motivo.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AusenciasCompanion(')
          ..write('id: $id, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('motivo: $motivo, ')
          ..write('tipo: $tipo')
          ..write(')'))
        .toString();
  }
}

class $IncidenciasTable extends Incidencias
    with TableInfo<$IncidenciasTable, Incidencia> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncidenciasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _actividadIdMeta =
      const VerificationMeta('actividadId');
  @override
  late final GeneratedColumn<int> actividadId = GeneratedColumn<int>(
      'actividad_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES actividades (id)'));
  static const VerificationMeta _funcionarioInasistenteIdMeta =
      const VerificationMeta('funcionarioInasistenteId');
  @override
  late final GeneratedColumn<int> funcionarioInasistenteId =
      GeneratedColumn<int>('funcionario_inasistente_id', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES funcionarios (id)'));
  static const VerificationMeta _fechaHoraRegistroMeta =
      const VerificationMeta('fechaHoraRegistro');
  @override
  late final GeneratedColumn<DateTime> fechaHoraRegistro =
      GeneratedColumn<DateTime>('fecha_hora_registro', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('falta'));
  static const VerificationMeta _testigoUnoIdMeta =
      const VerificationMeta('testigoUnoId');
  @override
  late final GeneratedColumn<int> testigoUnoId = GeneratedColumn<int>(
      'testigo_uno_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES funcionarios (id)'));
  static const VerificationMeta _testigoDosIdMeta =
      const VerificationMeta('testigoDosId');
  @override
  late final GeneratedColumn<int> testigoDosId = GeneratedColumn<int>(
      'testigo_dos_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES funcionarios (id)'));
  static const VerificationMeta _observacionesMeta =
      const VerificationMeta('observaciones');
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
      'observaciones', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        actividadId,
        funcionarioInasistenteId,
        fechaHoraRegistro,
        descripcion,
        tipo,
        testigoUnoId,
        testigoDosId,
        observaciones
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'incidencias';
  @override
  VerificationContext validateIntegrity(Insertable<Incidencia> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('actividad_id')) {
      context.handle(
          _actividadIdMeta,
          actividadId.isAcceptableOrUnknown(
              data['actividad_id']!, _actividadIdMeta));
    } else if (isInserting) {
      context.missing(_actividadIdMeta);
    }
    if (data.containsKey('funcionario_inasistente_id')) {
      context.handle(
          _funcionarioInasistenteIdMeta,
          funcionarioInasistenteId.isAcceptableOrUnknown(
              data['funcionario_inasistente_id']!,
              _funcionarioInasistenteIdMeta));
    } else if (isInserting) {
      context.missing(_funcionarioInasistenteIdMeta);
    }
    if (data.containsKey('fecha_hora_registro')) {
      context.handle(
          _fechaHoraRegistroMeta,
          fechaHoraRegistro.isAcceptableOrUnknown(
              data['fecha_hora_registro']!, _fechaHoraRegistroMeta));
    } else if (isInserting) {
      context.missing(_fechaHoraRegistroMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    }
    if (data.containsKey('testigo_uno_id')) {
      context.handle(
          _testigoUnoIdMeta,
          testigoUnoId.isAcceptableOrUnknown(
              data['testigo_uno_id']!, _testigoUnoIdMeta));
    }
    if (data.containsKey('testigo_dos_id')) {
      context.handle(
          _testigoDosIdMeta,
          testigoDosId.isAcceptableOrUnknown(
              data['testigo_dos_id']!, _testigoDosIdMeta));
    }
    if (data.containsKey('observaciones')) {
      context.handle(
          _observacionesMeta,
          observaciones.isAcceptableOrUnknown(
              data['observaciones']!, _observacionesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Incidencia map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Incidencia(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      actividadId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}actividad_id'])!,
      funcionarioInasistenteId: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}funcionario_inasistente_id'])!,
      fechaHoraRegistro: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}fecha_hora_registro'])!,
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      testigoUnoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}testigo_uno_id']),
      testigoDosId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}testigo_dos_id']),
      observaciones: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observaciones']),
    );
  }

  @override
  $IncidenciasTable createAlias(String alias) {
    return $IncidenciasTable(attachedDatabase, alias);
  }
}

class Incidencia extends DataClass implements Insertable<Incidencia> {
  final int id;
  final int actividadId;
  final int funcionarioInasistenteId;
  final DateTime fechaHoraRegistro;
  final String descripcion;
  final String tipo;
  final int? testigoUnoId;
  final int? testigoDosId;
  final String? observaciones;
  const Incidencia(
      {required this.id,
      required this.actividadId,
      required this.funcionarioInasistenteId,
      required this.fechaHoraRegistro,
      required this.descripcion,
      required this.tipo,
      this.testigoUnoId,
      this.testigoDosId,
      this.observaciones});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['actividad_id'] = Variable<int>(actividadId);
    map['funcionario_inasistente_id'] = Variable<int>(funcionarioInasistenteId);
    map['fecha_hora_registro'] = Variable<DateTime>(fechaHoraRegistro);
    map['descripcion'] = Variable<String>(descripcion);
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || testigoUnoId != null) {
      map['testigo_uno_id'] = Variable<int>(testigoUnoId);
    }
    if (!nullToAbsent || testigoDosId != null) {
      map['testigo_dos_id'] = Variable<int>(testigoDosId);
    }
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    return map;
  }

  IncidenciasCompanion toCompanion(bool nullToAbsent) {
    return IncidenciasCompanion(
      id: Value(id),
      actividadId: Value(actividadId),
      funcionarioInasistenteId: Value(funcionarioInasistenteId),
      fechaHoraRegistro: Value(fechaHoraRegistro),
      descripcion: Value(descripcion),
      tipo: Value(tipo),
      testigoUnoId: testigoUnoId == null && nullToAbsent
          ? const Value.absent()
          : Value(testigoUnoId),
      testigoDosId: testigoDosId == null && nullToAbsent
          ? const Value.absent()
          : Value(testigoDosId),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
    );
  }

  factory Incidencia.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Incidencia(
      id: serializer.fromJson<int>(json['id']),
      actividadId: serializer.fromJson<int>(json['actividadId']),
      funcionarioInasistenteId:
          serializer.fromJson<int>(json['funcionarioInasistenteId']),
      fechaHoraRegistro:
          serializer.fromJson<DateTime>(json['fechaHoraRegistro']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      tipo: serializer.fromJson<String>(json['tipo']),
      testigoUnoId: serializer.fromJson<int?>(json['testigoUnoId']),
      testigoDosId: serializer.fromJson<int?>(json['testigoDosId']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'actividadId': serializer.toJson<int>(actividadId),
      'funcionarioInasistenteId':
          serializer.toJson<int>(funcionarioInasistenteId),
      'fechaHoraRegistro': serializer.toJson<DateTime>(fechaHoraRegistro),
      'descripcion': serializer.toJson<String>(descripcion),
      'tipo': serializer.toJson<String>(tipo),
      'testigoUnoId': serializer.toJson<int?>(testigoUnoId),
      'testigoDosId': serializer.toJson<int?>(testigoDosId),
      'observaciones': serializer.toJson<String?>(observaciones),
    };
  }

  Incidencia copyWith(
          {int? id,
          int? actividadId,
          int? funcionarioInasistenteId,
          DateTime? fechaHoraRegistro,
          String? descripcion,
          String? tipo,
          Value<int?> testigoUnoId = const Value.absent(),
          Value<int?> testigoDosId = const Value.absent(),
          Value<String?> observaciones = const Value.absent()}) =>
      Incidencia(
        id: id ?? this.id,
        actividadId: actividadId ?? this.actividadId,
        funcionarioInasistenteId:
            funcionarioInasistenteId ?? this.funcionarioInasistenteId,
        fechaHoraRegistro: fechaHoraRegistro ?? this.fechaHoraRegistro,
        descripcion: descripcion ?? this.descripcion,
        tipo: tipo ?? this.tipo,
        testigoUnoId:
            testigoUnoId.present ? testigoUnoId.value : this.testigoUnoId,
        testigoDosId:
            testigoDosId.present ? testigoDosId.value : this.testigoDosId,
        observaciones:
            observaciones.present ? observaciones.value : this.observaciones,
      );
  Incidencia copyWithCompanion(IncidenciasCompanion data) {
    return Incidencia(
      id: data.id.present ? data.id.value : this.id,
      actividadId:
          data.actividadId.present ? data.actividadId.value : this.actividadId,
      funcionarioInasistenteId: data.funcionarioInasistenteId.present
          ? data.funcionarioInasistenteId.value
          : this.funcionarioInasistenteId,
      fechaHoraRegistro: data.fechaHoraRegistro.present
          ? data.fechaHoraRegistro.value
          : this.fechaHoraRegistro,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      testigoUnoId: data.testigoUnoId.present
          ? data.testigoUnoId.value
          : this.testigoUnoId,
      testigoDosId: data.testigoDosId.present
          ? data.testigoDosId.value
          : this.testigoDosId,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Incidencia(')
          ..write('id: $id, ')
          ..write('actividadId: $actividadId, ')
          ..write('funcionarioInasistenteId: $funcionarioInasistenteId, ')
          ..write('fechaHoraRegistro: $fechaHoraRegistro, ')
          ..write('descripcion: $descripcion, ')
          ..write('tipo: $tipo, ')
          ..write('testigoUnoId: $testigoUnoId, ')
          ..write('testigoDosId: $testigoDosId, ')
          ..write('observaciones: $observaciones')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      actividadId,
      funcionarioInasistenteId,
      fechaHoraRegistro,
      descripcion,
      tipo,
      testigoUnoId,
      testigoDosId,
      observaciones);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Incidencia &&
          other.id == this.id &&
          other.actividadId == this.actividadId &&
          other.funcionarioInasistenteId == this.funcionarioInasistenteId &&
          other.fechaHoraRegistro == this.fechaHoraRegistro &&
          other.descripcion == this.descripcion &&
          other.tipo == this.tipo &&
          other.testigoUnoId == this.testigoUnoId &&
          other.testigoDosId == this.testigoDosId &&
          other.observaciones == this.observaciones);
}

class IncidenciasCompanion extends UpdateCompanion<Incidencia> {
  final Value<int> id;
  final Value<int> actividadId;
  final Value<int> funcionarioInasistenteId;
  final Value<DateTime> fechaHoraRegistro;
  final Value<String> descripcion;
  final Value<String> tipo;
  final Value<int?> testigoUnoId;
  final Value<int?> testigoDosId;
  final Value<String?> observaciones;
  const IncidenciasCompanion({
    this.id = const Value.absent(),
    this.actividadId = const Value.absent(),
    this.funcionarioInasistenteId = const Value.absent(),
    this.fechaHoraRegistro = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.tipo = const Value.absent(),
    this.testigoUnoId = const Value.absent(),
    this.testigoDosId = const Value.absent(),
    this.observaciones = const Value.absent(),
  });
  IncidenciasCompanion.insert({
    this.id = const Value.absent(),
    required int actividadId,
    required int funcionarioInasistenteId,
    required DateTime fechaHoraRegistro,
    required String descripcion,
    this.tipo = const Value.absent(),
    this.testigoUnoId = const Value.absent(),
    this.testigoDosId = const Value.absent(),
    this.observaciones = const Value.absent(),
  })  : actividadId = Value(actividadId),
        funcionarioInasistenteId = Value(funcionarioInasistenteId),
        fechaHoraRegistro = Value(fechaHoraRegistro),
        descripcion = Value(descripcion);
  static Insertable<Incidencia> custom({
    Expression<int>? id,
    Expression<int>? actividadId,
    Expression<int>? funcionarioInasistenteId,
    Expression<DateTime>? fechaHoraRegistro,
    Expression<String>? descripcion,
    Expression<String>? tipo,
    Expression<int>? testigoUnoId,
    Expression<int>? testigoDosId,
    Expression<String>? observaciones,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actividadId != null) 'actividad_id': actividadId,
      if (funcionarioInasistenteId != null)
        'funcionario_inasistente_id': funcionarioInasistenteId,
      if (fechaHoraRegistro != null) 'fecha_hora_registro': fechaHoraRegistro,
      if (descripcion != null) 'descripcion': descripcion,
      if (tipo != null) 'tipo': tipo,
      if (testigoUnoId != null) 'testigo_uno_id': testigoUnoId,
      if (testigoDosId != null) 'testigo_dos_id': testigoDosId,
      if (observaciones != null) 'observaciones': observaciones,
    });
  }

  IncidenciasCompanion copyWith(
      {Value<int>? id,
      Value<int>? actividadId,
      Value<int>? funcionarioInasistenteId,
      Value<DateTime>? fechaHoraRegistro,
      Value<String>? descripcion,
      Value<String>? tipo,
      Value<int?>? testigoUnoId,
      Value<int?>? testigoDosId,
      Value<String?>? observaciones}) {
    return IncidenciasCompanion(
      id: id ?? this.id,
      actividadId: actividadId ?? this.actividadId,
      funcionarioInasistenteId:
          funcionarioInasistenteId ?? this.funcionarioInasistenteId,
      fechaHoraRegistro: fechaHoraRegistro ?? this.fechaHoraRegistro,
      descripcion: descripcion ?? this.descripcion,
      tipo: tipo ?? this.tipo,
      testigoUnoId: testigoUnoId ?? this.testigoUnoId,
      testigoDosId: testigoDosId ?? this.testigoDosId,
      observaciones: observaciones ?? this.observaciones,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (actividadId.present) {
      map['actividad_id'] = Variable<int>(actividadId.value);
    }
    if (funcionarioInasistenteId.present) {
      map['funcionario_inasistente_id'] =
          Variable<int>(funcionarioInasistenteId.value);
    }
    if (fechaHoraRegistro.present) {
      map['fecha_hora_registro'] = Variable<DateTime>(fechaHoraRegistro.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (testigoUnoId.present) {
      map['testigo_uno_id'] = Variable<int>(testigoUnoId.value);
    }
    if (testigoDosId.present) {
      map['testigo_dos_id'] = Variable<int>(testigoDosId.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncidenciasCompanion(')
          ..write('id: $id, ')
          ..write('actividadId: $actividadId, ')
          ..write('funcionarioInasistenteId: $funcionarioInasistenteId, ')
          ..write('fechaHoraRegistro: $fechaHoraRegistro, ')
          ..write('descripcion: $descripcion, ')
          ..write('tipo: $tipo, ')
          ..write('testigoUnoId: $testigoUnoId, ')
          ..write('testigoDosId: $testigoDosId, ')
          ..write('observaciones: $observaciones')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsuariosSistemaTable usuariosSistema =
      $UsuariosSistemaTable(this);
  late final $ConfigSettingsTable configSettings = $ConfigSettingsTable(this);
  late final $RangosTable rangos = $RangosTable(this);
  late final $TiposGuardiaTable tiposGuardia = $TiposGuardiaTable(this);
  late final $UbicacionesTable ubicaciones = $UbicacionesTable(this);
  late final $PlanificacionesSemanalesTable planificacionesSemanales =
      $PlanificacionesSemanalesTable(this);
  late final $FuncionariosTable funcionarios = $FuncionariosTable(this);
  late final $EstudiosAcademicosTable estudiosAcademicos =
      $EstudiosAcademicosTable(this);
  late final $CursosCertificadosTable cursosCertificados =
      $CursosCertificadosTable(this);
  late final $FamiliaresTable familiares = $FamiliaresTable(this);
  late final $HijosTable hijos = $HijosTable(this);
  late final $ActividadesTable actividades = $ActividadesTable(this);
  late final $AsignacionesTable asignaciones = $AsignacionesTable(this);
  late final $AusenciasTable ausencias = $AusenciasTable(this);
  late final $IncidenciasTable incidencias = $IncidenciasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        usuariosSistema,
        configSettings,
        rangos,
        tiposGuardia,
        ubicaciones,
        planificacionesSemanales,
        funcionarios,
        estudiosAcademicos,
        cursosCertificados,
        familiares,
        hijos,
        actividades,
        asignaciones,
        ausencias,
        incidencias
      ];
}

typedef $$UsuariosSistemaTableCreateCompanionBuilder = UsuariosSistemaCompanion
    Function({
  Value<int> id,
  required String usuario,
  required String password,
  Value<String> rol,
  Value<String?> preguntaSeguridad,
  Value<String?> respuestaSeguridad,
});
typedef $$UsuariosSistemaTableUpdateCompanionBuilder = UsuariosSistemaCompanion
    Function({
  Value<int> id,
  Value<String> usuario,
  Value<String> password,
  Value<String> rol,
  Value<String?> preguntaSeguridad,
  Value<String?> respuestaSeguridad,
});

class $$UsuariosSistemaTableFilterComposer
    extends Composer<_$AppDatabase, $UsuariosSistemaTable> {
  $$UsuariosSistemaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuario => $composableBuilder(
      column: $table.usuario, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rol => $composableBuilder(
      column: $table.rol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preguntaSeguridad => $composableBuilder(
      column: $table.preguntaSeguridad,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get respuestaSeguridad => $composableBuilder(
      column: $table.respuestaSeguridad,
      builder: (column) => ColumnFilters(column));
}

class $$UsuariosSistemaTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuariosSistemaTable> {
  $$UsuariosSistemaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuario => $composableBuilder(
      column: $table.usuario, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rol => $composableBuilder(
      column: $table.rol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preguntaSeguridad => $composableBuilder(
      column: $table.preguntaSeguridad,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get respuestaSeguridad => $composableBuilder(
      column: $table.respuestaSeguridad,
      builder: (column) => ColumnOrderings(column));
}

class $$UsuariosSistemaTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuariosSistemaTable> {
  $$UsuariosSistemaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get usuario =>
      $composableBuilder(column: $table.usuario, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get rol =>
      $composableBuilder(column: $table.rol, builder: (column) => column);

  GeneratedColumn<String> get preguntaSeguridad => $composableBuilder(
      column: $table.preguntaSeguridad, builder: (column) => column);

  GeneratedColumn<String> get respuestaSeguridad => $composableBuilder(
      column: $table.respuestaSeguridad, builder: (column) => column);
}

class $$UsuariosSistemaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsuariosSistemaTable,
    UsuariosSistemaData,
    $$UsuariosSistemaTableFilterComposer,
    $$UsuariosSistemaTableOrderingComposer,
    $$UsuariosSistemaTableAnnotationComposer,
    $$UsuariosSistemaTableCreateCompanionBuilder,
    $$UsuariosSistemaTableUpdateCompanionBuilder,
    (
      UsuariosSistemaData,
      BaseReferences<_$AppDatabase, $UsuariosSistemaTable, UsuariosSistemaData>
    ),
    UsuariosSistemaData,
    PrefetchHooks Function()> {
  $$UsuariosSistemaTableTableManager(
      _$AppDatabase db, $UsuariosSistemaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuariosSistemaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuariosSistemaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuariosSistemaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> usuario = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String> rol = const Value.absent(),
            Value<String?> preguntaSeguridad = const Value.absent(),
            Value<String?> respuestaSeguridad = const Value.absent(),
          }) =>
              UsuariosSistemaCompanion(
            id: id,
            usuario: usuario,
            password: password,
            rol: rol,
            preguntaSeguridad: preguntaSeguridad,
            respuestaSeguridad: respuestaSeguridad,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String usuario,
            required String password,
            Value<String> rol = const Value.absent(),
            Value<String?> preguntaSeguridad = const Value.absent(),
            Value<String?> respuestaSeguridad = const Value.absent(),
          }) =>
              UsuariosSistemaCompanion.insert(
            id: id,
            usuario: usuario,
            password: password,
            rol: rol,
            preguntaSeguridad: preguntaSeguridad,
            respuestaSeguridad: respuestaSeguridad,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsuariosSistemaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsuariosSistemaTable,
    UsuariosSistemaData,
    $$UsuariosSistemaTableFilterComposer,
    $$UsuariosSistemaTableOrderingComposer,
    $$UsuariosSistemaTableAnnotationComposer,
    $$UsuariosSistemaTableCreateCompanionBuilder,
    $$UsuariosSistemaTableUpdateCompanionBuilder,
    (
      UsuariosSistemaData,
      BaseReferences<_$AppDatabase, $UsuariosSistemaTable, UsuariosSistemaData>
    ),
    UsuariosSistemaData,
    PrefetchHooks Function()>;
typedef $$ConfigSettingsTableCreateCompanionBuilder = ConfigSettingsCompanion
    Function({
  Value<int> id,
  Value<String> nombreInstitucion,
  Value<String?> parqueNombre,
  Value<String?> sectorNombre,
  Value<String?> ciudad,
  Value<String?> municipio,
  Value<String?> estado,
  required String nombreJefe,
  Value<String?> apellidoJefe,
  required String rangoJefe,
  Value<String> jefeCargo,
  required String usuario,
  required String password,
  Value<String?> preguntaSeguridad,
  Value<String?> respuestaSeguridad,
});
typedef $$ConfigSettingsTableUpdateCompanionBuilder = ConfigSettingsCompanion
    Function({
  Value<int> id,
  Value<String> nombreInstitucion,
  Value<String?> parqueNombre,
  Value<String?> sectorNombre,
  Value<String?> ciudad,
  Value<String?> municipio,
  Value<String?> estado,
  Value<String> nombreJefe,
  Value<String?> apellidoJefe,
  Value<String> rangoJefe,
  Value<String> jefeCargo,
  Value<String> usuario,
  Value<String> password,
  Value<String?> preguntaSeguridad,
  Value<String?> respuestaSeguridad,
});

class $$ConfigSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $ConfigSettingsTable> {
  $$ConfigSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombreInstitucion => $composableBuilder(
      column: $table.nombreInstitucion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parqueNombre => $composableBuilder(
      column: $table.parqueNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sectorNombre => $composableBuilder(
      column: $table.sectorNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ciudad => $composableBuilder(
      column: $table.ciudad, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get municipio => $composableBuilder(
      column: $table.municipio, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombreJefe => $composableBuilder(
      column: $table.nombreJefe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apellidoJefe => $composableBuilder(
      column: $table.apellidoJefe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rangoJefe => $composableBuilder(
      column: $table.rangoJefe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jefeCargo => $composableBuilder(
      column: $table.jefeCargo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuario => $composableBuilder(
      column: $table.usuario, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preguntaSeguridad => $composableBuilder(
      column: $table.preguntaSeguridad,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get respuestaSeguridad => $composableBuilder(
      column: $table.respuestaSeguridad,
      builder: (column) => ColumnFilters(column));
}

class $$ConfigSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfigSettingsTable> {
  $$ConfigSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombreInstitucion => $composableBuilder(
      column: $table.nombreInstitucion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parqueNombre => $composableBuilder(
      column: $table.parqueNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sectorNombre => $composableBuilder(
      column: $table.sectorNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ciudad => $composableBuilder(
      column: $table.ciudad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get municipio => $composableBuilder(
      column: $table.municipio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombreJefe => $composableBuilder(
      column: $table.nombreJefe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apellidoJefe => $composableBuilder(
      column: $table.apellidoJefe,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rangoJefe => $composableBuilder(
      column: $table.rangoJefe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jefeCargo => $composableBuilder(
      column: $table.jefeCargo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuario => $composableBuilder(
      column: $table.usuario, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preguntaSeguridad => $composableBuilder(
      column: $table.preguntaSeguridad,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get respuestaSeguridad => $composableBuilder(
      column: $table.respuestaSeguridad,
      builder: (column) => ColumnOrderings(column));
}

class $$ConfigSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfigSettingsTable> {
  $$ConfigSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombreInstitucion => $composableBuilder(
      column: $table.nombreInstitucion, builder: (column) => column);

  GeneratedColumn<String> get parqueNombre => $composableBuilder(
      column: $table.parqueNombre, builder: (column) => column);

  GeneratedColumn<String> get sectorNombre => $composableBuilder(
      column: $table.sectorNombre, builder: (column) => column);

  GeneratedColumn<String> get ciudad =>
      $composableBuilder(column: $table.ciudad, builder: (column) => column);

  GeneratedColumn<String> get municipio =>
      $composableBuilder(column: $table.municipio, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get nombreJefe => $composableBuilder(
      column: $table.nombreJefe, builder: (column) => column);

  GeneratedColumn<String> get apellidoJefe => $composableBuilder(
      column: $table.apellidoJefe, builder: (column) => column);

  GeneratedColumn<String> get rangoJefe =>
      $composableBuilder(column: $table.rangoJefe, builder: (column) => column);

  GeneratedColumn<String> get jefeCargo =>
      $composableBuilder(column: $table.jefeCargo, builder: (column) => column);

  GeneratedColumn<String> get usuario =>
      $composableBuilder(column: $table.usuario, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get preguntaSeguridad => $composableBuilder(
      column: $table.preguntaSeguridad, builder: (column) => column);

  GeneratedColumn<String> get respuestaSeguridad => $composableBuilder(
      column: $table.respuestaSeguridad, builder: (column) => column);
}

class $$ConfigSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConfigSettingsTable,
    ConfigSetting,
    $$ConfigSettingsTableFilterComposer,
    $$ConfigSettingsTableOrderingComposer,
    $$ConfigSettingsTableAnnotationComposer,
    $$ConfigSettingsTableCreateCompanionBuilder,
    $$ConfigSettingsTableUpdateCompanionBuilder,
    (
      ConfigSetting,
      BaseReferences<_$AppDatabase, $ConfigSettingsTable, ConfigSetting>
    ),
    ConfigSetting,
    PrefetchHooks Function()> {
  $$ConfigSettingsTableTableManager(
      _$AppDatabase db, $ConfigSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfigSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfigSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfigSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombreInstitucion = const Value.absent(),
            Value<String?> parqueNombre = const Value.absent(),
            Value<String?> sectorNombre = const Value.absent(),
            Value<String?> ciudad = const Value.absent(),
            Value<String?> municipio = const Value.absent(),
            Value<String?> estado = const Value.absent(),
            Value<String> nombreJefe = const Value.absent(),
            Value<String?> apellidoJefe = const Value.absent(),
            Value<String> rangoJefe = const Value.absent(),
            Value<String> jefeCargo = const Value.absent(),
            Value<String> usuario = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String?> preguntaSeguridad = const Value.absent(),
            Value<String?> respuestaSeguridad = const Value.absent(),
          }) =>
              ConfigSettingsCompanion(
            id: id,
            nombreInstitucion: nombreInstitucion,
            parqueNombre: parqueNombre,
            sectorNombre: sectorNombre,
            ciudad: ciudad,
            municipio: municipio,
            estado: estado,
            nombreJefe: nombreJefe,
            apellidoJefe: apellidoJefe,
            rangoJefe: rangoJefe,
            jefeCargo: jefeCargo,
            usuario: usuario,
            password: password,
            preguntaSeguridad: preguntaSeguridad,
            respuestaSeguridad: respuestaSeguridad,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombreInstitucion = const Value.absent(),
            Value<String?> parqueNombre = const Value.absent(),
            Value<String?> sectorNombre = const Value.absent(),
            Value<String?> ciudad = const Value.absent(),
            Value<String?> municipio = const Value.absent(),
            Value<String?> estado = const Value.absent(),
            required String nombreJefe,
            Value<String?> apellidoJefe = const Value.absent(),
            required String rangoJefe,
            Value<String> jefeCargo = const Value.absent(),
            required String usuario,
            required String password,
            Value<String?> preguntaSeguridad = const Value.absent(),
            Value<String?> respuestaSeguridad = const Value.absent(),
          }) =>
              ConfigSettingsCompanion.insert(
            id: id,
            nombreInstitucion: nombreInstitucion,
            parqueNombre: parqueNombre,
            sectorNombre: sectorNombre,
            ciudad: ciudad,
            municipio: municipio,
            estado: estado,
            nombreJefe: nombreJefe,
            apellidoJefe: apellidoJefe,
            rangoJefe: rangoJefe,
            jefeCargo: jefeCargo,
            usuario: usuario,
            password: password,
            preguntaSeguridad: preguntaSeguridad,
            respuestaSeguridad: respuestaSeguridad,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConfigSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConfigSettingsTable,
    ConfigSetting,
    $$ConfigSettingsTableFilterComposer,
    $$ConfigSettingsTableOrderingComposer,
    $$ConfigSettingsTableAnnotationComposer,
    $$ConfigSettingsTableCreateCompanionBuilder,
    $$ConfigSettingsTableUpdateCompanionBuilder,
    (
      ConfigSetting,
      BaseReferences<_$AppDatabase, $ConfigSettingsTable, ConfigSetting>
    ),
    ConfigSetting,
    PrefetchHooks Function()>;
typedef $$RangosTableCreateCompanionBuilder = RangosCompanion Function({
  Value<int> id,
  required String nombre,
  Value<String?> descripcion,
  Value<int> prioridad,
});
typedef $$RangosTableUpdateCompanionBuilder = RangosCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String?> descripcion,
  Value<int> prioridad,
});

final class $$RangosTableReferences
    extends BaseReferences<_$AppDatabase, $RangosTable, Rango> {
  $$RangosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FuncionariosTable, List<Funcionario>>
      _funcionariosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.funcionarios,
              aliasName:
                  $_aliasNameGenerator(db.rangos.id, db.funcionarios.rangoId));

  $$FuncionariosTableProcessedTableManager get funcionariosRefs {
    final manager = $$FuncionariosTableTableManager($_db, $_db.funcionarios)
        .filter((f) => f.rangoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_funcionariosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RangosTableFilterComposer
    extends Composer<_$AppDatabase, $RangosTable> {
  $$RangosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get prioridad => $composableBuilder(
      column: $table.prioridad, builder: (column) => ColumnFilters(column));

  Expression<bool> funcionariosRefs(
      Expression<bool> Function($$FuncionariosTableFilterComposer f) f) {
    final $$FuncionariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.rangoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableFilterComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RangosTableOrderingComposer
    extends Composer<_$AppDatabase, $RangosTable> {
  $$RangosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get prioridad => $composableBuilder(
      column: $table.prioridad, builder: (column) => ColumnOrderings(column));
}

class $$RangosTableAnnotationComposer
    extends Composer<_$AppDatabase, $RangosTable> {
  $$RangosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<int> get prioridad =>
      $composableBuilder(column: $table.prioridad, builder: (column) => column);

  Expression<T> funcionariosRefs<T extends Object>(
      Expression<T> Function($$FuncionariosTableAnnotationComposer a) f) {
    final $$FuncionariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.rangoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableAnnotationComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RangosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RangosTable,
    Rango,
    $$RangosTableFilterComposer,
    $$RangosTableOrderingComposer,
    $$RangosTableAnnotationComposer,
    $$RangosTableCreateCompanionBuilder,
    $$RangosTableUpdateCompanionBuilder,
    (Rango, $$RangosTableReferences),
    Rango,
    PrefetchHooks Function({bool funcionariosRefs})> {
  $$RangosTableTableManager(_$AppDatabase db, $RangosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RangosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RangosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RangosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String?> descripcion = const Value.absent(),
            Value<int> prioridad = const Value.absent(),
          }) =>
              RangosCompanion(
            id: id,
            nombre: nombre,
            descripcion: descripcion,
            prioridad: prioridad,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            Value<String?> descripcion = const Value.absent(),
            Value<int> prioridad = const Value.absent(),
          }) =>
              RangosCompanion.insert(
            id: id,
            nombre: nombre,
            descripcion: descripcion,
            prioridad: prioridad,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RangosTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({funcionariosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (funcionariosRefs) db.funcionarios],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (funcionariosRefs)
                    await $_getPrefetchedData<Rango, $RangosTable, Funcionario>(
                        currentTable: table,
                        referencedTable:
                            $$RangosTableReferences._funcionariosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RangosTableReferences(db, table, p0)
                                .funcionariosRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.rangoId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RangosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RangosTable,
    Rango,
    $$RangosTableFilterComposer,
    $$RangosTableOrderingComposer,
    $$RangosTableAnnotationComposer,
    $$RangosTableCreateCompanionBuilder,
    $$RangosTableUpdateCompanionBuilder,
    (Rango, $$RangosTableReferences),
    Rango,
    PrefetchHooks Function({bool funcionariosRefs})>;
typedef $$TiposGuardiaTableCreateCompanionBuilder = TiposGuardiaCompanion
    Function({
  Value<int> id,
  required String nombre,
  Value<String?> descripcion,
  Value<bool> activo,
});
typedef $$TiposGuardiaTableUpdateCompanionBuilder = TiposGuardiaCompanion
    Function({
  Value<int> id,
  Value<String> nombre,
  Value<String?> descripcion,
  Value<bool> activo,
});

final class $$TiposGuardiaTableReferences extends BaseReferences<_$AppDatabase,
    $TiposGuardiaTable, TiposGuardiaData> {
  $$TiposGuardiaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ActividadesTable, List<Actividade>>
      _actividadesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.actividades,
              aliasName: $_aliasNameGenerator(
                  db.tiposGuardia.id, db.actividades.tipoGuardiaId));

  $$ActividadesTableProcessedTableManager get actividadesRefs {
    final manager = $$ActividadesTableTableManager($_db, $_db.actividades)
        .filter((f) => f.tipoGuardiaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_actividadesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TiposGuardiaTableFilterComposer
    extends Composer<_$AppDatabase, $TiposGuardiaTable> {
  $$TiposGuardiaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  Expression<bool> actividadesRefs(
      Expression<bool> Function($$ActividadesTableFilterComposer f) f) {
    final $$ActividadesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.actividades,
        getReferencedColumn: (t) => t.tipoGuardiaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ActividadesTableFilterComposer(
              $db: $db,
              $table: $db.actividades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TiposGuardiaTableOrderingComposer
    extends Composer<_$AppDatabase, $TiposGuardiaTable> {
  $$TiposGuardiaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));
}

class $$TiposGuardiaTableAnnotationComposer
    extends Composer<_$AppDatabase, $TiposGuardiaTable> {
  $$TiposGuardiaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  Expression<T> actividadesRefs<T extends Object>(
      Expression<T> Function($$ActividadesTableAnnotationComposer a) f) {
    final $$ActividadesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.actividades,
        getReferencedColumn: (t) => t.tipoGuardiaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ActividadesTableAnnotationComposer(
              $db: $db,
              $table: $db.actividades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TiposGuardiaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TiposGuardiaTable,
    TiposGuardiaData,
    $$TiposGuardiaTableFilterComposer,
    $$TiposGuardiaTableOrderingComposer,
    $$TiposGuardiaTableAnnotationComposer,
    $$TiposGuardiaTableCreateCompanionBuilder,
    $$TiposGuardiaTableUpdateCompanionBuilder,
    (TiposGuardiaData, $$TiposGuardiaTableReferences),
    TiposGuardiaData,
    PrefetchHooks Function({bool actividadesRefs})> {
  $$TiposGuardiaTableTableManager(_$AppDatabase db, $TiposGuardiaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TiposGuardiaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TiposGuardiaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TiposGuardiaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String?> descripcion = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              TiposGuardiaCompanion(
            id: id,
            nombre: nombre,
            descripcion: descripcion,
            activo: activo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            Value<String?> descripcion = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              TiposGuardiaCompanion.insert(
            id: id,
            nombre: nombre,
            descripcion: descripcion,
            activo: activo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TiposGuardiaTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({actividadesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (actividadesRefs) db.actividades],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (actividadesRefs)
                    await $_getPrefetchedData<TiposGuardiaData,
                            $TiposGuardiaTable, Actividade>(
                        currentTable: table,
                        referencedTable: $$TiposGuardiaTableReferences
                            ._actividadesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TiposGuardiaTableReferences(db, table, p0)
                                .actividadesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.tipoGuardiaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TiposGuardiaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TiposGuardiaTable,
    TiposGuardiaData,
    $$TiposGuardiaTableFilterComposer,
    $$TiposGuardiaTableOrderingComposer,
    $$TiposGuardiaTableAnnotationComposer,
    $$TiposGuardiaTableCreateCompanionBuilder,
    $$TiposGuardiaTableUpdateCompanionBuilder,
    (TiposGuardiaData, $$TiposGuardiaTableReferences),
    TiposGuardiaData,
    PrefetchHooks Function({bool actividadesRefs})>;
typedef $$UbicacionesTableCreateCompanionBuilder = UbicacionesCompanion
    Function({
  Value<int> id,
  required String nombre,
  Value<String?> descripcion,
  Value<bool> activo,
});
typedef $$UbicacionesTableUpdateCompanionBuilder = UbicacionesCompanion
    Function({
  Value<int> id,
  Value<String> nombre,
  Value<String?> descripcion,
  Value<bool> activo,
});

class $$UbicacionesTableFilterComposer
    extends Composer<_$AppDatabase, $UbicacionesTable> {
  $$UbicacionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));
}

class $$UbicacionesTableOrderingComposer
    extends Composer<_$AppDatabase, $UbicacionesTable> {
  $$UbicacionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));
}

class $$UbicacionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UbicacionesTable> {
  $$UbicacionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);
}

class $$UbicacionesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UbicacionesTable,
    Ubicacione,
    $$UbicacionesTableFilterComposer,
    $$UbicacionesTableOrderingComposer,
    $$UbicacionesTableAnnotationComposer,
    $$UbicacionesTableCreateCompanionBuilder,
    $$UbicacionesTableUpdateCompanionBuilder,
    (Ubicacione, BaseReferences<_$AppDatabase, $UbicacionesTable, Ubicacione>),
    Ubicacione,
    PrefetchHooks Function()> {
  $$UbicacionesTableTableManager(_$AppDatabase db, $UbicacionesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UbicacionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UbicacionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UbicacionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String?> descripcion = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              UbicacionesCompanion(
            id: id,
            nombre: nombre,
            descripcion: descripcion,
            activo: activo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            Value<String?> descripcion = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              UbicacionesCompanion.insert(
            id: id,
            nombre: nombre,
            descripcion: descripcion,
            activo: activo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UbicacionesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UbicacionesTable,
    Ubicacione,
    $$UbicacionesTableFilterComposer,
    $$UbicacionesTableOrderingComposer,
    $$UbicacionesTableAnnotationComposer,
    $$UbicacionesTableCreateCompanionBuilder,
    $$UbicacionesTableUpdateCompanionBuilder,
    (Ubicacione, BaseReferences<_$AppDatabase, $UbicacionesTable, Ubicacione>),
    Ubicacione,
    PrefetchHooks Function()>;
typedef $$PlanificacionesSemanalesTableCreateCompanionBuilder
    = PlanificacionesSemanalesCompanion Function({
  Value<int> id,
  required DateTime fechaInicio,
  required DateTime fechaFin,
  required String codigo,
  Value<bool> cerrada,
});
typedef $$PlanificacionesSemanalesTableUpdateCompanionBuilder
    = PlanificacionesSemanalesCompanion Function({
  Value<int> id,
  Value<DateTime> fechaInicio,
  Value<DateTime> fechaFin,
  Value<String> codigo,
  Value<bool> cerrada,
});

final class $$PlanificacionesSemanalesTableReferences extends BaseReferences<
    _$AppDatabase, $PlanificacionesSemanalesTable, PlanificacionesSemanale> {
  $$PlanificacionesSemanalesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ActividadesTable, List<Actividade>>
      _actividadesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.actividades,
          aliasName: $_aliasNameGenerator(
              db.planificacionesSemanales.id, db.actividades.planificacionId));

  $$ActividadesTableProcessedTableManager get actividadesRefs {
    final manager = $$ActividadesTableTableManager($_db, $_db.actividades)
        .filter(
            (f) => f.planificacionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_actividadesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PlanificacionesSemanalesTableFilterComposer
    extends Composer<_$AppDatabase, $PlanificacionesSemanalesTable> {
  $$PlanificacionesSemanalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
      column: $table.fechaInicio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaFin => $composableBuilder(
      column: $table.fechaFin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get cerrada => $composableBuilder(
      column: $table.cerrada, builder: (column) => ColumnFilters(column));

  Expression<bool> actividadesRefs(
      Expression<bool> Function($$ActividadesTableFilterComposer f) f) {
    final $$ActividadesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.actividades,
        getReferencedColumn: (t) => t.planificacionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ActividadesTableFilterComposer(
              $db: $db,
              $table: $db.actividades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlanificacionesSemanalesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanificacionesSemanalesTable> {
  $$PlanificacionesSemanalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
      column: $table.fechaInicio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaFin => $composableBuilder(
      column: $table.fechaFin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get cerrada => $composableBuilder(
      column: $table.cerrada, builder: (column) => ColumnOrderings(column));
}

class $$PlanificacionesSemanalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanificacionesSemanalesTable> {
  $$PlanificacionesSemanalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
      column: $table.fechaInicio, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaFin =>
      $composableBuilder(column: $table.fechaFin, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<bool> get cerrada =>
      $composableBuilder(column: $table.cerrada, builder: (column) => column);

  Expression<T> actividadesRefs<T extends Object>(
      Expression<T> Function($$ActividadesTableAnnotationComposer a) f) {
    final $$ActividadesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.actividades,
        getReferencedColumn: (t) => t.planificacionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ActividadesTableAnnotationComposer(
              $db: $db,
              $table: $db.actividades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlanificacionesSemanalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlanificacionesSemanalesTable,
    PlanificacionesSemanale,
    $$PlanificacionesSemanalesTableFilterComposer,
    $$PlanificacionesSemanalesTableOrderingComposer,
    $$PlanificacionesSemanalesTableAnnotationComposer,
    $$PlanificacionesSemanalesTableCreateCompanionBuilder,
    $$PlanificacionesSemanalesTableUpdateCompanionBuilder,
    (PlanificacionesSemanale, $$PlanificacionesSemanalesTableReferences),
    PlanificacionesSemanale,
    PrefetchHooks Function({bool actividadesRefs})> {
  $$PlanificacionesSemanalesTableTableManager(
      _$AppDatabase db, $PlanificacionesSemanalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanificacionesSemanalesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanificacionesSemanalesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanificacionesSemanalesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> fechaInicio = const Value.absent(),
            Value<DateTime> fechaFin = const Value.absent(),
            Value<String> codigo = const Value.absent(),
            Value<bool> cerrada = const Value.absent(),
          }) =>
              PlanificacionesSemanalesCompanion(
            id: id,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            codigo: codigo,
            cerrada: cerrada,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime fechaInicio,
            required DateTime fechaFin,
            required String codigo,
            Value<bool> cerrada = const Value.absent(),
          }) =>
              PlanificacionesSemanalesCompanion.insert(
            id: id,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            codigo: codigo,
            cerrada: cerrada,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlanificacionesSemanalesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({actividadesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (actividadesRefs) db.actividades],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (actividadesRefs)
                    await $_getPrefetchedData<PlanificacionesSemanale,
                            $PlanificacionesSemanalesTable, Actividade>(
                        currentTable: table,
                        referencedTable:
                            $$PlanificacionesSemanalesTableReferences
                                ._actividadesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlanificacionesSemanalesTableReferences(
                                    db, table, p0)
                                .actividadesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.planificacionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PlanificacionesSemanalesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $PlanificacionesSemanalesTable,
        PlanificacionesSemanale,
        $$PlanificacionesSemanalesTableFilterComposer,
        $$PlanificacionesSemanalesTableOrderingComposer,
        $$PlanificacionesSemanalesTableAnnotationComposer,
        $$PlanificacionesSemanalesTableCreateCompanionBuilder,
        $$PlanificacionesSemanalesTableUpdateCompanionBuilder,
        (PlanificacionesSemanale, $$PlanificacionesSemanalesTableReferences),
        PlanificacionesSemanale,
        PrefetchHooks Function({bool actividadesRefs})>;
typedef $$FuncionariosTableCreateCompanionBuilder = FuncionariosCompanion
    Function({
  Value<int> id,
  required String nombres,
  required String apellidos,
  required String cedula,
  Value<String?> rango,
  Value<int?> rangoId,
  Value<DateTime?> fechaNacimiento,
  Value<DateTime?> fechaIngreso,
  Value<String?> telefono,
  Value<int> diasLaboralesSemanales,
  Value<String?> diasLibresPreferidos,
  Value<int> saldoCompensacion,
  Value<bool> estaActivo,
  Value<String?> fotoPath,
  Value<DateTime?> ultimaFechaPernocta,
});
typedef $$FuncionariosTableUpdateCompanionBuilder = FuncionariosCompanion
    Function({
  Value<int> id,
  Value<String> nombres,
  Value<String> apellidos,
  Value<String> cedula,
  Value<String?> rango,
  Value<int?> rangoId,
  Value<DateTime?> fechaNacimiento,
  Value<DateTime?> fechaIngreso,
  Value<String?> telefono,
  Value<int> diasLaboralesSemanales,
  Value<String?> diasLibresPreferidos,
  Value<int> saldoCompensacion,
  Value<bool> estaActivo,
  Value<String?> fotoPath,
  Value<DateTime?> ultimaFechaPernocta,
});

final class $$FuncionariosTableReferences
    extends BaseReferences<_$AppDatabase, $FuncionariosTable, Funcionario> {
  $$FuncionariosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RangosTable _rangoIdTable(_$AppDatabase db) => db.rangos
      .createAlias($_aliasNameGenerator(db.funcionarios.rangoId, db.rangos.id));

  $$RangosTableProcessedTableManager? get rangoId {
    final $_column = $_itemColumn<int>('rango_id');
    if ($_column == null) return null;
    final manager = $$RangosTableTableManager($_db, $_db.rangos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rangoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$EstudiosAcademicosTable, List<EstudiosAcademico>>
      _estudiosAcademicosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.estudiosAcademicos,
              aliasName: $_aliasNameGenerator(
                  db.funcionarios.id, db.estudiosAcademicos.funcionarioId));

  $$EstudiosAcademicosTableProcessedTableManager get estudiosAcademicosRefs {
    final manager = $$EstudiosAcademicosTableTableManager(
            $_db, $_db.estudiosAcademicos)
        .filter((f) => f.funcionarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_estudiosAcademicosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CursosCertificadosTable, List<CursosCertificado>>
      _cursosCertificadosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.cursosCertificados,
              aliasName: $_aliasNameGenerator(
                  db.funcionarios.id, db.cursosCertificados.funcionarioId));

  $$CursosCertificadosTableProcessedTableManager get cursosCertificadosRefs {
    final manager = $$CursosCertificadosTableTableManager(
            $_db, $_db.cursosCertificados)
        .filter((f) => f.funcionarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_cursosCertificadosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$FamiliaresTable, List<Familiare>>
      _familiaresRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.familiares,
              aliasName: $_aliasNameGenerator(
                  db.funcionarios.id, db.familiares.funcionarioId));

  $$FamiliaresTableProcessedTableManager get familiaresRefs {
    final manager = $$FamiliaresTableTableManager($_db, $_db.familiares)
        .filter((f) => f.funcionarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_familiaresRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HijosTable, List<Hijo>> _hijosRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.hijos,
          aliasName:
              $_aliasNameGenerator(db.funcionarios.id, db.hijos.funcionarioId));

  $$HijosTableProcessedTableManager get hijosRefs {
    final manager = $$HijosTableTableManager($_db, $_db.hijos)
        .filter((f) => f.funcionarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_hijosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ActividadesTable, List<Actividade>>
      _actividadesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.actividades,
              aliasName: $_aliasNameGenerator(
                  db.funcionarios.id, db.actividades.jefeServicioId));

  $$ActividadesTableProcessedTableManager get actividadesRefs {
    final manager = $$ActividadesTableTableManager($_db, $_db.actividades)
        .filter((f) => f.jefeServicioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_actividadesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AsignacionesTable, List<Asignacione>>
      _asignacionesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.asignaciones,
              aliasName: $_aliasNameGenerator(
                  db.funcionarios.id, db.asignaciones.funcionarioId));

  $$AsignacionesTableProcessedTableManager get asignacionesRefs {
    final manager = $$AsignacionesTableTableManager($_db, $_db.asignaciones)
        .filter((f) => f.funcionarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_asignacionesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AusenciasTable, List<Ausencia>>
      _ausenciasRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.ausencias,
              aliasName: $_aliasNameGenerator(
                  db.funcionarios.id, db.ausencias.funcionarioId));

  $$AusenciasTableProcessedTableManager get ausenciasRefs {
    final manager = $$AusenciasTableTableManager($_db, $_db.ausencias)
        .filter((f) => f.funcionarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ausenciasRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$FuncionariosTableFilterComposer
    extends Composer<_$AppDatabase, $FuncionariosTable> {
  $$FuncionariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombres => $composableBuilder(
      column: $table.nombres, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apellidos => $composableBuilder(
      column: $table.apellidos, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cedula => $composableBuilder(
      column: $table.cedula, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rango => $composableBuilder(
      column: $table.rango, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaNacimiento => $composableBuilder(
      column: $table.fechaNacimiento,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaIngreso => $composableBuilder(
      column: $table.fechaIngreso, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get diasLaboralesSemanales => $composableBuilder(
      column: $table.diasLaboralesSemanales,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get diasLibresPreferidos => $composableBuilder(
      column: $table.diasLibresPreferidos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saldoCompensacion => $composableBuilder(
      column: $table.saldoCompensacion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get estaActivo => $composableBuilder(
      column: $table.estaActivo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fotoPath => $composableBuilder(
      column: $table.fotoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get ultimaFechaPernocta => $composableBuilder(
      column: $table.ultimaFechaPernocta,
      builder: (column) => ColumnFilters(column));

  $$RangosTableFilterComposer get rangoId {
    final $$RangosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rangoId,
        referencedTable: $db.rangos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RangosTableFilterComposer(
              $db: $db,
              $table: $db.rangos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> estudiosAcademicosRefs(
      Expression<bool> Function($$EstudiosAcademicosTableFilterComposer f) f) {
    final $$EstudiosAcademicosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.estudiosAcademicos,
        getReferencedColumn: (t) => t.funcionarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EstudiosAcademicosTableFilterComposer(
              $db: $db,
              $table: $db.estudiosAcademicos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> cursosCertificadosRefs(
      Expression<bool> Function($$CursosCertificadosTableFilterComposer f) f) {
    final $$CursosCertificadosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.cursosCertificados,
        getReferencedColumn: (t) => t.funcionarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CursosCertificadosTableFilterComposer(
              $db: $db,
              $table: $db.cursosCertificados,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> familiaresRefs(
      Expression<bool> Function($$FamiliaresTableFilterComposer f) f) {
    final $$FamiliaresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.familiares,
        getReferencedColumn: (t) => t.funcionarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FamiliaresTableFilterComposer(
              $db: $db,
              $table: $db.familiares,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> hijosRefs(
      Expression<bool> Function($$HijosTableFilterComposer f) f) {
    final $$HijosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.hijos,
        getReferencedColumn: (t) => t.funcionarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HijosTableFilterComposer(
              $db: $db,
              $table: $db.hijos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> actividadesRefs(
      Expression<bool> Function($$ActividadesTableFilterComposer f) f) {
    final $$ActividadesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.actividades,
        getReferencedColumn: (t) => t.jefeServicioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ActividadesTableFilterComposer(
              $db: $db,
              $table: $db.actividades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> asignacionesRefs(
      Expression<bool> Function($$AsignacionesTableFilterComposer f) f) {
    final $$AsignacionesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.asignaciones,
        getReferencedColumn: (t) => t.funcionarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AsignacionesTableFilterComposer(
              $db: $db,
              $table: $db.asignaciones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> ausenciasRefs(
      Expression<bool> Function($$AusenciasTableFilterComposer f) f) {
    final $$AusenciasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ausencias,
        getReferencedColumn: (t) => t.funcionarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AusenciasTableFilterComposer(
              $db: $db,
              $table: $db.ausencias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FuncionariosTableOrderingComposer
    extends Composer<_$AppDatabase, $FuncionariosTable> {
  $$FuncionariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombres => $composableBuilder(
      column: $table.nombres, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apellidos => $composableBuilder(
      column: $table.apellidos, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cedula => $composableBuilder(
      column: $table.cedula, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rango => $composableBuilder(
      column: $table.rango, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaNacimiento => $composableBuilder(
      column: $table.fechaNacimiento,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaIngreso => $composableBuilder(
      column: $table.fechaIngreso,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get diasLaboralesSemanales => $composableBuilder(
      column: $table.diasLaboralesSemanales,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get diasLibresPreferidos => $composableBuilder(
      column: $table.diasLibresPreferidos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saldoCompensacion => $composableBuilder(
      column: $table.saldoCompensacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get estaActivo => $composableBuilder(
      column: $table.estaActivo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fotoPath => $composableBuilder(
      column: $table.fotoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get ultimaFechaPernocta => $composableBuilder(
      column: $table.ultimaFechaPernocta,
      builder: (column) => ColumnOrderings(column));

  $$RangosTableOrderingComposer get rangoId {
    final $$RangosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rangoId,
        referencedTable: $db.rangos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RangosTableOrderingComposer(
              $db: $db,
              $table: $db.rangos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FuncionariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $FuncionariosTable> {
  $$FuncionariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombres =>
      $composableBuilder(column: $table.nombres, builder: (column) => column);

  GeneratedColumn<String> get apellidos =>
      $composableBuilder(column: $table.apellidos, builder: (column) => column);

  GeneratedColumn<String> get cedula =>
      $composableBuilder(column: $table.cedula, builder: (column) => column);

  GeneratedColumn<String> get rango =>
      $composableBuilder(column: $table.rango, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaNacimiento => $composableBuilder(
      column: $table.fechaNacimiento, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaIngreso => $composableBuilder(
      column: $table.fechaIngreso, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<int> get diasLaboralesSemanales => $composableBuilder(
      column: $table.diasLaboralesSemanales, builder: (column) => column);

  GeneratedColumn<String> get diasLibresPreferidos => $composableBuilder(
      column: $table.diasLibresPreferidos, builder: (column) => column);

  GeneratedColumn<int> get saldoCompensacion => $composableBuilder(
      column: $table.saldoCompensacion, builder: (column) => column);

  GeneratedColumn<bool> get estaActivo => $composableBuilder(
      column: $table.estaActivo, builder: (column) => column);

  GeneratedColumn<String> get fotoPath =>
      $composableBuilder(column: $table.fotoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get ultimaFechaPernocta => $composableBuilder(
      column: $table.ultimaFechaPernocta, builder: (column) => column);

  $$RangosTableAnnotationComposer get rangoId {
    final $$RangosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rangoId,
        referencedTable: $db.rangos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RangosTableAnnotationComposer(
              $db: $db,
              $table: $db.rangos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> estudiosAcademicosRefs<T extends Object>(
      Expression<T> Function($$EstudiosAcademicosTableAnnotationComposer a) f) {
    final $$EstudiosAcademicosTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.estudiosAcademicos,
            getReferencedColumn: (t) => t.funcionarioId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EstudiosAcademicosTableAnnotationComposer(
                  $db: $db,
                  $table: $db.estudiosAcademicos,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> cursosCertificadosRefs<T extends Object>(
      Expression<T> Function($$CursosCertificadosTableAnnotationComposer a) f) {
    final $$CursosCertificadosTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.cursosCertificados,
            getReferencedColumn: (t) => t.funcionarioId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CursosCertificadosTableAnnotationComposer(
                  $db: $db,
                  $table: $db.cursosCertificados,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> familiaresRefs<T extends Object>(
      Expression<T> Function($$FamiliaresTableAnnotationComposer a) f) {
    final $$FamiliaresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.familiares,
        getReferencedColumn: (t) => t.funcionarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FamiliaresTableAnnotationComposer(
              $db: $db,
              $table: $db.familiares,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> hijosRefs<T extends Object>(
      Expression<T> Function($$HijosTableAnnotationComposer a) f) {
    final $$HijosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.hijos,
        getReferencedColumn: (t) => t.funcionarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HijosTableAnnotationComposer(
              $db: $db,
              $table: $db.hijos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> actividadesRefs<T extends Object>(
      Expression<T> Function($$ActividadesTableAnnotationComposer a) f) {
    final $$ActividadesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.actividades,
        getReferencedColumn: (t) => t.jefeServicioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ActividadesTableAnnotationComposer(
              $db: $db,
              $table: $db.actividades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> asignacionesRefs<T extends Object>(
      Expression<T> Function($$AsignacionesTableAnnotationComposer a) f) {
    final $$AsignacionesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.asignaciones,
        getReferencedColumn: (t) => t.funcionarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AsignacionesTableAnnotationComposer(
              $db: $db,
              $table: $db.asignaciones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> ausenciasRefs<T extends Object>(
      Expression<T> Function($$AusenciasTableAnnotationComposer a) f) {
    final $$AusenciasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ausencias,
        getReferencedColumn: (t) => t.funcionarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AusenciasTableAnnotationComposer(
              $db: $db,
              $table: $db.ausencias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FuncionariosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FuncionariosTable,
    Funcionario,
    $$FuncionariosTableFilterComposer,
    $$FuncionariosTableOrderingComposer,
    $$FuncionariosTableAnnotationComposer,
    $$FuncionariosTableCreateCompanionBuilder,
    $$FuncionariosTableUpdateCompanionBuilder,
    (Funcionario, $$FuncionariosTableReferences),
    Funcionario,
    PrefetchHooks Function(
        {bool rangoId,
        bool estudiosAcademicosRefs,
        bool cursosCertificadosRefs,
        bool familiaresRefs,
        bool hijosRefs,
        bool actividadesRefs,
        bool asignacionesRefs,
        bool ausenciasRefs})> {
  $$FuncionariosTableTableManager(_$AppDatabase db, $FuncionariosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FuncionariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FuncionariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FuncionariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombres = const Value.absent(),
            Value<String> apellidos = const Value.absent(),
            Value<String> cedula = const Value.absent(),
            Value<String?> rango = const Value.absent(),
            Value<int?> rangoId = const Value.absent(),
            Value<DateTime?> fechaNacimiento = const Value.absent(),
            Value<DateTime?> fechaIngreso = const Value.absent(),
            Value<String?> telefono = const Value.absent(),
            Value<int> diasLaboralesSemanales = const Value.absent(),
            Value<String?> diasLibresPreferidos = const Value.absent(),
            Value<int> saldoCompensacion = const Value.absent(),
            Value<bool> estaActivo = const Value.absent(),
            Value<String?> fotoPath = const Value.absent(),
            Value<DateTime?> ultimaFechaPernocta = const Value.absent(),
          }) =>
              FuncionariosCompanion(
            id: id,
            nombres: nombres,
            apellidos: apellidos,
            cedula: cedula,
            rango: rango,
            rangoId: rangoId,
            fechaNacimiento: fechaNacimiento,
            fechaIngreso: fechaIngreso,
            telefono: telefono,
            diasLaboralesSemanales: diasLaboralesSemanales,
            diasLibresPreferidos: diasLibresPreferidos,
            saldoCompensacion: saldoCompensacion,
            estaActivo: estaActivo,
            fotoPath: fotoPath,
            ultimaFechaPernocta: ultimaFechaPernocta,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombres,
            required String apellidos,
            required String cedula,
            Value<String?> rango = const Value.absent(),
            Value<int?> rangoId = const Value.absent(),
            Value<DateTime?> fechaNacimiento = const Value.absent(),
            Value<DateTime?> fechaIngreso = const Value.absent(),
            Value<String?> telefono = const Value.absent(),
            Value<int> diasLaboralesSemanales = const Value.absent(),
            Value<String?> diasLibresPreferidos = const Value.absent(),
            Value<int> saldoCompensacion = const Value.absent(),
            Value<bool> estaActivo = const Value.absent(),
            Value<String?> fotoPath = const Value.absent(),
            Value<DateTime?> ultimaFechaPernocta = const Value.absent(),
          }) =>
              FuncionariosCompanion.insert(
            id: id,
            nombres: nombres,
            apellidos: apellidos,
            cedula: cedula,
            rango: rango,
            rangoId: rangoId,
            fechaNacimiento: fechaNacimiento,
            fechaIngreso: fechaIngreso,
            telefono: telefono,
            diasLaboralesSemanales: diasLaboralesSemanales,
            diasLibresPreferidos: diasLibresPreferidos,
            saldoCompensacion: saldoCompensacion,
            estaActivo: estaActivo,
            fotoPath: fotoPath,
            ultimaFechaPernocta: ultimaFechaPernocta,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FuncionariosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {rangoId = false,
              estudiosAcademicosRefs = false,
              cursosCertificadosRefs = false,
              familiaresRefs = false,
              hijosRefs = false,
              actividadesRefs = false,
              asignacionesRefs = false,
              ausenciasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (estudiosAcademicosRefs) db.estudiosAcademicos,
                if (cursosCertificadosRefs) db.cursosCertificados,
                if (familiaresRefs) db.familiares,
                if (hijosRefs) db.hijos,
                if (actividadesRefs) db.actividades,
                if (asignacionesRefs) db.asignaciones,
                if (ausenciasRefs) db.ausencias
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (rangoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.rangoId,
                    referencedTable:
                        $$FuncionariosTableReferences._rangoIdTable(db),
                    referencedColumn:
                        $$FuncionariosTableReferences._rangoIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (estudiosAcademicosRefs)
                    await $_getPrefetchedData<Funcionario, $FuncionariosTable,
                            EstudiosAcademico>(
                        currentTable: table,
                        referencedTable: $$FuncionariosTableReferences
                            ._estudiosAcademicosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FuncionariosTableReferences(db, table, p0)
                                .estudiosAcademicosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.funcionarioId == item.id),
                        typedResults: items),
                  if (cursosCertificadosRefs)
                    await $_getPrefetchedData<Funcionario, $FuncionariosTable,
                            CursosCertificado>(
                        currentTable: table,
                        referencedTable: $$FuncionariosTableReferences
                            ._cursosCertificadosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FuncionariosTableReferences(db, table, p0)
                                .cursosCertificadosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.funcionarioId == item.id),
                        typedResults: items),
                  if (familiaresRefs)
                    await $_getPrefetchedData<Funcionario, $FuncionariosTable,
                            Familiare>(
                        currentTable: table,
                        referencedTable: $$FuncionariosTableReferences
                            ._familiaresRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FuncionariosTableReferences(db, table, p0)
                                .familiaresRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.funcionarioId == item.id),
                        typedResults: items),
                  if (hijosRefs)
                    await $_getPrefetchedData<Funcionario, $FuncionariosTable,
                            Hijo>(
                        currentTable: table,
                        referencedTable:
                            $$FuncionariosTableReferences._hijosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FuncionariosTableReferences(db, table, p0)
                                .hijosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.funcionarioId == item.id),
                        typedResults: items),
                  if (actividadesRefs)
                    await $_getPrefetchedData<Funcionario, $FuncionariosTable,
                            Actividade>(
                        currentTable: table,
                        referencedTable: $$FuncionariosTableReferences
                            ._actividadesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FuncionariosTableReferences(db, table, p0)
                                .actividadesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.jefeServicioId == item.id),
                        typedResults: items),
                  if (asignacionesRefs)
                    await $_getPrefetchedData<Funcionario, $FuncionariosTable,
                            Asignacione>(
                        currentTable: table,
                        referencedTable: $$FuncionariosTableReferences
                            ._asignacionesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FuncionariosTableReferences(db, table, p0)
                                .asignacionesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.funcionarioId == item.id),
                        typedResults: items),
                  if (ausenciasRefs)
                    await $_getPrefetchedData<Funcionario, $FuncionariosTable,
                            Ausencia>(
                        currentTable: table,
                        referencedTable: $$FuncionariosTableReferences
                            ._ausenciasRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FuncionariosTableReferences(db, table, p0)
                                .ausenciasRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.funcionarioId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$FuncionariosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FuncionariosTable,
    Funcionario,
    $$FuncionariosTableFilterComposer,
    $$FuncionariosTableOrderingComposer,
    $$FuncionariosTableAnnotationComposer,
    $$FuncionariosTableCreateCompanionBuilder,
    $$FuncionariosTableUpdateCompanionBuilder,
    (Funcionario, $$FuncionariosTableReferences),
    Funcionario,
    PrefetchHooks Function(
        {bool rangoId,
        bool estudiosAcademicosRefs,
        bool cursosCertificadosRefs,
        bool familiaresRefs,
        bool hijosRefs,
        bool actividadesRefs,
        bool asignacionesRefs,
        bool ausenciasRefs})>;
typedef $$EstudiosAcademicosTableCreateCompanionBuilder
    = EstudiosAcademicosCompanion Function({
  Value<int> id,
  required int funcionarioId,
  required String gradoInstruccion,
  required String tituloObtenido,
  Value<String?> rutaPdfTitulo,
});
typedef $$EstudiosAcademicosTableUpdateCompanionBuilder
    = EstudiosAcademicosCompanion Function({
  Value<int> id,
  Value<int> funcionarioId,
  Value<String> gradoInstruccion,
  Value<String> tituloObtenido,
  Value<String?> rutaPdfTitulo,
});

final class $$EstudiosAcademicosTableReferences extends BaseReferences<
    _$AppDatabase, $EstudiosAcademicosTable, EstudiosAcademico> {
  $$EstudiosAcademicosTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $FuncionariosTable _funcionarioIdTable(_$AppDatabase db) =>
      db.funcionarios.createAlias($_aliasNameGenerator(
          db.estudiosAcademicos.funcionarioId, db.funcionarios.id));

  $$FuncionariosTableProcessedTableManager get funcionarioId {
    final $_column = $_itemColumn<int>('funcionario_id')!;

    final manager = $$FuncionariosTableTableManager($_db, $_db.funcionarios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_funcionarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EstudiosAcademicosTableFilterComposer
    extends Composer<_$AppDatabase, $EstudiosAcademicosTable> {
  $$EstudiosAcademicosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gradoInstruccion => $composableBuilder(
      column: $table.gradoInstruccion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tituloObtenido => $composableBuilder(
      column: $table.tituloObtenido,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rutaPdfTitulo => $composableBuilder(
      column: $table.rutaPdfTitulo, builder: (column) => ColumnFilters(column));

  $$FuncionariosTableFilterComposer get funcionarioId {
    final $$FuncionariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableFilterComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EstudiosAcademicosTableOrderingComposer
    extends Composer<_$AppDatabase, $EstudiosAcademicosTable> {
  $$EstudiosAcademicosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gradoInstruccion => $composableBuilder(
      column: $table.gradoInstruccion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tituloObtenido => $composableBuilder(
      column: $table.tituloObtenido,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rutaPdfTitulo => $composableBuilder(
      column: $table.rutaPdfTitulo,
      builder: (column) => ColumnOrderings(column));

  $$FuncionariosTableOrderingComposer get funcionarioId {
    final $$FuncionariosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableOrderingComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EstudiosAcademicosTableAnnotationComposer
    extends Composer<_$AppDatabase, $EstudiosAcademicosTable> {
  $$EstudiosAcademicosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gradoInstruccion => $composableBuilder(
      column: $table.gradoInstruccion, builder: (column) => column);

  GeneratedColumn<String> get tituloObtenido => $composableBuilder(
      column: $table.tituloObtenido, builder: (column) => column);

  GeneratedColumn<String> get rutaPdfTitulo => $composableBuilder(
      column: $table.rutaPdfTitulo, builder: (column) => column);

  $$FuncionariosTableAnnotationComposer get funcionarioId {
    final $$FuncionariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableAnnotationComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EstudiosAcademicosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EstudiosAcademicosTable,
    EstudiosAcademico,
    $$EstudiosAcademicosTableFilterComposer,
    $$EstudiosAcademicosTableOrderingComposer,
    $$EstudiosAcademicosTableAnnotationComposer,
    $$EstudiosAcademicosTableCreateCompanionBuilder,
    $$EstudiosAcademicosTableUpdateCompanionBuilder,
    (EstudiosAcademico, $$EstudiosAcademicosTableReferences),
    EstudiosAcademico,
    PrefetchHooks Function({bool funcionarioId})> {
  $$EstudiosAcademicosTableTableManager(
      _$AppDatabase db, $EstudiosAcademicosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EstudiosAcademicosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EstudiosAcademicosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EstudiosAcademicosTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> funcionarioId = const Value.absent(),
            Value<String> gradoInstruccion = const Value.absent(),
            Value<String> tituloObtenido = const Value.absent(),
            Value<String?> rutaPdfTitulo = const Value.absent(),
          }) =>
              EstudiosAcademicosCompanion(
            id: id,
            funcionarioId: funcionarioId,
            gradoInstruccion: gradoInstruccion,
            tituloObtenido: tituloObtenido,
            rutaPdfTitulo: rutaPdfTitulo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int funcionarioId,
            required String gradoInstruccion,
            required String tituloObtenido,
            Value<String?> rutaPdfTitulo = const Value.absent(),
          }) =>
              EstudiosAcademicosCompanion.insert(
            id: id,
            funcionarioId: funcionarioId,
            gradoInstruccion: gradoInstruccion,
            tituloObtenido: tituloObtenido,
            rutaPdfTitulo: rutaPdfTitulo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EstudiosAcademicosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({funcionarioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (funcionarioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.funcionarioId,
                    referencedTable: $$EstudiosAcademicosTableReferences
                        ._funcionarioIdTable(db),
                    referencedColumn: $$EstudiosAcademicosTableReferences
                        ._funcionarioIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EstudiosAcademicosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EstudiosAcademicosTable,
    EstudiosAcademico,
    $$EstudiosAcademicosTableFilterComposer,
    $$EstudiosAcademicosTableOrderingComposer,
    $$EstudiosAcademicosTableAnnotationComposer,
    $$EstudiosAcademicosTableCreateCompanionBuilder,
    $$EstudiosAcademicosTableUpdateCompanionBuilder,
    (EstudiosAcademico, $$EstudiosAcademicosTableReferences),
    EstudiosAcademico,
    PrefetchHooks Function({bool funcionarioId})>;
typedef $$CursosCertificadosTableCreateCompanionBuilder
    = CursosCertificadosCompanion Function({
  Value<int> id,
  required int funcionarioId,
  required String nombreCertificado,
  Value<String?> rutaPdfCertificado,
});
typedef $$CursosCertificadosTableUpdateCompanionBuilder
    = CursosCertificadosCompanion Function({
  Value<int> id,
  Value<int> funcionarioId,
  Value<String> nombreCertificado,
  Value<String?> rutaPdfCertificado,
});

final class $$CursosCertificadosTableReferences extends BaseReferences<
    _$AppDatabase, $CursosCertificadosTable, CursosCertificado> {
  $$CursosCertificadosTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $FuncionariosTable _funcionarioIdTable(_$AppDatabase db) =>
      db.funcionarios.createAlias($_aliasNameGenerator(
          db.cursosCertificados.funcionarioId, db.funcionarios.id));

  $$FuncionariosTableProcessedTableManager get funcionarioId {
    final $_column = $_itemColumn<int>('funcionario_id')!;

    final manager = $$FuncionariosTableTableManager($_db, $_db.funcionarios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_funcionarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CursosCertificadosTableFilterComposer
    extends Composer<_$AppDatabase, $CursosCertificadosTable> {
  $$CursosCertificadosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombreCertificado => $composableBuilder(
      column: $table.nombreCertificado,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rutaPdfCertificado => $composableBuilder(
      column: $table.rutaPdfCertificado,
      builder: (column) => ColumnFilters(column));

  $$FuncionariosTableFilterComposer get funcionarioId {
    final $$FuncionariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableFilterComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CursosCertificadosTableOrderingComposer
    extends Composer<_$AppDatabase, $CursosCertificadosTable> {
  $$CursosCertificadosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombreCertificado => $composableBuilder(
      column: $table.nombreCertificado,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rutaPdfCertificado => $composableBuilder(
      column: $table.rutaPdfCertificado,
      builder: (column) => ColumnOrderings(column));

  $$FuncionariosTableOrderingComposer get funcionarioId {
    final $$FuncionariosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableOrderingComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CursosCertificadosTableAnnotationComposer
    extends Composer<_$AppDatabase, $CursosCertificadosTable> {
  $$CursosCertificadosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombreCertificado => $composableBuilder(
      column: $table.nombreCertificado, builder: (column) => column);

  GeneratedColumn<String> get rutaPdfCertificado => $composableBuilder(
      column: $table.rutaPdfCertificado, builder: (column) => column);

  $$FuncionariosTableAnnotationComposer get funcionarioId {
    final $$FuncionariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableAnnotationComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CursosCertificadosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CursosCertificadosTable,
    CursosCertificado,
    $$CursosCertificadosTableFilterComposer,
    $$CursosCertificadosTableOrderingComposer,
    $$CursosCertificadosTableAnnotationComposer,
    $$CursosCertificadosTableCreateCompanionBuilder,
    $$CursosCertificadosTableUpdateCompanionBuilder,
    (CursosCertificado, $$CursosCertificadosTableReferences),
    CursosCertificado,
    PrefetchHooks Function({bool funcionarioId})> {
  $$CursosCertificadosTableTableManager(
      _$AppDatabase db, $CursosCertificadosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CursosCertificadosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CursosCertificadosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CursosCertificadosTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> funcionarioId = const Value.absent(),
            Value<String> nombreCertificado = const Value.absent(),
            Value<String?> rutaPdfCertificado = const Value.absent(),
          }) =>
              CursosCertificadosCompanion(
            id: id,
            funcionarioId: funcionarioId,
            nombreCertificado: nombreCertificado,
            rutaPdfCertificado: rutaPdfCertificado,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int funcionarioId,
            required String nombreCertificado,
            Value<String?> rutaPdfCertificado = const Value.absent(),
          }) =>
              CursosCertificadosCompanion.insert(
            id: id,
            funcionarioId: funcionarioId,
            nombreCertificado: nombreCertificado,
            rutaPdfCertificado: rutaPdfCertificado,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CursosCertificadosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({funcionarioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (funcionarioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.funcionarioId,
                    referencedTable: $$CursosCertificadosTableReferences
                        ._funcionarioIdTable(db),
                    referencedColumn: $$CursosCertificadosTableReferences
                        ._funcionarioIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CursosCertificadosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CursosCertificadosTable,
    CursosCertificado,
    $$CursosCertificadosTableFilterComposer,
    $$CursosCertificadosTableOrderingComposer,
    $$CursosCertificadosTableAnnotationComposer,
    $$CursosCertificadosTableCreateCompanionBuilder,
    $$CursosCertificadosTableUpdateCompanionBuilder,
    (CursosCertificado, $$CursosCertificadosTableReferences),
    CursosCertificado,
    PrefetchHooks Function({bool funcionarioId})>;
typedef $$FamiliaresTableCreateCompanionBuilder = FamiliaresCompanion Function({
  Value<int> id,
  required int funcionarioId,
  required String nombres,
  required String apellidos,
  required String cedula,
  required int edad,
  Value<String?> telefono,
  Value<String> parentesco,
});
typedef $$FamiliaresTableUpdateCompanionBuilder = FamiliaresCompanion Function({
  Value<int> id,
  Value<int> funcionarioId,
  Value<String> nombres,
  Value<String> apellidos,
  Value<String> cedula,
  Value<int> edad,
  Value<String?> telefono,
  Value<String> parentesco,
});

final class $$FamiliaresTableReferences
    extends BaseReferences<_$AppDatabase, $FamiliaresTable, Familiare> {
  $$FamiliaresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FuncionariosTable _funcionarioIdTable(_$AppDatabase db) =>
      db.funcionarios.createAlias($_aliasNameGenerator(
          db.familiares.funcionarioId, db.funcionarios.id));

  $$FuncionariosTableProcessedTableManager get funcionarioId {
    final $_column = $_itemColumn<int>('funcionario_id')!;

    final manager = $$FuncionariosTableTableManager($_db, $_db.funcionarios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_funcionarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FamiliaresTableFilterComposer
    extends Composer<_$AppDatabase, $FamiliaresTable> {
  $$FamiliaresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombres => $composableBuilder(
      column: $table.nombres, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apellidos => $composableBuilder(
      column: $table.apellidos, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cedula => $composableBuilder(
      column: $table.cedula, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get edad => $composableBuilder(
      column: $table.edad, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentesco => $composableBuilder(
      column: $table.parentesco, builder: (column) => ColumnFilters(column));

  $$FuncionariosTableFilterComposer get funcionarioId {
    final $$FuncionariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableFilterComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FamiliaresTableOrderingComposer
    extends Composer<_$AppDatabase, $FamiliaresTable> {
  $$FamiliaresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombres => $composableBuilder(
      column: $table.nombres, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apellidos => $composableBuilder(
      column: $table.apellidos, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cedula => $composableBuilder(
      column: $table.cedula, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get edad => $composableBuilder(
      column: $table.edad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentesco => $composableBuilder(
      column: $table.parentesco, builder: (column) => ColumnOrderings(column));

  $$FuncionariosTableOrderingComposer get funcionarioId {
    final $$FuncionariosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableOrderingComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FamiliaresTableAnnotationComposer
    extends Composer<_$AppDatabase, $FamiliaresTable> {
  $$FamiliaresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombres =>
      $composableBuilder(column: $table.nombres, builder: (column) => column);

  GeneratedColumn<String> get apellidos =>
      $composableBuilder(column: $table.apellidos, builder: (column) => column);

  GeneratedColumn<String> get cedula =>
      $composableBuilder(column: $table.cedula, builder: (column) => column);

  GeneratedColumn<int> get edad =>
      $composableBuilder(column: $table.edad, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get parentesco => $composableBuilder(
      column: $table.parentesco, builder: (column) => column);

  $$FuncionariosTableAnnotationComposer get funcionarioId {
    final $$FuncionariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableAnnotationComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FamiliaresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FamiliaresTable,
    Familiare,
    $$FamiliaresTableFilterComposer,
    $$FamiliaresTableOrderingComposer,
    $$FamiliaresTableAnnotationComposer,
    $$FamiliaresTableCreateCompanionBuilder,
    $$FamiliaresTableUpdateCompanionBuilder,
    (Familiare, $$FamiliaresTableReferences),
    Familiare,
    PrefetchHooks Function({bool funcionarioId})> {
  $$FamiliaresTableTableManager(_$AppDatabase db, $FamiliaresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamiliaresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamiliaresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamiliaresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> funcionarioId = const Value.absent(),
            Value<String> nombres = const Value.absent(),
            Value<String> apellidos = const Value.absent(),
            Value<String> cedula = const Value.absent(),
            Value<int> edad = const Value.absent(),
            Value<String?> telefono = const Value.absent(),
            Value<String> parentesco = const Value.absent(),
          }) =>
              FamiliaresCompanion(
            id: id,
            funcionarioId: funcionarioId,
            nombres: nombres,
            apellidos: apellidos,
            cedula: cedula,
            edad: edad,
            telefono: telefono,
            parentesco: parentesco,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int funcionarioId,
            required String nombres,
            required String apellidos,
            required String cedula,
            required int edad,
            Value<String?> telefono = const Value.absent(),
            Value<String> parentesco = const Value.absent(),
          }) =>
              FamiliaresCompanion.insert(
            id: id,
            funcionarioId: funcionarioId,
            nombres: nombres,
            apellidos: apellidos,
            cedula: cedula,
            edad: edad,
            telefono: telefono,
            parentesco: parentesco,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FamiliaresTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({funcionarioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (funcionarioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.funcionarioId,
                    referencedTable:
                        $$FamiliaresTableReferences._funcionarioIdTable(db),
                    referencedColumn:
                        $$FamiliaresTableReferences._funcionarioIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FamiliaresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FamiliaresTable,
    Familiare,
    $$FamiliaresTableFilterComposer,
    $$FamiliaresTableOrderingComposer,
    $$FamiliaresTableAnnotationComposer,
    $$FamiliaresTableCreateCompanionBuilder,
    $$FamiliaresTableUpdateCompanionBuilder,
    (Familiare, $$FamiliaresTableReferences),
    Familiare,
    PrefetchHooks Function({bool funcionarioId})>;
typedef $$HijosTableCreateCompanionBuilder = HijosCompanion Function({
  Value<int> id,
  required int funcionarioId,
  required String nombres,
  required String apellidos,
  required int edad,
});
typedef $$HijosTableUpdateCompanionBuilder = HijosCompanion Function({
  Value<int> id,
  Value<int> funcionarioId,
  Value<String> nombres,
  Value<String> apellidos,
  Value<int> edad,
});

final class $$HijosTableReferences
    extends BaseReferences<_$AppDatabase, $HijosTable, Hijo> {
  $$HijosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FuncionariosTable _funcionarioIdTable(_$AppDatabase db) =>
      db.funcionarios.createAlias(
          $_aliasNameGenerator(db.hijos.funcionarioId, db.funcionarios.id));

  $$FuncionariosTableProcessedTableManager get funcionarioId {
    final $_column = $_itemColumn<int>('funcionario_id')!;

    final manager = $$FuncionariosTableTableManager($_db, $_db.funcionarios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_funcionarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HijosTableFilterComposer extends Composer<_$AppDatabase, $HijosTable> {
  $$HijosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombres => $composableBuilder(
      column: $table.nombres, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apellidos => $composableBuilder(
      column: $table.apellidos, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get edad => $composableBuilder(
      column: $table.edad, builder: (column) => ColumnFilters(column));

  $$FuncionariosTableFilterComposer get funcionarioId {
    final $$FuncionariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableFilterComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HijosTableOrderingComposer
    extends Composer<_$AppDatabase, $HijosTable> {
  $$HijosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombres => $composableBuilder(
      column: $table.nombres, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apellidos => $composableBuilder(
      column: $table.apellidos, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get edad => $composableBuilder(
      column: $table.edad, builder: (column) => ColumnOrderings(column));

  $$FuncionariosTableOrderingComposer get funcionarioId {
    final $$FuncionariosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableOrderingComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HijosTableAnnotationComposer
    extends Composer<_$AppDatabase, $HijosTable> {
  $$HijosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombres =>
      $composableBuilder(column: $table.nombres, builder: (column) => column);

  GeneratedColumn<String> get apellidos =>
      $composableBuilder(column: $table.apellidos, builder: (column) => column);

  GeneratedColumn<int> get edad =>
      $composableBuilder(column: $table.edad, builder: (column) => column);

  $$FuncionariosTableAnnotationComposer get funcionarioId {
    final $$FuncionariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableAnnotationComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HijosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HijosTable,
    Hijo,
    $$HijosTableFilterComposer,
    $$HijosTableOrderingComposer,
    $$HijosTableAnnotationComposer,
    $$HijosTableCreateCompanionBuilder,
    $$HijosTableUpdateCompanionBuilder,
    (Hijo, $$HijosTableReferences),
    Hijo,
    PrefetchHooks Function({bool funcionarioId})> {
  $$HijosTableTableManager(_$AppDatabase db, $HijosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HijosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HijosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HijosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> funcionarioId = const Value.absent(),
            Value<String> nombres = const Value.absent(),
            Value<String> apellidos = const Value.absent(),
            Value<int> edad = const Value.absent(),
          }) =>
              HijosCompanion(
            id: id,
            funcionarioId: funcionarioId,
            nombres: nombres,
            apellidos: apellidos,
            edad: edad,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int funcionarioId,
            required String nombres,
            required String apellidos,
            required int edad,
          }) =>
              HijosCompanion.insert(
            id: id,
            funcionarioId: funcionarioId,
            nombres: nombres,
            apellidos: apellidos,
            edad: edad,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$HijosTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({funcionarioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (funcionarioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.funcionarioId,
                    referencedTable:
                        $$HijosTableReferences._funcionarioIdTable(db),
                    referencedColumn:
                        $$HijosTableReferences._funcionarioIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HijosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HijosTable,
    Hijo,
    $$HijosTableFilterComposer,
    $$HijosTableOrderingComposer,
    $$HijosTableAnnotationComposer,
    $$HijosTableCreateCompanionBuilder,
    $$HijosTableUpdateCompanionBuilder,
    (Hijo, $$HijosTableReferences),
    Hijo,
    PrefetchHooks Function({bool funcionarioId})>;
typedef $$ActividadesTableCreateCompanionBuilder = ActividadesCompanion
    Function({
  Value<int> id,
  Value<int?> planificacionId,
  Value<int?> tipoGuardiaId,
  required String nombreActividad,
  required DateTime fecha,
  Value<DateTime?> fechaFin,
  required String lugar,
  Value<String> categoria,
  Value<int?> jefeServicioId,
  Value<bool> esPernocta,
  Value<int> diasDescansoGenerados,
});
typedef $$ActividadesTableUpdateCompanionBuilder = ActividadesCompanion
    Function({
  Value<int> id,
  Value<int?> planificacionId,
  Value<int?> tipoGuardiaId,
  Value<String> nombreActividad,
  Value<DateTime> fecha,
  Value<DateTime?> fechaFin,
  Value<String> lugar,
  Value<String> categoria,
  Value<int?> jefeServicioId,
  Value<bool> esPernocta,
  Value<int> diasDescansoGenerados,
});

final class $$ActividadesTableReferences
    extends BaseReferences<_$AppDatabase, $ActividadesTable, Actividade> {
  $$ActividadesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlanificacionesSemanalesTable _planificacionIdTable(
          _$AppDatabase db) =>
      db.planificacionesSemanales.createAlias($_aliasNameGenerator(
          db.actividades.planificacionId, db.planificacionesSemanales.id));

  $$PlanificacionesSemanalesTableProcessedTableManager? get planificacionId {
    final $_column = $_itemColumn<int>('planificacion_id');
    if ($_column == null) return null;
    final manager = $$PlanificacionesSemanalesTableTableManager(
            $_db, $_db.planificacionesSemanales)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planificacionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TiposGuardiaTable _tipoGuardiaIdTable(_$AppDatabase db) =>
      db.tiposGuardia.createAlias($_aliasNameGenerator(
          db.actividades.tipoGuardiaId, db.tiposGuardia.id));

  $$TiposGuardiaTableProcessedTableManager? get tipoGuardiaId {
    final $_column = $_itemColumn<int>('tipo_guardia_id');
    if ($_column == null) return null;
    final manager = $$TiposGuardiaTableTableManager($_db, $_db.tiposGuardia)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tipoGuardiaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $FuncionariosTable _jefeServicioIdTable(_$AppDatabase db) =>
      db.funcionarios.createAlias($_aliasNameGenerator(
          db.actividades.jefeServicioId, db.funcionarios.id));

  $$FuncionariosTableProcessedTableManager? get jefeServicioId {
    final $_column = $_itemColumn<int>('jefe_servicio_id');
    if ($_column == null) return null;
    final manager = $$FuncionariosTableTableManager($_db, $_db.funcionarios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jefeServicioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AsignacionesTable, List<Asignacione>>
      _asignacionesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.asignaciones,
              aliasName: $_aliasNameGenerator(
                  db.actividades.id, db.asignaciones.actividadId));

  $$AsignacionesTableProcessedTableManager get asignacionesRefs {
    final manager = $$AsignacionesTableTableManager($_db, $_db.asignaciones)
        .filter((f) => f.actividadId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_asignacionesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$IncidenciasTable, List<Incidencia>>
      _incidenciasRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.incidencias,
              aliasName: $_aliasNameGenerator(
                  db.actividades.id, db.incidencias.actividadId));

  $$IncidenciasTableProcessedTableManager get incidenciasRefs {
    final manager = $$IncidenciasTableTableManager($_db, $_db.incidencias)
        .filter((f) => f.actividadId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_incidenciasRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ActividadesTableFilterComposer
    extends Composer<_$AppDatabase, $ActividadesTable> {
  $$ActividadesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombreActividad => $composableBuilder(
      column: $table.nombreActividad,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaFin => $composableBuilder(
      column: $table.fechaFin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lugar => $composableBuilder(
      column: $table.lugar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoria => $composableBuilder(
      column: $table.categoria, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get esPernocta => $composableBuilder(
      column: $table.esPernocta, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get diasDescansoGenerados => $composableBuilder(
      column: $table.diasDescansoGenerados,
      builder: (column) => ColumnFilters(column));

  $$PlanificacionesSemanalesTableFilterComposer get planificacionId {
    final $$PlanificacionesSemanalesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.planificacionId,
            referencedTable: $db.planificacionesSemanales,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PlanificacionesSemanalesTableFilterComposer(
                  $db: $db,
                  $table: $db.planificacionesSemanales,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$TiposGuardiaTableFilterComposer get tipoGuardiaId {
    final $$TiposGuardiaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tipoGuardiaId,
        referencedTable: $db.tiposGuardia,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TiposGuardiaTableFilterComposer(
              $db: $db,
              $table: $db.tiposGuardia,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$FuncionariosTableFilterComposer get jefeServicioId {
    final $$FuncionariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.jefeServicioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableFilterComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> asignacionesRefs(
      Expression<bool> Function($$AsignacionesTableFilterComposer f) f) {
    final $$AsignacionesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.asignaciones,
        getReferencedColumn: (t) => t.actividadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AsignacionesTableFilterComposer(
              $db: $db,
              $table: $db.asignaciones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> incidenciasRefs(
      Expression<bool> Function($$IncidenciasTableFilterComposer f) f) {
    final $$IncidenciasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.incidencias,
        getReferencedColumn: (t) => t.actividadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IncidenciasTableFilterComposer(
              $db: $db,
              $table: $db.incidencias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ActividadesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActividadesTable> {
  $$ActividadesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombreActividad => $composableBuilder(
      column: $table.nombreActividad,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaFin => $composableBuilder(
      column: $table.fechaFin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lugar => $composableBuilder(
      column: $table.lugar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoria => $composableBuilder(
      column: $table.categoria, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get esPernocta => $composableBuilder(
      column: $table.esPernocta, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get diasDescansoGenerados => $composableBuilder(
      column: $table.diasDescansoGenerados,
      builder: (column) => ColumnOrderings(column));

  $$PlanificacionesSemanalesTableOrderingComposer get planificacionId {
    final $$PlanificacionesSemanalesTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.planificacionId,
            referencedTable: $db.planificacionesSemanales,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PlanificacionesSemanalesTableOrderingComposer(
                  $db: $db,
                  $table: $db.planificacionesSemanales,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$TiposGuardiaTableOrderingComposer get tipoGuardiaId {
    final $$TiposGuardiaTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tipoGuardiaId,
        referencedTable: $db.tiposGuardia,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TiposGuardiaTableOrderingComposer(
              $db: $db,
              $table: $db.tiposGuardia,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$FuncionariosTableOrderingComposer get jefeServicioId {
    final $$FuncionariosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.jefeServicioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableOrderingComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ActividadesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActividadesTable> {
  $$ActividadesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombreActividad => $composableBuilder(
      column: $table.nombreActividad, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaFin =>
      $composableBuilder(column: $table.fechaFin, builder: (column) => column);

  GeneratedColumn<String> get lugar =>
      $composableBuilder(column: $table.lugar, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<bool> get esPernocta => $composableBuilder(
      column: $table.esPernocta, builder: (column) => column);

  GeneratedColumn<int> get diasDescansoGenerados => $composableBuilder(
      column: $table.diasDescansoGenerados, builder: (column) => column);

  $$PlanificacionesSemanalesTableAnnotationComposer get planificacionId {
    final $$PlanificacionesSemanalesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.planificacionId,
            referencedTable: $db.planificacionesSemanales,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PlanificacionesSemanalesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.planificacionesSemanales,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$TiposGuardiaTableAnnotationComposer get tipoGuardiaId {
    final $$TiposGuardiaTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tipoGuardiaId,
        referencedTable: $db.tiposGuardia,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TiposGuardiaTableAnnotationComposer(
              $db: $db,
              $table: $db.tiposGuardia,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$FuncionariosTableAnnotationComposer get jefeServicioId {
    final $$FuncionariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.jefeServicioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableAnnotationComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> asignacionesRefs<T extends Object>(
      Expression<T> Function($$AsignacionesTableAnnotationComposer a) f) {
    final $$AsignacionesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.asignaciones,
        getReferencedColumn: (t) => t.actividadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AsignacionesTableAnnotationComposer(
              $db: $db,
              $table: $db.asignaciones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> incidenciasRefs<T extends Object>(
      Expression<T> Function($$IncidenciasTableAnnotationComposer a) f) {
    final $$IncidenciasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.incidencias,
        getReferencedColumn: (t) => t.actividadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IncidenciasTableAnnotationComposer(
              $db: $db,
              $table: $db.incidencias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ActividadesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ActividadesTable,
    Actividade,
    $$ActividadesTableFilterComposer,
    $$ActividadesTableOrderingComposer,
    $$ActividadesTableAnnotationComposer,
    $$ActividadesTableCreateCompanionBuilder,
    $$ActividadesTableUpdateCompanionBuilder,
    (Actividade, $$ActividadesTableReferences),
    Actividade,
    PrefetchHooks Function(
        {bool planificacionId,
        bool tipoGuardiaId,
        bool jefeServicioId,
        bool asignacionesRefs,
        bool incidenciasRefs})> {
  $$ActividadesTableTableManager(_$AppDatabase db, $ActividadesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActividadesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActividadesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActividadesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> planificacionId = const Value.absent(),
            Value<int?> tipoGuardiaId = const Value.absent(),
            Value<String> nombreActividad = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
            Value<DateTime?> fechaFin = const Value.absent(),
            Value<String> lugar = const Value.absent(),
            Value<String> categoria = const Value.absent(),
            Value<int?> jefeServicioId = const Value.absent(),
            Value<bool> esPernocta = const Value.absent(),
            Value<int> diasDescansoGenerados = const Value.absent(),
          }) =>
              ActividadesCompanion(
            id: id,
            planificacionId: planificacionId,
            tipoGuardiaId: tipoGuardiaId,
            nombreActividad: nombreActividad,
            fecha: fecha,
            fechaFin: fechaFin,
            lugar: lugar,
            categoria: categoria,
            jefeServicioId: jefeServicioId,
            esPernocta: esPernocta,
            diasDescansoGenerados: diasDescansoGenerados,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> planificacionId = const Value.absent(),
            Value<int?> tipoGuardiaId = const Value.absent(),
            required String nombreActividad,
            required DateTime fecha,
            Value<DateTime?> fechaFin = const Value.absent(),
            required String lugar,
            Value<String> categoria = const Value.absent(),
            Value<int?> jefeServicioId = const Value.absent(),
            Value<bool> esPernocta = const Value.absent(),
            Value<int> diasDescansoGenerados = const Value.absent(),
          }) =>
              ActividadesCompanion.insert(
            id: id,
            planificacionId: planificacionId,
            tipoGuardiaId: tipoGuardiaId,
            nombreActividad: nombreActividad,
            fecha: fecha,
            fechaFin: fechaFin,
            lugar: lugar,
            categoria: categoria,
            jefeServicioId: jefeServicioId,
            esPernocta: esPernocta,
            diasDescansoGenerados: diasDescansoGenerados,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ActividadesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {planificacionId = false,
              tipoGuardiaId = false,
              jefeServicioId = false,
              asignacionesRefs = false,
              incidenciasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (asignacionesRefs) db.asignaciones,
                if (incidenciasRefs) db.incidencias
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (planificacionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.planificacionId,
                    referencedTable:
                        $$ActividadesTableReferences._planificacionIdTable(db),
                    referencedColumn: $$ActividadesTableReferences
                        ._planificacionIdTable(db)
                        .id,
                  ) as T;
                }
                if (tipoGuardiaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tipoGuardiaId,
                    referencedTable:
                        $$ActividadesTableReferences._tipoGuardiaIdTable(db),
                    referencedColumn:
                        $$ActividadesTableReferences._tipoGuardiaIdTable(db).id,
                  ) as T;
                }
                if (jefeServicioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.jefeServicioId,
                    referencedTable:
                        $$ActividadesTableReferences._jefeServicioIdTable(db),
                    referencedColumn: $$ActividadesTableReferences
                        ._jefeServicioIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (asignacionesRefs)
                    await $_getPrefetchedData<Actividade, $ActividadesTable,
                            Asignacione>(
                        currentTable: table,
                        referencedTable: $$ActividadesTableReferences
                            ._asignacionesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ActividadesTableReferences(db, table, p0)
                                .asignacionesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.actividadId == item.id),
                        typedResults: items),
                  if (incidenciasRefs)
                    await $_getPrefetchedData<Actividade, $ActividadesTable,
                            Incidencia>(
                        currentTable: table,
                        referencedTable: $$ActividadesTableReferences
                            ._incidenciasRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ActividadesTableReferences(db, table, p0)
                                .incidenciasRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.actividadId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ActividadesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ActividadesTable,
    Actividade,
    $$ActividadesTableFilterComposer,
    $$ActividadesTableOrderingComposer,
    $$ActividadesTableAnnotationComposer,
    $$ActividadesTableCreateCompanionBuilder,
    $$ActividadesTableUpdateCompanionBuilder,
    (Actividade, $$ActividadesTableReferences),
    Actividade,
    PrefetchHooks Function(
        {bool planificacionId,
        bool tipoGuardiaId,
        bool jefeServicioId,
        bool asignacionesRefs,
        bool incidenciasRefs})>;
typedef $$AsignacionesTableCreateCompanionBuilder = AsignacionesCompanion
    Function({
  Value<int> id,
  required int funcionarioId,
  required int actividadId,
  Value<DateTime> fechaAsignacion,
  Value<DateTime?> fechaBloqueoHasta,
  Value<bool> esCompensada,
  Value<bool> esJefeServicio,
});
typedef $$AsignacionesTableUpdateCompanionBuilder = AsignacionesCompanion
    Function({
  Value<int> id,
  Value<int> funcionarioId,
  Value<int> actividadId,
  Value<DateTime> fechaAsignacion,
  Value<DateTime?> fechaBloqueoHasta,
  Value<bool> esCompensada,
  Value<bool> esJefeServicio,
});

final class $$AsignacionesTableReferences
    extends BaseReferences<_$AppDatabase, $AsignacionesTable, Asignacione> {
  $$AsignacionesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FuncionariosTable _funcionarioIdTable(_$AppDatabase db) =>
      db.funcionarios.createAlias($_aliasNameGenerator(
          db.asignaciones.funcionarioId, db.funcionarios.id));

  $$FuncionariosTableProcessedTableManager get funcionarioId {
    final $_column = $_itemColumn<int>('funcionario_id')!;

    final manager = $$FuncionariosTableTableManager($_db, $_db.funcionarios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_funcionarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ActividadesTable _actividadIdTable(_$AppDatabase db) =>
      db.actividades.createAlias(
          $_aliasNameGenerator(db.asignaciones.actividadId, db.actividades.id));

  $$ActividadesTableProcessedTableManager get actividadId {
    final $_column = $_itemColumn<int>('actividad_id')!;

    final manager = $$ActividadesTableTableManager($_db, $_db.actividades)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actividadIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AsignacionesTableFilterComposer
    extends Composer<_$AppDatabase, $AsignacionesTable> {
  $$AsignacionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaAsignacion => $composableBuilder(
      column: $table.fechaAsignacion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaBloqueoHasta => $composableBuilder(
      column: $table.fechaBloqueoHasta,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get esCompensada => $composableBuilder(
      column: $table.esCompensada, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get esJefeServicio => $composableBuilder(
      column: $table.esJefeServicio,
      builder: (column) => ColumnFilters(column));

  $$FuncionariosTableFilterComposer get funcionarioId {
    final $$FuncionariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableFilterComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ActividadesTableFilterComposer get actividadId {
    final $$ActividadesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.actividadId,
        referencedTable: $db.actividades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ActividadesTableFilterComposer(
              $db: $db,
              $table: $db.actividades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AsignacionesTableOrderingComposer
    extends Composer<_$AppDatabase, $AsignacionesTable> {
  $$AsignacionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaAsignacion => $composableBuilder(
      column: $table.fechaAsignacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaBloqueoHasta => $composableBuilder(
      column: $table.fechaBloqueoHasta,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get esCompensada => $composableBuilder(
      column: $table.esCompensada,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get esJefeServicio => $composableBuilder(
      column: $table.esJefeServicio,
      builder: (column) => ColumnOrderings(column));

  $$FuncionariosTableOrderingComposer get funcionarioId {
    final $$FuncionariosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableOrderingComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ActividadesTableOrderingComposer get actividadId {
    final $$ActividadesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.actividadId,
        referencedTable: $db.actividades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ActividadesTableOrderingComposer(
              $db: $db,
              $table: $db.actividades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AsignacionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AsignacionesTable> {
  $$AsignacionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaAsignacion => $composableBuilder(
      column: $table.fechaAsignacion, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaBloqueoHasta => $composableBuilder(
      column: $table.fechaBloqueoHasta, builder: (column) => column);

  GeneratedColumn<bool> get esCompensada => $composableBuilder(
      column: $table.esCompensada, builder: (column) => column);

  GeneratedColumn<bool> get esJefeServicio => $composableBuilder(
      column: $table.esJefeServicio, builder: (column) => column);

  $$FuncionariosTableAnnotationComposer get funcionarioId {
    final $$FuncionariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableAnnotationComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ActividadesTableAnnotationComposer get actividadId {
    final $$ActividadesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.actividadId,
        referencedTable: $db.actividades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ActividadesTableAnnotationComposer(
              $db: $db,
              $table: $db.actividades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AsignacionesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AsignacionesTable,
    Asignacione,
    $$AsignacionesTableFilterComposer,
    $$AsignacionesTableOrderingComposer,
    $$AsignacionesTableAnnotationComposer,
    $$AsignacionesTableCreateCompanionBuilder,
    $$AsignacionesTableUpdateCompanionBuilder,
    (Asignacione, $$AsignacionesTableReferences),
    Asignacione,
    PrefetchHooks Function({bool funcionarioId, bool actividadId})> {
  $$AsignacionesTableTableManager(_$AppDatabase db, $AsignacionesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AsignacionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AsignacionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AsignacionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> funcionarioId = const Value.absent(),
            Value<int> actividadId = const Value.absent(),
            Value<DateTime> fechaAsignacion = const Value.absent(),
            Value<DateTime?> fechaBloqueoHasta = const Value.absent(),
            Value<bool> esCompensada = const Value.absent(),
            Value<bool> esJefeServicio = const Value.absent(),
          }) =>
              AsignacionesCompanion(
            id: id,
            funcionarioId: funcionarioId,
            actividadId: actividadId,
            fechaAsignacion: fechaAsignacion,
            fechaBloqueoHasta: fechaBloqueoHasta,
            esCompensada: esCompensada,
            esJefeServicio: esJefeServicio,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int funcionarioId,
            required int actividadId,
            Value<DateTime> fechaAsignacion = const Value.absent(),
            Value<DateTime?> fechaBloqueoHasta = const Value.absent(),
            Value<bool> esCompensada = const Value.absent(),
            Value<bool> esJefeServicio = const Value.absent(),
          }) =>
              AsignacionesCompanion.insert(
            id: id,
            funcionarioId: funcionarioId,
            actividadId: actividadId,
            fechaAsignacion: fechaAsignacion,
            fechaBloqueoHasta: fechaBloqueoHasta,
            esCompensada: esCompensada,
            esJefeServicio: esJefeServicio,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AsignacionesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {funcionarioId = false, actividadId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (funcionarioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.funcionarioId,
                    referencedTable:
                        $$AsignacionesTableReferences._funcionarioIdTable(db),
                    referencedColumn: $$AsignacionesTableReferences
                        ._funcionarioIdTable(db)
                        .id,
                  ) as T;
                }
                if (actividadId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.actividadId,
                    referencedTable:
                        $$AsignacionesTableReferences._actividadIdTable(db),
                    referencedColumn:
                        $$AsignacionesTableReferences._actividadIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AsignacionesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AsignacionesTable,
    Asignacione,
    $$AsignacionesTableFilterComposer,
    $$AsignacionesTableOrderingComposer,
    $$AsignacionesTableAnnotationComposer,
    $$AsignacionesTableCreateCompanionBuilder,
    $$AsignacionesTableUpdateCompanionBuilder,
    (Asignacione, $$AsignacionesTableReferences),
    Asignacione,
    PrefetchHooks Function({bool funcionarioId, bool actividadId})>;
typedef $$AusenciasTableCreateCompanionBuilder = AusenciasCompanion Function({
  Value<int> id,
  required int funcionarioId,
  required DateTime fechaInicio,
  required DateTime fechaFin,
  required String motivo,
  Value<String> tipo,
});
typedef $$AusenciasTableUpdateCompanionBuilder = AusenciasCompanion Function({
  Value<int> id,
  Value<int> funcionarioId,
  Value<DateTime> fechaInicio,
  Value<DateTime> fechaFin,
  Value<String> motivo,
  Value<String> tipo,
});

final class $$AusenciasTableReferences
    extends BaseReferences<_$AppDatabase, $AusenciasTable, Ausencia> {
  $$AusenciasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FuncionariosTable _funcionarioIdTable(_$AppDatabase db) =>
      db.funcionarios.createAlias(
          $_aliasNameGenerator(db.ausencias.funcionarioId, db.funcionarios.id));

  $$FuncionariosTableProcessedTableManager get funcionarioId {
    final $_column = $_itemColumn<int>('funcionario_id')!;

    final manager = $$FuncionariosTableTableManager($_db, $_db.funcionarios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_funcionarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AusenciasTableFilterComposer
    extends Composer<_$AppDatabase, $AusenciasTable> {
  $$AusenciasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
      column: $table.fechaInicio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaFin => $composableBuilder(
      column: $table.fechaFin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motivo => $composableBuilder(
      column: $table.motivo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  $$FuncionariosTableFilterComposer get funcionarioId {
    final $$FuncionariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableFilterComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AusenciasTableOrderingComposer
    extends Composer<_$AppDatabase, $AusenciasTable> {
  $$AusenciasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
      column: $table.fechaInicio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaFin => $composableBuilder(
      column: $table.fechaFin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motivo => $composableBuilder(
      column: $table.motivo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  $$FuncionariosTableOrderingComposer get funcionarioId {
    final $$FuncionariosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableOrderingComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AusenciasTableAnnotationComposer
    extends Composer<_$AppDatabase, $AusenciasTable> {
  $$AusenciasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
      column: $table.fechaInicio, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaFin =>
      $composableBuilder(column: $table.fechaFin, builder: (column) => column);

  GeneratedColumn<String> get motivo =>
      $composableBuilder(column: $table.motivo, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  $$FuncionariosTableAnnotationComposer get funcionarioId {
    final $$FuncionariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableAnnotationComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AusenciasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AusenciasTable,
    Ausencia,
    $$AusenciasTableFilterComposer,
    $$AusenciasTableOrderingComposer,
    $$AusenciasTableAnnotationComposer,
    $$AusenciasTableCreateCompanionBuilder,
    $$AusenciasTableUpdateCompanionBuilder,
    (Ausencia, $$AusenciasTableReferences),
    Ausencia,
    PrefetchHooks Function({bool funcionarioId})> {
  $$AusenciasTableTableManager(_$AppDatabase db, $AusenciasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AusenciasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AusenciasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AusenciasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> funcionarioId = const Value.absent(),
            Value<DateTime> fechaInicio = const Value.absent(),
            Value<DateTime> fechaFin = const Value.absent(),
            Value<String> motivo = const Value.absent(),
            Value<String> tipo = const Value.absent(),
          }) =>
              AusenciasCompanion(
            id: id,
            funcionarioId: funcionarioId,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            motivo: motivo,
            tipo: tipo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int funcionarioId,
            required DateTime fechaInicio,
            required DateTime fechaFin,
            required String motivo,
            Value<String> tipo = const Value.absent(),
          }) =>
              AusenciasCompanion.insert(
            id: id,
            funcionarioId: funcionarioId,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            motivo: motivo,
            tipo: tipo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AusenciasTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({funcionarioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (funcionarioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.funcionarioId,
                    referencedTable:
                        $$AusenciasTableReferences._funcionarioIdTable(db),
                    referencedColumn:
                        $$AusenciasTableReferences._funcionarioIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AusenciasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AusenciasTable,
    Ausencia,
    $$AusenciasTableFilterComposer,
    $$AusenciasTableOrderingComposer,
    $$AusenciasTableAnnotationComposer,
    $$AusenciasTableCreateCompanionBuilder,
    $$AusenciasTableUpdateCompanionBuilder,
    (Ausencia, $$AusenciasTableReferences),
    Ausencia,
    PrefetchHooks Function({bool funcionarioId})>;
typedef $$IncidenciasTableCreateCompanionBuilder = IncidenciasCompanion
    Function({
  Value<int> id,
  required int actividadId,
  required int funcionarioInasistenteId,
  required DateTime fechaHoraRegistro,
  required String descripcion,
  Value<String> tipo,
  Value<int?> testigoUnoId,
  Value<int?> testigoDosId,
  Value<String?> observaciones,
});
typedef $$IncidenciasTableUpdateCompanionBuilder = IncidenciasCompanion
    Function({
  Value<int> id,
  Value<int> actividadId,
  Value<int> funcionarioInasistenteId,
  Value<DateTime> fechaHoraRegistro,
  Value<String> descripcion,
  Value<String> tipo,
  Value<int?> testigoUnoId,
  Value<int?> testigoDosId,
  Value<String?> observaciones,
});

final class $$IncidenciasTableReferences
    extends BaseReferences<_$AppDatabase, $IncidenciasTable, Incidencia> {
  $$IncidenciasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ActividadesTable _actividadIdTable(_$AppDatabase db) =>
      db.actividades.createAlias(
          $_aliasNameGenerator(db.incidencias.actividadId, db.actividades.id));

  $$ActividadesTableProcessedTableManager get actividadId {
    final $_column = $_itemColumn<int>('actividad_id')!;

    final manager = $$ActividadesTableTableManager($_db, $_db.actividades)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actividadIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $FuncionariosTable _funcionarioInasistenteIdTable(_$AppDatabase db) =>
      db.funcionarios.createAlias($_aliasNameGenerator(
          db.incidencias.funcionarioInasistenteId, db.funcionarios.id));

  $$FuncionariosTableProcessedTableManager get funcionarioInasistenteId {
    final $_column = $_itemColumn<int>('funcionario_inasistente_id')!;

    final manager = $$FuncionariosTableTableManager($_db, $_db.funcionarios)
        .filter((f) => f.id.sqlEquals($_column));
    final item =
        $_typedResult.readTableOrNull(_funcionarioInasistenteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $FuncionariosTable _testigoUnoIdTable(_$AppDatabase db) =>
      db.funcionarios.createAlias($_aliasNameGenerator(
          db.incidencias.testigoUnoId, db.funcionarios.id));

  $$FuncionariosTableProcessedTableManager? get testigoUnoId {
    final $_column = $_itemColumn<int>('testigo_uno_id');
    if ($_column == null) return null;
    final manager = $$FuncionariosTableTableManager($_db, $_db.funcionarios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_testigoUnoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $FuncionariosTable _testigoDosIdTable(_$AppDatabase db) =>
      db.funcionarios.createAlias($_aliasNameGenerator(
          db.incidencias.testigoDosId, db.funcionarios.id));

  $$FuncionariosTableProcessedTableManager? get testigoDosId {
    final $_column = $_itemColumn<int>('testigo_dos_id');
    if ($_column == null) return null;
    final manager = $$FuncionariosTableTableManager($_db, $_db.funcionarios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_testigoDosIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$IncidenciasTableFilterComposer
    extends Composer<_$AppDatabase, $IncidenciasTable> {
  $$IncidenciasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaHoraRegistro => $composableBuilder(
      column: $table.fechaHoraRegistro,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => ColumnFilters(column));

  $$ActividadesTableFilterComposer get actividadId {
    final $$ActividadesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.actividadId,
        referencedTable: $db.actividades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ActividadesTableFilterComposer(
              $db: $db,
              $table: $db.actividades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$FuncionariosTableFilterComposer get funcionarioInasistenteId {
    final $$FuncionariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioInasistenteId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableFilterComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$FuncionariosTableFilterComposer get testigoUnoId {
    final $$FuncionariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.testigoUnoId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableFilterComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$FuncionariosTableFilterComposer get testigoDosId {
    final $$FuncionariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.testigoDosId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableFilterComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IncidenciasTableOrderingComposer
    extends Composer<_$AppDatabase, $IncidenciasTable> {
  $$IncidenciasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaHoraRegistro => $composableBuilder(
      column: $table.fechaHoraRegistro,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observaciones => $composableBuilder(
      column: $table.observaciones,
      builder: (column) => ColumnOrderings(column));

  $$ActividadesTableOrderingComposer get actividadId {
    final $$ActividadesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.actividadId,
        referencedTable: $db.actividades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ActividadesTableOrderingComposer(
              $db: $db,
              $table: $db.actividades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$FuncionariosTableOrderingComposer get funcionarioInasistenteId {
    final $$FuncionariosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioInasistenteId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableOrderingComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$FuncionariosTableOrderingComposer get testigoUnoId {
    final $$FuncionariosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.testigoUnoId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableOrderingComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$FuncionariosTableOrderingComposer get testigoDosId {
    final $$FuncionariosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.testigoDosId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableOrderingComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IncidenciasTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncidenciasTable> {
  $$IncidenciasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaHoraRegistro => $composableBuilder(
      column: $table.fechaHoraRegistro, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => column);

  $$ActividadesTableAnnotationComposer get actividadId {
    final $$ActividadesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.actividadId,
        referencedTable: $db.actividades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ActividadesTableAnnotationComposer(
              $db: $db,
              $table: $db.actividades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$FuncionariosTableAnnotationComposer get funcionarioInasistenteId {
    final $$FuncionariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioInasistenteId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableAnnotationComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$FuncionariosTableAnnotationComposer get testigoUnoId {
    final $$FuncionariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.testigoUnoId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableAnnotationComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$FuncionariosTableAnnotationComposer get testigoDosId {
    final $$FuncionariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.testigoDosId,
        referencedTable: $db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuncionariosTableAnnotationComposer(
              $db: $db,
              $table: $db.funcionarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IncidenciasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IncidenciasTable,
    Incidencia,
    $$IncidenciasTableFilterComposer,
    $$IncidenciasTableOrderingComposer,
    $$IncidenciasTableAnnotationComposer,
    $$IncidenciasTableCreateCompanionBuilder,
    $$IncidenciasTableUpdateCompanionBuilder,
    (Incidencia, $$IncidenciasTableReferences),
    Incidencia,
    PrefetchHooks Function(
        {bool actividadId,
        bool funcionarioInasistenteId,
        bool testigoUnoId,
        bool testigoDosId})> {
  $$IncidenciasTableTableManager(_$AppDatabase db, $IncidenciasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncidenciasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncidenciasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncidenciasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> actividadId = const Value.absent(),
            Value<int> funcionarioInasistenteId = const Value.absent(),
            Value<DateTime> fechaHoraRegistro = const Value.absent(),
            Value<String> descripcion = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<int?> testigoUnoId = const Value.absent(),
            Value<int?> testigoDosId = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
          }) =>
              IncidenciasCompanion(
            id: id,
            actividadId: actividadId,
            funcionarioInasistenteId: funcionarioInasistenteId,
            fechaHoraRegistro: fechaHoraRegistro,
            descripcion: descripcion,
            tipo: tipo,
            testigoUnoId: testigoUnoId,
            testigoDosId: testigoDosId,
            observaciones: observaciones,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int actividadId,
            required int funcionarioInasistenteId,
            required DateTime fechaHoraRegistro,
            required String descripcion,
            Value<String> tipo = const Value.absent(),
            Value<int?> testigoUnoId = const Value.absent(),
            Value<int?> testigoDosId = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
          }) =>
              IncidenciasCompanion.insert(
            id: id,
            actividadId: actividadId,
            funcionarioInasistenteId: funcionarioInasistenteId,
            fechaHoraRegistro: fechaHoraRegistro,
            descripcion: descripcion,
            tipo: tipo,
            testigoUnoId: testigoUnoId,
            testigoDosId: testigoDosId,
            observaciones: observaciones,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$IncidenciasTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {actividadId = false,
              funcionarioInasistenteId = false,
              testigoUnoId = false,
              testigoDosId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (actividadId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.actividadId,
                    referencedTable:
                        $$IncidenciasTableReferences._actividadIdTable(db),
                    referencedColumn:
                        $$IncidenciasTableReferences._actividadIdTable(db).id,
                  ) as T;
                }
                if (funcionarioInasistenteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.funcionarioInasistenteId,
                    referencedTable: $$IncidenciasTableReferences
                        ._funcionarioInasistenteIdTable(db),
                    referencedColumn: $$IncidenciasTableReferences
                        ._funcionarioInasistenteIdTable(db)
                        .id,
                  ) as T;
                }
                if (testigoUnoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.testigoUnoId,
                    referencedTable:
                        $$IncidenciasTableReferences._testigoUnoIdTable(db),
                    referencedColumn:
                        $$IncidenciasTableReferences._testigoUnoIdTable(db).id,
                  ) as T;
                }
                if (testigoDosId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.testigoDosId,
                    referencedTable:
                        $$IncidenciasTableReferences._testigoDosIdTable(db),
                    referencedColumn:
                        $$IncidenciasTableReferences._testigoDosIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$IncidenciasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IncidenciasTable,
    Incidencia,
    $$IncidenciasTableFilterComposer,
    $$IncidenciasTableOrderingComposer,
    $$IncidenciasTableAnnotationComposer,
    $$IncidenciasTableCreateCompanionBuilder,
    $$IncidenciasTableUpdateCompanionBuilder,
    (Incidencia, $$IncidenciasTableReferences),
    Incidencia,
    PrefetchHooks Function(
        {bool actividadId,
        bool funcionarioInasistenteId,
        bool testigoUnoId,
        bool testigoDosId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsuariosSistemaTableTableManager get usuariosSistema =>
      $$UsuariosSistemaTableTableManager(_db, _db.usuariosSistema);
  $$ConfigSettingsTableTableManager get configSettings =>
      $$ConfigSettingsTableTableManager(_db, _db.configSettings);
  $$RangosTableTableManager get rangos =>
      $$RangosTableTableManager(_db, _db.rangos);
  $$TiposGuardiaTableTableManager get tiposGuardia =>
      $$TiposGuardiaTableTableManager(_db, _db.tiposGuardia);
  $$UbicacionesTableTableManager get ubicaciones =>
      $$UbicacionesTableTableManager(_db, _db.ubicaciones);
  $$PlanificacionesSemanalesTableTableManager get planificacionesSemanales =>
      $$PlanificacionesSemanalesTableTableManager(
          _db, _db.planificacionesSemanales);
  $$FuncionariosTableTableManager get funcionarios =>
      $$FuncionariosTableTableManager(_db, _db.funcionarios);
  $$EstudiosAcademicosTableTableManager get estudiosAcademicos =>
      $$EstudiosAcademicosTableTableManager(_db, _db.estudiosAcademicos);
  $$CursosCertificadosTableTableManager get cursosCertificados =>
      $$CursosCertificadosTableTableManager(_db, _db.cursosCertificados);
  $$FamiliaresTableTableManager get familiares =>
      $$FamiliaresTableTableManager(_db, _db.familiares);
  $$HijosTableTableManager get hijos =>
      $$HijosTableTableManager(_db, _db.hijos);
  $$ActividadesTableTableManager get actividades =>
      $$ActividadesTableTableManager(_db, _db.actividades);
  $$AsignacionesTableTableManager get asignaciones =>
      $$AsignacionesTableTableManager(_db, _db.asignaciones);
  $$AusenciasTableTableManager get ausencias =>
      $$AusenciasTableTableManager(_db, _db.ausencias);
  $$IncidenciasTableTableManager get incidencias =>
      $$IncidenciasTableTableManager(_db, _db.incidencias);
}
