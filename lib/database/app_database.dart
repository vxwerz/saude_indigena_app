import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Aldeias, Indigenas, HistoricoLogradouros, Atendimentos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();

          // Popula as 9 aldeias automaticamente na primeira inicialização
          await batch((b) {
            b.insertAll(aldeias, [
              AldeiasCompanion.insert(nome: 'Aldeinha'),
              AldeiasCompanion.insert(nome: 'Itaoca Guarani'),
              AldeiasCompanion.insert(nome: 'Itaoca Tupi'),
              AldeiasCompanion.insert(nome: 'Tekoa'),
              AldeiasCompanion.insert(nome: 'Yakã'),
              AldeiasCompanion.insert(nome: 'Arapyau'),
              AldeiasCompanion.insert(nome: 'Nhanderú-Pó'),
              AldeiasCompanion.insert(nome: 'Ka\'aguy Mirim'),
              AldeiasCompanion.insert(nome: 'Barigui'),
            ]);
          });
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            // Recria a estrutura das colunas sem causar conflito de tipo de classe
            await m.alterTable(TableMigration(atendimentos));
          }
        },
      );

  // ===========================================================================
  // CONSULTAS (QUERIES) DO APP
  // ===========================================================================

  // 1. Cadastrar um novo indígena
  Future<int> cadastrarIndigena(IndigenasCompanion indigena) {
    return into(indigenas).insert(indigena);
  }

  // 2. Listar todos os indígenas de uma aldeia específica
  Future<List<Indigena>> listarIndigenasPorAldeia(int aldeiaId) {
    return (select(indigenas)..where((tbl) => tbl.aldeiaAtualId.equals(aldeiaId))).get();
  }

  // 3. Mudar Indígena de Aldeia (Atualiza localização e cria registro no Histórico)
  Future<void> transferirDeAldeia({
    required String indigenaId,
    required int aldeiaOrigemId,
    required int aldeiaDestinoId,
    String? motivo,
  }) async {
    return transaction(() async {
      await (update(indigenas)..where((tbl) => tbl.id.equals(indigenaId))).write(
        IndigenasCompanion(aldeiaAtualId: Value(aldeiaDestinoId)),
      );

      await into(historicoLogradouros).insert(
        HistoricoLogradourosCompanion.insert(
          indigenaId: indigenaId,
          aldeiaOrigemId: aldeiaOrigemId,
          aldeiaDestinoId: aldeiaDestinoId,
          dataMudanca: DateTime.now(),
          motivo: Value(motivo),
        ),
      );
    });
  }

  // 4. Buscar casos especiais para a gestão centralizada
  Future<List<Indigena>> listarGestantes() {
    return (select(indigenas)..where((tbl) => tbl.gestante.equals(true))).get();
  }

  Future<List<Indigena>> listarInternados() {
    return (select(indigenas)..where((tbl) => tbl.internado.equals(true))).get();
  }

  Future<List<Indigena>> listarEmTransito() {
    return (select(indigenas)..where((tbl) => tbl.emTransito.equals(true))).get();
  }

  // 5. CONSULTAS PARA OS RELATÓRIOS MENSAIS

  // Busca atendimentos de um agente específico no mês/ano (Ficha Word Individual)
  Future<List<Atendimento>> listarAtendimentosPorAgenteEMes(String matricula, int mes, int ano) async {
    final todos = await select(atendimentos).get();
    return todos.where((a) => a.agenteMatricula == matricula && a.dataHora.month == mes && a.dataHora.year == ano).toList();
  }

  // Busca TODOS os atendimentos do mês/ano (Fechamento Geral da Unidade)
  Future<List<Atendimento>> listarAtendimentosGeraisPorMes(int mes, int ano) async {
    final todos = await select(atendimentos).get();
    return todos.where((a) => a.dataHora.month == mes && a.dataHora.year == ano).toList();
  }
}

QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'saude_indigena_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}