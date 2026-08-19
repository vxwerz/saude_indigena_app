// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AldeiasTable extends Aldeias with TableInfo<$AldeiasTable, Aldeia> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AldeiasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _dseiMeta = const VerificationMeta('dsei');
  @override
  late final GeneratedColumn<String> dsei = GeneratedColumn<String>(
      'dsei', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('DSEI Litoral Sul'));
  @override
  List<GeneratedColumn> get $columns => [id, nome, dsei];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'aldeias';
  @override
  VerificationContext validateIntegrity(Insertable<Aldeia> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('dsei')) {
      context.handle(
          _dseiMeta, dsei.isAcceptableOrUnknown(data['dsei']!, _dseiMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Aldeia map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Aldeia(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      dsei: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dsei'])!,
    );
  }

  @override
  $AldeiasTable createAlias(String alias) {
    return $AldeiasTable(attachedDatabase, alias);
  }
}

class Aldeia extends DataClass implements Insertable<Aldeia> {
  final int id;
  final String nome;
  final String dsei;
  const Aldeia({required this.id, required this.nome, required this.dsei});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['dsei'] = Variable<String>(dsei);
    return map;
  }

  AldeiasCompanion toCompanion(bool nullToAbsent) {
    return AldeiasCompanion(
      id: Value(id),
      nome: Value(nome),
      dsei: Value(dsei),
    );
  }

  factory Aldeia.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Aldeia(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      dsei: serializer.fromJson<String>(json['dsei']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'dsei': serializer.toJson<String>(dsei),
    };
  }

  Aldeia copyWith({int? id, String? nome, String? dsei}) => Aldeia(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        dsei: dsei ?? this.dsei,
      );
  Aldeia copyWithCompanion(AldeiasCompanion data) {
    return Aldeia(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      dsei: data.dsei.present ? data.dsei.value : this.dsei,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Aldeia(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('dsei: $dsei')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, dsei);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Aldeia &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.dsei == this.dsei);
}

class AldeiasCompanion extends UpdateCompanion<Aldeia> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> dsei;
  const AldeiasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.dsei = const Value.absent(),
  });
  AldeiasCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.dsei = const Value.absent(),
  }) : nome = Value(nome);
  static Insertable<Aldeia> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? dsei,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (dsei != null) 'dsei': dsei,
    });
  }

  AldeiasCompanion copyWith(
      {Value<int>? id, Value<String>? nome, Value<String>? dsei}) {
    return AldeiasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      dsei: dsei ?? this.dsei,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (dsei.present) {
      map['dsei'] = Variable<String>(dsei.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AldeiasCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('dsei: $dsei')
          ..write(')'))
        .toString();
  }
}

