import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import 'package:super_tag_editor/tag_editor.dart';
import 'package:super_tag_editor/widgets/rich_text_widget.dart';

import '../../../core/model/note_model.dart';
import '../../../core/viewmodel/note_repository.dart';
import '../../../core/viewmodel/utils.dart';
import 'note_details_screen.dart';
import 'note_settings_screen.dart';

// ignore: must_be_immutable
class NotePage extends ConsumerStatefulWidget {
  List<String>? seciliEtiketler;
  NotePage({super.key, this.seciliEtiketler});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotePageState();
}

class _NotePageState extends ConsumerState<NotePage> {
  late Box<Note> _noteBox;
  TextEditingController search = TextEditingController();
  List<String> secilenEtiketler = [];
  List<String> oneriler = [];
  bool yuklendiMi = false;
  TextEditingController tagText = TextEditingController();
  List<Note> filteredNotes = [];
  FocusNode tagFocus = FocusNode();

  Future<void> openHiveBox() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter<Note>(NotesAdapter());
    }
    await Hive.openBox<Note>('notes');
    _noteBox = Hive.box<Note>('notes');
  }

  @override
  void initState() {
    super.initState();
    widget.seciliEtiketler != null ? secilenEtiketler.addAll(widget.seciliEtiketler!) : null;
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        await Hive.initFlutter();
        await openHiveBox();
      },
    ).whenComplete(() async {
      setState(() {
        yuklendiMi = true;
      });
      await ref.read(noteRepositoryprovider).getAllNotes("1", _noteBox).whenComplete(() {
        setState(() {
          filteredNotes.clear();
          filteredNotes.addAll(ref.read(noteRepositoryprovider).refreshNotes(secilenEtiketler));
        });
      });
    });
  }

  @override
  void dispose() {
    _noteBox.close();
    search.dispose();
    Hive.close();
    tagText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteRepository = ref.watch(noteRepositoryprovider);
    return !yuklendiMi
        ? const Scaffold(
            backgroundColor: Color.fromRGBO(255, 248, 225, 1),
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: Colors.amber.shade50,
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  // SliverAppBar(
                  //   backgroundColor: Colors.amber.shade50,
                  //   foregroundColor: Colors.grey.shade800,
                  //   expandedHeight: 75,
                  // ),
                  SliverAppBar(
                    backgroundColor: Colors.amber.shade50,
                    foregroundColor: Colors.grey.shade800,
                    floating: true,
                    pinned: true,
                    snap: false,
                    leading: IconButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    expandedHeight: 225,
                    // leading: const SizedBox.shrink(),
                    bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(75),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildTagEditor(noteRepository),
                        )),
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [StretchMode.fadeTitle],
                      titlePadding: const EdgeInsetsDirectional.only(start: 32, bottom: 75),
                      title: Text(
                        "Notlarım",
                        style: GoogleFonts.quicksand(fontSize: 25, color: Colors.grey.shade800),
                      ),
                      // collapseMode: CollapseMode.pin,
                    ),
                  ),
                ];
              },
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: ReorderableGridView.count(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      onReorder: (oldIndex, newIndex) async {
                        await ref.read(noteRepositoryprovider).indexChangeNote(oldIndex, newIndex, _noteBox);
                        setState(() {
                          refreshFilter(noteRepository);
                          // filteredNotes = ref.read(noteRepositoryprovider).refreshNotes(secilenEtiketler);
                        });
                      },
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                      header: filteredNotes.isEmpty ? [const Center(child: Text("Burada bişey yok"))] : null,
                      dragWidgetBuilder: (index, child) {
                        return Material(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: NoteCard(
                            key: ValueKey(filteredNotes[index]),
                            note: filteredNotes[index],
                          ),
                        );
                      },
                      children: List.generate(
                        filteredNotes.length,
                        (index) {
                          return InkWell(
                            key: ValueKey(filteredNotes[index]),
                            onTap: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddNotePage(
                                      userId: "1",
                                      index: index,
                                      note: filteredNotes[index],
                                    ),
                                  )).then((value) async {
                                await ref.read(noteRepositoryprovider).getAllNotes("1", _noteBox).whenComplete(() {
                                  setState(() {
                                    filteredNotes.clear();
                                    filteredNotes
                                        .addAll(ref.read(noteRepositoryprovider).refreshNotes(secilenEtiketler));
                                  });
                                });
                              });
                            },
                            child: NoteCard(
                              note: filteredNotes[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
                isExtended: true,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNotePage(
                          userId: "1",
                          seciliEtiketler: secilenEtiketler,
                        ),
                      )).then((value) async {
                    await ref.read(noteRepositoryprovider).getAllNotes("1", _noteBox).whenComplete(() {
                      setState(() {
                        filteredNotes.clear();
                        filteredNotes.addAll(ref.read(noteRepositoryprovider).refreshNotes(secilenEtiketler));
                      });
                    });
                  });
                },
                backgroundColor: Colors.amber.shade50,
                child: const Icon(
                  Icons.add,
                  color: Color.fromRGBO(255, 111, 0, 1),
                )),
            // floatingActionButton: SizedBox(
            //   height: 250,
            //   child: Column(
            //     children: [
            //       FloatingActionButton(
            //         heroTag: const ValueKey("dene1"),
            //         onPressed: () async {
            //           await noteRepository.getAllNotes("1", _noteBox);
            //           refreshFilter(noteRepository);
            //           // Navigator.push(
            //           //     context,
            //           //     MaterialPageRoute(
            //           //       builder: (context) => AddNotePage(),
            //           //     ));
            //         },
            //         backgroundColor: Colors.blue,
            //         child: const Text("Not Getir"),
            //       ),
            //       FloatingActionButton(
            //         heroTag: const ValueKey("dene"),
            //         onPressed: () async {
            //           await noteRepository.addNote(
            //               Note(
            //                   userId: "1",
            //                   noteId: "1",
            //                   head: "Deneme",
            //                   content: "Deneme 1-2-3-5-6",
            //                   gradientColors: noteRepository.allGradients[0],
            //                   tags: ["deneme"],
            //                   time: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            //                           DateTime.now().hour, DateTime.now().minute)
            //                       .toIso8601String()),
            //               _noteBox);
            //         },
            //         backgroundColor: Colors.grey.shade700,
            //         child: const Text("Not Ekle"),
            //       ),
            //       FloatingActionButton(
            //         heroTag: const ValueKey("dene2"),
            //         onPressed: () async {
            //           Hive.deleteBoxFromDisk("notes");
            //         },
            //         backgroundColor: Colors.grey.shade700,
            //         child: const Text("Herşeyi sıfırla"),
            //       ),
            //     ],
            //   ),
            // ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.black,
              padding: EdgeInsets.zero,
              height: 70,
              elevation: 20,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              notchMargin: 10,
              shape: const CircularNotchedRectangle(),
              child: BottomNavigationBar(
                  iconSize: 30,
                  onTap: (value) async {
                    if (value == 0) {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NoteSettings(),
                          )).then((value) async {
                        if (!Hive.isBoxOpen("notes")) {
                          _noteBox = await Hive.openBox<Note>("notes").whenComplete(() {
                            setState(() {});
                          });
                        }
                        await ref.read(noteRepositoryprovider).getAllNotes("1", _noteBox);
                      });
                    } else if (value == 1) {
                      setState(() {
                        FocusScope.of(context).requestFocus(tagFocus);
                      });
                    }
                  },
                  elevation: 0,
                  backgroundColor: Colors.amber.shade50,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.bars, color: Colors.grey.shade900), label: "", tooltip: "Ayarlar"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search, color: Colors.grey.shade900), label: "", tooltip: "Arama")
                  ]),
            ),
          );
  }

  void refreshFilter(NoteRepository noteRepository) {
    //En son aynı tag'i yazınca notları ikilediğini gördük. Yani 2 kere dene yazıyorsun o orda iki tane deneme açıyor gibi bir hata.
    filteredNotes.clear();
    var notes = noteRepository.notes;
    List<String> uniqueList = [];
    Set<String> seen = <String>{};

    for (String item in secilenEtiketler) {
      if (!seen.contains(item)) {
        uniqueList.add(item);
        seen.add(item);
      }
    }
    secilenEtiketler.clear();
    secilenEtiketler.addAll(uniqueList);
    // ignore: prefer_is_empty
    if (secilenEtiketler.length == 0) {
      filteredNotes.clear();
      filteredNotes.addAll(notes);
      // print("burada");
    } else {
      for (var i = 0; i < notes.length; i++) {
        for (var j = 0; j < notes[i].tags.length; j++) {
          for (var k = 0; k < secilenEtiketler.length; k++) {
            // print("değerlendirme:${notes[i].tags[j]} aranan:${secilenEtiketler[k]} i:$i j:$j k:$k");
            // print("note tag length:${notes[i].tags.length}");
            // print("arama length:${secilenEtiketler.length}");
            // if (notes[i].tags[j].toLowerCase().contains(secilenEtiketler[k].toLowerCase())) {
            if (isSimilar(notes[i].tags[j].trim().toLowerCase(), secilenEtiketler[k].trim().toLowerCase(), 0.8)) {
              bool ekleme = true;
              for (var e in filteredNotes) {
                if (e.noteId == notes[i].noteId) {
                  ekleme = false;
                }
              }
              if (ekleme) {
                filteredNotes.add(notes[i]);
              }
              // print("${notes[i].tags[j]} eşleşti");
            }
          }
        }
      }
    }

    setState(() {});
  }

  TagEditor<String> buildTagEditor(NoteRepository noteRepository) {
    return TagEditor<String>(
      focusNode: tagFocus,
      length: secilenEtiketler.length,
      controller: tagText,
      delimiters: const [','],
      resetTextOnSubmitted: true,

      onSubmitted: (outstandingValue) {
        setState(() {
          secilenEtiketler.add(outstandingValue);
        });
        refreshFilter(noteRepository);
      },
      autofocus: false,
      // backgroundColor: Colors.white60,
      backgroundColor: Colors.amber.shade100,
      // enableBorderColor: Colors.black,
      // focusedBorderColor: Colors.black,
      borderRadius: 25,
      padding: const EdgeInsets.only(left: 15),
      inputDecoration: InputDecoration(
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          border: InputBorder.none,
          hintText: 'Etiket ara...',
          suffixIconColor: Colors.black,
          iconColor: Colors.black,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                secilenEtiketler.add(tagText.text);
                tagText.clear();
              });
              refreshFilter(noteRepository);
            },
          ),
          hintStyle: GoogleFonts.quicksand(fontSize: 20)),
      onTagChanged: (newValue) {
        setState(() {
          secilenEtiketler.add(newValue);
        });
        refreshFilter(noteRepository);
      },
      tagBuilder: (context, index) => Chip(
        label: Text(
          secilenEtiketler[index],
          style: GoogleFonts.quicksand(color: Colors.white),
        ),
        backgroundColor: Colors.amber,
        onDeleted: () {
          setState(() {
            secilenEtiketler.removeAt(index);
          });
          refreshFilter(noteRepository);
        },
      ),
      // InputFormatters example, this disallow \ and /
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))],
      useDefaultHighlight: false,
      suggestionBuilder: (context, state, data, index, length, highlight, suggestionValid) {
        var borderRadius = const BorderRadius.all(Radius.circular(20));
        if (index == 0) {
          borderRadius = const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          );
        } else if (index == length - 1) {
          borderRadius = const BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          );
        }
        return InkWell(
          onTap: () {
            setState(() {
              secilenEtiketler.add(data);
            });
            state.resetTextField();
            state.closeSuggestionBox();
          },
          child: Container(
              decoration:
                  highlight ? BoxDecoration(color: Theme.of(context).focusColor, borderRadius: borderRadius) : null,
              padding: const EdgeInsets.all(16),
              child: RichTextWidget(
                wordSearched: suggestionValid ?? '',
                textOrigin: data,
              )),
        );
      },
      onFocusTagAction: (focused) {
        setState(() {});
      },
      onDeleteTagAction: () {
        if (secilenEtiketler.isNotEmpty) {
          setState(() {
            secilenEtiketler.removeLast();
          });
        }
        refreshFilter(noteRepository);
      },
      onSelectOptionAction: (item) {
        setState(() {
          secilenEtiketler.add(item);
        });
        refreshFilter(noteRepository);
      },
      suggestionsBoxElevation: 10,
      findSuggestions: (String query) {
        if (query.isNotEmpty) {
          var lowercaseQuery = query.toLowerCase();
          return oneriler.where((profile) {
            return profile.toLowerCase().contains(query.toLowerCase()) ||
                profile.toLowerCase().contains(query.toLowerCase());
          }).toList(growable: false)
            ..sort(
                (a, b) => a.toLowerCase().indexOf(lowercaseQuery).compareTo(b.toLowerCase().indexOf(lowercaseQuery)));
        }
        return [];
      },
    );
  }
}

// Diğer sınıflar aynı kalacak

class NoteCard extends ConsumerWidget {
  final Note note;
  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: note.gradientColors.map((e) => Color(e)).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, -15),
                spreadRadius: -10,
                blurRadius: 10,
                blurStyle: BlurStyle.solid,
                color: Color(note.gradientColors.last))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              note.head == "" ? "..." : note.head,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                note.content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Flexible(
              flex: 3,
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade900, width: 0.7)),
                  child: Text(getRelativeTime(DateTime.parse(note.time)))))
        ],
      ),
    );
  }
}
