class StatisticModel {
  String uid;
  // double gunlukMaksimumOkumaSuresi;
  // double hedefSure; // yerel veritabanında tutulacak
  List<String>? haftalikOkumaVerisi;// Sunucuda haftalık ve aylık olarak ayrılmayacak tek veri seti olacak
  List<String>? aylikOkumaVerisi; // kullanım açısından böyle kolay olduğu için gelen veriyi bu şekilde ayıracağız. 

  //OkumaVerisiString: "gün.ay.yıl,okumaDk" => "08.06.2023,0.5"

  StatisticModel(
      {required this.uid, this.haftalikOkumaVerisi, this.aylikOkumaVerisi});
}
