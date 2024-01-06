import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitapla/view/auth/widget_tree.dart';
import '../../core/model/book_model.dart';
import '../../core/model/sharing_model.dart';
import '../../core/model/user_model.dart';
import '../../core/viewmodel/auth.dart';
import '../../core/viewmodel/database.dart';
import '../dashboard/booksearch/book_finder_screen.dart';

class ShareScreen extends ConsumerStatefulWidget {
  const ShareScreen({super.key});

  @override
  ConsumerState<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends ConsumerState<ShareScreen> {
  String userId = "";
  bool pageLoaded = false;
  TextEditingController shareText = TextEditingController();
  UserModel? user;
  ShareAccessType shareType = ShareAccessType.public;
  BookModel? selectedBook;
  bool isLoading = false;
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
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
          title: Text(
            "Paylaşım yap",
            style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                onPressed: () async {
                  if (user == null) {
                    Db().getUserDetail(userId).then((value) {
                      if (value == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text("Kullanıcı yüklenirken bir hata meydana geldi"),
                            );
                          },
                        );
                        return;
                      }
                      setState(() {
                        user = value;
                      });
                    });
                  }
                  if (shareText.text.length < 10) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text("Paylaşılan metin en az 10 karakter olmalıdır!!"),
                        );
                      },
                    );
                    return;
                  }
                  if (userId.length < 2) {
                    print("userId hatası");
                    return;
                  }
                  final SharingModel share = SharingModel(
                    userId: userId,
                    sharingName: "${user!.name} ${user!.surname}",
                    shareTime: DateTime.now(),
                    shareAccessType: shareType,
                    likedUsers: [],
                    resharedUsers: [],
                    resenderUsers: [],
                    shareText: shareText.text,
                    comments: [],
                    shareBookName: selectedBook?.title ?? "",
                    shareAuthorName: ""
                  );
                  setState(() {
                    isLoading = true;
                  });
                  await Db().sentShare(share).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Paylaşım Yapıldı.")));
                    Navigator.pop(context);
                  }).catchError((e) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.orange),
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
                child: const Text("Paylaş"),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  radius: 22,
                  backgroundImage: const AssetImage("assets/user.png"),
                  child: FutureBuilder(
                    future: Db().getUserDetail(userId),
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
                  width: 20,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    showShareTypeSelect().then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: shareType.name == "public" ? Colors.blue : Colors.purple),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Text(
                          shareType.name == "public" ? "Herkese Açık" : "Gizli",
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: shareType.name == "public" ? Colors.blue : Colors.purple),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: shareType.name == "public" ? Colors.blue : Colors.purple,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 100,
              child: Container(
                decoration: const BoxDecoration(),
                padding: const EdgeInsets.only(left: 24, top: 16),
                child: TextField(
                  // minLines: 1,
                  controller: shareText,
                  maxLines: null,
                  maxLength: 1000,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  expands: true,
                  autofocus: true,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w600, fontSize: 17),
                  decoration: InputDecoration(
                      hintText: "Yazmaya başla...", hintStyle: GoogleFonts.quicksand(), border: InputBorder.none),
                ),
              ),
            ),
            Expanded(
              flex: 15,
              child: Container(
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          await buildBookSearch(context).then((value) {
                            setState(() {
                              selectedBook = value;
                            });
                          });
                        },
                        child: Container(
                          decoration:
                              BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.book_outlined,
                                color: Colors.orange,
                                size: 30,
                              ),
                              Text(
                                "Kitap Ekle",
                                style:
                                    GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          decoration:
                              BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.image_outlined,
                                color: Colors.orange,
                                size: 30,
                              ),
                              Text(
                                "Resim Ekle",
                                style:
                                    GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          decoration:
                              BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_pin_rounded,
                                color: Colors.orange,
                                size: 30,
                              ),
                              Text(
                                "Yazar Ekle",
                                style:
                                    GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future<void> showShareTypeSelect() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return BottomSheet(
            enableDrag: false,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: SizedBox(
                      width: 75,
                      child: Divider(
                        thickness: 4,
                        color: Color.fromRGBO(97, 97, 97, 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                        child: Text(
                      "Hedef kitle seç",
                      style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                  ),
                  const Divider(
                    color: Color.fromRGBO(66, 66, 66, 0.2),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.blue.shade300, borderRadius: BorderRadius.circular(5)),
                      child: const Icon(
                        Icons.public,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      "Herkese Açık",
                      style: GoogleFonts.quicksand(),
                    ),
                    trailing: shareType.name == "public"
                        ? const CircleAvatar(
                            radius: 14, backgroundColor: Colors.green, child: Icon(Icons.check, color: Colors.white))
                        : null,
                    onTap: () {
                      setState(() {
                        shareType = ShareAccessType.public;
                      });
                    },
                  ),
                  const Divider(color: Color.fromRGBO(66, 66, 66, 0.2)),
                  ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.purple.shade300, borderRadius: BorderRadius.circular(5)),
                      child: const Icon(
                        Icons.person_off_outlined,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      "Gizli",
                      style: GoogleFonts.quicksand(),
                    ),
                    trailing: shareType.name == "private"
                        ? const CircleAvatar(
                            radius: 14, backgroundColor: Colors.green, child: Icon(Icons.check, color: Colors.white))
                        : null,
                    onTap: () {
                      setState(() {
                        shareType = ShareAccessType.private;
                      });
                    },
                    contentPadding: const EdgeInsets.all(10),
                  )
                ],
              );
            },
            onClosing: () {},
          );
        },
      ),
    );
  }
}
