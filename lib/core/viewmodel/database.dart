import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/comment_model.dart';
import '../model/group_model.dart';
import '../model/message_model.dart';
import '../model/sharing_model.dart';
import '../model/user_model.dart';

class Db {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserDetail(String userId) async {
    var a = _firebaseFirestore.collection("users").doc(userId).withConverter<UserModel?>(
      fromFirestore: (snapshot, options) {
        return UserModel.fromMap(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value!.toMap();
      },
    );
    var result = await a.get().then((value) => value.data());
    print("get user detail çalıştı");
    return result;
  }

  Future<List<UserModel>> getUsersDetail(List<String> userIds) async {
    List<UserModel> users = [];
    for (var userId in userIds) {
      await _firebaseFirestore
          .collection("users")
          .doc(userId)
          .get()
          .then((value) => value.data() != null ? users.add(UserModel.fromMap(value.data()!)) : null);
    }
    return users;
  }

  Future<List<GroupModel>> getGroupData(String userId) async {
    List<GroupModel> matchingGroups = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('groups').where('memberIds', arrayContains: userId).get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        // Firestore'dan alınan verileri GroupModel olarak dönüştürün
        GroupModel group = GroupModel.fromMap(data);

        matchingGroups.add(group);
      }
    } catch (e) {
      print('Veri çekme hatası: $e');
    }

    return matchingGroups;
  }

  Future<List<MessageModel>> getMessages(String userId) async {
    List<MessageModel> userMessages = [];

    // Firestore bağlantısı oluşturun
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // "messages" koleksiyonunu sorgulayın
    QuerySnapshot senderMessages = await firestore.collection('messages').where('senderId', isEqualTo: userId).get();

    QuerySnapshot receiverMessages =
        await firestore.collection('messages').where('receiverId', isEqualTo: userId).get();

    // Alınan mesajları dönüştürün ve listeye ekleyin
    for (var doc in senderMessages.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // MessageModel sınıfına dönüştürün
      var message = MessageModel.fromMap(data);

      // Listeye ekleyin
      userMessages.add(message);
    }

    for (var doc in receiverMessages.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // MessageModel sınıfına dönüştürün
      var message = MessageModel.fromMap(data);
      print(message.messageText);
      // Listeye ekleyin
      userMessages.add(message);
    }

    return userMessages;
  }

  Stream<List<MessageModel>> getMessagesStream(String userId) async* {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    while (true) {
      try {
        QuerySnapshot senderMessages =
            await firestore.collection('messages').where('senderId', isEqualTo: userId).get();

        QuerySnapshot receiverMessages =
            await firestore.collection('messages').where('receiverId', isEqualTo: userId).get();

        List<MessageModel> userMessages = [];

        for (var doc in senderMessages.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          var message = MessageModel.fromMap(data);
          userMessages.add(message);
        }

        for (var doc in receiverMessages.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          var message = MessageModel.fromMap(data);
          userMessages.add(message);
        }

        // Elde edilen mesajları Stream'e ekleyin
        yield userMessages;

        // Belirli bir süre bekleyin ve tekrar sorgulayın (örneğin 5 saniye)
        await Future.delayed(const Duration(seconds: 5));
      } catch (e) {
        print("Hata: $e");
        // Hata durumunda bekleyin ve tekrar deneyin
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  Stream<QuerySnapshot> getStreamChatData(String userId, String receiverId) {
    String id = [userId, receiverId].join("~");
    // print(id);
    return _firebaseFirestore
        .collection("chatRooms")
        .doc(id)
        .collection("messages")
        .orderBy("messageTime", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUsersFromChat(String userId) {
    return _firebaseFirestore.collection("usersChats").where("mergeIds", arrayContains: userId).snapshots();
  }

  Future<void> sentMessage(String userId, String receiverId, MessageModel newMessage) async {
    String id = [userId, receiverId].join("~");
    await _firebaseFirestore.collection("chatRooms").doc(id).collection("messages").add(newMessage.toMap());
  }

  Future<String> getUserPhoto(String userId) async {
    try {
      var data = await _firebaseFirestore.collection("users").doc(userId).get();
      return UserModel.fromMap(data.data()!).profileImageUrl!;
    } catch (e) {
      print("Hata oldu getUserPhoto $e");
      return "";
    }
  }

  Future<List<SharingModel>> getShares(String userId) async {
    return await _firebaseFirestore.collection("shares").get().then<List<SharingModel>>((data) async {
      return await Future.delayed(
        Duration.zero,
        () {
          return data.docs.map((e) => SharingModel.fromMap(e.data())).toList();
        },
      ).then((value) {
        return value;
      });
    });
  }

  Future<void> sentShare(SharingModel share) async {
    await _firebaseFirestore.collection("shares").add(share.toMap());
  }

  Future<void> sentComment(String shareId, CommentModel comment) async {
    var ref = _firebaseFirestore.collection("shares").doc(shareId);
    var doc = await ref.get();
    List<String> list = List<String>.from(doc.data()?["comments"] ?? []);
    list.add(jsonEncode(comment.toMap()));
    await ref.update({"comments": list});
  }

  Future<Map<String, SharingModel>> getSharesWithId(String userId) async {
    return await _firebaseFirestore.collection("shares").limit(5).get().then<Map<String, SharingModel>>((data) async {
      Map<String, SharingModel> mapData = {};
      return await Future.delayed(
        Duration.zero,
        () {
          for (var i = 0; i < data.docs.length; i++) {
            mapData[data.docs[i].id] = SharingModel.fromMap(data.docs[i].data());
          }
          return mapData;
        },
      ).then((value) {
        return value;
      });
    });
  }

  Future<SharingModel?> getShare(String shareId) async {
    return await _firebaseFirestore
        .collection("shares")
        .doc(shareId)
        .get()
        .then((value) => SharingModel.fromMap(value.data() ?? {}));
  }

  Future<void> sentLikeShare(String shareId, String userId) async {
    await _firebaseFirestore.collection('shares').doc(shareId).update({
      'likedUsers': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> removeLikeShare(String shareId, String userId) async {
    await _firebaseFirestore.collection('shares').doc(shareId).update({
      'likedUsers': FieldValue.arrayRemove([userId])
    });
  }
}
