// import 'dart:math';
import 'dart:ui';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/init/network/google_books_service.dart';
import '../../../core/model/book_model.dart';
import '../../../core/model/note_model.dart';
import '../../../core/viewmodel/note_repository.dart';
import 'authors_screen.dart';
import 'book_details_screen.dart';
import 'books_screen.dart';
import 'categories_screen.dart';

class BookFinderScreen extends ConsumerStatefulWidget {
  const BookFinderScreen({super.key});

  @override
  ConsumerState<BookFinderScreen> createState() => _BookFinderScreenState();
}

class _BookFinderScreenState extends ConsumerState<BookFinderScreen> {
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

  List<Map<String, String>> yazarlar = [
    {
      "name": "Orhan Pamuk",
      "image":
          "https://www.harvardmagazine.com/sites/default/files/styles/4x3_main/public/img/story/1209/0909_12f_1.jpg"
    },
    {"name": "Yaşar Kemal", "image": "https://www.biyografi.info/personpicture-fb/yasarkemal.jpg"},
    {
      "name": "Nazım Hikmet",
      "image": "https://upload.wikimedia.org/wikipedia/en/thumb/b/b8/NazimHikmetRan.jpg/220px-NazimHikmetRan.jpg"
    },
    {"name": "Sabahattin Ali", "image": "https://upload.wikimedia.org/wikipedia/tr/f/f6/Sabahattin_ali.jpg"},
    {
      "name": "Ahmet Hamdi Tanpınar",
      "image":
          "https://i.tmgrup.com.tr/fikriyat/album/2020/01/24/ahmet-hamdi-tanpinar-kimdir-ahmet-hamdi-tanpinarin-hayati-1579847769060.jpg"
    },
  ];

  List<Map<String, String>> kitaplar = [
    {"name": "Masumiyet Müzesi", "author": "Orhan Pamuk"},
    {"name": "Hayvan Çiftliği", "author": "George Orwell"},
    {"name": "Lavinia", "author": "Özdemir Asaf"},
    {"name": "Suç ve Ceza", "author": "Dostoyevski"},
  ];

  TextEditingController search = TextEditingController();
  // late Box<BookModel> _bookBox;
  // Future<void> openHiveBox() async {
  //   if (!Hive.isAdapterRegistered(1)) {
  //     Hive.registerAdapter<BookModel>(BooksAdapter());
  //   }
  //   await Hive.openBox<BookModel>('books');
  //   _bookBox = Hive.box<BookModel>('books');
  // }

  @override
  void initState() {
    super.initState();
    // Future.delayed(
    //   const Duration(seconds: 0),
    //   () async {
    //     await Hive.initFlutter();
    //     await openHiveBox();
    //     setState(() {});
    //   },
    // );
  }

  @override
  void dispose() {
    super.dispose();
    search.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade900,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Kitap Bul",
          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8, right: 10, left: 10, bottom: 20),
            // child: TypeAheadField(
            //   textFieldConfiguration: TextFieldConfiguration(
            //     style: GoogleFonts.quicksand(),
            //     controller: search,
            //     decoration: InputDecoration(
            //         suffixIcon: IconButton(
            //             onPressed: () {
            //               FocusScopeNode currentFocus = FocusScope.of(context);
            //               if (!currentFocus.hasPrimaryFocus) {
            //                 currentFocus.unfocus();
            //               }
            //               search.clear();
            //             },
            //             icon: const Icon(Icons.close)),
            //         prefixIcon: const Icon(Icons.search_rounded),
            //         filled: true,
            //         fillColor: Colors.grey.shade100,
            //         hintText: "Başlıklar ve Yazarlar...",
            //         hintStyle: GoogleFonts.quicksand(),
            //         border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
            //         contentPadding: const EdgeInsets.all(8)),
            //   ),
            //   minCharsForSuggestions: 3,
            //   noItemsFoundBuilder: (context) => ListTile(
            //     title: const Text("Aramanızla eşleşen sonuç bulunamadı"),
            //     subtitle: const Text("Kendiniz eklemek için tıklayın"),
            //     onTap: () {
            //       print("Manuel kitap ekleme sayfası");
            //     },
            //   ),
            //   suggestionsCallback: (pattern) async {
            //     Future<List<BookModel>> future1 = GoogleBooksService().getGBooksData(query: pattern);
            //     Future<List<BookModel>> future2 =
            //         GoogleBooksService().getGBooksFromAuthor(author: pattern, startIndex: 0);

