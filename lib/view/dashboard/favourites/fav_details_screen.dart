// ignore_for_file: must_be_immutable

import 'package:blur/blur.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
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
import '../../../core/viewmodel/utils.dart';
import '../booksearch/book_details_screen.dart';
import '../booksearch/book_finder_screen.dart';

class FavDetails extends ConsumerStatefulWidget {
  String favListName;
  final ScrollController scrollController;
  FavDetails({super.key, required this.favListName, required this.scrollController});
  @override
  ConsumerState<FavDetails> createState() => _FavDetailsState();
}

class _FavDetailsState extends ConsumerState<FavDetails> {
  late final Box<BookModel> favBox;
  Map<String, List<BookModel>> favData = {"": []};
  bool editMode = false;
  bool spamP = true;
  Future<void> getFavList() async {
    try {
      favBox = await Hive.openBox("books");
    } catch (e) {}
    await ref
        .read(bookRepositoryprovider)
        .getAllFavListBooks(userId: "1", favoriteBox: favBox, favListName: widget.favListName)
        .then((value) => setState(() {
              favData = value;
              // print(value);
            }));
  }

  @override
  void initState() {
    super.initState();
    getFavList();
  }

  @override
  void dispose() {
    super.dispose();
    favBox.close();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    return ColoredBox(
      color: Colors.white,
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: favData.entries.toList().first.value.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 10),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  child: ColoredBox(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Center(
                            child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.favListName.toUpperCase(),
                              style: GoogleFonts.quicksand(fontSize: 25, fontWeight: FontWeight.w700),
                            ),
                            editMode
                                ? FilledButton.icon(
                                    label: const Text("Listeyi sil"),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return NAlertDialog(
                                              backgroundColor: Colors.white,
                                              title: const Text("Favori Listesi Silme"),
                                              content: Text(
                                                  "\"${widget.favListName}\" isimli favori listenizi silmek istediğinize emin misiniz ?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      if (spamP) {
                                                        setState(() {
                                                          spamP = false;
                                                        });
                                                        await ref
                                                            .read(bookRepositoryprovider)
                                                            .removeFavList(favBox, widget.favListName)
                                                            .then((value) {
                                                          setState(() {
                                                            spamP = true;
                                                          });
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                        }).catchError((e) {
                                                          setState(() {
                                                            spamP = true;
                                                          });
                                                        });
                                                      }
                                                    },
                                                    child: const Text("Listeyi Sil")),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("İptal"))
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.delete_forever))
                                : const SizedBox.shrink()
                          ],
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                widget.scrollController.animateTo(
                                  0, // Hedef pozisyon (en yukarı)
                                  duration: const Duration(milliseconds: 500), // Animasyon süresi
                                  curve: Curves.easeInOut, // Animasyon eğrisi
                                );
                                setState(() {
                                  editMode = !editMode;
                                });
                              },
                              label: Text(
                                "Düzenle",
                                style: GoogleFonts.quicksand(color: Colors.black),
                              ),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${favData.entries.toList().first.value.length} kitap",
                                    style: GoogleFonts.quicksand(
                                        decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const BookFinderScreen(),
                                            ));
                                      },
                                      icon: const Icon(Icons.add_box_outlined))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
          index--;
          return ColoredBox(
            color: Colors.white,
            child: ZoomTapAnimation(
              onTap: !editMode
                  ? () async {
                      await getNote(favData.entries.toList().first.value[index].title)
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
                                          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                      child: BookDetails(
                                          book: favData.entries.toList().first.value[index],
                                          scrollController: scrollController)
                                      // buildBookDetails(suggestion, size, scrollController, notes)
                                      );
                                },
                                anchors: [0, 1],
                                isSafeArea: true,
                              ));
                    }
                  : null,
              child: Stack(
                children: [
                  Blur(
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
                                tag: favData.entries.toList().first.value[index],
                                child: favData.entries.toList().first.value[index].imageLink.startsWith("assets")
                                    ? Image.asset(
                                        "assets/book.png",
                                        width: 100,
                                        height: 175,
                                        fit: BoxFit.fitWidth,
                                      )
                                    : Image.network(
                                        favData.entries.toList().first.value[index].imageLink,
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
                                        favData.entries.toList().first.value[index].title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey.shade900),
                                      ),
                                      Text(favData.entries.toList().first.value[index].author,
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade700)),
                                    ],
                                  ),
                                ),
                              )
                            ]),
                      ),
                      child: !favData.entries.toList().first.value[index].imageLink.startsWith("assets")
                          ? Image.network(
                              favData.entries.toList().first.value[index].imageLink,
                              width: MediaQuery.sizeOf(context).width,
                              height: 175,
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return SizedBox(
                                  height: 175,
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
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
                  editMode
                      ? SizedBox(
                          height: 175,
                          child: ColoredBox(
                            color: Colors.grey.withOpacity(0.4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                    onPressed: () async {
                                      if (spamP) {
                                        setState(() {
                                          spamP = false;
                                        });
                                        await ref
                                            .read(bookRepositoryprovider)
                                            .removeFavListBook(
                                                favBox, favData.entries.toList().first.value[index], widget.favListName)
                                            .then((_) async {
                                          await ref
                                              .read(bookRepositoryprovider)
                                              .getAllFavListBooks(
                                                  userId: "1", favoriteBox: favBox, favListName: widget.favListName)
                                              .then((data) {
                                            setState(() {
                                              spamP = true;
                                              favData = data;
                                            });
                                          }).catchError((e) {
                                            setState(() {
                                              spamP = true;
                                            });
                                          });
                                        }).catchError((e) {
                                          setState(() {
                                            spamP = true;
                                          });
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.remove_circle),
                                    label: const Text("Sil")),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton.icon(
                                        onPressed: index != 0
                                            ? () async {
                                                if (spamP) {
                                                  setState(() {
                                                    spamP = false;
                                                  });
                                                  await ref
                                                      .read(bookRepositoryprovider)
                                                      .indexChangeFavListBook(
                                                          bookBox: favBox,
                                                          upBook: favData.entries.toList().first.value[index],
                                                          downBook: favData.entries.toList().first.value[index - 1],
                                                          favListName: widget.favListName)
                                                      .then((data) {
                                                    setState(() {
                                                      favData = data;
                                                    });
                                                    startDelay().then((value) {
                                                      setState(() {
                                                        spamP = true;
                                                      });
                                                    });
                                                  }).catchError((e) {
                                                    setState(() {
                                                      spamP = true;
                                                    });
                                                  });
                                                }
                                              }
                                            : null,
                                        icon: const Icon(Icons.arrow_circle_up_rounded),
                                        label: const Text("Yukarı Taşı")),
                                    ElevatedButton.icon(
                                        onPressed: index != favData.entries.toList().first.value.length - 1
                                            ? () async {
                                                if (spamP) {
                                                  setState(() {
                                                    spamP = false;
                                                  });
                                                  await ref
                                                      .read(bookRepositoryprovider)
                                                      .indexChangeFavListBook(
                                                          bookBox: favBox,
                                                          upBook: favData.entries.toList().first.value[index],
                                                          downBook: favData.entries.toList().first.value[index + 1],
                                                          favListName: widget.favListName)
                                                      .then((data) {
                                                    setState(() {
                                                      favData = data;
                                                    });
                                                    startDelay().then((value) {
                                                      setState(() {
                                                        favData = data;
                                                        spamP = true;
                                                      });
                                                    });
                                                  }).catchError((e) {
                                                    setState(() {
                                                      spamP = true;
                                                    });
                                                  });
                                                }

                                                await Future.delayed(const Duration(seconds: 5));
                                              }
                                            : null,
                                        icon: const Icon(Icons.arrow_circle_down_rounded),
                                        label: const Text("Aşağı Taşı")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          );
        },
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
}
