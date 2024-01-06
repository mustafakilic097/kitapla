// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitapla/view/dashboard/favourites/reading_list_screen.dart';
import 'package:kitapla/view/auth/widget_tree.dart';

import '../../core/model/user_model.dart';
import '../../core/viewmodel/auth.dart';
import '../../core/viewmodel/database.dart';
import '../../core/viewmodel/user_repository.dart';
import '../dashboard/booksearch/book_finder_screen.dart';
import '../dashboard/notes/note_screen.dart';
import '../dashboard/statistic/statistic_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  UserModel? user;
  bool cevrimici = true;
  bool cevrimdisi = false;

  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
    String? uid = Auth().currentUser?.uid;
    Future.delayed(
      const Duration(seconds: 1),
      () {
        setState(() {
          isExpanded = false;
        });
      },
    );
    if (uid == null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WidgetTree(),
          ));
      return;
    }
    getUserData(uid);
  }

  Future<void> getUserData(String uid) async {
    try {
      Db().getUserDetail(uid).then((val) {
        if (val == null) {
          throw Exception("Kullanıcı yüklenemedi");
        }
        setState(() {
          user = val;
        });
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Hata"),
          content: const Text("Veriler alınırken bir sorun oluştu"),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  getUserData(uid);
                },
                child: const Text("Tekrar Dene"))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = ref.watch(userRepositoryProvider);
    return ColoredBox(
      color: Colors.white,
      child: SingleChildScrollView(
        // physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Column(children: [
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Image.network(
                        user?.thumbnailImageUrl != null ? user?.thumbnailImageUrl ?? "" : "",
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return const LinearProgressIndicator(
                            color: Color.fromRGBO(250, 250, 250, 1),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: LinearProgressIndicator(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 50, width: double.infinity, child: ColoredBox(color: Colors.white))
                  ]),
                ),
                Positioned(
                  left: 20,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.network(
                        user?.profileImageUrl != null ? user?.profileImageUrl ?? "" : "",
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
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: PopupMenuButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      offset: const Offset(-20, 35),
                      itemBuilder: (context) {
                        return [ PopupMenuItem(child: const Text("Çıkış Yap"),onTap: () async{
                          await Auth().signOut();
                        },)];
                      },
                      icon:  Icon(Icons.settings_outlined,color: Colors.grey.shade600,),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 0, left: 20),
              child: Text(
                user != null
                    ? "${user!.name} ${user!.surname}"
                    : userRepository.localUser != null
                        ? "${userRepository.localUser!.name} ${userRepository.localUser!.surname}"
                        : "",
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, right: 8, left: 20, bottom: 16),
              child: Text(
                "@${user?.username ?? ""}", // "Kitapla üyesi",
                style: GoogleFonts.quicksand(fontSize: 17),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 25),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Kontrol Paneli",
                  style: GoogleFonts.quicksand(fontSize: 15),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, right: 15),
              child: Material(
                color: Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StatisticScreen(),
                            ));
                      },
                      title: Text("İstatistikler",
                          style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold)),
                      leading: const CircleAvatar(
                          backgroundColor: Color.fromRGBO(13, 71, 161, 1),
                          radius: 35,
                          child: Icon(
                            Icons.ssid_chart_rounded,
                            color: Colors.white,
                            size: 35,
                          )),
                      contentPadding: const EdgeInsets.all(16),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BookFinderScreen(),
                            ));
                      },
                      title: Text("Kitap Bul", style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold)),
                      leading: const CircleAvatar(
                          backgroundColor: Color.fromRGBO(0, 230, 118, 1),
                          radius: 35,
                          child: Icon(
                            CupertinoIcons.doc_text_search,
                            // Icons.manage_search_sharp,
                            color: Colors.white,
                            size: 35,
                          )),
                      contentPadding: const EdgeInsets.all(16),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReadingList(),
                            ));
                      },
                      title: Text("Kütüphane", style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold)),
                      leading: const CircleAvatar(
                          backgroundColor: Colors.deepOrange,
                          radius: 35,
                          child: Icon(
                            Icons.local_library_rounded,
                            color: Colors.white,
                            size: 35,
                          )),
                      contentPadding: const EdgeInsets.all(16),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotePage(),
                            ));
                      },
                      title: Text("Notlarım", style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold)),
                      leading: const CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 35,
                          child: Icon(
                            Icons.sticky_note_2_rounded,
                            color: Colors.white,
                            size: 35,
                          )),
                      contentPadding: const EdgeInsets.all(16),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                      ),
                    ),
                    ListTile(
                      onTap: null,
                      // () {
                      //   // Navigator.push(
                      //   //     context,
                      //   //     MaterialPageRoute(
                      //   //       builder: (context) => const TasksScreen(),
                      //   //     ));
                      // },
                      title: Text("Hedefler (Yakında)",
                          style: GoogleFonts.quicksand(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)),
                      leading: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          // Colors.purple,
                          radius: 35,
                          child: Icon(
                            Icons.task_alt_rounded,
                            color: Colors.white,
                            size: 35,
                          )),
                      contentPadding: const EdgeInsets.all(16),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //     padding: const EdgeInsets.only(left: 25),
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       "Hesabım",
            //       style: GoogleFonts.quicksand(fontSize: 15),
            //     )),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 25, top: 5, right: 15),
            //     child: TextButton(
            //         child: Text(
            //           "Çıkış Yap",
            //           style: GoogleFonts.quicksand(
            //               color: const Color.fromARGB(245, 255, 64, 0), fontWeight: FontWeight.bold, fontSize: 20),
            //         ),
            //         onPressed: () async {
                      
            //         }),
            //   ),
            // ),
            const SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> buildSonOkumaList() {
    return [
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 8.0, left: 15),
        child: Text(
          "Son Okuma Aktivitelerim",
          style: GoogleFonts.quicksand(color: Colors.grey.shade900, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Container(
          // padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(15)),
          height: 300,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white38, borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    title: const Text("Yaban"),
                    subtitle: const Text("41 dk okuma yapıldı"),
                    trailing: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("03.06.23"),
                        Text("11:30"),
                      ],
                    ),
                    leading: SizedBox(
                      width: 50,
                      height: 75,
                      child: Card(
                        color: Colors.brown,
                        child: Center(
                            child: Text(
                          "Y",
                          style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
                        )),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: 15,
          ),
        ),
      ),
    ];
  }

  Widget buildDigerAraclar() {
    return SizedBox(
      height: 150,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const ReadingList();
                },
              ));
            },
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                // boxShadow: const [BoxShadow(blurRadius: 5)],
                color: Colors.brown.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DecoratedBox(
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(25)),
                      child: Image.asset(
                        "assets/read.png",
                        height: 100,
                      )),
                  DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      "Okuma Listesi",
                      style:
                          GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.grey.shade50),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 200,
            decoration: BoxDecoration(
              // boxShadow: const [BoxShadow(blurRadius: 5)],
              color: Colors.red.shade400,
              // color: Colors.brown.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(25)),
                    child: Image.asset(
                      "assets/target.png",
                      height: 100,
                    )),
                Container(
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    "Hedefler",
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.grey.shade50),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NotePage(),
              ));
            },
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                // boxShadow: const [BoxShadow(blurRadius: 5)],
                color: Colors.green.shade400,
                // color: Colors.brown.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(25)),
                      child: Image.asset(
                        "assets/note.png",
                        height: 100,
                      )),
                  Container(
                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      "Kişisel Notlar",
                      style:
                          GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.grey.shade50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
