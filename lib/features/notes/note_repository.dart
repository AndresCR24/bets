import 'package:flutter/foundation.dart';

import '../../data/local/app_database.dart';
import '../../data/remote/note_remote_service.dart';
import 'note_model.dart';

class NoteRepository {
  final AppDatabase localDb;
  final NoteRemoteService remoteService;

  NoteRepository({
    required this.localDb,
    required this.remoteService,
  });

  Stream<List<NoteModel>> watchNotes() => localDb.watchNotes();

  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    final note = NoteModel(
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    final saved = await localDb.insertNote(note);

    try {
      await remoteService.upsertNote(saved);
    } catch (e) {
      debugPrint('Error al sincronizar nueva nota con Firestore: $e');
    }
  }

  Future<void> updateNote({
    required NoteModel note,
    required String title,
    required String content,
  }) async {
    final updated = note.copyWith(title: title, content: content);

    await localDb.updateNote(updated);

    try {
      await remoteService.upsertNote(updated);
    } catch (e) {
      debugPrint('Error al actualizar nota en Firestore: $e');
    }
  }
}
