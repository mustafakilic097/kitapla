import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../model/message_model.dart';
import 'database.dart';

class MessageRepository extends ChangeNotifier {
  Map<String, List<MessageModel>> messageData = {
    // MessageModel(
    //   senderId: "mustafa",
    //   receiverId: "000001",
    //   messageText: "Merhaba okurlar nasılsınız. Ne yapıyorsunuz ?",
    //   messageTime: "22-03-2023 01:16",
    //   contentType: ContentType.text,
    //   isRead: true,
    //   messageType: MessageType.group,
    // ),
    // MessageModel(
    //   senderId: "peter",
    //   receiverId: "000001",
    //   messageText: "Şu anlık sadece okuma yapıyoruz.",
    //   messageTime: "22-03-2023 12:56",
    //   contentType: ContentType.text,
    //   isRead: true,
    //   messageType: MessageType.group,
    // ),
    // MessageModel(
    //   senderId: "peter",
    //   receiverId: "000001",
    //   messageText: "Sen napıyorsun ?",
    //   messageTime: "22-03-2023 12:58",
    //   contentType: ContentType.text,
    //   isRead: true,
    //   messageType: MessageType.group,
    // ),
  };

  Future<void> setSyncMessageData(Map<String, List<MessageModel>> onlineData, Box<MessageModel> messageBox) async {
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(MessageModelAdapter());
    }
    await messageBox.clear();
    // print(onlineData);
    for (var i = 0; i < onlineData.values.length; i++) {
      await messageBox.addAll(onlineData.values.toList()[i]);
    }
    getLocalMessages(messageBox);
  }

  Map<String, List<MessageModel>> getLocalMessages(Box<MessageModel> messageBox) {
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(MessageModelAdapter());
    }
    Map<String, List<MessageModel>> messages = {};
    for (var i = 0; i < messageBox.length; i++) {
      var messageName = messageBox.keyAt(i);
      var messageX = messageBox.getAt(i);
      if (messageX != null) {
        messages.update(
          messageName.toString().split("~")[0],
          (value) {
            value.add(messageX);
            return value;
          },
          ifAbsent: () {
            return [messageX];
          },
        );
      }
    }
    messageData.clear();
    messageData.addAll(messages);
    notifyListeners();
    return messageData;
  }

  Future<Map<String, List<MessageModel>>> getMessageData(String userId) async {
    //database'den tüm id'yle eşleşen mesajları getir.
    return Db().getMessages(userId).then((allMessageData) {
//sohbet balonu için {karşı tarafın id bilgisi : tüm mesajlaşmalar} olan bir map oluşturduk.
      Map<String, List<MessageModel>> messages = {};
      for (var i = 0; i < allMessageData.length; i++) {
        //Kişisel sohbetler için
        if (allMessageData[i].messageType == MessageType.person) {
          //Gönderen kişiye göre karşının id'sini bulma
          if (allMessageData[i].senderId == userId) {
            messages.update(
              allMessageData[i].receiverId,
              (value) {
                value.add(allMessageData[i]);
                return value;
              },
              ifAbsent: () {
                return [allMessageData[i]];
              },
            );
          }
          //Gönderen kişiye göre karşının id'sini bulma
          if (allMessageData[i].receiverId == userId) {
            messages.update(
              allMessageData[i].senderId,
              (value) {
                value.add(allMessageData[i]);
                return value;
              },
              ifAbsent: () {
                return [allMessageData[i]];
              },
            );
          }
        }
      }
      return messages;
    });
  }

  Stream<Map<String, List<MessageModel>>> getChatMessagesStream(String userId) async* {
  await for (var allMessageData in Db().getMessagesStream(userId)) {
    Map<String, List<MessageModel>> messages = {};

    for (var i = 0; i < allMessageData.length; i++) {
      // Kişisel sohbetler için
      if (allMessageData[i].messageType == MessageType.person) {
        // Gönderen kişiye göre karşının id'sini bulma
        if (allMessageData[i].senderId == userId) {
          messages.update(
            allMessageData[i].receiverId,
            (value) {
              value.add(allMessageData[i]);
              return value;
            },
            ifAbsent: () {
              return [allMessageData[i]];
            },
          );
        }
        // Gönderen kişiye göre karşının id'sini bulma
        if (allMessageData[i].receiverId == userId) {
          messages.update(
            allMessageData[i].senderId,
            (value) {
              value.add(allMessageData[i]);
              return value;
            },
            ifAbsent: () {
              return [allMessageData[i]];
            },
          );
        }
      }
    }

    // Elde edilen mesajları Stream'e ekleyin
    yield messages;
    print(messages);
    // Belirli bir süre bekleyin ve tekrar sorgulayın (örneğin 5 saniye)
    await Future.delayed(const Duration(seconds: 5));
  }
}

  

//fonksiyonlar hazır sadece ekran çağrılırken bunlar çağrılacak ve tüm sayfayla entegre olacak.
//Bir stream oluşturulacak.
  void sentMessage(MessageModel message) {
    // messageData.add(message);
    // notifyListeners();
  }
}

final messageRepositoryProvider = ChangeNotifierProvider((ref) => MessageRepository());
