import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/note_model.dart';
import 'utils.dart';

class NoteRepository extends ChangeNotifier {
  List<Note> notes = [
    // Note(
    //     userId: "1",
    //     noteId: "1",
    //     head: 'Yaban kitabı ilk',
    //     content:
    //         "Yaban kitabında, Osmanlı İmparatorluğu'nun son dönemlerinde yaşanan toplumsal ve siyasi değişimler etrafında şekillenen bir hikaye anlatılır.Roman, Ahmet Celâl adlı bir genç adamın İstanbul'dan Anadolu'ya dönüşünü ve çevresindeki insanlarla olan ilişkilerini ele alır.Yaban, modernleşmenin getirdiği çatışmaları, gelenek ve batılılaşma arasındaki gerilimi ve dönemin toplumsal yapıları üzerinden okuyucuya aktarır.Kitap, dönemin siyasi atmosferine ve toplumsal sorunlarına derin bir bakış sunarak, okuyucuyu düşündürmeye ve sorgulamaya yönlendirir.",
    //     gradientColors: [0xFF757575, 0xFF424242],
    //     tags: ["Yaban"]),
    // Note(
    //     userId: "1",
    //     noteId: "2",
    //     head: 'Sefiller gerçektende sefiller mi',
    //     content:
    //         '"Sefiller" Victor Hugo tarafından yazılan ünlü bir romandır. Bu epik roman, Fransız Devrimi döneminde geçer ve adalet, ahlak, aşk ve insanlık gibi evrensel temaları ele alır. "Sefiller", etkileyici bir anlatıyla okuyuculara derin duygusal deneyimler sunar.',
    //     gradientColors: [0xFFFFF176, 0xFFF9A825],
    //     tags: ["Sefiller"]),
    // Note(
    //     userId: "1",
    //     noteId: "3",
    //     head: '1984 kitabı yorumlama',
    //     content:
    //         'George Orwell tarafından yazılan ve distopik bir geleceği konu alan önemli bir roman olarak kabul edilir. Kitap, totaliter bir rejimin hüküm sürdüğü Oceania adlı bir devlette geçer. Roman, bireysel özgürlüklerin sınırlanması, düşünce kontrolü ve devletin insanların her hareketini izlemesi gibi kavramları ele alır.',
    //     gradientColors: [0xFFF48FB1, 0xFFE91E63],
    //     tags: ["1984"]),
    // Note(
    //     userId: "1",
    //     noteId: "4",
    //     head: 'Sefiller Egzersiz Planı',
    //     content: 'Koşu: 30 dakika\nYoga: 1 saat',
    //     gradientColors: [0xFFAB9101, 0xFFBF360C],
    //     tags: ["Sefiller"]),
    // Note(
    //     userId: "1",
    //     noteId: "5",
    //     head: '1984 Alışveriş Listesi',
    //     content:
    //         'George Orwell tarafından yazılan ve distopik bir geleceği konu alan önemli bir roman olarak kabul edilir. Kitap, totaliter bir rejimin hüküm sürdüğü Oceania adlı bir devlette geçer. Roman, bireysel özgürlüklerin sınırlanması, düşünce kontrolü ve devletin insanların her hareketini izlemesi gibi kavramları ele alır.',
    //     gradientColors: [0xFFAB9101, 0xFFBF360C],
    //     tags: ["1984"]),
    // Note(
    //     userId: "1",
    //     noteId: "6",
    //     head: '1984 Egzersiz Planı',
    //     content: 'Koşu: 30 dakika\nYoga: 1 saat',
    //     gradientColors: [0xFF1976D2, 0xFF0D47A1],
    //     tags: ["1984"]),
    // Diğer notlar...
  ];

