import "dart:convert";
import "package:http/http.dart" as http;
import "package:string_similarity/string_similarity.dart";

import "../../model/book_model.dart";
import "../../viewmodel/utils.dart";

class GoogleBooksService {
  Future<BookModel?> getGBookData({required String query, String? author}) async {
    String encodedQuery = Uri.encodeComponent(query);
    String url = "";
    url = 'https://www.googleapis.com/books/v1/volumes?q="$encodedQuery"&printType=books&langRestrict=tr';
    if (author != null) {
      url =
          'https://www.googleapis.com/books/v1/volumes?q="$encodedQuery"+inauthor:$author&printType=books&langRestrict=tr';
    }
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = response.body.toString();
      Map<String, dynamic> decodedData = jsonDecode(data);
      // print(data);
      // print("--"*50);
      // print(decodedData["items"][0]);
      // return null;
      // print(decodedData["items"]);
      var result = BookModel.fromJson(decodedData["items"][0]);
      result = setFilter([result]).first;
      return result;
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<List<BookModel>> getGBooksData({required String query, String? author}) async {
    try {
      String encodedQuery = Uri.encodeComponent(query);
      String url = "";
      url = 'https://www.googleapis.com/books/v1/volumes?q="$encodedQuery"&printType=books&langRestrict=tr';
      if (author != null) {
        url =
            'https://www.googleapis.com/books/v1/volumes?q="$encodedQuery"+inauthor:$author&printType=books&langRestrict=tr';
      }
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = response.body.toString();
        Map<String, dynamic> decodedData = jsonDecode(data);
        // print(data);
        // print("--"*50);
        // print(decodedData["items"][0]);
        // return null;
        // print(decodedData["items"]);
        var result =
            List.generate(decodedData["items"].length, (index) => BookModel.fromJson(decodedData["items"][index]));
        result = setFilter(result);
        return result;
      } else {
        print(response.statusCode);
        return [];
      }
    } catch (e) {
      print("Bir hatayla karşılaşıldı: $e");
      return [];
    }
  }

