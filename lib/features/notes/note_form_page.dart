import 'package:flutter/material.dart';

import 'note_model.dart';
import 'note_repository.dart';

class NoteFormPage extends StatefulWidget {
  final NoteRepository repository;
  final NoteModel? note;

  const NoteFormPage({
    super.key,
    required this.repository,
    this.note,
  });

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  bool _loading = false;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      if (_isEditing) {
        await widget.repository.updateNote(
          note: widget.note!,
          title: _titleCtrl.text.trim(),
          content: _contentCtrl.text.trim(),
        );
      } else {
        await widget.repository.addNote(
          title: _titleCtrl.text.trim(),
          content: _contentCtrl.text.trim(),
        );
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar predicción' : 'Nueva predicción'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Título de la pelea',
                  hintText: 'Ej: Canelo vs Berlanga',
                  prefixIcon: Icon(Icons.emoji_events_outlined),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'El título es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _contentCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tu predicción',
                  hintText:
                      'Ej: Canelo gana por KO en el 7mo round. Su uppercut derecho...',
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Escribe tu predicción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              ElevatedButton.icon(
                onPressed: _loading ? null : _save,
                icon: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isEditing ? 'Actualizar' : 'Guardar predicción'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
