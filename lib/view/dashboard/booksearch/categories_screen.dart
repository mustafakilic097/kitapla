import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/viewmodel/utils.dart';
import 'books_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Map<String, String>> kategoriler = [
    {
      "name": "Fiction",
      "nameTR": "Roman",
      "image":
          "https://images.pexels.com/photos/46274/pexels-photo-46274.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    {
      "name": "Science",
      "nameTR": "Bilim",
      "image":
          "https://images.pexels.com/photos/2280571/pexels-photo-2280571.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    {
      "name": "Religion",
      "nameTR": "Din",
      "image":
          "https://images.pexels.com/photos/256963/pexels-photo-256963.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    {
      "name": "Education",
      "nameTR": "Eğitim",
      "image":
          "https://images.pexels.com/photos/289737/pexels-photo-289737.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    {
      "name": "Psychology",
      "nameTR": "Psikoloji",
      "image":
          "https://images.pexels.com/photos/307008/pexels-photo-307008.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    {
      "name": "Poetry",
      "nameTR": "Şiir",
      "image":
          "https://images.pexels.com/photos/356372/pexels-photo-356372.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
  ];
  List<Map<String, String>> sortedKategoriler = [];
  int selectedSort = 0;

  TextEditingController search = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      sortedKategoriler.addAll(categoryList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.grey.shade900,
              title: Text(
                "Kategoriler",
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              ),
              elevation: 0,
              centerTitle: true,
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(55),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 16, top: 4, bottom: 4),
                    child: TextField(
                      controller: search,
                      onChanged: (value) {
                        if (search.text == "") {
                          sortedKategoriler.clear();
                          sortedKategoriler.addAll(categoryList);
                        }
                        List<Map<String, String>> newList = [];
                        for (var i = 0; i < categoryList.length; i++) {
                          if ((categoryList[i]["nameTR"] ?? "").toLowerCase().contains(search.text.toLowerCase())) {
                            newList.add(categoryList[i]);
                          }
                        }
                        sortedKategoriler.clear();
                        sortedKategoriler.addAll(newList);
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          suffixIcon: IconButton(
                              onPressed: () {
                                if (search.text == "") {
                                  sortedKategoriler.clear();
                                  sortedKategoriler.addAll(categoryList);
                                }
                                List<Map<String, String>> newList = [];
                                for (var i = 0; i < categoryList.length; i++) {
                                  if ((categoryList[i]["nameTR"] ?? "")
                                      .toLowerCase()
                                      .contains(search.text.toLowerCase())) {
                                    newList.add(categoryList[i]);
                                  }
                                }
                                sortedKategoriler.clear();
                                sortedKategoriler.addAll(newList);
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.search,
                              )),
                          hintText: "Başlıklar, yazarlar",
                          hintStyle: GoogleFonts.quicksand(),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
                          contentPadding: const EdgeInsets.all(8)),
                    ),
                  )),
            ),
            const SliverPadding(padding: EdgeInsets.all(8)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 140,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  itemCount: kategoriler.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BooksScreen(
                                kategori: kategoriler[index],
                              ),
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Column(
                          children: [
                            Container(
                              height: 90,
                              width: 75,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(kategoriler[index]["image"] ?? "",
                                          cacheKey: kategoriler[index]["image"] ?? ""),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            Text(
                              kategoriler[index]["nameTR"] ?? "",
                              style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(left: 16.0, bottom: 5),
                alignment: Alignment.centerLeft,
                child: PopupMenuButton(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(245, 245, 245, 1), borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "  Sıralama: ${selectedSort == 0 ? "Popüleriğe göre" : "Alfabeye göre"} ",
                      style: GoogleFonts.quicksand(fontSize: 18),
                    ),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: const Text("Popülerliğe göre"),
                        onTap: () {
                          setState(() {
                            sortedKategoriler.clear();
                            sortedKategoriler.addAll(categoryList);
                            selectedSort = 0;
                          });
                        },
                      ),
                      PopupMenuItem(
                        child: const Text("Alfabeye göre"),
                        onTap: () {
                          setState(() {
                            sortedKategoriler.sort(
                              (a, b) => a["nameTR"]!
                                  .toString()
                                  .toLowerCase()
                                  .compareTo(b["nameTR"]!.toString().toLowerCase()),
                            );
                            selectedSort = 1;
                          });
                        },
                      )
                    ];
                  },
                ),
              ),
            )
          ];
        },
        body: GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: sortedKategoriler.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BooksScreen(
                        kategori: sortedKategoriler[index],
                      ),
                    ));
              },
              child: Stack(
                children: [
                  AspectRatio(
                      aspectRatio: 1.4,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            sortedKategoriler[index]["image"] ?? "",
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const AspectRatio(
                                aspectRatio: 1.4,
                                child: Center(
                                  child: SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: LinearProgressIndicator(
                                        color: Colors.white,
                                        backgroundColor: Color.fromRGBO(245, 245, 245, 1),
                                      )),
                                ),
                              );
                            },
                          ))),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.only(left: 6.0),
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [Colors.black87, Colors.black26])),
                      child: Text(
                        sortedKategoriler[index]["nameTR"] ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5, mainAxisSpacing: 5, crossAxisCount: 2, childAspectRatio: 1.4),
        ),
      ),
    );
  }
}
