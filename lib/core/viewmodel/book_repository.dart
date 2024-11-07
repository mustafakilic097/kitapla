import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../model/book_model.dart';

class BookRepository extends ChangeNotifier {
  List<BookModel> books = [
    // BookModel(bookId: "1", bookName: "Sefiller", bookAuthor: "Mustafa", bookColor: 0xFFFF0000, bookYear: "2001",bookISBN: "-"),
    // BookModel(bookId: "2", bookName: "1984", bookAuthor: "Mustafa", bookColor: 0xFF0000FF, bookYear: "2005",bookISBN: "-"),
    // BookModel(bookId: "3", bookName: "Küçük Prens", bookAuthor: "Mustafa", bookColor: 0xFF000000, bookYear: "2005",bookISBN: "-"),
    // BookModel(bookId: "4", bookName: "Suç ve Ceza", bookAuthor: "Mustafa", bookColor: 0xFFFF0000, bookYear: "2005",bookISBN: "-"),
    // BookModel(
    //     bookId: "5", bookName: "Yeraltından Notlar", bookAuthor: "Mustafa", bookColor: 0xFFFFA500, bookYear: "2005",bookISBN: "-"),
    // BookModel(bookId: "6", bookName: "Anna Karenina", bookAuthor: "Mustafa", bookColor: 0xFF00FF00, bookYear: "2005",bookISBN: "-"),
    // BookModel(
    //     bookId: "7",
    //     bookName: "Gözlerimi Kaparım Vazifemi Yaparım",
    //     bookAuthor: "Mustafa",
    //     bookColor: 0xFFFF0000,
    //     bookYear: "2005",bookISBN: "-"),
    // BookModel(
    //     bookId: "8",
    //     bookName: "Beyaz Zambaklar Ülkesinde",
    //     bookAuthor: "Mustafa",
    //     bookColor: 0xFF000000,
    //     bookYear: "2005",bookISBN: "-"),
    // BookModel(bookId: "9", bookName: "İnce Memed", bookAuthor: "Mustafa", bookColor: 0xFFFF0000, bookYear: "2005",bookISBN: "-"),
    // BookModel(
    //     bookId: "10", bookName: "Kürk Mantolu Madonna", bookAuthor: "Mustafa", bookColor: 0xFFFF0000, bookYear: "2005",bookISBN: "-"),
    // BookModel(bookId: "11", bookName: "Simyacı", bookAuthor: "Mustafa", bookColor: 0xFFFF0000, bookYear: "2005",bookISBN: "-"),
    // BookModel(bookId: "12", bookName: "Dönüşüm", bookAuthor: "Mustafa", bookColor: 0xFF00FF00, bookYear: "2005",bookISBN: "-"),
    // BookModel(bookId: "13", bookName: "Veba", bookAuthor: "Mustafa", bookColor: 0xFF000000, bookYear: "2005",bookISBN: "-"),
    // BookModel(
    //     bookId: "14", bookName: "Kırmızı Pazartesi", bookAuthor: "Mustafa", bookColor: 0xFFFFA500, bookYear: "2005",bookISBN: "-"),
    // BookModel(bookId: "15", bookName: "Beyaz Gemi", bookAuthor: "Mustafa", bookColor: 0xFF0000FF, bookYear: "2005",bookISBN: "-"),
  ];

  Map<String, BookModel> favoriteBooks = {};

  Map<String, List<BookModel>> favoriteLists = {};