            //     List<BookModel> resultList = [];

            //     List<BookModel> result1 = await future1;
            //     resultList.addAll(result1);

            //     List<BookModel> result2 = await future2;
            //     resultList.addAll(result2);

            //     Random random = Random();
            //     resultList.shuffle(random);

            //     List<BookModel?> lastList = allYazarlar.map((e) {
            //       if (!((e["name"] ?? "").toLowerCase()).contains(pattern.toLowerCase())) return null;
            //       return BookModel(
            //           bookId: "*",
            //           title: e["name"] ?? "",
            //           subtitle: "",
            //           description: "",
            //           author: "",
            //           categories: [""],
            //           country: "",
            //           language: "",
            //           previewLink: "",
            //           imageLink: (e["image"] != null && e["image"] != "")
            //               ? e["image"]!
            //               : "https://cdn-icons-png.flaticon.com/128/9977/9977254.png",
            //           pageCount: "",
            //           publishedDate: "");
            //     }).toList();
            //     for (var e in lastList) {
            //       if (e == null) continue;
            //       resultList.insert(0, e);
            //     }
            //     return Future.value(resultList);
            //   },
            //   itemSeparatorBuilder: (context, index) => const Divider(),
            //   loadingBuilder: (context) => const LinearProgressIndicator(),
            //   suggestionsBoxDecoration: SuggestionsBoxDecoration(
            //       borderRadius: BorderRadius.circular(15),
            //       color: Colors.blueGrey.shade50,
            //       constraints: const BoxConstraints(maxHeight: 250)),
            //   autoFlipMinHeight: 100,
            //   itemBuilder: (context, suggestion) {
            //     return ListTile(
            //       leading: !suggestion.imageLink.startsWith("assets")
            //           ? Image.network(
            //               suggestion.imageLink,
            //               loadingBuilder: (context, child, loadingProgress) =>
            //                   (loadingProgress == null) ? child : const CircularProgressIndicator(),
            //               errorBuilder: (context, error, stackTrace) {
            //                 return Image.asset("assets/book.png");
            //               },
            //               fit: BoxFit.fitHeight,
            //               // height: 128,
            //               // width: 64,
            //             )
            //           : Image.asset("assets/book.png"),
            //       title: Text(
            //         suggestion.title,
            //         maxLines: 2,
            //         style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
            //       ),
            //       subtitle: Text(
            //         suggestion.author,
            //         maxLines: 2,
            //         style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
            //       ),
            //     );
            //   },
            //   hideOnError: true,
            //   onSuggestionSelected: (suggestion) async {
            //     if (suggestion.bookId == "*") {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => BooksScreen(
            //               yazar: suggestion.title,
            //             ),
            //           ));
            //       return;
            //     }
            //     await getNote(suggestion.title).then((notes) => showFlexibleBottomSheet(
            //           minHeight: 0,
            //           initHeight: 0.8,
            //           maxHeight: 1,
            //           bottomSheetColor: Colors.transparent,
            //           isCollapsible: true,
            //           context: context,
            //           isModal: true,
            //           useRootNavigator: true,
            //           builder: (context, scrollController, bottomSheetOffset) {
            //             return Material(
            //                 clipBehavior: Clip.hardEdge,
            //                 color: Colors.transparent,
            //                 borderRadius:
            //                     const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            //                 child: BookDetails(book: suggestion, scrollController: scrollController)
            //                 // buildBookDetails(suggestion, size, scrollController, notes)
            //                 );
            //           },
            //           anchors: [0, 1],
            //           isSafeArea: true,
            //         ));
            //     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookDetails(book: suggestion)));
            //   }, onSelected: (InvalidType value) {  },
            // ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Yazarlar",
                  style: GoogleFonts.quicksand(fontSize: 25, color: Colors.grey.shade900, fontWeight: FontWeight.bold),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AuthorsScreen(),
                      ));
                    },
                    child: Text(
                      "Tümünü göster",
                      style: GoogleFonts.quicksand(fontSize: 17, color: Colors.grey),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 135,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BooksScreen(
                            yazar: yazarlar[index]["name"],
                          ),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Column(
                      children: [
                        Container(
                          width: 75,
                          height: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(yazarlar[index]["image"] ?? "",
                                    cacheKey: yazarlar[index]["image"] ?? ""),
                                fit: BoxFit.cover,
                              )),
                        ),
                        SizedBox(
                          width: 100,
                          child: Center(
                            child: Text(
                              yazarlar[index]["name"] ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: yazarlar.length,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kitaplar",
                  style: GoogleFonts.quicksand(fontSize: 25, color: Colors.grey.shade900, fontWeight: FontWeight.bold),
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BooksScreen(),
                          ));
                    },
                    child: Text(
                      "Tümünü göster",
                      style: GoogleFonts.quicksand(fontSize: 17, color: Colors.grey),
                    )),
              ],
            ),
          ),
          FutureBuilder(
            // future: GoogleBooksService().getGBooksData(query: kitaplar[0]["name"] ?? "", author: kitaplar[0]["author"]),
            future: getBooks(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done && true) {
                final data = snapshot.data!;
                return CarouselSlider(
                  items: List.generate(data.length, (i) {
                    if (data[i] == null) return const Text("HATA");
                    return InkWell(
                      onTap: () async {
                        await getNote(data[i]!.title).then((notes) => showFlexibleBottomSheet(
                              minHeight: 0,
                              initHeight: 0.8,
                              maxHeight: 1,
                              bottomSheetColor: Colors.transparent,
                              isCollapsible: true,
                              context: context,
                              isModal: true,
                              useRootNavigator: true,
                              builder: (context, scrollController, bottomSheetOffset) {
                                return Material(
                                    clipBehavior: Clip.hardEdge,
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                    child: BookDetails(book: data[i]!, scrollController: scrollController)
                                    // buildBookDetails(data[i]!, size, scrollController, notes)
                                    );
                              },
                              anchors: [0, 1],
                              isSafeArea: true,
                            ));

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => BookDetails(book: data[i]!),
                        //     ));
                      },
                      splashColor: Colors.blue.shade900,
                      child: DecoratedBox(
                        decoration:
                            BoxDecoration(border: Border.all(width: 2), borderRadius: BorderRadius.circular(25)),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20, tileMode: TileMode.repeated),
                                  child: data[i]!.imageLink.startsWith("assets")
                                      ? Image.asset(
                                          "assets/book.png",
                                          fit: BoxFit.fill,
                                          color: Colors.white.withOpacity(0.5),
                                          colorBlendMode: BlendMode.dstATop,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: data[i]!.imageLink,
                                          fit: BoxFit.fill,
                                          color: Colors.white.withOpacity(0.5),
                                          colorBlendMode: BlendMode.dstATop,
                                        ),
                                ),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                                width: double.maxFinite,
                                height: 150,
                                child: Row(children: [
                                  Hero(
                                    tag: data[i]!,
                                    child: Container(
                                      height: 150,
                                      width: 128,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fitHeight,
                                              image: data[i]!.imageLink.startsWith("assets")
                                                  ? const AssetImage("assets/book.png")
                                                  : NetworkImage(data[i]!.imageLink) as ImageProvider)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data[i]!.title,
                                          maxLines: 2,
                                          style: GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // Text(data.subtitle),
                                        Text(
                                          data[i]!.author,
                                          maxLines: 1,
                                          style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          data[i]!.publishedDate,
                                          maxLines: 1,
                                          style: GoogleFonts.quicksand(),
                                        ),
                                        Text(
                                          data[i]!.subtitle,
                                          maxLines: 3,
                                          style: GoogleFonts.quicksand(),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: Color.fromRGBO(130, 177, 255, 1),
                                    size: 35,
                                  )
                                ])),
                          ],
                        ),
                      ),
                    );
                  }),
                  options: CarouselOptions(
                      viewportFraction: 0.8,
                      enlargeCenterPage: true,
                      height: 175,
                      scrollDirection: Axis.horizontal,
                      autoPlay: true),
                );
              }
              return SizedBox(
                  height: 175,
                  child: CarouselSlider(
                    items: List.generate(
                        3,
                        (index) => ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: const SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: ColoredBox(
                                  color: Color.fromRGBO(245, 245, 245, 1),
                                  child: LinearProgressIndicator(
                                    color: Color.fromRGBO(250, 250, 250, 1),
                                    backgroundColor: Color.fromRGBO(245, 245, 245, 1),
                                  ),
                                ),
                              ),
                            )),
                    options: CarouselOptions(
                        viewportFraction: 0.8,
                        enlargeCenterPage: true,
                        height: 175,
                        scrollDirection: Axis.horizontal,
                        autoPlay: true),
                  ));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kategoriler",
                  style: GoogleFonts.quicksand(fontSize: 25, color: Colors.grey.shade900, fontWeight: FontWeight.bold),
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoriesScreen(),
                          ));
                    },
                    child: Text(
                      "Tümünü göster",
                      style: GoogleFonts.quicksand(fontSize: 17, color: Colors.grey),
                    )),
              ],
            ),
          ),
          Wrap(
              alignment: WrapAlignment.spaceAround,
              runSpacing: 8,
              children: List.generate(
                kategoriler.length,
                (i) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BooksScreen(
                              kategori: kategoriler[i],
                            ),
                          ));
                    },
                    child: Container(
                      height: 110,
                      width: MediaQuery.sizeOf(context).width / 2 - 16,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover, image: CachedNetworkImageProvider(kategoriler[i]["image"] ?? "")),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [Colors.black87, Colors.black26]),
                        ),
                        child: Text(
                          kategoriler[i]["nameTR"] ?? "",
                          style: GoogleFonts.quicksand(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }

  Future<List<Note>> getNote(String title) async {
    List<Note> bookNote = [];
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter<Note>(NotesAdapter());
    }
    var notes = await Hive.openBox<Note>('notes');
    await ref.read(noteRepositoryprovider).getNote("1", notes, title).then((nots) {
      if (nots != null) bookNote.addAll(nots);
    });
    return bookNote;
  }

  Future<List<BookModel?>> getBooks() async {
    var a = Future.wait<BookModel?>(kitaplar.map((e) {
      return GoogleBooksService().getGBookData(query: e["name"] ?? "", author: e["author"]);
    }));
    return a;
  }
}

