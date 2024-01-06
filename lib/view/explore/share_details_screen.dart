// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitapla/view/auth/widget_tree.dart';
import '../../core/components/card/share_card.dart';
import '../../core/model/comment_model.dart';
import '../../core/model/sharing_model.dart';
import '../../core/model/user_model.dart';
import '../../core/viewmodel/auth.dart';
import '../../core/viewmodel/database.dart';
import '../../core/viewmodel/utils.dart';

class ShareDetailScreen extends StatefulWidget {
  const ShareDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ShareDetailScreen> createState() => _ShareDetailScreenState();
}

class _ShareDetailScreenState extends State<ShareDetailScreen> {
  late dynamic arguments = Get.arguments;
  SharingModel get shareData => arguments[0];
  String get shareId => arguments[1];
  set shareData(SharingModel changedData){
    shareData = changedData;
  }
  String userId = "";
  bool pageLoaded = false;
  UserModel? user;
  // late SharingModel shareData = shareData;
  TextEditingController commentText = TextEditingController();

  @override
  void initState() {
    super.initState();
    try {
      setState(() {
        userId = Auth().currentUser!.uid;
      });
    } catch (e) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WidgetTree(),
          ));
    }
    Db().getUserDetail(userId).then((val) {
      setState(() {
        user = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Gönderi", style: GoogleFonts.quicksand(fontWeight: FontWeight.w600)),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                return await Db().getShare(shareId).then((value) {
                  if (value == null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Paylaşım yüklenirken hata oluştu..")));
                    return;
                  }
                  setState(() {
                    shareData = value;
                  });
                });
              },
              child: ListView(
                children: [
                  buildShareCard(
                      context: context,
                      shareData: shareData,
                      isInDetail: true,
                      shareId: shareId,
                      userId: userId),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: shareData.comments.length,
                    itemBuilder: (context, i) {
                      return buildCommentCard(shareData.comments[i]);
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
              color: Color.fromRGBO(189, 189, 189, 1),
            ))),
            child: TextField(
              controller: commentText,
              decoration: InputDecoration(
                hintText: "Yorum yap",
                border: InputBorder.none,
                suffixIcon: IconButton(
                  style: const ButtonStyle(
                    iconColor: MaterialStatePropertyAll(Colors.blue),
                  ),
                  onPressed: () async {
                    if (commentText.text.isNotEmpty) {
                      if (user == null) {
                        Db().getUserDetail(userId).then((value) async {
                          if (value == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(content: Text("Hata ile karşılaşıldı")));
                            return;
                          }
                          CommentModel comment = CommentModel(
                              userId: userId,
                              name: "${value.name} ${value.surname}",
                              commentText: commentText.text,
                              commentLikes: [],
                              commentDate: DateTime.now());
                          if (!FocusScope.of(context).hasPrimaryFocus) {
                            FocusScope.of(context).unfocus();
                          }
                          commentText.clear();
                          setState(() {
                            shareData.comments.insert(0, comment);
                          });
                          await Db().sentComment(shareId, comment).then((value) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(content: Text("Yorum gönderildi...")));
                          });
                          return;
                        });
                      }
                      CommentModel comment = CommentModel(
                          userId: userId,
                          name: "${user!.name} ${user!.surname}",
                          commentText: commentText.text,
                          commentLikes: [],
                          commentDate: DateTime.now());
                      if (!FocusScope.of(context).hasPrimaryFocus) {
                        FocusScope.of(context).unfocus();
                      }
                      commentText.clear();
                      setState(() {
                        shareData.comments.insert(0, comment);
                      });
                      await Db().sentComment(shareId, comment).then((value) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text("Yorum gönderildi...")));
                      });
                      return;
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCommentCard(CommentModel comment) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: const AssetImage("assets/user.png"),
                      child: FutureBuilder(
                        future: Db().getUserDetail(comment.userId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox.shrink();
                          }
                          UserModel? user = snapshot.data;
                          if (user == null) {
                            return const SizedBox.shrink();
                          }
                          return Image.network(
                            user.profileImageUrl != null ? user.profileImageUrl! : "",
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person_rounded, color: Colors.white);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: LinearProgressIndicator(),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        comment.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "•",
                      style: TextStyle(fontSize: 25, color: Color.fromRGBO(112, 112, 112, 0.902)),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        getRelativeTime(comment.commentDate),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(fontWeight: FontWeight.w500, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.more_vert_outlined,
                      )))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              comment.commentText,
              style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.heart)),
              IconButton(
                  onPressed: () {
                    commentText.clear();
                    commentText.text = "@${comment.name}: ";
                  },
                  icon: Transform.scale(
                      scaleX: -1, alignment: Alignment.center, child: const Icon(CupertinoIcons.reply))),
            ],
          ),
        ],
      ),
    );
  }
}

void showLikedUsersDialog({context, required List<String> users, required Size size}) {
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          titlePadding: const EdgeInsets.all(4),
          backgroundColor: Colors.white,
          title: DecoratedBox(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade500))),
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
                Text(
                  "Beğenen kullanıcılar",
                  style: GoogleFonts.quicksand(),
                ),
              ],
            ),
          ),
          children: [
            SizedBox(
              height: size.height / 2,
              width: size.width - 50,
              child: FutureBuilder<List<UserModel>>(
                future: Db().getUsersDetail(users),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<UserModel> users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.isNotEmpty ? users.length : 1,
                    itemBuilder: (context, i) {
                      if (users.isEmpty) {
                        return const Center(
                          child: Text("Kullanıcı bilgileri getirilemedi ya da beğenen hiç kimse yok :|"),
                        );
                      }
                      return ListTile(
                        onTap: () {},
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundImage: const AssetImage("assets/user.png"),
                          child: Image.network(
                            users[i].profileImageUrl != null ? users[i].profileImageUrl! : "",
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person_rounded, color: Colors.white);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: LinearProgressIndicator(),
                              );
                            },
                          ),
                        ),
                        title: Text("${users[i].name} ${users[i].surname}"),
                        trailing: const Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.red,
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        );
      });
}
