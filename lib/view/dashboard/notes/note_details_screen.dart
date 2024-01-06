import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_tag_editor/tag_editor.dart';
import 'package:super_tag_editor/widgets/rich_text_widget.dart';
import "dart:math" as math;

import '../../../core/model/note_model.dart';
import '../../../core/viewmodel/note_repository.dart';

// ignore: must_be_immutable
class AddNotePage extends ConsumerStatefulWidget {
  int? index;
  Note? note;
  List<String>? seciliEtiketler;
  final String userId;
  AddNotePage({super.key, this.note, this.seciliEtiketler, this.index, required this.userId});

  @override
  ConsumerState<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends ConsumerState<AddNotePage> {
  TextEditingController header = TextEditingController();
  TextEditingController content = TextEditingController();
  late List<Color> currentBackgroundColor;
  late Box<Note> _noteBox;

  List<String> oneriler = [];
  List<String> secilenEtiketler = [];
  TextEditingController tagText = TextEditingController();

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
    currentBackgroundColor = NoteRepository().allGradients.first.map<Color>((e) => Color(e)).toList();
    if (widget.note != null) {
      header.text = widget.note!.head;
      content.text = widget.note!.content;
      currentBackgroundColor = widget.note!.gradientColors.map<Color>((e) => Color(e)).toList();
      secilenEtiketler.addAll(widget.note!.tags);
    } else {
      secilenEtiketler.addAll(widget.seciliEtiketler ?? []);
    }

    openHiveBox();
  }

  @override
  void dispose() {
    header.dispose();
    content.dispose();
    tagText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteRepository = ref.watch(noteRepositoryprovider);
    return WillPopScope(
      onWillPop: () {
        var a = Future.delayed(
          const Duration(seconds: 0),
          () async {
            if (widget.index == null) {
              if (content.text != "") {
                Note newNote = Note(
                    userId: widget.userId,
                    noteId: widget.userId,
                    content: content.text,
                    head: header.text,
                    gradientColors: currentBackgroundColor.map<int>((e) => e.value).toList(),
                    tags: secilenEtiketler,
                    time: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour,
                            DateTime.now().minute)
                        .toIso8601String());
                await ref.read(noteRepositoryprovider).addNote(newNote, _noteBox);
              }
              return;
            }
            Note updatedNote = Note(
                userId: widget.note!.userId,
                noteId: widget.note!.noteId,
                head: header.text,
                content: content.text,
                gradientColors: widget.note!.gradientColors,
                tags: secilenEtiketler,
                time: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour,
                        DateTime.now().minute)
                    .toIso8601String());
            await ref.read(noteRepositoryprovider).updateNote(updatedNote, _noteBox, widget.index!);
          },
        ).then((_) => true);
        return a;
      },
      child: Scaffold(
        backgroundColor: currentBackgroundColor.first,
        appBar: AppBar(
          backgroundColor: currentBackgroundColor.first,
          elevation: 0,
          foregroundColor: Colors.black,
          actions: [
            InkWell(
                onTap: () async {
                  if (widget.note != null) {
                    var randomColor =
                        noteRepository.allGradients[math.Random().nextInt(noteRepository.allGradients.length)];
                    setState(() {
                      currentBackgroundColor = randomColor.map<Color>((e) => Color(e)).toList();
                    });
                    widget.note!.gradientColors = randomColor;
                    if (widget.index == null) return;
                    await ref.read(noteRepositoryprovider).changeGradient(randomColor, _noteBox, widget.index!);
                    return;
                  }
                  setState(() {
                    currentBackgroundColor = noteRepository
                        .allGradients[math.Random().nextInt(noteRepository.allGradients.length)]
                        .map<Color>((e) => Color(e))
                        .toList();
                  });
                },
                child: const Icon(
                  Icons.palette,
                  size: 30,
                )),
            PopupMenuButton(
              color: currentBackgroundColor[1],
              icon: Icon(
                Icons.more_vert_rounded,
                color: Colors.grey.shade900,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: widget.index != null
                        ? () async {
                            if (widget.index != null) {
                              Note updatedNote = Note(
                                  userId: widget.note!.userId,
                                  noteId: widget.note!.noteId,
                                  head: header.text,
                                  content: content.text,
                                  gradientColors: widget.note!.gradientColors,
                                  tags: secilenEtiketler,
                                  time: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
                                          DateTime.now().hour, DateTime.now().minute)
                                      .toIso8601String());
                              await ref.read(noteRepositoryprovider).updateNote(updatedNote, _noteBox, widget.index!);
                            }
                          }
                        : null,
                    child: const ListTile(
                      title: Text("Kaydet"),
                      leading: Icon(Icons.save_rounded),
                    ),
                  ),
                  PopupMenuItem(
                    child: const ListTile(
                      title: Text("Sil"),
                      leading: Icon(Icons.delete),
                    ),
                    onTap: () async {
                      if (widget.index == null) return;
                      await ref.read(noteRepositoryprovider).removeNote(widget.index!, _noteBox).whenComplete(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                  PopupMenuItem(
                    child: const ListTile(
                      title: Text("Gönder"),
                      leading: Icon(Icons.share_rounded),
                    ),
                    onTap: () async {
                      final box = context.findRenderObject() as RenderBox?;
                      await Share.share(content.text,
                          subject: header.text, sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
                    },
                  ),
                ];
              },
            )
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 16, bottom: 8, top: 8),
              child: TextField(
                controller: header,
                decoration: InputDecoration.collapsed(
                    hintText: "Başlık",
                    hintStyle:
                        GoogleFonts.quicksand(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.grey.shade800),
                    border: InputBorder.none
                    // contentPadding: const EdgeInsets.all(8),
                    ),
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            // const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: buildTagEditor(widget.note),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 16, bottom: 8, top: 8),
              child: TextField(
                controller: content,
                minLines: null,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: "Yazmaya başla ...",
                    hintStyle: GoogleFonts.quicksand(fontSize: 17, color: Colors.grey.shade800),
                    // contentPadding: const EdgeInsets.all(8),
                    border: InputBorder.none),
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 17),
                cursorHeight: 25,
              ),
            )
          ],
        ),
      ),
    );
  }

  TagEditor<String> buildTagEditor(Note? note) {
    return TagEditor<String>(
      length: secilenEtiketler.length,
      controller: tagText,
      delimiters: const [','],
      hasAddButton: true,
      resetTextOnSubmitted: true,
      textStyle: GoogleFonts.quicksand(),
      onSubmitted: (outstandingValue) {
        setState(() {
          secilenEtiketler.add(outstandingValue);
        });
      },
      borderRadius: 25,
      // backgroundColor: currentBackgroundColor.last,
      inputDecoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: 'Etiketler...',
          hintStyle: GoogleFonts.quicksand(fontSize: 18)),
      onTagChanged: (newValue) {
        setState(() {
          secilenEtiketler.add(newValue);
        });
      },
      tagBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Chip(
          label: Text(
            secilenEtiketler[index],
            style: GoogleFonts.quicksand(color: Colors.grey.shade900),
          ),
          backgroundColor: currentBackgroundColor[1],
          onDeleted: () {
            setState(() {
              secilenEtiketler.removeAt(index);
            });
          },
        ),
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
      },
      onSelectOptionAction: (item) {
        setState(() {
          secilenEtiketler.add(item);
        });
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
