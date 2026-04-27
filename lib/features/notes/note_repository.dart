import 'package:flutter/foundation.dart';

import '../../data/local/app_database.dart';
import '../../data/remote/note_remote_service.dart';
import 'note_model.dart';

// Repositorio que coordina persistencia local (Drift) y remota (Firestore)
class NoteRepository {
  final AppDatabase localDb;
  final NoteRemoteService remoteService;

  NoteRepository({
    required this.localDb,
    required this.remoteService,
  });

  // Stream reactivo desde Drift
  Stream<List<NoteModel>> watchNotes() => localDb.watchNotes();

  // Guardar nueva nota en Drift y luego sincronizar con Firestore
  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    final note = NoteModel(
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    // 1. Persistir localmente y obtener el ID asignado
    final saved = await localDb.insertNote(note);

    // 2. Sincronizar con Firestore (no bloquea si falla)
    try {
      await remoteService.upsertNote(saved);
    } catch (e) {
      debugPrint('Error al sincronizar nueva nota con Firestore: $e');
    }
  }

  // Editar nota existente en Drift y sincronizar con Firestore
  Future<void> updateNote({
    required NoteModel note,
    required String title,
    required String content,
  }) async {
    final updated = note.copyWith(title: title, content: content);

    // 1. Actualizar localmente
    await localDb.updateNote(updated);

    // 2. Sincronizar con Firestore
    try {
      await remoteService.upsertNote(updated);
    } catch (e) {
      debugPrint('Error al actualizar nota en Firestore: $e');
    }
  }
}
