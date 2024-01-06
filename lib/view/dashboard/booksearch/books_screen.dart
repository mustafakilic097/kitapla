import 'package:blur/blur.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:loadmore/loadmore.dart';

import '../../../core/init/network/google_books_service.dart';
import '../../../core/model/book_model.dart';
import '../../../core/model/note_model.dart';
import '../../../core/viewmodel/note_repository.dart';
import '../../../core/viewmodel/utils.dart';
import 'book_details_screen.dart';

class BooksScreen extends ConsumerStatefulWidget {
  final String? yazar;
  final Map<String, String>? kategori;
  const BooksScreen({super.key, this.yazar, this.kategori});

  @override
  ConsumerState<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends ConsumerState<BooksScreen> {
  List<BookModel> books = [];
  List<BookModel> sortedBooks = [];
  int loadedIndex = 0;
  bool firstLoad = false;
  bool kontrol = false;
  bool isFinish = false;
  bool addBlock = false;
  TextEditingController search = TextEditingController();

  late String? yazar = widget.yazar;
  late Map<String, String>? kategori = widget.kategori;

  @override
  void initState() {
    super.initState();
    if (yazar != null) {
      getAuthorsList().then(
        (value) => setState(() => firstLoad = true),
      );
    } else if (kategori != null) {
      getCategoriesList().then((value) => setState(() => firstLoad = true));
    } else {
      getBooksList().then((value) => setState(() => firstLoad = true));
    }
    search.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    search.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    return !firstLoad
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey.shade900,
                    title: Text(
                      "Kitaplar",
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    ),
                    centerTitle: true,
                    elevation: 0,
                    bottom: const PreferredSize(
                        preferredSize: Size.fromHeight(55),
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.0, left: 16, top: 4, bottom: 2),
                          // child: TypeAheadField(
                          //   textFieldConfiguration: TextFieldConfiguration(
                          //     style: GoogleFonts.quicksand(),
                          //     controller: search,
                          //     decoration: InputDecoration(
                          //         suffixIcon: (search.text.isNotEmpty)
                          //             ? IconButton(onPressed: search.clear, icon: const Icon(Icons.close))
                          //             : null,
                          //         prefixIcon: const Icon(Icons.search_rounded),
                          //         filled: true,
                          //         fillColor: Colors.grey.shade100,
                          //         hintText: "Başlıklar...",
                          //         hintStyle: GoogleFonts.quicksand(),
                          //         border: OutlineInputBorder(
                          //             borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
                          //         contentPadding: const EdgeInsets.all(8)),
                          //   ),
                          //   minCharsForSuggestions: 3,
                          //   noItemsFoundBuilder: (context) => const Text("Aramanızla eşleşen öge bulunamadı"),
                          //   suggestionsCallback: (pattern) async {
                          //     return await GoogleBooksService().getGBooksData(query: pattern);
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
                          //                 borderRadius: const BorderRadius.only(
                          //                     topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                          //                 child: BookDetails(book: suggestion, scrollController: scrollController)
                          //                 // buildBookDetails(suggestion, size, scrollController, notes)
                          //                 );
                          //           },
                          //           anchors: [0, 1],
                          //           isSafeArea: true,
                          //         ));
                          //     // Navigator.of(context)
                          //     //     .push(MaterialPageRoute(builder: (context) => BookDetails(book: suggestion)));
                          //   },
                          // ),
                        )),
                  ),
                  if (yazar != null || kategori != null)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 50,
                        child: ListView(
                          padding: const EdgeInsets.all(5),
                          scrollDirection: Axis.horizontal,
                          children: [
                            if (yazar != null)
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    yazar = null;
                                    loadedIndex = 0;
                                    kontrol = false;
                                    isFinish = false;
                                    addBlock = true;
                                    books.clear();
                                    sortedBooks.clear();
                                  });
                                  await getBooksList();
                                },
                                child: Badge(
                                  smallSize: 10,
                                  largeSize: 24,
                                  offset: const Offset(8, -4),
                                  backgroundColor: Colors.grey.shade200,
                                  label: Icon(
                                    Icons.close_rounded,
                                    color: Colors.grey.shade800,
                                    size: 20,
                                  ),
                                  child: FilterChip(
                                    backgroundColor: Colors.blue.shade100,
                                    label: Row(
                                      children: [
                                        Text(
                                          "Yazar: $yazar",
                                          style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    onSelected: (value) async {},
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 15,
                            ),
                            if (kategori != null)
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    kategori = null;
                                    loadedIndex = 0;
                                    kontrol = false;
                                    isFinish = false;
                                    addBlock = true;
                                    books.clear();
                                    sortedBooks.clear();
                                  });
                                  await getBooksList();
                                },
                                child: Badge(
                                  smallSize: 10,
                                  largeSize: 24,
                                  offset: const Offset(8, -4),
                                  backgroundColor: Colors.grey.shade200,
                                  label: Icon(
                                    Icons.close_rounded,
                                    color: Colors.grey.shade800,
                                    size: 20,
                                  ),
                                  child: FilterChip(
                                    label: Text("Kategori: ${kategori!["nameTR"]}"),
                                    onSelected: (value) {},
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                            onPressed: () {
                              TextEditingController yazarField = TextEditingController(text: yazar);
                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
                                    child: CupertinoActionSheet(
                                      title: Material(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(15),
                                        child: TextField(
                                            controller: yazarField,
                                            onSubmitted: (val) {
                                              yazar = val;
                                              loadedIndex = 0;
                                              kontrol = false;
                                              isFinish = false;
                                              addBlock = true;
                                              books.clear();
                                              sortedBooks.clear();
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Yazar",
                                              hintText: "Yazarın tam adını girin.",
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  if (yazarField.text.isEmpty || yazarField.text.length < 3) return;
                                                  yazar = yazarField.text;
                                                  loadedIndex = 0;
                                                  kontrol = false;
                                                  isFinish = false;
                                                  addBlock = true;
                                                  books.clear();
                                                  sortedBooks.clear();
                                                  setState(() {});
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor: Color.fromRGBO(227, 242, 253, 1),
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Color.fromRGBO(13, 71, 161, 1),
                                                  ),
                                                ),
                                              ),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                              hintStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                              labelStyle: const TextStyle(fontSize: 13),
                                            )),
                                      ),
                                      message: Material(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(15),
                                        child: Center(
                                          child: DropdownButton<Map<String, String>>(
                                              dropdownColor: Colors.grey.shade200,
                                              isExpanded: true,
                                              borderRadius: BorderRadius.circular(15),
                                              padding: const EdgeInsets.all(8),
                                              icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                              underline: const SizedBox.shrink(),
                                              items: List.generate(
                                                  categoryList.length,
                                                  (index) => DropdownMenuItem<Map<String, String>>(
                                                        value: categoryList[index],
                                                        child: Text(categoryList[index]["nameTR"] ?? ""),
                                                      )),
                                              value: kategori,
                                              hint: const Text("Kategori Seçin..."),
                                              menuMaxHeight: 270,
                                              onChanged: (val) async {
                                                if (val == null) return;
                                                setState(() {
                                                  kategori = val;
                                                  loadedIndex = 0;
                                                  kontrol = false;
                                                  isFinish = false;
                                                  addBlock = true;
                                                  books.clear();
                                                  sortedBooks.clear();
                                                });
                                              }),
                                        ),
                                      ),
                                      actions: [
                                        CupertinoActionSheetAction(
                                            isDefaultAction: true,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Bitti",
                                              style: TextStyle(color: Colors.blue),
                                            ))
                                      ],
                                      // cancelButton: CupertinoActionSheetAction(
                                      //     onPressed: () {
                                      //       Navigator.pop(context);
                                      //     },
                                      //     child: const Text("İptal")),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.filter_alt_rounded),
                            label: const Text("Filtrele"))),
                  )
                ];
              },
              body: LoadMore(
                onLoadMore: () {
                  setState(() {
                    kontrol = true;
                  });
                  if (yazar != null) {
                    return getAuthorsList();
                  } else if (kategori != null) {
                    return getCategoriesList();
                  } else {
                    return getBooksList();
                  }
                },
                textBuilder: (status) {
                  if (status == LoadMoreStatus.loading) {
                    if (sortedBooks.isNotEmpty) {
                      return "Daha fazlası aranıyor...";
                    }
                    return "Yükleniyor...";
                  } else if (status == LoadMoreStatus.nomore) {
                    return "Daha fazlası için arama yapabilirsiniz. 🔎";
                  } else if (status == LoadMoreStatus.outScreen) {
                    return "Ekran dışına taşma";
                  } else if (status == LoadMoreStatus.idle) {
                    return "...";
                  } else if (status == LoadMoreStatus.fail) {
                    return "Ahh sanırım bişeyler ters gitti 🤐";
                  } else {
                    return "Bilinmeyen Hata...";
                  }
                },
                isFinish: (yazar != null) || (kategori != null) ? isFinish : books.length >= kitapListesi.length,
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: InkWell(
                        onTap: () async {
                          await getNote(sortedBooks[i].title).then((notes) => showFlexibleBottomSheet(
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
                                      child: BookDetails(book: sortedBooks[i], scrollController: scrollController)
                                      // buildBookDetails(suggestion, size, scrollController, notes)
                                      );
                                },
                                anchors: [0, 1],
                                isSafeArea: true,
                              ));
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
                                    tag: sortedBooks[i],
                                    child: sortedBooks[i].imageLink.startsWith("assets")
                                        ? Image.asset(
                                            "assets/book.png",
                                            width: 100,
                                            height: 175,
                                            fit: BoxFit.fitWidth,
                                          )
                                        : Image.network(
                                            sortedBooks[i].imageLink,
                                            width: 100,
                                            height: 175,
                                            fit: BoxFit.fitWidth,
                                            loadingBuilder:
                                                (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
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
                                            sortedBooks[i].title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey.shade900),
                                          ),
                                          Text(sortedBooks[i].author,
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
                          child: sortedBooks[i].imageLink.startsWith("assets")
                              ? Image.asset(
                                  "assets/book.png",
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 175,
                                  fit: BoxFit.fill,
                                  repeat: ImageRepeat.repeatX,
                                )
                              : Image.network(
                                  sortedBooks[i].imageLink,
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 175,
                                  fit: BoxFit.fill,
                                  loadingBuilder:
                                      (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
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
                                ),
                        ),
                      ),
                    );
                  },
                  itemCount: sortedBooks.length,
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

  Future<bool> getAuthorsList() async {
    if (!kontrol) return false;
    var a = GoogleBooksService()
        .getGBooksFromAuthor(author: yazar!, startIndex: 0, getAllData: true, jumpIndex: loadedIndex)
        .then((value) {
      if (addBlock) {
        addBlock = false;
        return true;
      }
      if (value.isEmpty) {
        print("Yüklenemedi");
        return false;
      }
      if (value.isEmpty) {
        setState(() {
          isFinish = true;
        });
        return false;
      }
      for (var e in value) {
        var r = true;
        for (var be in books) {
          if (e.title == be.title) {
            r = false;
          }
        }

        if (r && !addBlock) {
          books.add(e);
          sortedBooks.add(e);
        }
      }
      return true;
    });
    setState(() {
      loadedIndex++;
      kontrol = false;
    });
    return a;
  }

  Future<bool> getCategoriesList() async {
    if (!kontrol) return false;
    var a = GoogleBooksService()
        .getGBooksFromCategori(
            categori: kategori!["name"]!, startIndex: 0, lang: "tr", getAllData: true, jumpIndex: loadedIndex)
        .then((value) {
      if (addBlock) {
        addBlock = false;
        return true;
      }
      if (value == null) {
        print("Yüklenemedi");
        return false;
      }
      if (value.isEmpty) {
        setState(() {
          isFinish = true;
        });
        return false;
      }
      for (var e in value) {
        var r = true;
        for (var be in books) {
          if (e.title == be.title) {
            r = false;
          }
        }

        if (r && !addBlock) {
          books.add(e);
          sortedBooks.add(e);
        }
      }
      return true;
    });
    setState(() {
      loadedIndex++;
      kontrol = false;
    });
    return a;
  }

  Future<bool> getBooksList() async {
    if (!kontrol) return false;
    if (addBlock) {
      setState(() {
        loadedIndex = 0;
      });
    }
    if (loadedIndex * 10 >= kitapListesi.length) {
      print("Bitti");
      return false;
    }
    List<Map<String, String>> liste = [];
    for (var i = loadedIndex * 10; i < (loadedIndex * 10 + 10); i++) {
      liste.add(kitapListesi[i]);
    }
    var a = Future.wait<BookModel?>(liste.map((e) {
      return GoogleBooksService().getGBookData(query: e["name"] ?? "", author: e["author"]);
    })).then((value) {
      if (addBlock) {
        addBlock = false;
        return true;
      }
      for (var element in value) {
        if (element != null && !addBlock) {
          books.add(element);
          sortedBooks.add(element);
        }
      }
      return true;
    });
    setState(() {
      loadedIndex++;
      kontrol = false;
    });
    return a;
  }
}
