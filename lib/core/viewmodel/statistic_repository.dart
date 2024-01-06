import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/statistic_model.dart';


class StatisticRepository extends ChangeNotifier {
  double gunlukMaksimumOkumaSuresi = 1.8;
  double hedefSure = 0.6;

  var kullaniciVerisi = StatisticModel(uid: "1", aylikOkumaVerisi: [
    "08.6.2023,0.6,0.6",
    "09.6.2023,0.3,0.2",
    "10.6.2023,0.7,0.6",
    "12.6.2023,0.7,1",
    "19.6.2023,0.9,0.6",
    "20.6.2023,0.3,0.2",
    "21.6.2023,0.6,0.9",
    "22.6.2023,0.7,0.5",
    "23.6.2023,1,0.7",
    "24.6.2023,0.6,0.6",
    "25.6.2023,1.3,0.6",
  ], haftalikOkumaVerisi: [
    "08.6.2023,0.6,0.6",
    "09.6.2023,0.3,0.2",
    "10.6.2023,0.7,0.6",
    "12.6.2023,0.7,1",
    "19.6.2023,0.9,0.6",
    "20.6.2023,0.3,0.2",
    "21.6.2023,0.6,0.9",
    "22.6.2023,0.7,1",
    "23.6.2023,1,0.7",
    "24.6.2023,0.6,0.6",
    "25.6.2023,1.3,0.6",
  ]);

  Future<void> gunlukVeriBaslat(String uid) async {
    if (kullaniciVerisi.uid == uid) {
      if (kullaniciVerisi.aylikOkumaVerisi == null && kullaniciVerisi.haftalikOkumaVerisi == null) {
        print("Kullanıcı verisi bulunamadı. Yeni liste oluşturuluyor...");
        kullaniciVerisi.aylikOkumaVerisi = [
          ("${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year},0,$hedefSure")
        ];
        kullaniciVerisi.haftalikOkumaVerisi = [
          ("${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year},0,$hedefSure")
        ];
        return;
      }

      if (kullaniciVerisi.aylikOkumaVerisi != null) {
        try {
          var a = tarihSureHedefGetir(kullaniciVerisi.aylikOkumaVerisi![kullaniciVerisi.aylikOkumaVerisi!.length - 1]);
          print("Bugünün verisi bulundu: $a");
          return;
        } catch (e) {
          print("hata: $e");
        }
        print("Bugün için veri bulunamadı. Yenisi ekleniyor...");
        String oncekiGunHedef = kullaniciVerisi.aylikOkumaVerisi!.isNotEmpty
            ? "${tarihSureHedefGetir(kullaniciVerisi.aylikOkumaVerisi![kullaniciVerisi.aylikOkumaVerisi!.length - 1])["hedef"]}"
            : "$hedefSure";

        oncekiGunHedef == "0" ? oncekiGunHedef = "$hedefSure" : null;
        kullaniciVerisi.aylikOkumaVerisi!
            .add("${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year},0,$oncekiGunHedef");
        kullaniciVerisi.haftalikOkumaVerisi!
            .add("${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year},0,$oncekiGunHedef");
        print(
            "Haftalık olarak eklenen:${kullaniciVerisi.haftalikOkumaVerisi![(kullaniciVerisi.haftalikOkumaVerisi!.length - 1)]}");
        print(
            "Aylık olarak eklenen:${kullaniciVerisi.aylikOkumaVerisi![(kullaniciVerisi.aylikOkumaVerisi!.length - 1)]}");
      }
    }
    await Future.delayed(const Duration(seconds: 0));
    print("burası bitti 1");
    notifyListeners();
  }

  void gunlukHedefDegistir(double newHedef) {
    if (kullaniciVerisi.aylikOkumaVerisi == null) return;
    if (newHedef == 0) return;
    for (var i = 0; i < kullaniciVerisi.aylikOkumaVerisi!.length; i++) {
      var veri = tarihSureHedefGetir(kullaniciVerisi.aylikOkumaVerisi![i])["tarih"]!.split(".");
      if (DateTime(int.parse(veri[2]), int.parse(veri[1]), int.parse(veri[0])) ==
          DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
        kullaniciVerisi.aylikOkumaVerisi![i] =
            "${veri[0]}.${veri[1]}.${veri[2]},${tarihSureHedefGetir(kullaniciVerisi.aylikOkumaVerisi![i])["sure"]},$newHedef";
        print(
            "la:${veri[0]}.${veri[1]}.${veri[2]},${tarihSureHedefGetir(kullaniciVerisi.aylikOkumaVerisi![i])["sure"]},$newHedef");
      }
    }
    notifyListeners();
  }

