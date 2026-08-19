import 'package:drift/drift.dart';

// -----------------------------------------------------------------------------
// TABELA 1: ALDEIAS
// -----------------------------------------------------------------------------
class Aldeias extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text().withLength(min: 1, max: 100)();
  TextColumn get dsei => text().withDefault(const Constant('DSEI Litoral Sul'))();
}

// -----------------------------------------------------------------------------
// TABELA 2: INDIGENAS
// -----------------------------------------------------------------------------
class Indigenas extends Table {
  TextColumn get id => text()(); // ID único (UUID ou similar)
  TextColumn get cns => text().unique()();
  TextColumn get nome => text()();
  DateTimeColumn get dataNascimento => dateTime()();
  
  // Chave Estrangeira apontando para a aldeia atual
  IntColumn get aldeiaAtualId => integer().references(Aldeias, #id)();

  // Flags para controle centralizado
  BoolColumn get emTransito => boolean().withDefault(const Constant(false))();
  BoolColumn get internado => boolean().withDefault(const Constant(false))();
  BoolColumn get gestante => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// -----------------------------------------------------------------------------
// TABELA 3: HISTORICO DE LOGRADOUROS (MUDANÇA DE ALDEIA)
// -----------------------------------------------------------------------------
class HistoricoLogradouros extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get indigenaId => text().references(Indigenas, #id)();
  
  // @ReferenceName diferencia as duas conexões com a mesma tabela (Aldeias)
  @ReferenceName('historicoOrigem')
  IntColumn get aldeiaOrigemId => integer().references(Aldeias, #id)();
  
  @ReferenceName('historicoDestino')
  IntColumn get aldeiaDestinoId => integer().references(Aldeias, #id)();
  
  DateTimeColumn get dataMudanca => dateTime()();
  TextColumn get motivo => text().nullable()();
}

// -----------------------------------------------------------------------------
// TABELA 4: ATENDIMENTOS DE SAÚDE
// -----------------------------------------------------------------------------
class Atendimentos extends Table {
  TextColumn get id => text()();
  TextColumn get indigenaId => text().references(Indigenas, #id)();
  IntColumn get aldeiaId => integer().references(Aldeias, #id)();
  TextColumn get tipoAtendimento => text()();
  TextColumn get observacoes => text()();
  DateTimeColumn get dataHora => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}