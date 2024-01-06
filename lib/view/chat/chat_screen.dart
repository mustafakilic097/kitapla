import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../core/model/chat_model.dart';
import '../../core/model/user_model.dart';
import '../../core/viewmodel/auth.dart';
import '../../core/viewmodel/chat_repositoy.dart';
import '../../core/viewmodel/database.dart';
import '../../main.dart';
import '../auth/widget_tree.dart';
import 'message_screen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  List<ChatModel> usersChats = [];
  String userId = "";
  late Box<ChatModel> chatBox;
  bool pageLoaded = true;
  List<UserModel?> chatUsers = [];
  final RefreshController _refreshController = RefreshController();

  Stream<QuerySnapshot<Object?>>? streamFunc;

  @override
  void initState() {
    super.initState();
    openHiveBox().then((_) {
      getCurrentUser();
      setState(() {
        pageLoaded = true;
        streamFunc = Db().getUsersFromChat(userId);
      });
      // getData(userId);
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamFunc = null;
  }

  @override
  Widget build(BuildContext context) {
    return !pageLoaded
        ? const ColoredBox(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : WillPopScope(
            onWillPop: () {
              if (!mounted) return Future.value(true);
              setState(() {
                streamFunc = null;
              });
              return Future.value(true);
            },
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 15),
                    sliver: SliverAppBar(
                      floating: true,
                      title: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Mesajlar",
                          style: GoogleFonts.quicksand(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      actions: [
                        PopupMenuButton(
                          offset: const Offset(0, 50),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: const Text("Yerel mesaj veritabanını sıfırla"),
                                onTap: () async {
                                  await Hive.deleteBoxFromDisk("messages").then((value) {
                                    print("silindi");
                                  });
                                  await Hive.deleteBoxFromDisk("usersChats").then((value) {
                                    print("silindi");
                                  });
                                },
                              ),
                              PopupMenuItem(
                                child: const Text("Yenile"),
                                onTap: () async {
                                  await Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MyApp(),
                                      )).then((value) => print("gitti"));
                                },
                              ),
                            ];
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: CircleAvatar(
                            radius: 26,
                            child: Icon(Icons.person_rounded, color: Colors.white),
                            // FutureBuilder(
                            //   future: Db().getUserDetail(userId),
                            //   builder: (context, snapshot) {
                            //     if (!snapshot.hasData) {
                            //       return const Icon(Icons.person_rounded, color: Colors.white);
                            //     }
                            //     UserModel? user = snapshot.data;
                            //     if (user == null) {
                            //       return const Icon(Icons.person_rounded, color: Colors.white);
                            //     }
                            //     return Image.network(
                            //       user.profileImageUrl != null ? user.profileImageUrl! : "",
                            //       errorBuilder: (context, error, stackTrace) {
                            //         return const Icon(Icons.person_rounded, color: Colors.white);
                            //       },
                            //       loadingBuilder: (context, child, loadingProgress) {
                            //         if (loadingProgress == null) return child;
                            //         return const Center(
                            //           child: LinearProgressIndicator(),
                            //         );
                            //       },
                            //     );
                            //   },
                            // ),
                          ),
                        ),
                      ],
                    ),
                  )
                ];
              },
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius:
                              const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                        ),
                        child: StreamBuilder(
                          stream: streamFunc,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.none) {
                              return Center(
                                child: Column(
                                  children: [
                                    const Text("İnternet bağlantısı yok..."),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            streamFunc = null;
                                            streamFunc = Db().getUsersFromChat(userId).distinct();
                                          });
                                        },
                                        child: const Text("Yenile"))
                                  ],
                                ),
                              );
                            }
                            if (!snapshot.hasData) {
                              return Column(children: [
                                LinearProgressIndicator(
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                                const Center(
                                  child: Text("Yükleniyor..."),
                                ),
                              ]);
                            }
                            List<ChatModel> chatData = snapshot.data!.docs
                                .map<ChatModel>((e) => ChatModel.fromMap(e.data() as Map<String, dynamic>))
                                .toList();
                            // List<ChatModel> chatData = usersChats;
                            setSync(userId, chatData);
                            // print(chatData);
                            //Chat ekranının yerel veritabanıyla senkronizasyonu test edilecek. Daha sonra mesajlar
                            // ekranı aynı şekilde düzenlenecek.
                            return SmartRefresher(
                              header: const WaterDropMaterialHeader(),
                              onRefresh: () async {
                                Future.delayed(
                                  const Duration(seconds: 0),
                                  () {
                                    setState(() {
                                      streamFunc = null;
                                      streamFunc = Db().getUsersFromChat(userId).distinct();
                                    });
                                  },
                                ).then((_) {
                                  _refreshController.refreshCompleted();
                                });
                              },
                              controller: _refreshController,
                              child: ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: chatData.length,
                                itemBuilder: (context, i) {
                                  String name = chatData[i].senderId == userId
                                      ? chatData[i].receiverName
                                      : chatData[i].senderName;
                                  String id =
                                      chatData[i].senderId == userId ? chatData[i].receiverId : chatData[i].senderId;
                                  return Builder(
                                    builder: (context) {
                                      if (getChatUser(id) != null) {
                                        return ChatContainer(
                                          id: id,
                                          name: name,
                                          chatData: chatData,
                                          index: i,
                                          chatUserDetail: getChatUser(id),
                                        );
                                      } else {
                                        Db().getUserDetail(id).then((value) {
                                          if (value == null) return;
                                          setState(() {
                                            chatUsers.add(value);
                                          });
                                        });
                                        return ChatContainer(
                                          id: id,
                                          name: name,
                                          chatData: chatData,
                                          index: i,
                                        );
                                      }
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) => Container(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: const Divider(
                                    height: 8.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void getCurrentUser() {
    try {
      setState(() {
        userId = Auth().currentUser!.uid;
      });
    } on FirebaseAuthException {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WidgetTree(),
          ));
      return;
    }
  }

  Future<void> openHiveBox() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(ChatModelAdapter());
    }
    await Hive.openBox<ChatModel>("usersChats").then((value) {
      setState(() => chatBox = value);
    });
  }

  UserModel? getChatUser(String id) {
    UserModel? user;
    for (var val in chatUsers) {
      if (val == null) continue;
      if (val.userId == id) {
        user = val;
      }
    }
    return user;
  }

  Future<void> setSync(String userId, List<ChatModel> onlineChatData) async {
    if (!mounted) return;
    try {
      await ref.read(chatRepositoryProvider).setSyncChatData(onlineChatData, chatBox);
      if (!mounted) return;
      setState(() {
        usersChats.clear();
        usersChats.addAll(onlineChatData);
      });
    } catch (e) {
      print("Bağlantıda hata oldu HATA--->>>> $e");
      List<ChatModel> localData = ref.read(chatRepositoryProvider).getLocalChats(chatBox);
      setState(() {
        usersChats.clear();
        usersChats.addAll(localData);
      });
    }
  }
}

class ChatContainer extends StatelessWidget {
  const ChatContainer(
      {super.key,
      required this.id,
      required this.name,
      required this.chatData,
      required this.index,
      this.chatUserDetail});

  final String id;
  final String name;
  final List<ChatModel> chatData;
  final int index;
  final UserModel? chatUserDetail;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: ZoomTapAnimation(
        child: ListTile(
          leading: CircleAvatar(
            foregroundColor: Theme.of(context).primaryColor,
            backgroundColor: Colors.blueGrey,
            radius: 26.0,
            child: Hero(
              tag: name,
              child: chatUserDetail != null
                  ? Image.network(
                      chatUserDetail!.profileImageUrl != null ? chatUserDetail!.profileImageUrl! : "",
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person_rounded, color: Colors.white);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: LinearProgressIndicator(),
                        );
                      },
                    )
                  : const Icon(Icons.person_rounded, color: Colors.white),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 25,
                child: Text(
                  name,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w600, fontSize: 17.0),
                ),
              ),
              Text(
                // Son mesajın saati
                "${chatData[index].lastMessageTime.hour}:${chatData[index].lastMessageTime.minute}",
                style: TextStyle(color: Colors.grey[600], fontSize: 13.0),
              ),
            ],
          ),
          splashColor: Colors.green.shade400,
          subtitle: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              chatData.toList()[index].lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.quicksand(color: Colors.grey[600], fontSize: 13.0, fontStyle: FontStyle.italic),
            ),
          ),
          onTap: () {
            if (chatUserDetail != null) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return MessageScreen(
                      chatUserId: id,
                      chatUserModel: chatData[index],
                      chatUserDetail: chatUserDetail,
                    );
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: animation.drive(Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
                          .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut))),
                      child: child,
                    );
                  },
                ),
              );
            } else {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return MessageScreen(
                      chatUserId: id,
                      chatUserModel: chatData[index],
                    );
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: animation.drive(Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
                          .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut))),
                      child: child,
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
