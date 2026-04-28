class NoteModel {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;

  const NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
