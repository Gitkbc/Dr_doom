class NoteModel {
  final String title;
  final String note;

  NoteModel({
    required this.title,
    required this.note,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      title: map['title'] ?? '',
      note: map['note'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'note': note,
    };
  }
}
