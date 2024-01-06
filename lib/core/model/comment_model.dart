// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

class CommentModel {
  final String userId;
  final String shareId;
  final String name; // daha sonraki aşamada burada name parametresi kaldırılacak id'den getirilecek
  String commentText;
  List<String> commentLikes;
  final DateTime commentDate; // Yorumun tarihi

  CommentModel({
    required this.userId,
    required this.shareId,
    required this.name,
    required this.commentText,
    required this.commentLikes,
    required this.commentDate,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "shareId": shareId,
      'name': name,
      'commentText': commentText,
      'commentLikes': commentLikes,
      'commentDate': commentDate.toIso8601String(), // DateTime'i String'e dönüştürme
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      userId: map["userId"],
      shareId:map["shareId"],
      name: map['name'],
      commentText: map['commentText'],
      commentLikes: List<String>.from(map['commentLikes'] ?? []),
      commentDate: DateTime.parse(map['commentDate']), // String'i DateTime'e dönüştürme
    );
  }
}

class CommentTypeAdapter extends TypeAdapter<CommentModel> {
  @override
  CommentModel read(BinaryReader reader) {
    return CommentModel(
        userId: reader.readString(),
        shareId: reader.readString(),
        name: reader.readString(),
        commentText: reader.readString(),
        commentLikes: reader.readStringList(),
        commentDate: reader.read());
  }

  @override
  int get typeId => 7;

  @override
  void write(BinaryWriter writer, CommentModel obj) {
    writer.writeString(obj.userId);
    writer.writeString(obj.name);
    writer.writeString(obj.commentText);
    writer.writeStringList(obj.commentLikes);
    writer.write(obj.commentDate);
  }
}