  List<List<int>> allGradients = [
    [0xFF81C784, 0xFFAED581],
    [0xFF81C784, 0xFFAED581], // Yeşil tonları
    [0xFFAED581, 0xFF81C784], // Lime tonları
    [0xFF1976D2, 0xFF0D47A1],
    [0xFFAB9101, 0xFFBF360C],
    [0xFF607D8B, 0xFF455A64],
    [0xFFF48FB1, 0xFFE91E63],
    [0xFFFFF176, 0xFFF9A825],
    [0xFF757575, 0xFF424242],
    [0xFFE57373, 0xFFF06292], // Pembe tonları
    [0xFFBA68C8, 0xFF9575CD], // Mor tonları
    [0xFF4DB6AC, 0xFF80CBC4], // Turkuaz tonları
    [0xFF9575CD, 0xFF7986CB], // Lavanta tonları
    [0xFF64B5F6, 0xFF4FC3F7], // Mavi tonları
    [0xFF4DD0E1, 0xFF4DB6AC], // Mercan tonları
    [0xFFDCE775, 0xFFFFF176], // Sarı tonları
    [0xFFFFD54F, 0xFFFFB74D], // Portakal tonları
    [0xFFFF8A65, 0xFFFF7043], // Koyu turuncu tonları
    [0xFFFF8A80, 0xFFFF5252], // Ateş kırmızısı tonları
    [0xFFBDBDBD, 0xFF9E9E9E], // Gri tonları
    [0xFF90A4AE, 0xFF78909C], // Mavi-gri tonları
    [0xFFB39DDB, 0xFF9575CD], // Menekşe tonları
    [0xFFE57373, 0xFFBA68C8], // Turuncu tonları
    [0xFF4DB6AC, 0xFF64B5F6], // Cyan tonları
    [0xFF80CBC4, 0xFF4DD0E1], // Deniz mavisi tonları
    [0xFF9575CD, 0xFF7986CB], // Fuşya tonları
    [0xFF9CCC65, 0xFFAED581], // Nane yeşili tonları
    [0xFFFFF176, 0xFFDCE775], // Limon tonları
    [0xFFFFB74D, 0xFFFFD54F], // Şeftali tonları
    [0xFFFF7043, 0xFFFF8A65], // Alev tonları
    [0xFFFF5252, 0xFFFF8A80], // Koyu kırmızı tonları
    [0xFF9E9E9E, 0xFFBDBDBD], // Gümüş tonları
    [0xFF78909C, 0xFF90A4AE], // Haki tonları
    [0xFF9575CD, 0xFFB39DDB], // Gece yarısı tonları
    // Yosun yeşili tonları
    [0xFFBA68C8, 0xFFE57373], // Pembe tonları
    [0xFF4FC3F7, 0xFF64B5F6],
  ];

  Future<List<Note>?> getNote(String userId, Box noteBox, String bookTitle) async {
    List<Note> result = [];
    for (var i = 0; i < noteBox.length; i++) {
      Note not = await noteBox.getAt(i);
      var ekleme = false;
      for (var tag in not.tags) {
        if (isSimilar(bookTitle.toLowerCase().trim(), tag.toLowerCase().trim(), 0.8)) {
          ekleme = true;
        }
      }
      if (ekleme) {
        result.add(not);
      }
    }
    return result;
  }

  Future<List<Note>> getAllNotes(String userId, Box noteBox) async {
    List<Note> result = [];
    for (var i = 0; i < noteBox.length; i++) {
      Note not = await noteBox.getAt(i);
      result.add(not);
    }
    notes.clear();
    notes.addAll(result);
    notifyListeners();
    return notes;
  }

  List<Note> refreshNotes(List<String> secilenEtiketler) {
    List<Note> filteredNotes = [];
    filteredNotes.clear();
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
    return filteredNotes;
  }

  Future<void> changeGradient(List<int> newColor, Box<Note> noteBox, int noteIndex) async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NotesAdapter());
    }
    Note? note = noteBox.getAt(noteIndex);
    if (note == null) return;
    if (newColor.length < 2) return;
    note.gradientColors = newColor;
    await noteBox.putAt(noteIndex, note);
    await getAllNotes("1", noteBox);
  }

  Future<void> addNote(Note newNote, Box<Note> noteBox) async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NotesAdapter());
    }
    newNote.noteId = noteBox.length.toString();
    print("${newNote.noteId} eklendi");
    await noteBox.put("note${noteBox.length}", newNote);
    await getAllNotes("1", noteBox);
  }

  Future<void> updateNote(Note updatedNote, Box<Note> noteBox, int? noteIndex) async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NotesAdapter());
    }
    int? index = await getAllNotes("1", noteBox).then((value) {
      int? index;
      for (int i = 0; i < value.length; i++) {
        var note = value[i];
        if (updatedNote.noteId == note.noteId) {
          index = i;
        }
      }
      return index;
    });
    if (index == null) {
      print("HAta");
      return;
    }
    await noteBox.putAt(index, updatedNote); // Güncellenmiş listeyi veritabanına geri kaydedin
    await getAllNotes("1", noteBox);
  }

  Future<void> indexChangeNote(int oldIndex, int newIndex, Box<Note> noteBox) async {
    final List<Note> values = noteBox.values.toList();
    values.insert(newIndex, values.removeAt(oldIndex));
    await noteBox.clear();
    await noteBox.addAll(values);
    await getAllNotes("1", noteBox);
  }

  Future<void> removeNote(int noteIndex, Box<Note> noteBox) async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NotesAdapter());
    }
    await noteBox.deleteAt(noteIndex);
    await getAllNotes("1", noteBox);
  }

  
}

final noteRepositoryprovider = ChangeNotifierProvider((ref) => NoteRepository());

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