  List<String> hedefGetirHaftalik({required int haftaBaslangicGunu}) {
    List<String> result = List.generate(7, (i) => hedefSure.toString());
    List<int> gunler = List.generate(7, (index) => haftaBaslangicGunu + index);
    if (kullaniciVerisi.haftalikOkumaVerisi == null) return result;

    for (var i = 0; i < kullaniciVerisi.haftalikOkumaVerisi!.length; i++) {
      for (var j = 0; j < 7; j++) {
        if (int.parse(tarihSureHedefGetir(kullaniciVerisi.haftalikOkumaVerisi![i])["tarih"]!.split(".")[0]) ==
            gunler[j]) {
          result[j] = tarihSureHedefGetir(kullaniciVerisi.haftalikOkumaVerisi![i])["hedef"]!;
        }
      }
    }
    print(result);
    return result;
  }

  List<String> hedefGetirAylik(int kacinciAy) {
    int sonGun = DateTime(DateTime.now().year, kacinciAy + 1, 0).day;
    List<String> result = List.generate(sonGun, (i) => hedefSure.toString());
    if (kullaniciVerisi.aylikOkumaVerisi == null) return result;

    for (var i = 0; i < kullaniciVerisi.aylikOkumaVerisi!.length; i++) {
      for (var j = 1; j <= sonGun; j++) {
        if (int.parse(tarihSureHedefGetir(kullaniciVerisi.aylikOkumaVerisi![i])["tarih"]!.split(".")[0]) == j&&(int.parse(tarihSureHedefGetir(kullaniciVerisi.aylikOkumaVerisi![i])["tarih"]!.split(".")[1]) == kacinciAy)) {
          result[j - 1] = tarihSureHedefGetir(kullaniciVerisi.aylikOkumaVerisi![i])["hedef"]!;
        }
      }
    }

    return result;
  }

  List<String> haftalikVeriGetir(int haftaBaslangicGunu) {
    List<String> result = ["0", "0", "0", "0", "0", "0", "0"];
    List<String> blankResult = ["0", "0", "0", "0", "0", "0", "0"];
    List<int> gunler = List.generate(7, (index) => haftaBaslangicGunu + index);
    if (kullaniciVerisi.haftalikOkumaVerisi == null) return blankResult;
    List<String> haftalikOkumaVerisi = kullaniciVerisi.haftalikOkumaVerisi!;

    for (var i = 0; i < haftalikOkumaVerisi.length; i++) {
      for (var j = 0; j < 7; j++) {
        if (int.parse(tarihSureHedefGetir(haftalikOkumaVerisi[i])["tarih"]!.split(".")[0]) == gunler[j]) {
          result[j] = tarihSureHedefGetir(haftalikOkumaVerisi[i])["sure"]!;
          // print("i:$i j:$j sure:${tarihSureHedefGetir(haftalikOkumaVerisi[i])["sure"]!}");
        }
      }
    }

    // for (var element in result) {print(element);}
    return result;
  }

  List<String> aylikVeriGetir(int kacinciAy) {
    int sonGun = DateTime(DateTime.now().year, kacinciAy + 1, 0).day;
    List<String> result = List.generate(sonGun, (i) => "0");
    if (kullaniciVerisi.aylikOkumaVerisi == null) return result;

    // var seciliAyVeri = [];
    // kullaniciVerisi.aylikOkumaVerisi!.forEach((veri) {
    //   if(veri)
    // });
    for (var i = 0; i < kullaniciVerisi.aylikOkumaVerisi!.length; i++) {
      for (var j = 1; j <= sonGun; j++) {
        if ((int.parse(tarihSureHedefGetir(kullaniciVerisi.aylikOkumaVerisi![i])["tarih"]!.split(".")[0]) == j)&&(int.parse(tarihSureHedefGetir(kullaniciVerisi.aylikOkumaVerisi![i])["tarih"]!.split(".")[1]) == kacinciAy)) {
          result[j - 1] = tarihSureHedefGetir(kullaniciVerisi.aylikOkumaVerisi![i])["sure"]!;
        }
      }
    }
    return result;
  }

