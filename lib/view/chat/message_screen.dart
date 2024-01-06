// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../core/model/chat_model.dart';
import '../../core/model/message_model.dart';
import '../../core/model/user_model.dart';
import '../../core/viewmodel/auth.dart';
import '../../core/viewmodel/database.dart';
import '../../core/viewmodel/message_repository.dart';
import '../../core/viewmodel/utils.dart';
import '../auth/widget_tree.dart';

enum MoreMenu { viewContact, media, search, mute, wallpaper, more }

class MessageScreen extends ConsumerStatefulWidget {
  final String chatUserId;
  final ChatModel chatUserModel;
  final UserModel? chatUserDetail;
  const MessageScreen({
    super.key,
    required this.chatUserId,
    required this.chatUserModel,
    this.chatUserDetail,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MessageScreenState();
  }
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  String userId = "";
  String counterId = "";
  bool pageLoaded = false;
  TextEditingController controller = TextEditingController();
  late Box<MessageModel> messageBox;

  Future<Box<MessageModel>> openHiveBox() async {
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(MessageModelAdapter());
    }
    return await Hive.openBox<MessageModel>("messages");
  }

  @override
  void initState() {
    super.initState();
    openHiveBox().then((box) {
      try {
        setState(() {
          messageBox = box;
          userId = Auth().currentUser!.uid;
          counterId = widget.chatUserModel.receiverId == userId
              ? widget.chatUserModel.senderId
              : widget.chatUserModel.receiverId;
          pageLoaded = true;
        });
      } catch (e) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const WidgetTree(),
            ));
        pageLoaded = true;
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var messageRepository = ref.watch(messageRepositoryProvider);
    var size = MediaQuery.sizeOf(context);
    return buildMessageScreen(messageRepository: messageRepository, size: size);
  }

  Widget buildMessageScreen({required MessageRepository messageRepository, required Size size}) {
    String name =
        widget.chatUserModel.receiverId == userId ? widget.chatUserModel.senderName : widget.chatUserModel.receiverName;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        titleSpacing: 0.0,
        title: InkWell(
          onTap: () async {
            // await Navigator.push(context, MaterialPageRoute(builder: (context) => GroupDetails(groupData: widget.groupData)));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.grey,
                radius: 18.0,
                child: Hero(
                  tag: name,
                  child: widget.chatUserDetail != null
                      ? Image.network(
                          widget.chatUserDetail!.profileImageUrl != null ? widget.chatUserDetail!.profileImageUrl! : "",
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
              Column(
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    height: 25,
                    child: Text(
                      name,
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, left: 8),
                    child: Text(
                      widget.chatUserDetail != null ? widget.chatUserDetail!.status.name : "",
                      style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.call,
              color: Colors.white,
            ),
            tooltip: "Voice call",
            onPressed: () {},
          ),
          PopupMenuButton<MoreMenu>(
            padding: const EdgeInsets.all(0.0),
            tooltip: "More options",
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MoreMenu>>[
              const PopupMenuItem<MoreMenu>(
                value: MoreMenu.more,
                child: ListTile(
                  title: Text("More"),
                  contentPadding: EdgeInsets.all(0.0),
                  trailing: Icon(Icons.arrow_right),
                ),
              ),
            ],
          ),
        ],
      ),
      body: !pageLoaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: BoxDecoration(
                  // color: Colors.black87 //GECE EKRANI
                  color: Theme.of(context).secondaryHeaderColor),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                        stream: Db().getStreamChatData(widget.chatUserModel.senderId, widget.chatUserModel.receiverId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<MessageModel> messages = snapshot.data!.docs
                              .map((e) => MessageModel.fromMap(e.data() as Map<String, dynamic>))
                              .toList()
                              .reversed
                              .toList();
                          ref.read(messageRepositoryProvider).setSyncMessageData(
                              {"${widget.chatUserModel.senderId}~${widget.chatUserModel.receiverId}": messages},
                              messageBox);
                          return ListView.builder(
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              if (message.senderId == userId) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    right: 8.0,
                                    top: 8.0,
                                    left: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                                          ),
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                            color: Theme.of(context).primaryColor,
                                            // color: Color.fromRGBO(249, 123, 34,1),
                                            // color: Color.fromRGBO(20, 108, 148,1),
                                            // color: Colors.grey.shade700,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3),
                                                  child: SelectableText(message.messageText,
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(fontSize: 16, color: Colors.white)),
                                                ),
                                              ),
                                              Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Padding(
                                                      padding: const EdgeInsets.only(left: 5),
                                                      child: Text(
                                                          DateFormat("HH:mm")
                                                              .format(stringToDateTime(message.messageTime)),
                                                          style:
                                                              const TextStyle(color: Colors.white70, fontSize: 13)))),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    left: 8.0,
                                    right: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                                          ),
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              // Align(
                                              //     alignment: Alignment.centerLeft,
                                              //     child: Text(
                                              //       message.,
                                              //       textAlign: TextAlign.end,
                                              //       style: const TextStyle(
                                              //           color: Colors.black, fontWeight: FontWeight.bold),
                                              //     )),
                                              const Divider(height: 5, thickness: 1),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(3.0),
                                                        child: Text(
                                                          message.messageText,
                                                          textAlign: TextAlign.left,
                                                          style: const TextStyle(color: Colors.black, fontSize: 16),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                        DateFormat("HH:mm")
                                                            .format(stringToDateTime(message.messageTime)),
                                                        style: TextStyle(color: Colors.grey.shade500),
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  disabledColor: Colors.grey,
                                  color: Colors.grey,
                                  icon: const Icon(Icons.insert_emoticon),
                                  onPressed: () {},
                                ),
                                Flexible(
                                  child: Container(
                                    constraints: const BoxConstraints(maxHeight: 100.0),
                                    child: TextField(
                                      controller: controller,
                                      style: const TextStyle(
                                          color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18.0),
                                      textCapitalization: TextCapitalization.sentences,
                                      textInputAction: null,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.all(0.0),
                                        hintText: "Type a message",
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 18.0,
                                        ),
                                        counterText: "",
                                      ),
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      maxLength: 1000,
                                      cursorColor: Theme.of(context).primaryColor,
                                      cursorWidth: 1.8,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  disabledColor: Colors.grey,
                                  color: Colors.grey,
                                  icon: const Icon(Icons.attach_file),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50.0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: FloatingActionButton(
                              elevation: 2.0,
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              child: const Icon(Icons.send),
                              onPressed: () async {
                                MessageModel newMessage = MessageModel(
                                    senderId: userId,
                                    receiverId: counterId,
                                    messageText: controller.text,
                                    messageTime: Timestamp.now().toString(),
                                    messageType: MessageType.person,
                                    contentType: ContentType.text,
                                    isRead: false);
                                await Db().sentMessage(
                                    widget.chatUserModel.senderId, widget.chatUserModel.receiverId, newMessage);
                                controller.text = "";
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