class $IndigenasTable extends Indigenas
    with TableInfo<$IndigenasTable, Indigena> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IndigenasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cnsMeta = const VerificationMeta('cns');
  @override
  late final GeneratedColumn<String> cns = GeneratedColumn<String>(
      'cns', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataNascimentoMeta =
      const VerificationMeta('dataNascimento');
  @override
  late final GeneratedColumn<DateTime> dataNascimento =
      GeneratedColumn<DateTime>('data_nascimento', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _aldeiaAtualIdMeta =
      const VerificationMeta('aldeiaAtualId');
  @override
  late final GeneratedColumn<int> aldeiaAtualId = GeneratedColumn<int>(
      'aldeia_atual_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES aldeias (id)'));
  static const VerificationMeta _emTransitoMeta =
      const VerificationMeta('emTransito');
  @override
  late final GeneratedColumn<bool> emTransito = GeneratedColumn<bool>(
      'em_transito', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("em_transito" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _internadoMeta =
      const VerificationMeta('internado');
  @override
  late final GeneratedColumn<bool> internado = GeneratedColumn<bool>(
      'internado', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("internado" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _gestanteMeta =
      const VerificationMeta('gestante');
  @override
  late final GeneratedColumn<bool> gestante = GeneratedColumn<bool>(
      'gestante', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("gestante" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cns,
        nome,
        dataNascimento,
        aldeiaAtualId,
        emTransito,
        internado,
        gestante
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'indigenas';
  @override
  VerificationContext validateIntegrity(Insertable<Indigena> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cns')) {
      context.handle(
          _cnsMeta, cns.isAcceptableOrUnknown(data['cns']!, _cnsMeta));
    } else if (isInserting) {
      context.missing(_cnsMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('data_nascimento')) {
      context.handle(
          _dataNascimentoMeta,
          dataNascimento.isAcceptableOrUnknown(
              data['data_nascimento']!, _dataNascimentoMeta));
    } else if (isInserting) {
      context.missing(_dataNascimentoMeta);
    }
    if (data.containsKey('aldeia_atual_id')) {
      context.handle(
          _aldeiaAtualIdMeta,
          aldeiaAtualId.isAcceptableOrUnknown(
              data['aldeia_atual_id']!, _aldeiaAtualIdMeta));
    } else if (isInserting) {
      context.missing(_aldeiaAtualIdMeta);
    }
    if (data.containsKey('em_transito')) {
      context.handle(
          _emTransitoMeta,
          emTransito.isAcceptableOrUnknown(
              data['em_transito']!, _emTransitoMeta));
    }
    if (data.containsKey('internado')) {
      context.handle(_internadoMeta,
          internado.isAcceptableOrUnknown(data['internado']!, _internadoMeta));
    }
    if (data.containsKey('gestante')) {
      context.handle(_gestanteMeta,
          gestante.isAcceptableOrUnknown(data['gestante']!, _gestanteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Indigena map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Indigena(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      cns: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cns'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      dataNascimento: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}data_nascimento'])!,
      aldeiaAtualId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}aldeia_atual_id'])!,
      emTransito: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}em_transito'])!,
      internado: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}internado'])!,
      gestante: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}gestante'])!,
    );
  }

  @override
  $IndigenasTable createAlias(String alias) {
    return $IndigenasTable(attachedDatabase, alias);
  }
}

class Indigena extends DataClass implements Insertable<Indigena> {
  final String id;
  final String cns;
  final String nome;
  final DateTime dataNascimento;
  final int aldeiaAtualId;
  final bool emTransito;
  final bool internado;
  final bool gestante;
  const Indigena(
      {required this.id,
      required this.cns,
      required this.nome,
      required this.dataNascimento,
      required this.aldeiaAtualId,
      required this.emTransito,
      required this.internado,
      required this.gestante});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cns'] = Variable<String>(cns);
    map['nome'] = Variable<String>(nome);
    map['data_nascimento'] = Variable<DateTime>(dataNascimento);
    map['aldeia_atual_id'] = Variable<int>(aldeiaAtualId);
    map['em_transito'] = Variable<bool>(emTransito);
    map['internado'] = Variable<bool>(internado);
    map['gestante'] = Variable<bool>(gestante);
    return map;
  }

  IndigenasCompanion toCompanion(bool nullToAbsent) {
    return IndigenasCompanion(
      id: Value(id),
      cns: Value(cns),
      nome: Value(nome),
      dataNascimento: Value(dataNascimento),
      aldeiaAtualId: Value(aldeiaAtualId),
      emTransito: Value(emTransito),
      internado: Value(internado),
      gestante: Value(gestante),
    );
  }

  factory Indigena.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Indigena(
      id: serializer.fromJson<String>(json['id']),
      cns: serializer.fromJson<String>(json['cns']),
      nome: serializer.fromJson<String>(json['nome']),
      dataNascimento: serializer.fromJson<DateTime>(json['dataNascimento']),
      aldeiaAtualId: serializer.fromJson<int>(json['aldeiaAtualId']),
      emTransito: serializer.fromJson<bool>(json['emTransito']),
      internado: serializer.fromJson<bool>(json['internado']),
      gestante: serializer.fromJson<bool>(json['gestante']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cns': serializer.toJson<String>(cns),
      'nome': serializer.toJson<String>(nome),
      'dataNascimento': serializer.toJson<DateTime>(dataNascimento),
      'aldeiaAtualId': serializer.toJson<int>(aldeiaAtualId),
      'emTransito': serializer.toJson<bool>(emTransito),
      'internado': serializer.toJson<bool>(internado),
      'gestante': serializer.toJson<bool>(gestante),
    };
  }

  Indigena copyWith(
          {String? id,
          String? cns,
          String? nome,
          DateTime? dataNascimento,
          int? aldeiaAtualId,
          bool? emTransito,
          bool? internado,
          bool? gestante}) =>
      Indigena(
        id: id ?? this.id,
        cns: cns ?? this.cns,
        nome: nome ?? this.nome,
        dataNascimento: dataNascimento ?? this.dataNascimento,
        aldeiaAtualId: aldeiaAtualId ?? this.aldeiaAtualId,
        emTransito: emTransito ?? this.emTransito,
        internado: internado ?? this.internado,
        gestante: gestante ?? this.gestante,
      );
  Indigena copyWithCompanion(IndigenasCompanion data) {
    return Indigena(
      id: data.id.present ? data.id.value : this.id,
      cns: data.cns.present ? data.cns.value : this.cns,
      nome: data.nome.present ? data.nome.value : this.nome,
      dataNascimento: data.dataNascimento.present
          ? data.dataNascimento.value
          : this.dataNascimento,
      aldeiaAtualId: data.aldeiaAtualId.present
          ? data.aldeiaAtualId.value
          : this.aldeiaAtualId,
      emTransito:
          data.emTransito.present ? data.emTransito.value : this.emTransito,
      internado: data.internado.present ? data.internado.value : this.internado,
      gestante: data.gestante.present ? data.gestante.value : this.gestante,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Indigena(')
          ..write('id: $id, ')
          ..write('cns: $cns, ')
          ..write('nome: $nome, ')
          ..write('dataNascimento: $dataNascimento, ')
          ..write('aldeiaAtualId: $aldeiaAtualId, ')
          ..write('emTransito: $emTransito, ')
          ..write('internado: $internado, ')
          ..write('gestante: $gestante')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cns, nome, dataNascimento, aldeiaAtualId,
      emTransito, internado, gestante);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Indigena &&
          other.id == this.id &&
          other.cns == this.cns &&
          other.nome == this.nome &&
          other.dataNascimento == this.dataNascimento &&
          other.aldeiaAtualId == this.aldeiaAtualId &&
          other.emTransito == this.emTransito &&
          other.internado == this.internado &&
          other.gestante == this.gestante);
}

class IndigenasCompanion extends UpdateCompanion<Indigena> {
  final Value<String> id;
  final Value<String> cns;
  final Value<String> nome;
  final Value<DateTime> dataNascimento;
  final Value<int> aldeiaAtualId;
  final Value<bool> emTransito;
  final Value<bool> internado;
  final Value<bool> gestante;
  final Value<int> rowid;
  const IndigenasCompanion({
    this.id = const Value.absent(),
    this.cns = const Value.absent(),
    this.nome = const Value.absent(),
    this.dataNascimento = const Value.absent(),
    this.aldeiaAtualId = const Value.absent(),
    this.emTransito = const Value.absent(),
    this.internado = const Value.absent(),
    this.gestante = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IndigenasCompanion.insert({
    required String id,
    required String cns,
    required String nome,
    required DateTime dataNascimento,
    required int aldeiaAtualId,
    this.emTransito = const Value.absent(),
    this.internado = const Value.absent(),
    this.gestante = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        cns = Value(cns),
        nome = Value(nome),
        dataNascimento = Value(dataNascimento),
        aldeiaAtualId = Value(aldeiaAtualId);
  static Insertable<Indigena> custom({
    Expression<String>? id,
    Expression<String>? cns,
    Expression<String>? nome,
    Expression<DateTime>? dataNascimento,
    Expression<int>? aldeiaAtualId,
    Expression<bool>? emTransito,
    Expression<bool>? internado,
    Expression<bool>? gestante,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cns != null) 'cns': cns,
      if (nome != null) 'nome': nome,
      if (dataNascimento != null) 'data_nascimento': dataNascimento,
      if (aldeiaAtualId != null) 'aldeia_atual_id': aldeiaAtualId,
      if (emTransito != null) 'em_transito': emTransito,
      if (internado != null) 'internado': internado,
      if (gestante != null) 'gestante': gestante,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IndigenasCompanion copyWith(
      {Value<String>? id,
      Value<String>? cns,
      Value<String>? nome,
      Value<DateTime>? dataNascimento,
      Value<int>? aldeiaAtualId,
      Value<bool>? emTransito,
      Value<bool>? internado,
      Value<bool>? gestante,
      Value<int>? rowid}) {
    return IndigenasCompanion(
      id: id ?? this.id,
      cns: cns ?? this.cns,
      nome: nome ?? this.nome,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      aldeiaAtualId: aldeiaAtualId ?? this.aldeiaAtualId,
      emTransito: emTransito ?? this.emTransito,
      internado: internado ?? this.internado,
      gestante: gestante ?? this.gestante,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cns.present) {
      map['cns'] = Variable<String>(cns.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (dataNascimento.present) {
      map['data_nascimento'] = Variable<DateTime>(dataNascimento.value);
    }
    if (aldeiaAtualId.present) {
      map['aldeia_atual_id'] = Variable<int>(aldeiaAtualId.value);
    }
    if (emTransito.present) {
      map['em_transito'] = Variable<bool>(emTransito.value);
    }
    if (internado.present) {
      map['internado'] = Variable<bool>(internado.value);
    }
    if (gestante.present) {
      map['gestante'] = Variable<bool>(gestante.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IndigenasCompanion(')
          ..write('id: $id, ')
          ..write('cns: $cns, ')
          ..write('nome: $nome, ')
          ..write('dataNascimento: $dataNascimento, ')
          ..write('aldeiaAtualId: $aldeiaAtualId, ')
          ..write('emTransito: $emTransito, ')
          ..write('internado: $internado, ')
          ..write('gestante: $gestante, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HistoricoLogradourosTable extends HistoricoLogradouros
    with TableInfo<$HistoricoLogradourosTable, HistoricoLogradouro> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoricoLogradourosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _indigenaIdMeta =
      const VerificationMeta('indigenaId');
  @override
  late final GeneratedColumn<String> indigenaId = GeneratedColumn<String>(
      'indigena_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES indigenas (id)'));
  static const VerificationMeta _aldeiaOrigemIdMeta =
      const VerificationMeta('aldeiaOrigemId');
  @override
  late final GeneratedColumn<int> aldeiaOrigemId = GeneratedColumn<int>(
      'aldeia_origem_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES aldeias (id)'));
  static const VerificationMeta _aldeiaDestinoIdMeta =
      const VerificationMeta('aldeiaDestinoId');
  @override
  late final GeneratedColumn<int> aldeiaDestinoId = GeneratedColumn<int>(
      'aldeia_destino_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES aldeias (id)'));
  static const VerificationMeta _dataMudancaMeta =
      const VerificationMeta('dataMudanca');
  @override
  late final GeneratedColumn<DateTime> dataMudanca = GeneratedColumn<DateTime>(
      'data_mudanca', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _motivoMeta = const VerificationMeta('motivo');
  @override
  late final GeneratedColumn<String> motivo = GeneratedColumn<String>(
      'motivo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, indigenaId, aldeiaOrigemId, aldeiaDestinoId, dataMudanca, motivo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historico_logradouros';
  @override
  VerificationContext validateIntegrity(
      Insertable<HistoricoLogradouro> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('indigena_id')) {
      context.handle(
          _indigenaIdMeta,
          indigenaId.isAcceptableOrUnknown(
              data['indigena_id']!, _indigenaIdMeta));
    } else if (isInserting) {
      context.missing(_indigenaIdMeta);
    }
    if (data.containsKey('aldeia_origem_id')) {
      context.handle(
          _aldeiaOrigemIdMeta,
          aldeiaOrigemId.isAcceptableOrUnknown(
              data['aldeia_origem_id']!, _aldeiaOrigemIdMeta));
    } else if (isInserting) {
      context.missing(_aldeiaOrigemIdMeta);
    }
    if (data.containsKey('aldeia_destino_id')) {
      context.handle(
          _aldeiaDestinoIdMeta,
          aldeiaDestinoId.isAcceptableOrUnknown(
              data['aldeia_destino_id']!, _aldeiaDestinoIdMeta));
    } else if (isInserting) {
      context.missing(_aldeiaDestinoIdMeta);
    }
    if (data.containsKey('data_mudanca')) {
      context.handle(
          _dataMudancaMeta,
          dataMudanca.isAcceptableOrUnknown(
              data['data_mudanca']!, _dataMudancaMeta));
    } else if (isInserting) {
      context.missing(_dataMudancaMeta);
    }
    if (data.containsKey('motivo')) {
      context.handle(_motivoMeta,
          motivo.isAcceptableOrUnknown(data['motivo']!, _motivoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoricoLogradouro map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoricoLogradouro(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      indigenaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}indigena_id'])!,
      aldeiaOrigemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}aldeia_origem_id'])!,
      aldeiaDestinoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}aldeia_destino_id'])!,
      dataMudanca: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_mudanca'])!,
      motivo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}motivo']),
    );
  }

  @override
  $HistoricoLogradourosTable createAlias(String alias) {
    return $HistoricoLogradourosTable(attachedDatabase, alias);
  }
}

class HistoricoLogradouro extends DataClass
    implements Insertable<HistoricoLogradouro> {
  final int id;
  final String indigenaId;
  final int aldeiaOrigemId;
  final int aldeiaDestinoId;
  final DateTime dataMudanca;
  final String? motivo;
  const HistoricoLogradouro(
      {required this.id,
      required this.indigenaId,
      required this.aldeiaOrigemId,
      required this.aldeiaDestinoId,
      required this.dataMudanca,
      this.motivo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['indigena_id'] = Variable<String>(indigenaId);
    map['aldeia_origem_id'] = Variable<int>(aldeiaOrigemId);
    map['aldeia_destino_id'] = Variable<int>(aldeiaDestinoId);
    map['data_mudanca'] = Variable<DateTime>(dataMudanca);
    if (!nullToAbsent || motivo != null) {
      map['motivo'] = Variable<String>(motivo);
    }
    return map;
  }

  HistoricoLogradourosCompanion toCompanion(bool nullToAbsent) {
    return HistoricoLogradourosCompanion(
      id: Value(id),
      indigenaId: Value(indigenaId),
      aldeiaOrigemId: Value(aldeiaOrigemId),
      aldeiaDestinoId: Value(aldeiaDestinoId),
      dataMudanca: Value(dataMudanca),
      motivo:
          motivo == null && nullToAbsent ? const Value.absent() : Value(motivo),
    );
  }

  factory HistoricoLogradouro.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoricoLogradouro(
      id: serializer.fromJson<int>(json['id']),
      indigenaId: serializer.fromJson<String>(json['indigenaId']),
      aldeiaOrigemId: serializer.fromJson<int>(json['aldeiaOrigemId']),
      aldeiaDestinoId: serializer.fromJson<int>(json['aldeiaDestinoId']),
      dataMudanca: serializer.fromJson<DateTime>(json['dataMudanca']),
      motivo: serializer.fromJson<String?>(json['motivo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'indigenaId': serializer.toJson<String>(indigenaId),
      'aldeiaOrigemId': serializer.toJson<int>(aldeiaOrigemId),
      'aldeiaDestinoId': serializer.toJson<int>(aldeiaDestinoId),
      'dataMudanca': serializer.toJson<DateTime>(dataMudanca),
      'motivo': serializer.toJson<String?>(motivo),
    };
  }

  HistoricoLogradouro copyWith(
          {int? id,
          String? indigenaId,
          int? aldeiaOrigemId,
          int? aldeiaDestinoId,
          DateTime? dataMudanca,
          Value<String?> motivo = const Value.absent()}) =>
      HistoricoLogradouro(
        id: id ?? this.id,
        indigenaId: indigenaId ?? this.indigenaId,
        aldeiaOrigemId: aldeiaOrigemId ?? this.aldeiaOrigemId,
        aldeiaDestinoId: aldeiaDestinoId ?? this.aldeiaDestinoId,
        dataMudanca: dataMudanca ?? this.dataMudanca,
        motivo: motivo.present ? motivo.value : this.motivo,
      );
  HistoricoLogradouro copyWithCompanion(HistoricoLogradourosCompanion data) {
    return HistoricoLogradouro(
      id: data.id.present ? data.id.value : this.id,
      indigenaId:
          data.indigenaId.present ? data.indigenaId.value : this.indigenaId,
      aldeiaOrigemId: data.aldeiaOrigemId.present
          ? data.aldeiaOrigemId.value
          : this.aldeiaOrigemId,
      aldeiaDestinoId: data.aldeiaDestinoId.present
          ? data.aldeiaDestinoId.value
          : this.aldeiaDestinoId,
      dataMudanca:
          data.dataMudanca.present ? data.dataMudanca.value : this.dataMudanca,
      motivo: data.motivo.present ? data.motivo.value : this.motivo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoricoLogradouro(')
          ..write('id: $id, ')
          ..write('indigenaId: $indigenaId, ')
          ..write('aldeiaOrigemId: $aldeiaOrigemId, ')
          ..write('aldeiaDestinoId: $aldeiaDestinoId, ')
          ..write('dataMudanca: $dataMudanca, ')
          ..write('motivo: $motivo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, indigenaId, aldeiaOrigemId, aldeiaDestinoId, dataMudanca, motivo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoricoLogradouro &&
          other.id == this.id &&
          other.indigenaId == this.indigenaId &&
          other.aldeiaOrigemId == this.aldeiaOrigemId &&
          other.aldeiaDestinoId == this.aldeiaDestinoId &&
          other.dataMudanca == this.dataMudanca &&
          other.motivo == this.motivo);
}

class HistoricoLogradourosCompanion
    extends UpdateCompanion<HistoricoLogradouro> {
  final Value<int> id;
  final Value<String> indigenaId;
  final Value<int> aldeiaOrigemId;
  final Value<int> aldeiaDestinoId;
  final Value<DateTime> dataMudanca;
  final Value<String?> motivo;
  const HistoricoLogradourosCompanion({
    this.id = const Value.absent(),
    this.indigenaId = const Value.absent(),
    this.aldeiaOrigemId = const Value.absent(),
    this.aldeiaDestinoId = const Value.absent(),
    this.dataMudanca = const Value.absent(),
    this.motivo = const Value.absent(),
  });
  HistoricoLogradourosCompanion.insert({
    this.id = const Value.absent(),
    required String indigenaId,
    required int aldeiaOrigemId,
    required int aldeiaDestinoId,
    required DateTime dataMudanca,
    this.motivo = const Value.absent(),
  })  : indigenaId = Value(indigenaId),
        aldeiaOrigemId = Value(aldeiaOrigemId),
        aldeiaDestinoId = Value(aldeiaDestinoId),
        dataMudanca = Value(dataMudanca);
  static Insertable<HistoricoLogradouro> custom({
    Expression<int>? id,
    Expression<String>? indigenaId,
    Expression<int>? aldeiaOrigemId,
    Expression<int>? aldeiaDestinoId,
    Expression<DateTime>? dataMudanca,
    Expression<String>? motivo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (indigenaId != null) 'indigena_id': indigenaId,
      if (aldeiaOrigemId != null) 'aldeia_origem_id': aldeiaOrigemId,
      if (aldeiaDestinoId != null) 'aldeia_destino_id': aldeiaDestinoId,
      if (dataMudanca != null) 'data_mudanca': dataMudanca,
      if (motivo != null) 'motivo': motivo,
    });
  }

  HistoricoLogradourosCompanion copyWith(
      {Value<int>? id,
      Value<String>? indigenaId,
      Value<int>? aldeiaOrigemId,
      Value<int>? aldeiaDestinoId,
      Value<DateTime>? dataMudanca,
      Value<String?>? motivo}) {
    return HistoricoLogradourosCompanion(
      id: id ?? this.id,
      indigenaId: indigenaId ?? this.indigenaId,
      aldeiaOrigemId: aldeiaOrigemId ?? this.aldeiaOrigemId,
      aldeiaDestinoId: aldeiaDestinoId ?? this.aldeiaDestinoId,
      dataMudanca: dataMudanca ?? this.dataMudanca,
      motivo: motivo ?? this.motivo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (indigenaId.present) {
      map['indigena_id'] = Variable<String>(indigenaId.value);
    }
    if (aldeiaOrigemId.present) {
      map['aldeia_origem_id'] = Variable<int>(aldeiaOrigemId.value);
    }
    if (aldeiaDestinoId.present) {
      map['aldeia_destino_id'] = Variable<int>(aldeiaDestinoId.value);
    }
    if (dataMudanca.present) {
      map['data_mudanca'] = Variable<DateTime>(dataMudanca.value);
    }
    if (motivo.present) {
      map['motivo'] = Variable<String>(motivo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoricoLogradourosCompanion(')
          ..write('id: $id, ')
          ..write('indigenaId: $indigenaId, ')
          ..write('aldeiaOrigemId: $aldeiaOrigemId, ')
          ..write('aldeiaDestinoId: $aldeiaDestinoId, ')
          ..write('dataMudanca: $dataMudanca, ')
          ..write('motivo: $motivo')
          ..write(')'))
        .toString();
  }
}

class $AtendimentosTable extends Atendimentos
    with TableInfo<$AtendimentosTable, Atendimento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AtendimentosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _indigenaIdMeta =
      const VerificationMeta('indigenaId');
  @override
  late final GeneratedColumn<String> indigenaId = GeneratedColumn<String>(
      'indigena_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES indigenas (id)'));
  static const VerificationMeta _aldeiaIdMeta =
      const VerificationMeta('aldeiaId');
  @override
  late final GeneratedColumn<int> aldeiaId = GeneratedColumn<int>(
      'aldeia_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES aldeias (id)'));
  static const VerificationMeta _tipoAtendimentoMeta =
      const VerificationMeta('tipoAtendimento');
  @override
  late final GeneratedColumn<String> tipoAtendimento = GeneratedColumn<String>(
      'tipo_atendimento', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _observacoesMeta =
      const VerificationMeta('observacoes');
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
      'observacoes', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataHoraMeta =
      const VerificationMeta('dataHora');
  @override
  late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>(
      'data_hora', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, indigenaId, aldeiaId, tipoAtendimento, observacoes, dataHora];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'atendimentos';
  @override
  VerificationContext validateIntegrity(Insertable<Atendimento> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('indigena_id')) {
      context.handle(
          _indigenaIdMeta,
          indigenaId.isAcceptableOrUnknown(
              data['indigena_id']!, _indigenaIdMeta));
    } else if (isInserting) {
      context.missing(_indigenaIdMeta);
    }
    if (data.containsKey('aldeia_id')) {
      context.handle(_aldeiaIdMeta,
          aldeiaId.isAcceptableOrUnknown(data['aldeia_id']!, _aldeiaIdMeta));
    } else if (isInserting) {
      context.missing(_aldeiaIdMeta);
    }
    if (data.containsKey('tipo_atendimento')) {
      context.handle(
          _tipoAtendimentoMeta,
          tipoAtendimento.isAcceptableOrUnknown(
              data['tipo_atendimento']!, _tipoAtendimentoMeta));
    } else if (isInserting) {
      context.missing(_tipoAtendimentoMeta);
    }
    if (data.containsKey('observacoes')) {
      context.handle(
          _observacoesMeta,
          observacoes.isAcceptableOrUnknown(
              data['observacoes']!, _observacoesMeta));
    } else if (isInserting) {
      context.missing(_observacoesMeta);
    }
    if (data.containsKey('data_hora')) {
      context.handle(_dataHoraMeta,
          dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta));
    } else if (isInserting) {
      context.missing(_dataHoraMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Atendimento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Atendimento(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      indigenaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}indigena_id'])!,
      aldeiaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}aldeia_id'])!,
      tipoAtendimento: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}tipo_atendimento'])!,
      observacoes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacoes'])!,
      dataHora: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_hora'])!,
    );
  }

  @override
  $AtendimentosTable createAlias(String alias) {
    return $AtendimentosTable(attachedDatabase, alias);
  }
}

class Atendimento extends DataClass implements Insertable<Atendimento> {
  final String id;
  final String indigenaId;
  final int aldeiaId;
  final String tipoAtendimento;
  final String observacoes;
  final DateTime dataHora;
  const Atendimento(
      {required this.id,
      required this.indigenaId,
      required this.aldeiaId,
      required this.tipoAtendimento,
      required this.observacoes,
      required this.dataHora});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['indigena_id'] = Variable<String>(indigenaId);
    map['aldeia_id'] = Variable<int>(aldeiaId);
    map['tipo_atendimento'] = Variable<String>(tipoAtendimento);
    map['observacoes'] = Variable<String>(observacoes);
    map['data_hora'] = Variable<DateTime>(dataHora);
    return map;
  }

  AtendimentosCompanion toCompanion(bool nullToAbsent) {
    return AtendimentosCompanion(
      id: Value(id),
      indigenaId: Value(indigenaId),
      aldeiaId: Value(aldeiaId),
      tipoAtendimento: Value(tipoAtendimento),
      observacoes: Value(observacoes),
      dataHora: Value(dataHora),
    );
  }

  factory Atendimento.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Atendimento(
      id: serializer.fromJson<String>(json['id']),
      indigenaId: serializer.fromJson<String>(json['indigenaId']),
      aldeiaId: serializer.fromJson<int>(json['aldeiaId']),
      tipoAtendimento: serializer.fromJson<String>(json['tipoAtendimento']),
      observacoes: serializer.fromJson<String>(json['observacoes']),
      dataHora: serializer.fromJson<DateTime>(json['dataHora']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'indigenaId': serializer.toJson<String>(indigenaId),
      'aldeiaId': serializer.toJson<int>(aldeiaId),
      'tipoAtendimento': serializer.toJson<String>(tipoAtendimento),
      'observacoes': serializer.toJson<String>(observacoes),
      'dataHora': serializer.toJson<DateTime>(dataHora),
    };
  }

  Atendimento copyWith(
          {String? id,
          String? indigenaId,
          int? aldeiaId,
          String? tipoAtendimento,
          String? observacoes,
          DateTime? dataHora}) =>
      Atendimento(
        id: id ?? this.id,
        indigenaId: indigenaId ?? this.indigenaId,
        aldeiaId: aldeiaId ?? this.aldeiaId,
        tipoAtendimento: tipoAtendimento ?? this.tipoAtendimento,
        observacoes: observacoes ?? this.observacoes,
        dataHora: dataHora ?? this.dataHora,
      );
  Atendimento copyWithCompanion(AtendimentosCompanion data) {
    return Atendimento(
      id: data.id.present ? data.id.value : this.id,
      indigenaId:
          data.indigenaId.present ? data.indigenaId.value : this.indigenaId,
      aldeiaId: data.aldeiaId.present ? data.aldeiaId.value : this.aldeiaId,
      tipoAtendimento: data.tipoAtendimento.present
          ? data.tipoAtendimento.value
          : this.tipoAtendimento,
      observacoes:
          data.observacoes.present ? data.observacoes.value : this.observacoes,
      dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Atendimento(')
          ..write('id: $id, ')
          ..write('indigenaId: $indigenaId, ')
          ..write('aldeiaId: $aldeiaId, ')
          ..write('tipoAtendimento: $tipoAtendimento, ')
          ..write('observacoes: $observacoes, ')
          ..write('dataHora: $dataHora')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, indigenaId, aldeiaId, tipoAtendimento, observacoes, dataHora);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Atendimento &&
          other.id == this.id &&
          other.indigenaId == this.indigenaId &&
          other.aldeiaId == this.aldeiaId &&
          other.tipoAtendimento == this.tipoAtendimento &&
          other.observacoes == this.observacoes &&
          other.dataHora == this.dataHora);
}

class AtendimentosCompanion extends UpdateCompanion<Atendimento> {
  final Value<String> id;
  final Value<String> indigenaId;
  final Value<int> aldeiaId;
  final Value<String> tipoAtendimento;
  final Value<String> observacoes;
  final Value<DateTime> dataHora;
  final Value<int> rowid;
  const AtendimentosCompanion({
    this.id = const Value.absent(),
    this.indigenaId = const Value.absent(),
    this.aldeiaId = const Value.absent(),
    this.tipoAtendimento = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.dataHora = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AtendimentosCompanion.insert({
    required String id,
    required String indigenaId,
    required int aldeiaId,
    required String tipoAtendimento,
    required String observacoes,
    required DateTime dataHora,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        indigenaId = Value(indigenaId),
        aldeiaId = Value(aldeiaId),
        tipoAtendimento = Value(tipoAtendimento),
        observacoes = Value(observacoes),
        dataHora = Value(dataHora);
  static Insertable<Atendimento> custom({
    Expression<String>? id,
    Expression<String>? indigenaId,
    Expression<int>? aldeiaId,
    Expression<String>? tipoAtendimento,
    Expression<String>? observacoes,
    Expression<DateTime>? dataHora,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (indigenaId != null) 'indigena_id': indigenaId,
      if (aldeiaId != null) 'aldeia_id': aldeiaId,
      if (tipoAtendimento != null) 'tipo_atendimento': tipoAtendimento,
      if (observacoes != null) 'observacoes': observacoes,
      if (dataHora != null) 'data_hora': dataHora,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AtendimentosCompanion copyWith(
      {Value<String>? id,
      Value<String>? indigenaId,
      Value<int>? aldeiaId,
      Value<String>? tipoAtendimento,
      Value<String>? observacoes,
      Value<DateTime>? dataHora,
      Value<int>? rowid}) {
    return AtendimentosCompanion(
      id: id ?? this.id,
      indigenaId: indigenaId ?? this.indigenaId,
      aldeiaId: aldeiaId ?? this.aldeiaId,
      tipoAtendimento: tipoAtendimento ?? this.tipoAtendimento,
      observacoes: observacoes ?? this.observacoes,
      dataHora: dataHora ?? this.dataHora,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (indigenaId.present) {
      map['indigena_id'] = Variable<String>(indigenaId.value);
    }
    if (aldeiaId.present) {
      map['aldeia_id'] = Variable<int>(aldeiaId.value);
    }
    if (tipoAtendimento.present) {
      map['tipo_atendimento'] = Variable<String>(tipoAtendimento.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (dataHora.present) {
      map['data_hora'] = Variable<DateTime>(dataHora.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AtendimentosCompanion(')
          ..write('id: $id, ')
          ..write('indigenaId: $indigenaId, ')
          ..write('aldeiaId: $aldeiaId, ')
          ..write('tipoAtendimento: $tipoAtendimento, ')
          ..write('observacoes: $observacoes, ')
          ..write('dataHora: $dataHora, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AldeiasTable aldeias = $AldeiasTable(this);
  late final $IndigenasTable indigenas = $IndigenasTable(this);
  late final $HistoricoLogradourosTable historicoLogradouros =
      $HistoricoLogradourosTable(this);
  late final $AtendimentosTable atendimentos = $AtendimentosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [aldeias, indigenas, historicoLogradouros, atendimentos];
}

typedef $$AldeiasTableCreateCompanionBuilder = AldeiasCompanion Function({
  Value<int> id,
  required String nome,
  Value<String> dsei,
});
typedef $$AldeiasTableUpdateCompanionBuilder = AldeiasCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<String> dsei,
});

final class $$AldeiasTableReferences
    extends BaseReferences<_$AppDatabase, $AldeiasTable, Aldeia> {
  $$AldeiasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$IndigenasTable, List<Indigena>>
      _indigenasRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.indigenas,
              aliasName: 'aldeias__id__indigenas__aldeia_atual_id');

  $$IndigenasTableProcessedTableManager get indigenasRefs {
    final manager = $$IndigenasTableTableManager($_db, $_db.indigenas)
        .filter((f) => f.aldeiaAtualId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_indigenasRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HistoricoLogradourosTable,
      List<HistoricoLogradouro>> _historicoOrigemTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.historicoLogradouros,
          aliasName: 'aldeias__id__historico_logradouros__aldeia_origem_id');

  $$HistoricoLogradourosTableProcessedTableManager get historicoOrigem {
    final manager = $$HistoricoLogradourosTableTableManager(
            $_db, $_db.historicoLogradouros)
        .filter((f) => f.aldeiaOrigemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_historicoOrigemTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HistoricoLogradourosTable,
      List<HistoricoLogradouro>> _historicoDestinoTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.historicoLogradouros,
          aliasName: 'aldeias__id__historico_logradouros__aldeia_destino_id');

  $$HistoricoLogradourosTableProcessedTableManager get historicoDestino {
    final manager = $$HistoricoLogradourosTableTableManager(
            $_db, $_db.historicoLogradouros)
        .filter(
            (f) => f.aldeiaDestinoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_historicoDestinoTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AtendimentosTable, List<Atendimento>>
      _atendimentosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.atendimentos,
              aliasName: 'aldeias__id__atendimentos__aldeia_id');

  $$AtendimentosTableProcessedTableManager get atendimentosRefs {
    final manager = $$AtendimentosTableTableManager($_db, $_db.atendimentos)
        .filter((f) => f.aldeiaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_atendimentosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AldeiasTableFilterComposer
    extends Composer<_$AppDatabase, $AldeiasTable> {
  $$AldeiasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dsei => $composableBuilder(
      column: $table.dsei, builder: (column) => ColumnFilters(column));

  Expression<bool> indigenasRefs(
      Expression<bool> Function($$IndigenasTableFilterComposer f) f) {
    final $$IndigenasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.indigenas,
        getReferencedColumn: (t) => t.aldeiaAtualId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IndigenasTableFilterComposer(
              $db: $db,
              $table: $db.indigenas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> historicoOrigem(
      Expression<bool> Function($$HistoricoLogradourosTableFilterComposer f)
          f) {
    final $$HistoricoLogradourosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.historicoLogradouros,
        getReferencedColumn: (t) => t.aldeiaOrigemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HistoricoLogradourosTableFilterComposer(
              $db: $db,
              $table: $db.historicoLogradouros,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> historicoDestino(
      Expression<bool> Function($$HistoricoLogradourosTableFilterComposer f)
          f) {
    final $$HistoricoLogradourosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.historicoLogradouros,
        getReferencedColumn: (t) => t.aldeiaDestinoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HistoricoLogradourosTableFilterComposer(
              $db: $db,
              $table: $db.historicoLogradouros,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> atendimentosRefs(
      Expression<bool> Function($$AtendimentosTableFilterComposer f) f) {
    final $$AtendimentosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.atendimentos,
        getReferencedColumn: (t) => t.aldeiaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AtendimentosTableFilterComposer(
              $db: $db,
              $table: $db.atendimentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AldeiasTableOrderingComposer
    extends Composer<_$AppDatabase, $AldeiasTable> {
  $$AldeiasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dsei => $composableBuilder(
      column: $table.dsei, builder: (column) => ColumnOrderings(column));
}

class $$AldeiasTableAnnotationComposer
    extends Composer<_$AppDatabase, $AldeiasTable> {
  $$AldeiasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get dsei =>
      $composableBuilder(column: $table.dsei, builder: (column) => column);

  Expression<T> indigenasRefs<T extends Object>(
      Expression<T> Function($$IndigenasTableAnnotationComposer a) f) {
    final $$IndigenasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.indigenas,
        getReferencedColumn: (t) => t.aldeiaAtualId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IndigenasTableAnnotationComposer(
              $db: $db,
              $table: $db.indigenas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> historicoOrigem<T extends Object>(
      Expression<T> Function($$HistoricoLogradourosTableAnnotationComposer a)
          f) {
    final $$HistoricoLogradourosTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.historicoLogradouros,
            getReferencedColumn: (t) => t.aldeiaOrigemId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HistoricoLogradourosTableAnnotationComposer(
                  $db: $db,
                  $table: $db.historicoLogradouros,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> historicoDestino<T extends Object>(
      Expression<T> Function($$HistoricoLogradourosTableAnnotationComposer a)
          f) {
    final $$HistoricoLogradourosTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.historicoLogradouros,
            getReferencedColumn: (t) => t.aldeiaDestinoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HistoricoLogradourosTableAnnotationComposer(
                  $db: $db,
                  $table: $db.historicoLogradouros,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> atendimentosRefs<T extends Object>(
      Expression<T> Function($$AtendimentosTableAnnotationComposer a) f) {
    final $$AtendimentosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.atendimentos,
        getReferencedColumn: (t) => t.aldeiaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AtendimentosTableAnnotationComposer(
              $db: $db,
              $table: $db.atendimentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AldeiasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AldeiasTable,
    Aldeia,
    $$AldeiasTableFilterComposer,
    $$AldeiasTableOrderingComposer,
    $$AldeiasTableAnnotationComposer,
    $$AldeiasTableCreateCompanionBuilder,
    $$AldeiasTableUpdateCompanionBuilder,
    (Aldeia, $$AldeiasTableReferences),
    Aldeia,
    PrefetchHooks Function(
        {bool indigenasRefs,
        bool historicoOrigem,
        bool historicoDestino,
        bool atendimentosRefs})> {
  $$AldeiasTableTableManager(_$AppDatabase db, $AldeiasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AldeiasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AldeiasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AldeiasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> dsei = const Value.absent(),
          }) =>
              AldeiasCompanion(
            id: id,
            nome: nome,
            dsei: dsei,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nome,
            Value<String> dsei = const Value.absent(),
          }) =>
              AldeiasCompanion.insert(
            id: id,
            nome: nome,
            dsei: dsei,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AldeiasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {indigenasRefs = false,
              historicoOrigem = false,
              historicoDestino = false,
              atendimentosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (indigenasRefs) db.indigenas,
                if (historicoOrigem) db.historicoLogradouros,
                if (historicoDestino) db.historicoLogradouros,
                if (atendimentosRefs) db.atendimentos
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (indigenasRefs)
                    await $_getPrefetchedData<Aldeia, $AldeiasTable, Indigena>(
                        currentTable: table,
                        referencedTable:
                            $$AldeiasTableReferences._indigenasRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AldeiasTableReferences(db, table, p0)
                                .indigenasRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.aldeiaAtualId == item.id),
                        typedResults: items),
                  if (historicoOrigem)
                    await $_getPrefetchedData<Aldeia, $AldeiasTable,
                            HistoricoLogradouro>(
                        currentTable: table,
                        referencedTable:
                            $$AldeiasTableReferences._historicoOrigemTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AldeiasTableReferences(db, table, p0)
                                .historicoOrigem,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.aldeiaOrigemId == item.id),
                        typedResults: items),
                  if (historicoDestino)
                    await $_getPrefetchedData<Aldeia, $AldeiasTable,
                            HistoricoLogradouro>(
                        currentTable: table,
                        referencedTable:
                            $$AldeiasTableReferences._historicoDestinoTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AldeiasTableReferences(db, table, p0)
                                .historicoDestino,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.aldeiaDestinoId == item.id),
                        typedResults: items),
                  if (atendimentosRefs)
                    await $_getPrefetchedData<Aldeia, $AldeiasTable,
                            Atendimento>(
                        currentTable: table,
                        referencedTable:
                            $$AldeiasTableReferences._atendimentosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AldeiasTableReferences(db, table, p0)
                                .atendimentosRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.aldeiaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AldeiasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AldeiasTable,
    Aldeia,
    $$AldeiasTableFilterComposer,
    $$AldeiasTableOrderingComposer,
    $$AldeiasTableAnnotationComposer,
    $$AldeiasTableCreateCompanionBuilder,
    $$AldeiasTableUpdateCompanionBuilder,
    (Aldeia, $$AldeiasTableReferences),
    Aldeia,
    PrefetchHooks Function(
        {bool indigenasRefs,
        bool historicoOrigem,
        bool historicoDestino,
        bool atendimentosRefs})>;
typedef $$IndigenasTableCreateCompanionBuilder = IndigenasCompanion Function({
  required String id,
  required String cns,
  required String nome,
  required DateTime dataNascimento,
  required int aldeiaAtualId,
  Value<bool> emTransito,
  Value<bool> internado,
  Value<bool> gestante,
  Value<int> rowid,
});
typedef $$IndigenasTableUpdateCompanionBuilder = IndigenasCompanion Function({
  Value<String> id,
  Value<String> cns,
  Value<String> nome,
  Value<DateTime> dataNascimento,
  Value<int> aldeiaAtualId,
  Value<bool> emTransito,
  Value<bool> internado,
  Value<bool> gestante,
  Value<int> rowid,
});

final class $$IndigenasTableReferences
    extends BaseReferences<_$AppDatabase, $IndigenasTable, Indigena> {
  $$IndigenasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AldeiasTable _aldeiaAtualIdTable(_$AppDatabase db) =>
      db.aldeias.createAlias('indigenas__aldeia_atual_id__aldeias__id');

  $$AldeiasTableProcessedTableManager get aldeiaAtualId {
    final $_column = $_itemColumn<int>('aldeia_atual_id')!;

    final manager = $$AldeiasTableTableManager($_db, $_db.aldeias)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_aldeiaAtualIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$HistoricoLogradourosTable,
      List<HistoricoLogradouro>> _historicoLogradourosRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.historicoLogradouros,
          aliasName: 'indigenas__id__historico_logradouros__indigena_id');

  $$HistoricoLogradourosTableProcessedTableManager
      get historicoLogradourosRefs {
    final manager = $$HistoricoLogradourosTableTableManager(
            $_db, $_db.historicoLogradouros)
        .filter((f) => f.indigenaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_historicoLogradourosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AtendimentosTable, List<Atendimento>>
      _atendimentosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.atendimentos,
              aliasName: 'indigenas__id__atendimentos__indigena_id');

  $$AtendimentosTableProcessedTableManager get atendimentosRefs {
    final manager = $$AtendimentosTableTableManager($_db, $_db.atendimentos)
        .filter((f) => f.indigenaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_atendimentosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$IndigenasTableFilterComposer
    extends Composer<_$AppDatabase, $IndigenasTable> {
  $$IndigenasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cns => $composableBuilder(
      column: $table.cns, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataNascimento => $composableBuilder(
      column: $table.dataNascimento,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get emTransito => $composableBuilder(
      column: $table.emTransito, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get internado => $composableBuilder(
      column: $table.internado, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get gestante => $composableBuilder(
      column: $table.gestante, builder: (column) => ColumnFilters(column));

  $$AldeiasTableFilterComposer get aldeiaAtualId {
    final $$AldeiasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.aldeiaAtualId,
        referencedTable: $db.aldeias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AldeiasTableFilterComposer(
              $db: $db,
              $table: $db.aldeias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> historicoLogradourosRefs(
      Expression<bool> Function($$HistoricoLogradourosTableFilterComposer f)
          f) {
    final $$HistoricoLogradourosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.historicoLogradouros,
        getReferencedColumn: (t) => t.indigenaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HistoricoLogradourosTableFilterComposer(
              $db: $db,
              $table: $db.historicoLogradouros,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> atendimentosRefs(
      Expression<bool> Function($$AtendimentosTableFilterComposer f) f) {
    final $$AtendimentosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.atendimentos,
        getReferencedColumn: (t) => t.indigenaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AtendimentosTableFilterComposer(
              $db: $db,
              $table: $db.atendimentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$IndigenasTableOrderingComposer
    extends Composer<_$AppDatabase, $IndigenasTable> {
  $$IndigenasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cns => $composableBuilder(
      column: $table.cns, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataNascimento => $composableBuilder(
      column: $table.dataNascimento,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get emTransito => $composableBuilder(
      column: $table.emTransito, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get internado => $composableBuilder(
      column: $table.internado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get gestante => $composableBuilder(
      column: $table.gestante, builder: (column) => ColumnOrderings(column));

  $$AldeiasTableOrderingComposer get aldeiaAtualId {
    final $$AldeiasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.aldeiaAtualId,
        referencedTable: $db.aldeias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AldeiasTableOrderingComposer(
              $db: $db,
              $table: $db.aldeias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IndigenasTableAnnotationComposer
    extends Composer<_$AppDatabase, $IndigenasTable> {
  $$IndigenasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cns =>
      $composableBuilder(column: $table.cns, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<DateTime> get dataNascimento => $composableBuilder(
      column: $table.dataNascimento, builder: (column) => column);

  GeneratedColumn<bool> get emTransito => $composableBuilder(
      column: $table.emTransito, builder: (column) => column);

  GeneratedColumn<bool> get internado =>
      $composableBuilder(column: $table.internado, builder: (column) => column);

  GeneratedColumn<bool> get gestante =>
      $composableBuilder(column: $table.gestante, builder: (column) => column);

  $$AldeiasTableAnnotationComposer get aldeiaAtualId {
    final $$AldeiasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.aldeiaAtualId,
        referencedTable: $db.aldeias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AldeiasTableAnnotationComposer(
              $db: $db,
              $table: $db.aldeias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> historicoLogradourosRefs<T extends Object>(
      Expression<T> Function($$HistoricoLogradourosTableAnnotationComposer a)
          f) {
    final $$HistoricoLogradourosTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.historicoLogradouros,
            getReferencedColumn: (t) => t.indigenaId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HistoricoLogradourosTableAnnotationComposer(
                  $db: $db,
                  $table: $db.historicoLogradouros,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> atendimentosRefs<T extends Object>(
      Expression<T> Function($$AtendimentosTableAnnotationComposer a) f) {
    final $$AtendimentosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.atendimentos,
        getReferencedColumn: (t) => t.indigenaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AtendimentosTableAnnotationComposer(
              $db: $db,
              $table: $db.atendimentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$IndigenasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IndigenasTable,
    Indigena,
    $$IndigenasTableFilterComposer,
    $$IndigenasTableOrderingComposer,
    $$IndigenasTableAnnotationComposer,
    $$IndigenasTableCreateCompanionBuilder,
    $$IndigenasTableUpdateCompanionBuilder,
    (Indigena, $$IndigenasTableReferences),
    Indigena,
    PrefetchHooks Function(
        {bool aldeiaAtualId,
        bool historicoLogradourosRefs,
        bool atendimentosRefs})> {
  $$IndigenasTableTableManager(_$AppDatabase db, $IndigenasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IndigenasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IndigenasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IndigenasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> cns = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<DateTime> dataNascimento = const Value.absent(),
            Value<int> aldeiaAtualId = const Value.absent(),
            Value<bool> emTransito = const Value.absent(),
            Value<bool> internado = const Value.absent(),
            Value<bool> gestante = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              IndigenasCompanion(
            id: id,
            cns: cns,
            nome: nome,
            dataNascimento: dataNascimento,
            aldeiaAtualId: aldeiaAtualId,
            emTransito: emTransito,
            internado: internado,
            gestante: gestante,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String cns,
            required String nome,
            required DateTime dataNascimento,
            required int aldeiaAtualId,
            Value<bool> emTransito = const Value.absent(),
            Value<bool> internado = const Value.absent(),
            Value<bool> gestante = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              IndigenasCompanion.insert(
            id: id,
            cns: cns,
            nome: nome,
            dataNascimento: dataNascimento,
            aldeiaAtualId: aldeiaAtualId,
            emTransito: emTransito,
            internado: internado,
            gestante: gestante,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$IndigenasTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {aldeiaAtualId = false,
              historicoLogradourosRefs = false,
              atendimentosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (historicoLogradourosRefs) db.historicoLogradouros,
                if (atendimentosRefs) db.atendimentos
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
                if (aldeiaAtualId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.aldeiaAtualId,
                    referencedTable:
                        $$IndigenasTableReferences._aldeiaAtualIdTable(db),
                    referencedColumn:
                        $$IndigenasTableReferences._aldeiaAtualIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (historicoLogradourosRefs)
                    await $_getPrefetchedData<Indigena, $IndigenasTable,
                            HistoricoLogradouro>(
                        currentTable: table,
                        referencedTable: $$IndigenasTableReferences
                            ._historicoLogradourosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$IndigenasTableReferences(db, table, p0)
                                .historicoLogradourosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.indigenaId == item.id),
                        typedResults: items),
                  if (atendimentosRefs)
                    await $_getPrefetchedData<Indigena, $IndigenasTable,
                            Atendimento>(
                        currentTable: table,
                        referencedTable: $$IndigenasTableReferences
                            ._atendimentosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$IndigenasTableReferences(db, table, p0)
                                .atendimentosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.indigenaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$IndigenasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IndigenasTable,
    Indigena,
    $$IndigenasTableFilterComposer,
    $$IndigenasTableOrderingComposer,
    $$IndigenasTableAnnotationComposer,
    $$IndigenasTableCreateCompanionBuilder,
    $$IndigenasTableUpdateCompanionBuilder,
    (Indigena, $$IndigenasTableReferences),
    Indigena,
    PrefetchHooks Function(
        {bool aldeiaAtualId,
        bool historicoLogradourosRefs,
        bool atendimentosRefs})>;
typedef $$HistoricoLogradourosTableCreateCompanionBuilder
    = HistoricoLogradourosCompanion Function({
  Value<int> id,
  required String indigenaId,
  required int aldeiaOrigemId,
  required int aldeiaDestinoId,
  required DateTime dataMudanca,
  Value<String?> motivo,
});
typedef $$HistoricoLogradourosTableUpdateCompanionBuilder
    = HistoricoLogradourosCompanion Function({
  Value<int> id,
  Value<String> indigenaId,
  Value<int> aldeiaOrigemId,
  Value<int> aldeiaDestinoId,
  Value<DateTime> dataMudanca,
  Value<String?> motivo,
});

final class $$HistoricoLogradourosTableReferences extends BaseReferences<
    _$AppDatabase, $HistoricoLogradourosTable, HistoricoLogradouro> {
  $$HistoricoLogradourosTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $IndigenasTable _indigenaIdTable(_$AppDatabase db) => db.indigenas
      .createAlias('historico_logradouros__indigena_id__indigenas__id');

  $$IndigenasTableProcessedTableManager get indigenaId {
    final $_column = $_itemColumn<String>('indigena_id')!;

    final manager = $$IndigenasTableTableManager($_db, $_db.indigenas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_indigenaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AldeiasTable _aldeiaOrigemIdTable(_$AppDatabase db) => db.aldeias
      .createAlias('historico_logradouros__aldeia_origem_id__aldeias__id');

  $$AldeiasTableProcessedTableManager get aldeiaOrigemId {
    final $_column = $_itemColumn<int>('aldeia_origem_id')!;

    final manager = $$AldeiasTableTableManager($_db, $_db.aldeias)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_aldeiaOrigemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AldeiasTable _aldeiaDestinoIdTable(_$AppDatabase db) => db.aldeias
      .createAlias('historico_logradouros__aldeia_destino_id__aldeias__id');

  $$AldeiasTableProcessedTableManager get aldeiaDestinoId {
    final $_column = $_itemColumn<int>('aldeia_destino_id')!;

    final manager = $$AldeiasTableTableManager($_db, $_db.aldeias)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_aldeiaDestinoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HistoricoLogradourosTableFilterComposer
    extends Composer<_$AppDatabase, $HistoricoLogradourosTable> {
  $$HistoricoLogradourosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataMudanca => $composableBuilder(
      column: $table.dataMudanca, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motivo => $composableBuilder(
      column: $table.motivo, builder: (column) => ColumnFilters(column));

  $$IndigenasTableFilterComposer get indigenaId {
    final $$IndigenasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.indigenaId,
        referencedTable: $db.indigenas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IndigenasTableFilterComposer(
              $db: $db,
              $table: $db.indigenas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AldeiasTableFilterComposer get aldeiaOrigemId {
    final $$AldeiasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.aldeiaOrigemId,
        referencedTable: $db.aldeias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AldeiasTableFilterComposer(
              $db: $db,
              $table: $db.aldeias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AldeiasTableFilterComposer get aldeiaDestinoId {
    final $$AldeiasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.aldeiaDestinoId,
        referencedTable: $db.aldeias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AldeiasTableFilterComposer(
              $db: $db,
              $table: $db.aldeias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HistoricoLogradourosTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoricoLogradourosTable> {
  $$HistoricoLogradourosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataMudanca => $composableBuilder(
      column: $table.dataMudanca, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motivo => $composableBuilder(
      column: $table.motivo, builder: (column) => ColumnOrderings(column));

  $$IndigenasTableOrderingComposer get indigenaId {
    final $$IndigenasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.indigenaId,
        referencedTable: $db.indigenas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IndigenasTableOrderingComposer(
              $db: $db,
              $table: $db.indigenas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AldeiasTableOrderingComposer get aldeiaOrigemId {
    final $$AldeiasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.aldeiaOrigemId,
        referencedTable: $db.aldeias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AldeiasTableOrderingComposer(
              $db: $db,
              $table: $db.aldeias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AldeiasTableOrderingComposer get aldeiaDestinoId {
    final $$AldeiasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.aldeiaDestinoId,
        referencedTable: $db.aldeias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AldeiasTableOrderingComposer(
              $db: $db,
              $table: $db.aldeias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HistoricoLogradourosTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoricoLogradourosTable> {
  $$HistoricoLogradourosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataMudanca => $composableBuilder(
      column: $table.dataMudanca, builder: (column) => column);

  GeneratedColumn<String> get motivo =>
      $composableBuilder(column: $table.motivo, builder: (column) => column);

  $$IndigenasTableAnnotationComposer get indigenaId {
    final $$IndigenasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.indigenaId,
        referencedTable: $db.indigenas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IndigenasTableAnnotationComposer(
              $db: $db,
              $table: $db.indigenas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AldeiasTableAnnotationComposer get aldeiaOrigemId {
    final $$AldeiasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.aldeiaOrigemId,
        referencedTable: $db.aldeias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AldeiasTableAnnotationComposer(
              $db: $db,
              $table: $db.aldeias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AldeiasTableAnnotationComposer get aldeiaDestinoId {
    final $$AldeiasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.aldeiaDestinoId,
        referencedTable: $db.aldeias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AldeiasTableAnnotationComposer(
              $db: $db,
              $table: $db.aldeias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HistoricoLogradourosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HistoricoLogradourosTable,
    HistoricoLogradouro,
    $$HistoricoLogradourosTableFilterComposer,
    $$HistoricoLogradourosTableOrderingComposer,
    $$HistoricoLogradourosTableAnnotationComposer,
    $$HistoricoLogradourosTableCreateCompanionBuilder,
    $$HistoricoLogradourosTableUpdateCompanionBuilder,
    (HistoricoLogradouro, $$HistoricoLogradourosTableReferences),
    HistoricoLogradouro,
    PrefetchHooks Function(
        {bool indigenaId, bool aldeiaOrigemId, bool aldeiaDestinoId})> {
  $$HistoricoLogradourosTableTableManager(
      _$AppDatabase db, $HistoricoLogradourosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoricoLogradourosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoricoLogradourosTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoricoLogradourosTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> indigenaId = const Value.absent(),
            Value<int> aldeiaOrigemId = const Value.absent(),
            Value<int> aldeiaDestinoId = const Value.absent(),
            Value<DateTime> dataMudanca = const Value.absent(),
            Value<String?> motivo = const Value.absent(),
          }) =>
              HistoricoLogradourosCompanion(
            id: id,
            indigenaId: indigenaId,
            aldeiaOrigemId: aldeiaOrigemId,
            aldeiaDestinoId: aldeiaDestinoId,
            dataMudanca: dataMudanca,
            motivo: motivo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String indigenaId,
            required int aldeiaOrigemId,
            required int aldeiaDestinoId,
            required DateTime dataMudanca,
            Value<String?> motivo = const Value.absent(),
          }) =>
              HistoricoLogradourosCompanion.insert(
            id: id,
            indigenaId: indigenaId,
            aldeiaOrigemId: aldeiaOrigemId,
            aldeiaDestinoId: aldeiaDestinoId,
            dataMudanca: dataMudanca,
            motivo: motivo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HistoricoLogradourosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {indigenaId = false,
              aldeiaOrigemId = false,
              aldeiaDestinoId = false}) {
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
                if (indigenaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.indigenaId,
                    referencedTable: $$HistoricoLogradourosTableReferences
                        ._indigenaIdTable(db),
                    referencedColumn: $$HistoricoLogradourosTableReferences
                        ._indigenaIdTable(db)
                        .id,
                  ) as T;
                }
                if (aldeiaOrigemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.aldeiaOrigemId,
                    referencedTable: $$HistoricoLogradourosTableReferences
                        ._aldeiaOrigemIdTable(db),
                    referencedColumn: $$HistoricoLogradourosTableReferences
                        ._aldeiaOrigemIdTable(db)
                        .id,
                  ) as T;
                }
                if (aldeiaDestinoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.aldeiaDestinoId,
                    referencedTable: $$HistoricoLogradourosTableReferences
                        ._aldeiaDestinoIdTable(db),
                    referencedColumn: $$HistoricoLogradourosTableReferences
                        ._aldeiaDestinoIdTable(db)
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

typedef $$HistoricoLogradourosTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $HistoricoLogradourosTable,
        HistoricoLogradouro,
        $$HistoricoLogradourosTableFilterComposer,
        $$HistoricoLogradourosTableOrderingComposer,
        $$HistoricoLogradourosTableAnnotationComposer,
        $$HistoricoLogradourosTableCreateCompanionBuilder,
        $$HistoricoLogradourosTableUpdateCompanionBuilder,
        (HistoricoLogradouro, $$HistoricoLogradourosTableReferences),
        HistoricoLogradouro,
        PrefetchHooks Function(
            {bool indigenaId, bool aldeiaOrigemId, bool aldeiaDestinoId})>;
typedef $$AtendimentosTableCreateCompanionBuilder = AtendimentosCompanion
    Function({
  required String id,
  required String indigenaId,
  required int aldeiaId,
  required String tipoAtendimento,
  required String observacoes,
  required DateTime dataHora,
  Value<int> rowid,
});
typedef $$AtendimentosTableUpdateCompanionBuilder = AtendimentosCompanion
    Function({
  Value<String> id,
  Value<String> indigenaId,
  Value<int> aldeiaId,
  Value<String> tipoAtendimento,
  Value<String> observacoes,
  Value<DateTime> dataHora,
  Value<int> rowid,
});

final class $$AtendimentosTableReferences
    extends BaseReferences<_$AppDatabase, $AtendimentosTable, Atendimento> {
  $$AtendimentosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IndigenasTable _indigenaIdTable(_$AppDatabase db) =>
      db.indigenas.createAlias('atendimentos__indigena_id__indigenas__id');

  $$IndigenasTableProcessedTableManager get indigenaId {
    final $_column = $_itemColumn<String>('indigena_id')!;

    final manager = $$IndigenasTableTableManager($_db, $_db.indigenas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_indigenaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AldeiasTable _aldeiaIdTable(_$AppDatabase db) =>
      db.aldeias.createAlias('atendimentos__aldeia_id__aldeias__id');

  $$AldeiasTableProcessedTableManager get aldeiaId {
    final $_column = $_itemColumn<int>('aldeia_id')!;

    final manager = $$AldeiasTableTableManager($_db, $_db.aldeias)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_aldeiaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AtendimentosTableFilterComposer
    extends Composer<_$AppDatabase, $AtendimentosTable> {
  $$AtendimentosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoAtendimento => $composableBuilder(
      column: $table.tipoAtendimento,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataHora => $composableBuilder(
      column: $table.dataHora, builder: (column) => ColumnFilters(column));

  $$IndigenasTableFilterComposer get indigenaId {
    final $$IndigenasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.indigenaId,
        referencedTable: $db.indigenas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IndigenasTableFilterComposer(
              $db: $db,
              $table: $db.indigenas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AldeiasTableFilterComposer get aldeiaId {
    final $$AldeiasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.aldeiaId,
        referencedTable: $db.aldeias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AldeiasTableFilterComposer(
              $db: $db,
              $table: $db.aldeias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AtendimentosTableOrderingComposer
    extends Composer<_$AppDatabase, $AtendimentosTable> {
  $$AtendimentosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoAtendimento => $composableBuilder(
      column: $table.tipoAtendimento,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataHora => $composableBuilder(
      column: $table.dataHora, builder: (column) => ColumnOrderings(column));

  $$IndigenasTableOrderingComposer get indigenaId {
    final $$IndigenasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.indigenaId,
        referencedTable: $db.indigenas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IndigenasTableOrderingComposer(
              $db: $db,
              $table: $db.indigenas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AldeiasTableOrderingComposer get aldeiaId {
    final $$AldeiasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.aldeiaId,
        referencedTable: $db.aldeias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AldeiasTableOrderingComposer(
              $db: $db,
              $table: $db.aldeias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AtendimentosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AtendimentosTable> {
  $$AtendimentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipoAtendimento => $composableBuilder(
      column: $table.tipoAtendimento, builder: (column) => column);

  GeneratedColumn<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHora =>
      $composableBuilder(column: $table.dataHora, builder: (column) => column);

  $$IndigenasTableAnnotationComposer get indigenaId {
    final $$IndigenasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.indigenaId,
        referencedTable: $db.indigenas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IndigenasTableAnnotationComposer(
              $db: $db,
              $table: $db.indigenas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AldeiasTableAnnotationComposer get aldeiaId {
    final $$AldeiasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.aldeiaId,
        referencedTable: $db.aldeias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AldeiasTableAnnotationComposer(
              $db: $db,
              $table: $db.aldeias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AtendimentosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AtendimentosTable,
    Atendimento,
    $$AtendimentosTableFilterComposer,
    $$AtendimentosTableOrderingComposer,
    $$AtendimentosTableAnnotationComposer,
    $$AtendimentosTableCreateCompanionBuilder,
    $$AtendimentosTableUpdateCompanionBuilder,
    (Atendimento, $$AtendimentosTableReferences),
    Atendimento,
    PrefetchHooks Function({bool indigenaId, bool aldeiaId})> {
  $$AtendimentosTableTableManager(_$AppDatabase db, $AtendimentosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AtendimentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AtendimentosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AtendimentosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> indigenaId = const Value.absent(),
            Value<int> aldeiaId = const Value.absent(),
            Value<String> tipoAtendimento = const Value.absent(),
            Value<String> observacoes = const Value.absent(),
            Value<DateTime> dataHora = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AtendimentosCompanion(
            id: id,
            indigenaId: indigenaId,
            aldeiaId: aldeiaId,
            tipoAtendimento: tipoAtendimento,
            observacoes: observacoes,
            dataHora: dataHora,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String indigenaId,
            required int aldeiaId,
            required String tipoAtendimento,
            required String observacoes,
            required DateTime dataHora,
            Value<int> rowid = const Value.absent(),
          }) =>
              AtendimentosCompanion.insert(
            id: id,
            indigenaId: indigenaId,
            aldeiaId: aldeiaId,
            tipoAtendimento: tipoAtendimento,
            observacoes: observacoes,
            dataHora: dataHora,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AtendimentosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({indigenaId = false, aldeiaId = false}) {
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
                if (indigenaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.indigenaId,
                    referencedTable:
                        $$AtendimentosTableReferences._indigenaIdTable(db),
                    referencedColumn:
                        $$AtendimentosTableReferences._indigenaIdTable(db).id,
                  ) as T;
                }
                if (aldeiaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.aldeiaId,
                    referencedTable:
                        $$AtendimentosTableReferences._aldeiaIdTable(db),
                    referencedColumn:
                        $$AtendimentosTableReferences._aldeiaIdTable(db).id,
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

typedef $$AtendimentosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AtendimentosTable,
    Atendimento,
    $$AtendimentosTableFilterComposer,
    $$AtendimentosTableOrderingComposer,
    $$AtendimentosTableAnnotationComposer,
    $$AtendimentosTableCreateCompanionBuilder,
    $$AtendimentosTableUpdateCompanionBuilder,
    (Atendimento, $$AtendimentosTableReferences),
    Atendimento,
    PrefetchHooks Function({bool indigenaId, bool aldeiaId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AldeiasTableTableManager get aldeias =>
      $$AldeiasTableTableManager(_db, _db.aldeias);
  $$IndigenasTableTableManager get indigenas =>
      $$IndigenasTableTableManager(_db, _db.indigenas);
  $$HistoricoLogradourosTableTableManager get historicoLogradouros =>
      $$HistoricoLogradourosTableTableManager(_db, _db.historicoLogradouros);
  $$AtendimentosTableTableManager get atendimentos =>
      $$AtendimentosTableTableManager(_db, _db.atendimentos);
}
