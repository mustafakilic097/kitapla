import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class BookModel {
  @HiveField(0)
  String bookId;
  @HiveField(1)
  String title;
  @HiveField(2)
  String subtitle;
  @HiveField(3)
  String description;
  @HiveField(4)
  String author; // hep ilk değerini al
  @HiveField(5)
  List<String> categories;
  @HiveField(6)
  String country;
  @HiveField(7)
  String language;
  @HiveField(8)
  String previewLink;
  @HiveField(9)
  String imageLink; // hep ilk değerini al
  @HiveField(10)
  String pageCount;
  @HiveField(11)
  String publishedDate; //null geliyor ya da  2016-05-12 00:00:00.000 böyle bişey geliyor

  factory BookModel.fromJson(Map<String, dynamic> json) {
    var date = json["volumeInfo"]["publishedDate"].toString() != "null"
        ? json["volumeInfo"]["publishedDate"].toString().split("-")[0]
        : "";
    return BookModel(
        bookId: json["id"] ?? "-",
        title: json["volumeInfo"]["title"] ?? "-",
        subtitle: json["volumeInfo"]["subtitle"] ?? "-",
        description: json["volumeInfo"]["description"] ?? "-",
        author: json["volumeInfo"]["authors"] != null ? json["volumeInfo"]["authors"][0] : "-",
        categories: List<String>.from(json["volumeInfo"]["categories"] ?? []),
        country: json["saleInfo"]["country"] ?? "-",
        language: json["volumeInfo"]["language"] ?? "-",
        previewLink: json["volumeInfo"]["previewLink"] ?? "-",
        imageLink: (json["volumeInfo"]["imageLinks"] != null
            ? json["volumeInfo"]["imageLinks"]["thumbnail"]
            : "assets/book.png"),
        pageCount: json["volumeInfo"]["pageCount"] != null ? json["volumeInfo"]["pageCount"].toString() : "-",
        publishedDate: date);
  }

  
  BookModel(
      {required this.bookId,
      required this.title,
      required this.subtitle,
      required this.description,
      required this.author,
      required this.categories,
      required this.country,
      required this.language,
      required this.previewLink,
      required this.imageLink,
      required this.pageCount,
      required this.publishedDate});

  // e.volumeInfo.industryIdentifiers bunu almamaya karar verdim.

  static BookModel blank() {
    return BookModel(
        bookId: "",
        title: "",
        subtitle: "",
        description: "",
        author: "",
        categories: [""],
        country: "",
        language: "",
        previewLink: "",
        imageLink: "",
        pageCount: "",
        publishedDate: "");
  }
}

class BooksAdapter extends TypeAdapter<BookModel> {
  @override
  final typeId = 1;

  @override
  BookModel read(BinaryReader reader) {
    try {
      // if (reader.readByte() != 0) {
      //   return read(reader);
      // }
      return BookModel(
          bookId: reader.readString(),
          title: reader.readString(),
          subtitle: reader.readString(),
          description: reader.readString(),
          author: reader.readString(),
          categories: reader.readStringList(),
          country: reader.readString(),
          language: reader.readString(),
          previewLink: reader.readString(),
          imageLink: reader.readString(),
          pageCount: reader.readString(),
          publishedDate: reader.readString());
    } catch (e) {
      print("Hata ile karşılaşıldı(Okuma): $e");
    }
    return BookModel.blank();
  }

  @override
  void write(BinaryWriter writer, BookModel obj) {
    try {
      writer.writeString(obj.bookId);
      writer.writeString(obj.title);
      writer.writeString(obj.subtitle);
      writer.writeString(obj.description);
      writer.writeString(obj.author);
      writer.writeStringList(obj.categories);
      writer.writeString(obj.country);
      writer.writeString(obj.language);
      writer.writeString(obj.previewLink);
      writer.writeString(obj.imageLink);
      writer.writeString(obj.pageCount);
      writer.writeString(obj.publishedDate);
    } catch (e) {
      print("Hata ile karşılaşıldı(Yazma): $e");
    }
  }
}
