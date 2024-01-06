import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:hive/hive.dart';

@HiveType(typeId: 5)
class ChatModel {
  @HiveField(0)
  final String senderId;
  @HiveField(1)
  final String receiverId;
  @HiveField(2)
  final String lastMessage;
  @HiveField(3)
  final DateTime lastMessageTime; // DateTime olarak tanımladık
  @HiveField(4)
  final bool lastMessageIsRead;
  @HiveField(5)
  final String senderName;
  @HiveField(6)
  final String receiverName;
  ChatModel({
    required this.senderId,
    required this.receiverId,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageIsRead,
    required this.senderName,
    required this.receiverName,
  });

// Firestore'dan gelen veriyi ChatModel'e dönüştüren fonksiyon
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
        senderId: map['senderId'],
        receiverId: map['receiverId'],
        lastMessage: map['lastMessage'],
        lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
        lastMessageIsRead: map['lastMessageIsRead'],
        senderName: map["senderName"],
        receiverName: map["receiverName"]);
  }

// ChatModel'i Firestore'a göndermek için veriyi dönüştüren fonksiyon
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'lastMessageIsRead': lastMessageIsRead,
      "senderName": senderName,
      "receiverName": receiverName
    };
  }
}

class ChatModelAdapter extends TypeAdapter<ChatModel> {
  @override
  final typeId = 5; // Yukarıdaki HiveType(typeId: 5) ile eşleşmelidir

  @override
  ChatModel read(BinaryReader reader) {
    return ChatModel(
      senderId: reader.readString(),
      receiverId: reader.readString(),
      lastMessage: reader.readString(),
      lastMessageTime: DateTime.fromMillisecondsSinceEpoch(reader.read()),
      lastMessageIsRead: reader.readBool(),
      senderName: reader.readString(),
      receiverName: reader.readString()
    );
  }

  @override
  void write(BinaryWriter writer, ChatModel obj) {
    writer.writeString(obj.senderId);
    writer.writeString(obj.receiverId);
    writer.writeString(obj.lastMessage);
    writer.write(obj.lastMessageTime.millisecondsSinceEpoch);
    writer.writeBool(obj.lastMessageIsRead);
    writer.writeString(obj.senderName);
    writer.writeString(obj.receiverName);
  }
}
