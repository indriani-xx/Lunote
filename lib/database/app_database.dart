import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DataClassName('NoteEntry')
//variabel dan antek" nya
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get judul => text()();
  TextColumn get content => text()();
  IntColumn get priority => integer()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'indri_notes.sqlite'));
    return NativeDatabase(file);
  });
}