  Future<void> removeFavListBook(Box<BookModel> favoriteListBox, BookModel removedBook, String favListName) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BooksAdapter());
    }
    int? bookIndex;

    for (var i = 0; i < favoriteListBox.keys.toList().length; i++) {
      if (favoriteListBox.keys.toList()[i] == "list~$favListName~${removedBook.bookId}~${removedBook.title}") {
        print(favoriteListBox.keys.toList()[i] + "siliniyor...");
        bookIndex = i;
        break;
      }
    }
    if (bookIndex == null) return;
    await favoriteListBox.deleteAt(bookIndex);
    getAllFavListBooks(userId: "1", favoriteBox: favoriteListBox);
  }

  Future<void> updateFavListBook(BookModel updatedbook, Box<BookModel> favoriteListBox, int favBookIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BooksAdapter());
    }
    await favoriteListBox.putAt(favBookIndex, updatedbook);
    getAllFavListBooks(userId: "1", favoriteBox: favoriteListBox);
  }

  Future<Map<String, List<BookModel>>> indexChangeFavListBook(
      {required String favListName,
      required BookModel downBook,
      required BookModel upBook,
      required Box<BookModel> bookBox}) async {
    // String downKey = "list~$favListName~${downBook.bookId}~${downBook.title}";
    // String upKey = "list~$favListName~${upBook.bookId}~${upBook.title}";
    String upKey1 = "list~$favListName~${upBook.bookId}~${downBook.title}";
    String downKey1 = "list~$favListName~${downBook.bookId}~${upBook.title}";
    await removeFavListBook(bookBox, upBook, favListName);
    await removeFavListBook(bookBox, downBook, favListName);
    var depo = downBook.bookId;
    downBook.bookId = upBook.bookId;
    upBook.bookId = depo;
    await bookBox.put(upKey1, downBook);
    await bookBox.put(downKey1, upBook);
    return await getAllFavListBooks(userId: "1", favoriteBox: bookBox);
  }

  Future<Map<String, List<BookModel>>> getAllFavListBooks(
      {required String userId, required Box<BookModel> favoriteBox, String? favListName}) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BooksAdapter());
    }
    Map<String, List<BookModel>> result = {};
    for (var i = 0; i < favoriteBox.length; i++) {
      BookModel? book = favoriteBox.getAt(i);
      String name = favoriteBox.keyAt(i).toString();
      // print("name:$name book:${book?.title}");
      // gelen key list ile başlamıyorsa
      if (!name.startsWith("list") && !(name.split("~").length < 3)) continue;
      result.update(
        name.split("~")[1],
        (value) {
          value.add(book!);
          return value;
        },
        ifAbsent: () {
          return [book!];
        },
      );
    }

    if ((favListName != null)) {
      List<BookModel> sortedList = [];
      sortedList.addAll(result[favListName] ?? []);
      sortedList.sort(
        (a, b) => int.parse(a.bookId).compareTo(int.parse(b.bookId)),
      );
      favoriteLists.clear();
      favoriteLists.addAll({favListName: sortedList});
    } else {
      //SIRALAMA İŞLEMİ
      var entryList = result.entries.toList();
      for (var i = 0; i < entryList.length; i++) {
        List<BookModel> sortedValues = [];
        sortedValues.addAll(entryList[i].value);
        sortedValues.sort((a, b) => int.parse(a.bookId).compareTo(int.parse(b.bookId)));
        entryList[i].value.clear();
        entryList[i].value.addAll(sortedValues);
      }
      Map<String, List<BookModel>> sortedMap = {};
      for (var entry in entryList) {
        sortedMap[entry.key] = entry.value;
      }
      favoriteLists.clear();
      favoriteLists.addAll(result);
    }
    // print(favoriteLists);
    notifyListeners();
    return favoriteLists;
  }

  Future<void> removeFavList(Box<BookModel> favBox, String favListName) async {
    for (var i = 0; i < favBox.keys.length; i++) {
      if (favBox.keyAt(i).toString().startsWith("list~$favListName")) {
        try {
          while (favBox.keyAt(i) != null) {
            await favBox.deleteAt(i);
          }
        } catch (e) {}
      }
    }
    notifyListeners();
    await getAllbooks("1", favBox);
  }

  List<String> getAllFavListBookNames(Box<BookModel> favoriteBox) {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BooksAdapter());
    }
    List<String> result = [];
    for (var i = 0; i < favoriteBox.length; i++) {
      String name = favoriteBox.keyAt(i);
      if (name.startsWith("list") && !result.contains(name.split("~")[1])) {
        result.add(name.split("~")[1]);
      }
    }
    return result;
  }
//-------------------------------------------------------------------------------------------//

  Future<void> updateFavBook(BookModel updatedbook, Box<BookModel> favoriteBox, int favBookIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BooksAdapter());
    }
    await favoriteBox.putAt(favBookIndex, updatedbook);
    await getAllFavBooks("1", favoriteBox);
  }

  Future<void> indexChangeFavBook(int oldIndex, int newIndex, Box<BookModel> favoriteBox) async {
    final List<BookModel> values = favoriteBox.values.toList();
    values.insert(newIndex, values.removeAt(oldIndex));
    await favoriteBox.clear();
    await favoriteBox.addAll(values);
    await getAllFavBooks("1", favoriteBox);
  }

  Future<Map<String, BookModel>> getAllFavBooks(String userId, Box<BookModel> bookBox) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BooksAdapter());
    }
    Map<String, BookModel> result = {};
    for (var i = 0; i < bookBox.length; i++) {
      String name = bookBox.keyAt(i);
      if (!name.startsWith("fav")) continue;
      BookModel? book = bookBox.getAt(i);
      result.addEntries({name: book!}.entries);
    }

    //SIRALAMA İŞLEMİ
    List<MapEntry<String, BookModel>> entryList = result.entries.toList();
    entryList.sort((a, b) => int.parse(a.value.bookId).compareTo(int.parse(b.value.bookId)));
    Map<String, BookModel> sortedMap = {};
    for (var entry in entryList) {
      sortedMap[entry.key] = entry.value;
    }
    favoriteBooks.clear();
    favoriteBooks.addAll(sortedMap);
    notifyListeners();
    return favoriteBooks;
  }

