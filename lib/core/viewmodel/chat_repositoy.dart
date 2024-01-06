import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/chat_model.dart';


class ChatRepository extends ChangeNotifier {
  List<ChatModel> chatsData = [];

  Future<void> setSyncChatData(List<ChatModel> onlineData, Box<ChatModel> chatBox) async {
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(ChatModelAdapter());
    }
    await chatBox.clear();
    // print(onlineData);
    await chatBox.addAll(onlineData);
    getLocalChats(chatBox);
  }

  List<ChatModel> getLocalChats(Box<ChatModel> chatBox) {
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(ChatModelAdapter());
    }
    List<ChatModel> chats = [];
    for (var i = 0; i < chatBox.length; i++) {
      ChatModel? chat = chatBox.getAt(i);
      if (chat != null) {
        chats.add(chat);
      }
    }
    chatsData.clear();
    chatsData.addAll(chats);
    notifyListeners();
    return chatsData;
  }

}

final chatRepositoryProvider = ChangeNotifierProvider((ref) => ChatRepository());