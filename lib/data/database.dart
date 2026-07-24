import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

class QAPairs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get query => text()();
  TextColumn get answer => text()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get isLocalMode => boolean().withDefault(const Constant(true))();
}

@DriftDatabase(tables: [QAPairs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<QAPair>> watchAllHistory() {
    return (select(qAPairs)
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<int> deleteHistory(int id) {
    return (delete(qAPairs)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'chat_history.sqlite'));

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