//-------------------------------------------------------------------------------------------//
  Future<List<BookModel>> getAllbooks(String userId, Box bookBox) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BooksAdapter());
    }
    List<BookModel> result = [];
    for (var i = 0; i < bookBox.length; i++) {
      BookModel book = await bookBox.getAt(i);
      result.add(book);
    }

    result.sort((a, b) => int.parse(a.bookId).compareTo(int.parse(b.bookId)));
    books.clear();
    books.addAll(result);
    notifyListeners();
    return books;
  }

  List<BookModel> refreshbooks(List<String> secilenEtiketler) {
    List<BookModel> filteredbooks = [];
    filteredbooks.clear();
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
      filteredbooks.clear();
      filteredbooks.addAll(books);
      // print("burada");
    } else {
      for (var i = 0; i < books.length; i++) {
        for (var k = 0; k < secilenEtiketler.length; k++) {
          // print("değerlendirme:${books[i].tags[j]} aranan:${secilenEtiketler[k]} i:$i j:$j k:$k");
          // print("book tag length:${books[i].tags.length}");
          // print("arama length:${secilenEtiketler.length}");
          if (books[i].title.toLowerCase().contains(secilenEtiketler[k].toLowerCase())) {
            bool ekleme = true;
            for (var e in filteredbooks) {
              if (e.bookId == books[i].bookId) {
                ekleme = false;
              }
            }
            if (ekleme) {
              filteredbooks.add(books[i]);
            }
            // print("${books[i].tags[j]} eşleşti");
          }
        }
      }
    }
    return filteredbooks;
  }

  Future<List<BookModel>> addbook(
      {required BookModel newbook, required Box<BookModel> bookBox, String? favTag, String? favName}) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BooksAdapter());
    }
    String id = "";
    if (favTag != null) id += "$favTag~";
    if (favName != null) id += "$favName~";
    newbook.bookId = bookBox.length.toString();
    print("${newbook.bookId} eklendi");
    // Burada newBook.title yaparak key kısmınında tamamen unique olması sağlanmıştır.
    // Diğer durumda silerken ve eklerken karışıklık çıkabiliyor.
    await bookBox.put("$id${bookBox.length}~${newbook.title}", newbook);
    return await getAllbooks("1", bookBox);
  }

  Future<void> updatebook(BookModel updatedbook, Box<BookModel> bookBox, int bookIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BooksAdapter());
    }
    await bookBox.putAt(bookIndex, updatedbook); // Güncellenmiş listeyi veritabanına geri kaydedin
    await getAllbooks("1", bookBox);
  }

  Future<void> removebook(Box<BookModel> bookBox, int index) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BooksAdapter());
    }
    // int? bookIndex;
    // await getAllbooks("1", bookBox).then((b) {
    //   for (var i = 0; i < b.length; i++) {
    //     if (b[i].bookId == book.bookId) {
    //       bookIndex = i;
    //     }
    //   }
    // });
    // if (bookIndex == null) return;
    await bookBox.deleteAt(index);
    await getAllbooks("1", bookBox);
  }
}

extension ExtendsionsOnMapDynamicDynamic<K, V> on Map<K, V> {
  /// Order by keys
  Map<K, V> orderByKeys({required int Function(K a, K b) compareTo}) {
    return Map.fromEntries(entries.toList()..sort((a, b) => compareTo(a.key, b.key)));
  }

  /// Order by values
  Map<K, V> orderByValues({required int Function(V a, V b) compareTo}) {
    return Map.fromEntries(entries.toList()..sort((a, b) => compareTo(a.value, b.value)));
  }
}

final bookRepositoryprovider = ChangeNotifierProvider((ref) => BookRepository());
