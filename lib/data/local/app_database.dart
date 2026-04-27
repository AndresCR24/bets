import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/notes/note_model.dart';

part 'app_database.g.dart';

// Tabla de notas de predicción
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'bets_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }

  // Convierte una fila de la tabla al modelo de la app
  NoteModel _toModel(Note row) {
    return NoteModel(
      id: row.id,
      title: row.title,
      content: row.content,
      createdAt: row.createdAt,
    );
  }

  // Stream reactivo con todas las notas ordenadas por fecha descendente
  Stream<List<NoteModel>> watchNotes() {
    final query = select(notes)
      ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]);
    return query.watch().map((rows) => rows.map(_toModel).toList());
  }

  // Insertar una nota y devolver el modelo con el ID asignado
  Future<NoteModel> insertNote(NoteModel note) async {
    final id = await into(notes).insert(
      NotesCompanion.insert(
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
      ),
    );
    return note.copyWith(id: id);
  }

  // Actualizar una nota existente
  Future<void> updateNote(NoteModel note) async {
    if (note.id == null) return;
    await (update(notes)..where((n) => n.id.equals(note.id!))).write(
      NotesCompanion(
        title: Value(note.title),
        content: Value(note.content),
        createdAt: Value(note.createdAt),
      ),
    );
  }
}
