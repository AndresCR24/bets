import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/notes/note_model.dart';

class NoteRemoteService {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('andres y lasso');

  Future<void> upsertNote(NoteModel note) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (note.id == null) return;

    await _collection.doc(note.id.toString()).set({
      'title': note.title,
      'content': note.content,
      'createdAt': Timestamp.fromDate(note.createdAt),
      'userId': userId,
    });
  }
}