Future<BookModel?> buildBookSearch(context) async {
  BookModel? book;
  List<BookModel> books = [];
  String helpText = "Kitap Arayın";
  TextEditingController controller = TextEditingController();
  return await showModalBottomSheet<BookModel?>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "Kitap seç",
                    style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () async {
                              setState(() {
                                helpText = "Yükleniyor...";
                                books.clear();
                              });
                              await GoogleBooksService()
                                  .getGBooksData(query: controller.text)
                                  .then((val) => setState(() {
                                        books.addAll(val);
                                        helpText = "Kitap Arayın";
                                      }));
                            },
                            icon: const Icon(Icons.search)),
                        contentPadding: const EdgeInsets.all(8),
                        hintText: "Kitap adını girin...",
                        hintStyle: GoogleFonts.quicksand(),
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: books.isEmpty ? 1 : books.length,
                    itemBuilder: (context, index) {
                      if (books.isEmpty) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              helpText,
                              style: GoogleFonts.quicksand(fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            const Icon(Icons.help)
                          ],
                        );
                      }
                      return ListTile(
                        leading: !books[index].imageLink.startsWith("assets")
                            ? Image.network(
                                books[index].imageLink,
                                loadingBuilder: (context, child, loadingProgress) =>
                                    (loadingProgress == null) ? child : const CircularProgressIndicator(),
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset("assets/book.png");
                                },
                                fit: BoxFit.fitHeight,
                                // height: 128,
                                // width: 64,
                              )
                            : Image.asset("assets/book.png"),
                        title: Text(
                          books[index].title,
                          maxLines: 2,
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          books[index].author,
                          maxLines: 2,
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          setState(() {
                            book = books[index];
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      );
    },
  ).then((value) => book);
}