  Future<List<BookModel>?> getGBooksFromCategori(
      {required String categori,
      required int startIndex,
      required String lang,
      bool? getAllData,
      int? jumpIndex}) async {
    try {
      String encodedQuery = Uri.encodeComponent(categori);
      String url =
          'https://www.googleapis.com/books/v1/volumes?q=subject:$encodedQuery&maxResult=3&printType=books&langRestrict=$lang';
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = response.body.toString();
        Map<String, dynamic> decodedData = jsonDecode(data);
        // print(data);
        // print("--"*50);
        // print(decodedData["items"][0]);
        // return null;
        int maxLength = decodedData["totalItems"];
        if (maxLength == 0) lang = "en";
        print(maxLength);
        // uuznluk belli olduktan sonraki aşama
        if (getAllData == true) {
          jumpIndex ??= 0;
          if (jumpIndex * 15 > maxLength) {
            return [];
          }
          List<BookModel>? books2 = [];
          int startIndex2 = jumpIndex * 15;
          for (var i = 0; i < (maxLength / 3 + maxLength % 3).toInt(); i++) {
            if (i == 5) break;
            try {
              String encodedQuery2 = Uri.encodeComponent(categori);
              String url2 =
                  'https://www.googleapis.com/books/v1/volumes?q=subject:$encodedQuery2&printType=books&startIndex=$startIndex2&langRestrict=$lang';
              http.Response response2 = await http.get(
                Uri.parse(url2),
              );
              if (response2.statusCode == 200) {
                var data2 = response2.body.toString();
                Map<String, dynamic> decodedData2 = jsonDecode(data2);
                var control = true;
                for (var i = 0; i < decodedData2.length; i++) {
                  if (decodedData2["items"][i] != null) {
                    for (var e in books2) {
                      if (e.title == BookModel.fromJson(decodedData2["items"][i]).title) {
                        control = false;
                      }
                    }
                    if (control) {
                      books2.add(BookModel.fromJson(decodedData2["items"][i]));
                    }
                  }
                }
              }
              startIndex2 += 3;
            } catch (e) {
              print("Hata oldu: $e");
            }
          }
          books2 = setFilter(books2);
          return books2;
        }
        String encodedQuery2 = Uri.encodeComponent(categori);
        if (!(startIndex + 3 <= maxLength)) {
          startIndex = maxLength - 3;
        }
        String url2 =
            'https://www.googleapis.com/books/v1/volumes?q=subject:$encodedQuery2&maxResult=3&printType=books&startIndex=$startIndex&langRestrict=$lang';
        http.Response response2 = await http.get(Uri.parse(url2));
        if (response2.statusCode == 200) {
          var data2 = response2.body.toString();
          Map<String, dynamic> decodedData2 = jsonDecode(data2);
          List<BookModel> books = [];
          for (var i = 0; i < decodedData2.length; i++) {
            books.add(BookModel.fromJson(decodedData2["items"][i]));
          }
          books = setFilter(books);

          return books;
        }
        return null;
      } else {
        print(response.statusCode);
        return null;
      }
    } catch (e) {
      print(e);
      print("Bir hata oldu !!!!");
    }
    return null;
  }

  Future<List<BookModel>> getGBooksFromAuthor(
      {required String author, required int startIndex, bool? getAllData, int? jumpIndex}) async {
    try {
      String encodedQuery = Uri.encodeComponent(author);
      String url = 'https://www.googleapis.com/books/v1/volumes?q=inauthor:$encodedQuery&printType=books&startIndex=0';
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = response.body.toString();
        Map<String, dynamic> decodedData = jsonDecode(data);
        int maxLength = decodedData["totalItems"];
        print("Gelen veri uzunluğu: $maxLength");
        // uuznluk belli olduktan sonraki aşama
        if (getAllData == true) {
          jumpIndex ??= 0;
          if (jumpIndex * 15 > maxLength) {
            return [];
          }
          List<BookModel>? books2 = [];
          int startIndex2 = jumpIndex * 15;
          for (var i = 0; i < (maxLength / 3 + maxLength % 3).toInt(); i++) {
            if (i == 5) break;
            try {
              String encodedQuery2 = Uri.encodeComponent(author);
              String url2 =
                  'https://www.googleapis.com/books/v1/volumes?q=inauthor:$encodedQuery2&printType=books&startIndex=$startIndex2';
              http.Response response2 = await http.get(
                Uri.parse(url2),
              );
              if (response2.statusCode == 200) {
                var data2 = response2.body.toString();
                Map<String, dynamic> decodedData2 = jsonDecode(data2);
                var control = true;
                for (var i = 0; i < decodedData2.length; i++) {
                  if (decodedData2["items"][i] != null) {
                    for (var e in books2) {
                      if (e.title == BookModel.fromJson(decodedData2["items"][i]).title) {
                        control = false;
                      }
                    }
                    if (control) {
                      books2.add(BookModel.fromJson(decodedData2["items"][i]));
                    }
                  }
                }
              }
              startIndex2 += 3;
            } catch (e) {
              print("Hata oldu: $e");
            }
          }
          books2 = setFilter(books2);

          return books2;
        }
        String encodedQuery2 = Uri.encodeComponent(author);
        if (!(startIndex + 3 <= maxLength)) {
          startIndex = maxLength - 3;
        }
        String url2 =
            'https://www.googleapis.com/books/v1/volumes?q=inauthor:$encodedQuery2&printType=books&startIndex=$startIndex';
        http.Response response2 = await http.get(Uri.parse(url2));
        if (response2.statusCode == 200) {
          var data2 = response2.body.toString();
          Map<String, dynamic> decodedData2 = jsonDecode(data2);
          List<BookModel> books = [];
          for (var i = 0; i < decodedData2.length; i++) {
            books.add(BookModel.fromJson(decodedData2["items"][i]));
          }
          books = setFilter(books);

          return books;
        }
        return [];
        // print(data);
        // print("--"*50);
        // print(decodedData["items"][0]);
        // return null;
      } else {
        print(response.statusCode);
        return [];
      }
    } catch (e) {
      print("Bir hata var: $e");
      return [];
    }
  }

  List<BookModel> setFilter(List<BookModel> books) {
    List<BookModel> filteredList = [];
    double findSimilarityScore(String input, String target) {
      return input.similarityTo(target);
    }

    bool isSimilar(String input, String target, double threshold) {
      double similarityScore = findSimilarityScore(input, target);
      return similarityScore >= threshold;
    }

    for (var book in books) {
      const double threshold = 0.8; // Eşleşme eşiği (0 ile 1 arasında bir değer seçin)
      bool control = true;
      for (String yasakliKitap in filterTitle) {
        if (isSimilar(book.title, yasakliKitap, threshold)) {
          control = false;
          print("Yasaklı bulundu: ${book.title}");
        }
      }

      for (String yasakliYazar in filterYazar) {
        if (isSimilar(book.author, yasakliYazar, threshold)) {
          control = false;
          print("Yasaklı bulundu: ${book.title}");
        }
      }
      if (control) filteredList.add(book);
    }
    return filteredList;
  }
}