  Map<String, String> tarihSureHedefGetir(String veriStr) {
    var result = {
      "tarih": veriStr.split(",")[0],
      "sure": veriStr.split(",")[1],
      "hedef": veriStr.split(",")[2],
    };
    return result;
  }

  // List<FlSpot> haftalikOkumaVerisi = [
  //   const FlSpot(1, 1),
  //   const FlSpot(2, 1.6),
  //   const FlSpot(3, 0.6),
  //   const FlSpot(4, 0.8),
  //   const FlSpot(5, 1.7),
  //   const FlSpot(6, 0),
  //   const FlSpot(7, 0.2),
  // ];

  String gunleriYaz(double value) {
    return value == 1
        ? "Pzt"
        : value == 2
            ? "Sal"
            : value == 3
                ? "Çar"
                : value == 4
                    ? "Per"
                    : value == 5
                        ? "Cum"
                        : value == 6
                            ? "Cmt"
                            : value == 7
                                ? "Paz"
                                : "$value";
  }

  String aylariYaz(int value) {
    return value == 1
        ? "Ocak"
        : value == 2
            ? "Şubat"
            : value == 3
                ? "Mart"
                : value == 4
                    ? "Nisan"
                    : value == 5
                        ? "Mayıs"
                        : value == 6
                            ? "Haziran"
                            : value == 7
                                ? "Temmuz"
                                : value == 8
                                    ? "Ağustos"
                                    : value == 9
                                        ? "Eylül"
                                        : value == 10
                                            ? "Ekim"
                                            : value == 11
                                                ? "Kasım"
                                                : value == 12
                                                    ? "Aralık"
                                                        : "$value";
  }

  List<double> aylikOkumaVerisi = [
    for (int i = 0; i < DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day; i++) Random().nextDouble() * 1.8
  ];

  // List<FlSpot> haftalikOkumaVerisiGuncelle({
  //   double? pzt,
  //   double? sal,
  //   double? car,
  //   double? per,
  //   double? cum,
  //   double? cmt,
  //   double? paz,
  // }) {
  //   if (pzt != null && pzt > gunlukMaksimumOkumaSuresi) pzt = gunlukMaksimumOkumaSuresi;
  //   if (sal != null && sal > gunlukMaksimumOkumaSuresi) sal = gunlukMaksimumOkumaSuresi;
  //   if (car != null && car > gunlukMaksimumOkumaSuresi) car = gunlukMaksimumOkumaSuresi;
  //   if (per != null && per > gunlukMaksimumOkumaSuresi) per = gunlukMaksimumOkumaSuresi;
  //   if (cum != null && cum > gunlukMaksimumOkumaSuresi) cum = gunlukMaksimumOkumaSuresi;
  //   if (cmt != null && cmt > gunlukMaksimumOkumaSuresi) cmt = gunlukMaksimumOkumaSuresi;
  //   if (paz != null && paz > gunlukMaksimumOkumaSuresi) paz = gunlukMaksimumOkumaSuresi;
  //   for (int i = 0; i < haftalikOkumaVerisi.length; i++) {
  //     if (pzt != null) haftalikOkumaVerisi[i] = FlSpot(1, pzt);
  //     if (sal != null) haftalikOkumaVerisi[i] = FlSpot(2, sal);
  //     if (car != null) haftalikOkumaVerisi[i] = FlSpot(3, car);
  //     if (per != null) haftalikOkumaVerisi[i] = FlSpot(4, per);
  //     if (cum != null) haftalikOkumaVerisi[i] = FlSpot(5, cum);
  //     if (cmt != null) haftalikOkumaVerisi[i] = FlSpot(6, cmt);
  //     if (paz != null) haftalikOkumaVerisi[i] = FlSpot(7, paz);
  //   }
  //   notifyListeners();
  //   return haftalikOkumaVerisi;
  // }

  double hedefSureGuncelle(double newHedefSure) {
    hedefSure = newHedefSure;
    notifyListeners();
    return newHedefSure;
  }
}

final statisticRepositoryProvider = ChangeNotifierProvider((ref) => StatisticRepository());
