import 'package:blur/blur.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../../core/model/book_model.dart';
import '../../../core/model/note_model.dart';
import '../../../core/viewmodel/book_repository.dart';
import '../../../core/viewmodel/note_repository.dart';
import '../booksearch/book_details_screen.dart';
import '../booksearch/book_finder_screen.dart';
import 'fav_details_screen.dart';

class ReadingList extends ConsumerStatefulWidget {
  const ReadingList({super.key});

  @override
  ConsumerState<ReadingList> createState() => _ReadingListState();
}

class _ReadingListState extends ConsumerState<ReadingList> {
  late Box<BookModel> _bookBox;
  bool yuklendiMi = false;
  List<String> seciliEtiketler = [];
  List<BookModel> filteredBooks = [];
  Map<String, BookModel> favoriteBooks = {};
  Map<String, List<BookModel>> favoriteLists = {};

  Future<void> openHiveBox() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter<BookModel>(BooksAdapter());
    }
    await Hive.openBox<BookModel>('books');
    _bookBox = Hive.box<BookModel>('books');
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        await Hive.close();
        await Hive.initFlutter();
        await openHiveBox();
      },
    ).then((_) async {
      setState(() {
        yuklendiMi = true;
      });
      await refreshAllList();
    });
  }

  Future<void> refreshAllList() async {
    await ref.read(bookRepositoryprovider).getAllFavBooks("1", _bookBox).then((mapValue) {
      setState(() {
        favoriteBooks.clear();
        favoriteBooks.addAll(mapValue);
      });
    });
    await ref.read(bookRepositoryprovider).getAllFavListBooks(userId: "1", favoriteBox: _bookBox).then((mapValue) {
      setState(() {
        favoriteLists.clear();
        favoriteLists.addAll(mapValue);
      });
    });
  }

  @override
  void dispose() {
    _bookBox.close();
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return !yuklendiMi
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : WillPopScope(
            onWillPop: () async {
              if (!Hive.isBoxOpen("books")) {
                _bookBox = await Hive.openBox("favBooks");
              }
              await refreshAllList();

              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      centerTitle: true,
                      leading: IconButton(
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                      actions: [
                        IconButton(
                            onPressed: () async {
                              await Hive.deleteBoxFromDisk("books").then((_) {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              });
                            },
                            icon: const Icon(Icons.remove_circle))
                      ],
                      title: Text(
                        "Okuma Listem",
                        style: GoogleFonts.quicksand(
                            color: Colors.grey.shade900, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              "Favori Listelerim",
                              style: GoogleFonts.quicksand(
                                  color: Colors.grey.shade900, fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                          ),
                          IconButton.filled(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => favListAddDialog(size.width - 50, context, _bookBox),
                              ).then((value) async {
                                await refreshAllList();
                              });
                            },
                            icon: const Icon(Icons.add_box_rounded),
                            style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white60)),
                            color: Colors.grey.shade700,
                          )
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CarouselSlider(
                          items: favoriteLists.entries
                              .map((e) => SizedBox.expand(
                                    child: ZoomTapAnimation(
                                      onTap: () async {
                                        //buraya liste için aynı kitap detayında olduğu gibi bir gösterim
                                        //yapılacak
                                        await showFlexibleBottomSheet(
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
                                                child:
                                                    FavDetails(favListName: e.key, scrollController: scrollController)
                                                // buildBookDetails(suggestion, size, scrollController, notes)
                                                );
                                          },
                                          anchors: [0, 0.8, 1],
                                          isSafeArea: true,
                                        ).then((_) async {
                                          await Hive.close();
                                          await Hive.initFlutter();
                                          await openHiveBox();
                                          await refreshAllList();
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20), color: Colors.blue.shade50),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  width: 75,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                    fit: BoxFit.fitWidth,
                                                    image: e.value.length > 1
                                                        ? e.value[1].imageLink.startsWith("assets")
                                                            ? Image.asset(
                                                                "assets/book.png",
                                                              ).image
                                                            : Image.network(
                                                                e.value[1].imageLink,
                                                                loadingBuilder: (BuildContext context, Widget child,
                                                                    ImageChunkEvent? loadingProgress) {
                                                                  if (loadingProgress == null) return child;
                                                                  return SizedBox(
                                                                    height: 175,
                                                                    child: Center(
                                                                      child: CircularProgressIndicator(
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes!
                                                                            : null,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ).image
                                                        : Image.asset("assets/book.png").image,
                                                  )),
                                                ),
                                                Container(
                                                  width: 100,
                                                  height: 125,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                    fit: BoxFit.fitWidth,
                                                    image: e.value.isNotEmpty
                                                        ? e.value[0].imageLink.startsWith("assets")
                                                            ? Image.asset(
                                                                "assets/book.png",
                                                              ).image
                                                            : Image.network(
                                                                e.value[0].imageLink,
                                                                loadingBuilder: (BuildContext context, Widget child,
                                                                    ImageChunkEvent? loadingProgress) {
                                                                  if (loadingProgress == null) return child;
                                                                  return SizedBox(
                                                                    height: 175,
                                                                    child: Center(
                                                                      child: CircularProgressIndicator(
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes!
                                                                            : null,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ).image
                                                        : Image.asset("assets/book.png").image,
                                                  )),
                                                ),
                                                Container(
                                                  width: 75,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                    fit: BoxFit.fitWidth,
                                                    image: e.value.length > 2
                                                        ? e.value[2].imageLink.startsWith("assets")
                                                            ? Image.asset(
                                                                "assets/book.png",
                                                              ).image
                                                            : Image.network(
                                                                e.value[2].imageLink,
                                                                loadingBuilder: (BuildContext context, Widget child,
                                                                    ImageChunkEvent? loadingProgress) {
                                                                  if (loadingProgress == null) return child;
                                                                  return SizedBox(
                                                                    height: 175,
                                                                    child: Center(
                                                                      child: CircularProgressIndicator(
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes!
                                                                            : null,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ).image
                                                        : Image.asset("assets/book.png").image,
                                                  )),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              e.key.toUpperCase(),
                                              style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          options: CarouselOptions(
                            viewportFraction: 0.8,
                            enlargeCenterPage: true,
                            height: 200,
                            autoPlay: true,
                            scrollDirection: Axis.horizontal,
                          )),
                    ),
                  ];
                },
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Favori Kitaplarım",
                            style: GoogleFonts.quicksand(
                                color: Colors.grey.shade900, fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          IconButton.filled(
                            onPressed: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BookFinderScreen(),
                                  )).then((_) async {
                                await Hive.close();
                                await Hive.initFlutter();
                                await openHiveBox();
                                await refreshAllList();
                              });
                            },
                            icon: const Icon(Icons.add_box_rounded),
                            style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white60)),
                            color: Colors.grey.shade700,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ReorderableListView(
                        padding: const EdgeInsets.all(8),
                        children: List.generate(
                            favoriteBooks.entries.isEmpty ? 1 : favoriteBooks.entries.length,
                            (index) => favoriteBooks.entries.isEmpty
                                ? SizedBox(
                                    key: ValueKey(index),
                                    width: size.width,
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          const Text("Henüz favori kitabın yok mu?"),
                                          TextButton(
                                              onPressed: () async {
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => const BookFinderScreen(),
                                                    )).then((_) async {
                                                  await ref
                                                      .read(bookRepositoryprovider)
                                                      .getAllFavBooks("1", _bookBox)
                                                      .then((value) => setState(() {
                                                            favoriteBooks.clear();
                                                            favoriteBooks.addAll(value);
                                                          }));
                                                });
                                              },
                                              child: const Text("Kitap Bul"))
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    key: ValueKey(favoriteBooks.entries.toList()[index]),
                                    width: size.width,
                                    height: 200,
                                    child: InkWell(
                                      onTap: () async {
                                        await getNote(favoriteBooks.entries.toList()[index].value.title)
                                            .then((notes) => showFlexibleBottomSheet(
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
                                                            topLeft: Radius.circular(30),
                                                            topRight: Radius.circular(30)),
                                                        child: BookDetails(
                                                            book: favoriteBooks.entries.toList()[index].value,
                                                            scrollController: scrollController)
                                                        // buildBookDetails(suggestion, size, scrollController, notes)
                                                        );
                                                  },
                                                  anchors: [0, 1],
                                                  isSafeArea: true,
                                                ))
                                            .then((_) async {
                                          await refreshAllList();
                                        });
                                      },
                                      child: Blur(
                                          alignment: Alignment.center,
                                          blur: 15,
                                          borderRadius: BorderRadius.circular(20),
                                          colorOpacity: 0.8,
                                          overlay: Padding(
                                            padding: const EdgeInsets.only(left: 12),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Hero(
                                                    tag: favoriteBooks.entries.toList()[index],
                                                    child: favoriteBooks.entries
                                                            .toList()[index]
                                                            .value
                                                            .imageLink
                                                            .startsWith("assets")
                                                        ? Image.asset(
                                                            "assets/book.png",
                                                            width: 100,
                                                            height: 175,
                                                            fit: BoxFit.fitWidth,
                                                          )
                                                        : Image.network(
                                                            favoriteBooks.entries.toList()[index].value.imageLink,
                                                            width: 100,
                                                            height: 175,
                                                            fit: BoxFit.fitWidth,
                                                            loadingBuilder: (BuildContext context, Widget child,
                                                                ImageChunkEvent? loadingProgress) {
                                                              if (loadingProgress == null) return child;
                                                              return SizedBox(
                                                                height: 175,
                                                                child: Center(
                                                                  child: CircularProgressIndicator(
                                                                    value: loadingProgress.expectedTotalBytes != null
                                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                                            loadingProgress.expectedTotalBytes!
                                                                        : null,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Flexible(
                                                    child: SizedBox(
                                                      height: 175,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            favoriteBooks.entries.toList()[index].value.title,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.quicksand(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 18,
                                                                color: Colors.grey.shade900),
                                                          ),
                                                          Text(favoriteBooks.entries.toList()[index].value.author,
                                                              style: GoogleFonts.quicksand(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16,
                                                                  color: Colors.grey.shade700)),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                          ),
                                          child: !favoriteBooks.entries
                                                  .toList()[index]
                                                  .value
                                                  .imageLink
                                                  .startsWith("assets")
                                              ? Image.network(
                                                  favoriteBooks.entries.toList()[index].value.imageLink,
                                                  width: MediaQuery.sizeOf(context).width,
                                                  height: 175,
                                                  fit: BoxFit.fill,
                                                  loadingBuilder: (BuildContext context, Widget child,
                                                      ImageChunkEvent? loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return SizedBox(
                                                      height: 175,
                                                      width: MediaQuery.sizeOf(context).width,
                                                      child: Center(
                                                        child: CircularProgressIndicator(
                                                          value: loadingProgress.expectedTotalBytes != null
                                                              ? loadingProgress.cumulativeBytesLoaded /
                                                                  loadingProgress.expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Image.asset(
                                                  "assets/book.png",
                                                  width: MediaQuery.sizeOf(context).width,
                                                  height: 175,
                                                  fit: BoxFit.fill,
                                                  repeat: ImageRepeat.repeatX,
                                                )),
                                    ),
                                  )).toList(),
                        //
                        onReorder: (oldIndex, newIndex) {},
                      ),
                    ),
                    // Expanded(
                    //   child: SizedBox(
                    //     width: double.infinity,
                    //     child: ReorderableGridView.count(
                    //       crossAxisSpacing: 10,
                    //       mainAxisSpacing: 10,
                    //       crossAxisCount: 1,
                    //       padding: const EdgeInsets.all(8),
                    //       physics: const BouncingScrollPhysics(),
                    //       onReorder: (oldIndex, newIndex) {
                    //         setState(() {
                    //           final element = filteredBooks.removeAt(oldIndex);
                    //           filteredBooks.insert(newIndex, element);
                    //         });
                    //       },
                    //       children: List.generate(
                    //           filteredBooks.length,
                    //           (i) => InkWell(
                    //                 key: ValueKey(filteredBooks[i]),
                    //                 onTap: () async {
                    //                   await getNote(filteredBooks[i].title)
                    //                       .then((notes) => showFlexibleBottomSheet(
                    //                             minHeight: 0,
                    //                             initHeight: 0.8,
                    //                             maxHeight: 1,
                    //                             bottomSheetColor: Colors.transparent,
                    //                             isCollapsible: true,
                    //                             context: context,
                    //                             isModal: true,
                    //                             useRootNavigator: true,
                    //                             builder: (context, scrollController, bottomSheetOffset) {
                    //                               return Material(
                    //                                   clipBehavior: Clip.hardEdge,
                    //                                   color: Colors.transparent,
                    //                                   borderRadius: const BorderRadius.only(
                    //                                       topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    //                                   child: BookDetails(
                    //                                       book: filteredBooks[i], scrollController: scrollController)
                    //                                   // buildBookDetails(suggestion, size, scrollController, notes)
                    //                                   );
                    //                             },
                    //                             anchors: [0, 1],
                    //                             isSafeArea: true,
                    //                           ))
                    //                       .then((_) async {
                    //                     await ref.read(bookRepositoryprovider).getAllbooks("1", _bookBox).whenComplete(() {
                    //                       refreshFilter(bookRepository);
                    //                     });
                    //                   });
                    //                   // await Navigator.push(
                    //                   //     context,
                    //                   //     MaterialPageRoute(
                    //                   //       builder: (context) => BookDetails(book: filteredBooks[i]),
                    //                   //     )).then((_) async {
                    //                   //   await ref.read(bookRepositoryprovider).getAllbooks("1", _bookBox).whenComplete(() {
                    //                   //     refreshFilter(bookRepository);
                    //                   //   });
                    //                   // });
                    //                 },
                    //                 child: Column(
                    //                   mainAxisSize: MainAxisSize.max,
                    //                   children: [
                    //                     SizedBox(
                    //                       height: 150,
                    //                       width: 150,
                    //                       // child: BetterImage(
                    //                       //   image: e.imageLink.startsWith("assets")
                    //                       //       ? const AssetImage("assets/book.png")
                    //                       //       : NetworkImage(e.imageLink) as ImageProvider,
                    //                       //   height: 150,
                    //                       //   width: 150,
                    //                       //   radius: BorderRadius.circular(50),
                    //                       // ),
                    //                       child: Container(
                    //                         decoration: BoxDecoration(
                    //                             boxShadow: [
                    //                               BoxShadow(
                    //                                   spreadRadius: -10,
                    //                                   color: Colors.grey.withOpacity(0.3),
                    //                                   blurRadius: 10,
                    //                                   offset: const Offset(0, 0))
                    //                             ],
                    //                             image: DecorationImage(
                    //                               filterQuality: FilterQuality.low,
                    //                               image: filteredBooks[i].imageLink.startsWith("assets")
                    //                                   ? const AssetImage("assets/book.png")
                    //                                   : NetworkImage(filteredBooks[i].imageLink) as ImageProvider,
                    //                               // image: e.imageLink == null
                    //                               //     ? AssetImage(
                    //                               //         "assets/book.png",
                    //                               //       )
                    //                               //     : NetworkImage(e.imageLink!),
                    //                               // colorFilter: ColorFilter.srgbToLinearGamma()
                    //                             )),
                    //                       ),
                    //                     ),
                    //                     SizedBox(
                    //                       width: MediaQuery.of(context).size.width / 3,
                    //                       height: 30,
                    //                       child: filteredBooks[i].title.length > 11
                    //                           ? Center(
                    //                               child: Marquee(
                    //                                 text: filteredBooks[i].title,
                    //                                 style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 15),
                    //                                 scrollAxis: Axis.horizontal,
                    //                                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                                 blankSpace: 20.0,
                    //                                 velocity: 100.0,
                    //                                 pauseAfterRound: const Duration(seconds: 10),
                    //                                 startAfter: const Duration(seconds: 5),
                    //                                 showFadingOnlyWhenScrolling: true,
                    //                                 startPadding: 10.0,
                    //                                 accelerationDuration: const Duration(seconds: 1),
                    //                                 accelerationCurve: Curves.easeInBack,
                    //                                 decelerationDuration: const Duration(milliseconds: 500),
                    //                                 decelerationCurve: Curves.easeInOut,
                    //                               ),
                    //                             )
                    //                           : Center(
                    //                               child: Text(
                    //                                 " ${filteredBooks[i].title}",
                    //                                 style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 15),
                    //                               ),
                    //                             ),
                    //                     )
                    //                   ],
                    //                 ),
                    //               )).toList(),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
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

  void refreshFilter(BookRepository bookRepository) {
    //En son aynı tag'i yazınca notları ikilediğini gördük. Yani 2 kere dene yazıyorsun o orda iki tane deneme açıyor gibi bir hata.
    filteredBooks.clear();
    var books = bookRepository.books;
    List<String> uniqueList = [];
    Set<String> seen = <String>{};

    for (String item in seciliEtiketler) {
      if (!seen.contains(item)) {
        uniqueList.add(item);
        seen.add(item);
      }
    }
    seciliEtiketler.clear();
    seciliEtiketler.addAll(uniqueList);
    // ignore: prefer_is_empty
    if (seciliEtiketler.length == 0) {
      filteredBooks.clear();
      filteredBooks.addAll(books);
      // print("burada");
    } else {
      for (var i = 0; i < books.length; i++) {
        for (var k = 0; k < seciliEtiketler.length; k++) {
          // print("değerlendirme:${notes[i].tags[j]} aranan:${secilenEtiketler[k]} i:$i j:$j k:$k");
          // print("note tag length:${notes[i].tags.length}");
          // print("arama length:${secilenEtiketler.length}");
          if (books[i].title.toLowerCase().contains(seciliEtiketler[k].toLowerCase())) {
            bool ekleme = true;
            for (var e in filteredBooks) {
              if (e.bookId == books[i].bookId) {
                ekleme = false;
              }
            }
            if (ekleme) {
              filteredBooks.add(books[i]);
            }
            // print("${notes[i].tags[j]} eşleşti");
          }
        }
      }
    }

    setState(() {});
  }

  Future<void> buildAddBook(BookRepository bookRepository) async {
    TextEditingController controller = TextEditingController();
    await showDialog(
        context: context,
        builder: (context) {
          return NDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border:
                            OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(25)),
                        labelText: "Kitap İsmi",
                        labelStyle: GoogleFonts.quicksand(),
                        suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.add))),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      // List<Book>? books =
                      //     await const GoogleBooksApi().searchBooks(controller.text, printType: PrintType.books);
                      // for (var e in books) {
                      //   print("---------------------------------" * 5);
                      //   print("id: ${e.id}");
                      //   print("country: ${e.saleInfo.country}");
                      //   print("Yazar: ${e.volumeInfo.authors}");
                      //   print("preview: ${e.volumeInfo.previewLink}");
                      //   print("categories: ${e.volumeInfo.categories}");
                      //   print("description: ${e.volumeInfo.description}");
                      //   print("image: ${e.volumeInfo.imageLinks}");
                      //   print("identifiers: ${e.volumeInfo.industryIdentifiers}");
                      //   print("language: ${e.volumeInfo.language}");
                      //   print("pageCount: ${e.volumeInfo.pageCount}");
                      //   print("publishedDate: ${e.volumeInfo.publishedDate}");
                      //   print("title: ${e.volumeInfo.title}");
                      //   print("subtitle: ${e.volumeInfo.subtitle}");
                      //   print("----------------------------------" * 5);
                      // }
                      try {
                        // List<Book>? books = await const GoogleBooksApi().searchBooks(controller.text,printType: PrintType.books).showProgressDialog(context, message: const Text("Kitap aranıyor...."), title: const Text("Yükleniyor..."));
                        // List<Book>? books = await const GoogleBooksApi().searchBooks(controller.text,printType: PrintType.books);
                        // print(books);
                        // print(books.first);
                        // print(books.first.volumeInfo.industryIdentifiers);
                        // BookModel newBook = BookModel(
                        //     bookId: books.first.id,
                        //     bookName: books.first.volumeInfo.title,
                        //     bookAuthor: books.first.volumeInfo.authors[0],
                        //     bookISBN: books.first.volumeInfo.industryIdentifiers.isNotEmpty
                        //         ? books.first.volumeInfo.industryIdentifiers.first.identifier.toString()
                        //         : "",
                        //     imageLink: books.first.volumeInfo.imageLinks?.values.first.toString() ??
                        //         "https://cdn-icons-png.flaticon.com/128/3557/3557574.png");
                        // await ref.read(bookRepositoryprovider).addbook(newBook, _bookBox).whenComplete(() {
                        //   refreshFilter(bookRepository);
                        //   Navigator.pop(context);
                        // });
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: const Text("Ekle"))
              ],
            ),
          );
        });
  }

  Widget buildA() {
    return Wrap(
      children: [
        SizedBox(
            height: 125,
            width: 90,
            child: InkWell(
                onTap: () {},
                splashColor: Colors.grey.shade800,
                child: Card(
                  color: Colors.grey.shade500.withOpacity(0.5),
                  child: Center(
                    child: Icon(
                      Icons.add_rounded,
                      size: 50,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ))),
      ],
    );
  }
}

StatefulBuilder favListAddDialog(double width, BuildContext context, Box<BookModel> bookBox) {
  TextEditingController controller = TextEditingController();
  return StatefulBuilder(builder: (context, setState) {
    return SimpleDialog(
      backgroundColor: Colors.grey.shade50,
      surfaceTintColor: Colors.white,
      alignment: Alignment.centerLeft,
      contentPadding: const EdgeInsets.all(16),
      children: [
        const SizedBox(
          height: 25,
        ),
        Text(
          "Liste Adı",
          style: GoogleFonts.quicksand(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.grey.shade800),
        ),
        CupertinoTextField(
          autofocus: true,
          controller: controller,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
              icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
              onPressed: () async {
                if (controller.text.length < 2) return;
                // Navigator.pop(context);
                await showFavListAddBookDialog(context, width, controller.text, bookBox);
              },
              label: const Text(
                "Devam et",
                style: TextStyle(color: Colors.black),
              )),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  });
}

Future<void> showFavListAddBookDialog(
    BuildContext context, double width, String favListName, Box<BookModel> bookBox) async {
  await BookRepository().getAllFavBooks("1", bookBox).then((booksList) {
    List<bool> checkList = List.generate(booksList.length, (index) => false);
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => SimpleDialog(
                backgroundColor: Colors.grey.shade50,
                surfaceTintColor: Colors.white,
                title: Text(favListName),
                children: [
                  SizedBox(
                    height: 300,
                    width: width,
                    child: ListView.builder(
                      itemCount: booksList.isEmpty ? 1 : booksList.length,
                      itemBuilder: (context, i) {
                        if (booksList.isEmpty) {
                          return ListTile(
                            title: const Text("Henüz favori kitabın yok mu ?"),
                            subtitle: const Text("Kitap ara"),
                            leading: const Icon(Icons.search),
                            onTap: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BookFinderScreen(),
                                  ));
                            },
                          );
                        }
                        return CheckboxListTile(
                          value: checkList[i],
                          onChanged: (val) {
                            if (val == null) return;
                            setState(() {
                              checkList[i] = val;
                            });
                          },
                          subtitle: Text(booksList.entries.toList()[i].value.author),
                          title: Text(booksList.entries.toList()[i].value.title),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          print(booksList);
                          for (var i = 0; i < booksList.length; i++) {
                            if (checkList[i]) {
                              await BookRepository().addbook(
                                  newbook: booksList.entries.toList()[i].value,
                                  bookBox: bookBox,
                                  favTag: "list",
                                  favName: favListName);
                            }
                          }
                          Navigator.pop(context);
                        },
                        label: const Text(
                          "Oluştur",
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                ],
              ),
            ));
  });
}
