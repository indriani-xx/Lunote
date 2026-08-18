import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DataClassName('NoteEntry')
//variabel dan antek" nya
// TABEL UNTUK NOTES
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  IntColumn get priority => integer()();
  DateTimeColumn get createdAt => dateTime()();
}

//TABEL UNTUK TODOLIST
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Notes, Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from == 1) {
        await m.addColumn(todos, todos.createdAt);
      }
    },
  );

  // FUNGSI CRUD NOTES--------------------------------------------
  // 1. READ
  Stream<List<NoteEntry>> watchAllNotes() {
    return select(notes).watch();
  }

  Future<int> insertNote(NotesCompanion note) {
    return into(notes).insert(note);
  }

  //UPDATE
  Future<bool> updateNote(NoteEntry note) {
    return update(notes).replace(note);
  }

  //DELETE
  Future<int> deleteNote(int id) {
    return (delete(notes)..where((tbl) => tbl.id.equals(id))).go();
  }

  //FUNGSI CRUD TODOS------------------------------------------------
  // 1. READ
  Stream<List<Todo>> watchAllTodos() {
    return select(todos).watch();
  }

  // 2. CREAD
  Future<int> insertTodo(TodosCompanion todo) {
    return into(todos).insert(todo);
  }

  // 3. EDIT
  Future<bool> updateTodo(Todo todo) {
    return update(todos).replace(todo);
  }

  // 4. DELETE
  Future<int> deleteTodo(int id) {
    return (delete(todos)..where((tbl) => tbl.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(
      p.join(dbFolder.path, 'indri_notes.sqlite'),
    ); // p itu artinya path, join itu untuk menggabungkan path
    return NativeDatabase(file);
  });
}
