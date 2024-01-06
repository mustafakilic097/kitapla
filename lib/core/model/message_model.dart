import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';


enum MessageType { group, person }

enum ContentType { text, image, voice }

@HiveType(typeId: 4)
class MessageModel {
  // İletişim bilgileri
  @HiveField(0)
  final String senderId;
  @HiveField(1)
  final String receiverId;
  //
  // Mesaj Bilgileri
  @HiveField(2)
  final String messageText;
  @HiveField(3)
  final MessageType messageType;
  @HiveField(4)
  final ContentType contentType;
  @HiveField(5)
  final String messageTime;
  @HiveField(6)
  final bool isRead;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    required this.messageType,
    required this.contentType,
    required this.messageTime,
    required this.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      messageText: json['messageText'],
      messageType: _convertStringToMessageType(json['messageType']),
      contentType: _convertStringToContentType(json['contentType']),
      messageTime: json['messageTime'],
      isRead: json['isRead'],
    );
  }

  // Firestore verilerini MessageModel nesnesine dönüştürme fonksiyonu
  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      messageText: data['messageText'],
      messageType: _convertStringToMessageType(data['messageType']),
      contentType: _convertStringToContentType(data['contentType']),
      messageTime: toDateTime(data['messageTime']).toIso8601String(),
      isRead: data['isRead'],
    );
  }

  // MessageModel nesnesini Firestore verilerine dönüştürme fonksiyonu
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageText': messageText,
      'messageType': messageType.toString(), // Enum değerini dizeye dönüştürün
      'contentType': contentType.toString(), // Enum değerini dizeye dönüştürün
      'messageTime': Timestamp.now(),
      'isRead': isRead,
    };
  }

  // String'i MessageType enumuna dönüştürme fonksiyonu
  static MessageType _convertStringToMessageType(String messageTypeString) {
    return messageTypeString == 'MessageType.group' ? MessageType.group : MessageType.person;
  }

  // String'i ContentType enumuna dönüştürme fonksiyonu
  static ContentType _convertStringToContentType(String contentTypeString) {
    return contentTypeString == 'ContentType.text'
        ? ContentType.text
        : contentTypeString == 'ContentType.image'
            ? ContentType.image
            : ContentType.voice;
  }
}

DateTime toDateTime(Timestamp val) => val.toDate();

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  int get typeId => 4; // MessageModel için ID

  @override
  MessageModel read(BinaryReader reader) {
    // Verileri okuma işlemi
    final senderId = reader.readString();
    final receiverId = reader.readString();
    final messageText = reader.readString();
    final messageType = reader.readString();
    final contentType = reader.readString();
    final messageTime = reader.readString();
    final isRead = reader.readBool();

    return MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      messageText: messageText,
      messageType: messageType == "MessageType.group" ? MessageType.group : MessageType.person,
      contentType: contentType == "ContentType.image"
          ? ContentType.image
          : contentType == "ContentType.voice"
              ? ContentType.voice
              : ContentType.text,
      messageTime: messageTime,
      isRead: isRead,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    // Verileri yazma işlemi
    writer.writeString(obj.senderId);
    writer.writeString(obj.receiverId);
    writer.writeString(obj.messageText);
    writer.writeString(obj.messageType.toString());
    writer.writeString(obj.contentType.toString());
    writer.writeString(obj.messageTime);
    writer.writeBool(obj.isRead);
  }
}

