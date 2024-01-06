import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  String noteId;
  @HiveField(2)
  final String head;
  @HiveField(3)
  final String content;
  @HiveField(4)
  List<int> gradientColors;
  @HiveField(5)
  List<String> tags;
  @HiveField(6)
  String time;
  // Note(this.userId,this.noteId,this.head,this.content,this.gradientColors,this.tags);
  Note(
      {required this.userId,
      required this.noteId,
      required this.head,
      required this.content,
      required this.gradientColors,
      required this.tags,
      required this.time,
      });
}

class NotesAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 0; // Tip kimliği (unique ID) olarak 0 kullanıyoruz

  @override
  Note read(BinaryReader reader) {
    return Note(
        userId: reader.readString(),
        noteId: reader.readString(),
        content: reader.readString(),
        head: reader.readString(),
        gradientColors: reader.readIntList(),
        tags: reader.readStringList(),
        time: reader.readString());
  }

  @override
  void write(BinaryWriter writer, Note obj) {
      writer.writeString(obj.userId);
      writer.writeString(obj.noteId);
      writer.writeString(obj.content);
      writer.writeString(obj.head);
      writer.writeIntList(obj.gradientColors);
      writer.writeStringList(obj.tags);
      writer.writeString(obj.time);

    // print(obj.length);
    // writer.writeByte(obj.length);
    // for (final note in obj) {
    //   writer.writeString(note.userId);
    //   writer.writeString(note.noteId);
    //   writer.writeString(note.content);
    //   writer.writeString(note.head);
    //   writer.writeIntList(note.gradientColors);
    //   writer.writeStringList(note.tags);
    // }
  }
}
