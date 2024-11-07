import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readmore/readmore.dart';

import '../../../core/model/book_model.dart';
import '../../../core/model/note_model.dart';
import '../../../core/viewmodel/book_repository.dart';
import '../../../core/viewmodel/note_repository.dart';
import '../../chat/groups/group_add_screen.dart';
import '../notes/note_screen.dart';
import '../favourites/reading_list_screen.dart';


class BookDetails extends ConsumerStatefulWidget {
  final BookModel book;
  final ScrollController scrollController;
  const BookDetails({super.key, required this.book, required this.scrollController});
  @override
  ConsumerState<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends ConsumerState<BookDetails> {
  late Box<BookModel> _bookBox;
  List<Note> bookNote = [];
  late BookModel book = widget.book;
  bool isFavorite = false;
  int? index;
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
        await Hive.initFlutter();
        await openHiveBox();
        await ref.read(bookRepositoryprovider).getAllFavBooks("1", _bookBox).then((val) {
          for (var i = 0; i < val.entries.length; i++) {
            if (val.entries.toList()[i].value.title == book.title) {
              setState(() {
                isFavorite = true;
                index = i;
              });
            }
          }
        });
        if (!Hive.isAdapterRegistered(0)) {
          Hive.registerAdapter<Note>(NotesAdapter());
        }
        var notes = await Hive.openBox<Note>('notes');
        await ref.read(noteRepositoryprovider).getNote("1", notes, widget.book.title).then((nots) {
          if (nots != null) bookNote = nots;
        });
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    !(_bookBox.isOpen) ? _bookBox.close() : null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bookRepository = ref.watch(bookRepositoryprovider);
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 10),
            child: Center(
              child: Container(
                width: 100,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: ColoredBox(
              color: Colors.white,
              child: Stack(
                children: [
                  Container(
                    height: 400,
                    padding: const EdgeInsets.only(top: 100),
                    width: size.width,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/background.jpg"),
                      fit: BoxFit.fitHeight,
                    )),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showImageViewer(
                                context,
                                book.imageLink.startsWith("assets")
                                    ? Image.asset("assets/book.png").image
                                    : Image.network(book.imageLink).image,
                                backgroundColor: Colors.white,
                                closeButtonColor: Colors.black, onViewerDismissed: () {
                              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                                  overlays: SystemUiOverlay.values);
                            });
                          },
                          child: Hero(
                            tag: book,
                            child: Container(
                                height: 150,
                                width: size.width / 3,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: book.imageLink.startsWith("assets")
                                        ? const AssetImage("assets/book.png")
                                        : NetworkImage(book.imageLink) as ImageProvider,
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: size.width / 2,
                          child: Center(
                            child: Text(
                              book.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style:
                                  GoogleFonts.quicksand(fontWeight: FontWeight.w800, fontSize: 17, color: Colors.black),
                            ),
                          ),
                        ),
                        Center(
                            child: Text(
                          book.author,
                          style: GoogleFonts.quicksand(
                              fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey.shade700),
                        )),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width,
                    child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                        tileColor: Colors.transparent,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  // String img = book.imageLink;
                                  // final response = await http.get(Uri.parse(img));

                                  // final documentDirectory = await getApplicationDocumentsDirectory();

                                  // final file = File(join(documentDirectory.path, 'imagetest.png'));
                                  // var notes = await Hive.openBox<Note>('notes');
                                  // await ref
                                  //     .read(noteRepositoryprovider)
                                  //     .getNote("1", notes, widget.book.title)
                                  //     .then((nots) {
                                  //   if (nots != null) bookNote = nots;
                                  // });
                                  // file.writeAsBytesSync(response.bodyBytes);

                                  // final box = context.findRenderObject() as RenderBox?;
                                  // await Share.shareXFiles(
                                  //   [XFile(file.path)],
                                  //   text: widget.book.title,
                                  //   sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                                  // );
                                },
                                icon: const Icon(Icons.share)),
                            IconButton(
                                onPressed: () async {
                                  if (isFavorite) {
                                    if (index == null) {
                                      await ref.read(bookRepositoryprovider).getAllFavBooks("1", _bookBox).then((val) {
                                        for (var i = 0; i < val.entries.length; i++) {
                                          if (val.entries.toList()[i].value.title == book.title) {
                                            setState(() {
                                              isFavorite = true;
                                              index = i;
                                            });
                                          }
                                        }
                                      });
                                    }
                                    await ref.read(bookRepositoryprovider).removebook(_bookBox, index!).then((value) {
                                      final snackBar = SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.orange,
                                        content: ListTile(
                                          title: const Text('Favorilerden Kaldırıldı'),
                                          subtitle: Text('${book.title} favori kitaplığına veda etti.'),
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                      setState(() {
                                        isFavorite = false;
                                      });
                                    });
                                  } else {
                                    await ref
                                        .read(bookRepositoryprovider)
                                        .addbook(bookBox: _bookBox, newbook: book, favTag: "fav")
                                        .then((value) {
                                      final snackBar = SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.green.shade800,
                                        content: SizedBox(
                                          width: size.width,
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: const Text('Favori kitaplığına eklendi'),
                                            trailing: FilledButton.icon(
                                              onPressed: () async {
                                                await favEditDialog(book, _bookBox, size.width - 50, bookRepository)
                                                    .then((val) async => await showDialog(
                                                          context: context,
                                                          builder: (context) => val,
                                                        ));
                                              },
                                              icon: const Icon(Icons.edit),
                                              label: const Text("Düzenle"),
                                              style: const ButtonStyle(
                                                  backgroundColor: WidgetStatePropertyAll(Colors.green)),
                                            ),
                                          ),
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                      setState(() {
                                        isFavorite = true;
                                      });
                                    });
                                  }
                                },
                                icon: Icon(isFavorite ? Icons.bookmark_added_rounded : Icons.bookmark_add_outlined)),
                            PopupMenuButton(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.zero,
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                              ),
                              offset: const Offset(0, 50),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: const Text("Grupları düzenle"),
                                    onTap: () async {
                                      await favEditDialog(book, _bookBox, size.width - 50, bookRepository)
                                          .then((val) async => await showDialog(
                                                context: context,
                                                builder: (context) => val,
                                              ));
                                    },
                                  ),
                                  const PopupMenuItem(child: Text("Diğer Bilgiler"))
                                ];
                              },
                            )
                          ],
                        ),
                        leading: const BackButton(
                          color: Color.fromRGBO(33, 33, 33, 1),
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: ColoredBox(
                      color: Colors.grey.shade50,
                      child: const Text(""),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 25,
                    left: 25,
                    child: Container(
                      height: 70,
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        border: Border.all(width: 0.1, color: Colors.deepOrange.shade100),
                      ),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                            width: 75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "0.0",
                                  style: GoogleFonts.quicksand(
                                      color: Colors.deepOrange.shade200, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                Text(
                                  "Skor",
                                  style: GoogleFonts.quicksand(color: Colors.grey.shade800),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  book.country,
                                  style: GoogleFonts.quicksand(
                                      color: Colors.deepOrange.shade200, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                Text(
                                  "Ülke",
                                  style: GoogleFonts.quicksand(color: Colors.grey.shade800),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  book.pageCount,
                                  style: GoogleFonts.quicksand(
                                      color: Colors.deepOrange.shade200, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                Text(
                                  "Sayfa Sayısı",
                                  style: GoogleFonts.quicksand(color: Colors.grey.shade800),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  book.language.toUpperCase(),
                                  style: GoogleFonts.quicksand(
                                      color: Colors.deepOrange.shade200, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                Text(
                                  "Dil",
                                  style: GoogleFonts.quicksand(color: Colors.grey.shade800),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ColoredBox(
            color: Colors.grey.shade50,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 8.0, left: 8),
                        child: Text(
                          "Açıklama",
                          style: GoogleFonts.quicksand(
                              color: Colors.grey.shade900, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ReadMoreText(
                          (book.description == "-" && book.subtitle == "-") ? "Açıklama yok...." : book.description,
                          trimCollapsedText: 'Devamını gör...',
                          trimExpandedText: ' Yazıyı küçült',
                          // moreStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          colorClickableText: Colors.pink,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      book.subtitle != "-"
                          ? Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                book.subtitle,
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: borderedContainer(
                      color: Colors.grey.shade100,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(top: 8.0, left: 8),
                                child: Text(
                                  "Notlarım",
                                  style: GoogleFonts.quicksand(
                                      color: Colors.grey.shade900, fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                              IconButton.filled(
                                onPressed: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NotePage(
                                          seciliEtiketler: [book.title],
                                        ),
                                      )).then((_) async {
                                    openHiveBox();
                                    if (!Hive.isAdapterRegistered(0)) {
                                      Hive.registerAdapter<Note>(NotesAdapter());
                                    }
                                    var notes = await Hive.openBox<Note>('notes');
                                    await ref.read(noteRepositoryprovider).getNote("1", notes, book.title).then((nots) {
                                      if (nots != null) bookNote = nots;
                                    });
                                    setState(() {});
                                  });
                                },
                                icon: const Icon(Icons.add_box_rounded),
                                style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white60)),
                                color: Colors.grey.shade700,
                              )
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 2, left: 10, right: 10, bottom: 2),
                            height: 100,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: bookNote.isEmpty ? 1 : bookNote.length,
                                itemBuilder: (context, index) {
                                  if (bookNote.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Not yok..."),
                                    );
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NotePage(
                                                seciliEtiketler: [book.title],
                                              ),
                                            ));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange.shade50,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(0, -2),
                                                  blurRadius: 20,
                                                  color: Colors.orange.shade100)
                                            ]),
                                        child: SizedBox(
                                          width: 100,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                bookNote[index].head,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 8.0, left: 8),
                    child: Text(
                      "Keşfet",
                      style:
                          GoogleFonts.quicksand(color: Colors.grey.shade900, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: size.width,
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Colors.grey.shade50),
                                foregroundColor: const WidgetStatePropertyAll(Colors.blue)),
                            child: const Text("Gruplara Git")),
                      ),
                      SizedBox(
                        width: size.width,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.grey.shade50),
                              foregroundColor: const WidgetStatePropertyAll(Colors.blue)),
                          child: const Text("Paylaşımlara Git"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 150,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<StatefulBuilder> favEditDialog(
    BookModel favBook, Box<BookModel> favBox, double width, BookRepository bookRepository) async {
  var favList = await BookRepository().getAllFavListBooks(userId: "1", favoriteBox: favBox);

  var allList = BookRepository().getAllFavListBookNames(favBox);
  List<bool> checkList = List.generate(allList.length, (index) => false);
  for (var i = 0; i < favList.entries.length; i++) {
    for (var j = 0; j < favList.entries.toList()[i].value.length; j++) {
      if (favList.entries.toList()[i].value[j].title.trim().toLowerCase() == favBook.title.trim().toLowerCase()) {
        try {
          checkList[allList.indexOf(favList.entries.toList()[i].key)] = true;
          print(favList.entries.toList()[i].key);
        } catch (e) {
          print(e);
        }
      }
    }
  }
  return StatefulBuilder(
    builder: (context, setState) => SimpleDialog(
      backgroundColor: Colors.white,
      title: ListTile(
        title: Text(favBook.title),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.green.shade100,
        trailing: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check,
              color: Colors.green,
            ),
            Text("seçili")
          ],
        ),
        leading: favBook.imageLink.startsWith("assets")
            ? Image.asset(
                "assets/book.png",
                width: 50,
                height: 75,
              )
            : Image.network(
                favBook.imageLink,
                width: 50,
                height: 75,
              ),
      ),
      children: [
        SizedBox(
          height: 300,
          width: width,
          child: ListView.separated(
              itemBuilder: (context, i) {
                if (allList.isEmpty) {
                  return const Center(child: Text("Henüz favori kitaplığınız yok"));
                }
                return CheckboxListTile(
                  value: checkList[i],
                  onChanged: (value) async {
                    if (value == null) return;
                    if (value) {
                      print("${favBook.title}, ${allList[i]} listesine ekleniyor");
                      await bookRepository.addbook(
                          newbook: favBook, bookBox: favBox, favName: allList[i], favTag: "list");
                    } else {
                      print("${favBook.title}, ${allList[i]} listesinden siliniyor");
                      await bookRepository.removeFavListBook(favBox, favBook, allList[i]);
                    }
                    setState(() {
                      checkList[i] = value;
                    });
                  },
                  title: Text(
                    allList[i],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: allList.isEmpty ? 1 : allList.length),
        ),
        ListTile(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_box_outlined),
              Text("Yeni Kitaplık oluştur"),
            ],
          ),
          onTap: () async {
            Navigator.pop(context);
            await showDialog(context: context, builder: (context) => favListAddDialog(width, context, favBox));
          },
        )
      ],
    ),
  );
}
