import 'package:flutter/material.dart';

import '../../features/auth/auth_service.dart';
import 'note_form_page.dart';
import 'note_model.dart';
import 'note_repository.dart';

class NotesPage extends StatelessWidget {
  final NoteRepository repository;
  final AuthService authService;

  const NotesPage({
    super.key,
    required this.repository,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fight Picks'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<List<NoteModel>>(
        stream: repository.watchNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data ?? [];

          if (notes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sports_mma, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Sin predicciones aún',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Toca + para agregar la primera',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: notes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final note = notes[index];
              return _NoteCard(
                note: note,
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NoteFormPage(
                      repository: repository,
                      note: note,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NoteFormPage(repository: repository),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onEdit;

  const _NoteCard({required this.note, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final d = note.createdAt;
    final dateStr =
        '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}  '
        '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const CircleAvatar(
          backgroundColor: Colors.deepOrange,
          child: Icon(Icons.sports_mma, color: Colors.white, size: 20),
        ),
        title: Text(
          note.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 6),
            Text(
              dateStr,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.deepOrange),
          onPressed: onEdit,
          tooltip: 'Editar',
        ),
      ),
    );
  }
}
