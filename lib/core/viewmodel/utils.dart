import 'package:intl/intl.dart';
import 'package:string_similarity/string_similarity.dart';

List<Map<String, String>> allYazarlar = [
  {
    "name": "Orhan Pamuk",
    "image": "https://www.harvardmagazine.com/sites/default/files/styles/4x3_main/public/img/story/1209/0909_12f_1.jpg"
  },
  {"name": "Yaşar Kemal", "image": "https://www.biyografi.info/personpicture-fb/yasarkemal.jpg"},
  {
    "name": "Nazım Hikmet",
    "image": "https://upload.wikimedia.org/wikipedia/en/thumb/b/b8/NazimHikmetRan.jpg/220px-NazimHikmetRan.jpg"
  },
  {"name": "Sabahattin Ali", "image": "https://upload.wikimedia.org/wikipedia/tr/f/f6/Sabahattin_ali.jpg"},
  {
    "name": "Ahmet Hamdi Tanpınar",
    "image":
        "https://i.tmgrup.com.tr/fikriyat/album/2020/01/24/ahmet-hamdi-tanpinar-kimdir-ahmet-hamdi-tanpinarin-hayati-1579847769060.jpg"
  },
  {'name': 'Cemal Süreya', 'image': ''},
  {'name': 'Peyami Safa', 'image': ''},
  {'name': 'Oğuz Atay', 'image': ''},
  {'name': 'Necip Fazıl Kısakürek', 'image': ''},
  {'name': 'Refik Halit Karay', 'image': ''},
  {'name': 'Canan Tan', 'image': ''},
  {'name': 'Adalet Ağaoğlu', 'image': ''},
  {'name': 'Murathan Mungan', 'image': ''},
  {'name': 'Bilge Karasu', 'image': ''},
  {'name': 'Kemal Tahir', 'image': ''},
  {'name': 'Halide Edip Adıvar', 'image': ''},
  {'name': 'Haldun Taner', 'image': ''},
  {'name': 'Sait Faik Abasıyanık', 'image': ''},
  {'name': 'İhsan Oktay Anar', 'image': ''},
  {'name': 'Ayşe Kulin', 'image': ''},
  {'name': 'Tahsin Yücel', 'image': ''},
  {'name': 'Kemal Bilbaşar', 'image': ''},
  {'name': 'Samiha Ayverdi', 'image': ''},
  {'name': 'Yusuf Atılgan', 'image': ''},
  {'name': 'Ayşe Sasa', 'image': ''},
  {'name': 'Sevgi Soysal', 'image': ''},
  {'name': 'Hakan Günday', 'image': ''},
  {'name': 'Sunay Akın', 'image': ''},
  {'name': 'Rasim Özdenören', 'image': ''},
  {'name': 'Emrah Serbes', 'image': ''},
  {'name': 'İskender Pala', 'image': ''},
  {'name': 'Tarık Buğra', 'image': ''},
  {'name': 'Aşık Veysel', 'image': ''},
  {'name': 'İsmet Özel', 'image': ''},
  {'name': 'Adalet Agaoglu', 'image': ''},
  {'name': 'İlhan Berk', 'image': ''},
  {'name': 'Ferit Edgü', 'image': ''},
  {'name': 'Latife Tekin', 'image': ''},
  {'name': 'Sevim Ak', 'image': ''},
  {'name': 'Tomris Uyar', 'image': ''},
  {'name': 'Reşat Nuri Güntekin', 'image': ''},
  {'name': 'Hasan Ali Toptaş', 'image': ''},
  {'name': 'Osman Pamukoğlu', 'image': ''},
  {'name': 'Ayfer Tunç', 'image': ''},
  {'name': 'İhsan Eliaçık', 'image': ''},
  {'name': 'Mehmet Akif Ersoy', 'image': ''},
  {'name': 'Ahmet Ümit', 'image': ''},
  {'name': 'Nezihe Meriç', 'image': ''},
  {'name': 'Ahmet Midhat Efendi', 'image': ''},
  {'name': 'Ahmet Arif', 'image': ''},
  {'name': 'Pınar Kür', 'image': ''},
  {'name': 'Attila İlhan', 'image': ''},
  {'name': 'Kemal Özer', 'image': ''},
  {'name': 'İsmet Küntay', 'image': ''},
  {'name': 'Hilmi Yavuz', 'image': ''},
  {'name': 'Murat Gülsoy', 'image': ''},
  {'name': 'Oruç Aruoba', 'image': ''},
  {'name': 'Aslı Erdoğan', 'image': ''},
  {'name': 'Nedim Gürsel', 'image': ''},
  {'name': 'Ümit Yaşar Oğuzcan', 'image': ''},
  {'name': 'Tarık Dursun K.', 'image': ''},
  {'name': 'Emine Sevgi Özdamar', 'image': ''},
  {'name': 'Ziya Gökalp', 'image': ''},
  {'name': 'Hasan Hüseyin Korkmazgil', 'image': ''},
  {'name': 'Erendiz Atasü', 'image': ''},
  {'name': 'Bülent Ortaçgil', 'image': ''},
  {'name': 'Erdal Öz', 'image': ''},
  {'name': 'Rıfat Ilgaz', 'image': ''},
  {'name': 'Sezai Karakoç', 'image': ''},
  {'name': 'Şule Gürbüz', 'image': ''},
  {'name': 'Muazzez İlmiye Çığ', 'image': ''},
  {'name': 'Aşık Mahzuni Şerif', 'image': ''},
  {'name': 'Melih Cevdet Anday', 'image': ''},
  {'name': 'Mina Urgan', 'image': ''},
  {'name': 'Refik Durbaş', 'image': ''},
  {'name': 'Ümit Kaftancıoğlu', 'image': ''},
  {'name': 'Lale Müldür', 'image': ''},
  {'name': 'Şükrü Erbaş', 'image': ''},
  {'name': 'Enis Batur', 'image': ''},
  {'name': 'Bejan Matur', 'image': ''},
  {'name': 'Murat Uyurkulak', 'image': ''},
  {'name': 'Ahmet Hamdi Gezgin', 'image': ''},
  {'name': 'Sezgin Kaymaz', 'image': ''},
  {'name': 'Ayfer Tunc', 'image': ''},
];

List<String> allCategorylist = [
  "TRAVEL",
  "ART",
  "PHILOSOPHY",
  "MATHEMATICS",
  "MEDICAL",
  "BIOGRAPHY",
  "MUSIC",
  "NATURE",
  "PETS",
  "COMPUTERS",
  "ARCHITECTURE",
  "COOKING",
  "PHOTOGRAPHY",
  "DESIGN",
  "DRAMA",
  "FAMILY",
  "FICTION",
  "GAMES & ACTIVITIES",
  "GARDENING",
  "SPORTS",
  "HISTORY",
  "TECHNOLOGY & ENGINEERING",
  "TRANSPORTATION",
  "LAW"
];

List<String> allCategorylistTR = [
  "SEYAHAT",
  "SANAT",
  "FELSEFE",
  "MATEMATİK",
  "TIBBİ",
  "BİYOGRAFİ VE OTOBİYOGRAFİ",
  "MÜZİK",
  "DOĞA",
  "EVCİL HAYVANLAR",
  "BİLGİSAYARLAR",
  "MİMARLIK",
  "YEMEK PİŞİRME",
  "FOTOĞRAFÇILIK",
  "TASARIM",
  "DRAM",
  "AİLE VE İLİŞKİLER",
  "KURGU",
  "OYUNLAR & AKTİVİTELER",
  "BAHÇECİLİK",
  "SPOR & REKREASYON",
  "TARİH",
  "TEKNOLOJİ VE MÜHENDİSLİK",
  "ULAŞIM",
  "HUKUK"
];

List<String> allCategoryImage = [
  "https://images.pexels.com/photos/346885/pexels-photo-346885.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/16932020/pexels-photo-16932020/free-photo-of-sanat-boyama-atolye-naturmort.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/3778998/pexels-photo-3778998.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/714699/pexels-photo-714699.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/40568/medical-appointment-doctor-healthcare-40568.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/3808904/pexels-photo-3808904.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/2090877/pexels-photo-2090877.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/1770809/pexels-photo-1770809.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/2248516/pexels-photo-2248516.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/12883026/pexels-photo-12883026.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/4838026/pexels-photo-4838026.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/4253320/pexels-photo-4253320.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/3014019/pexels-photo-3014019.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/7148060/pexels-photo-7148060.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/3771129/pexels-photo-3771129.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/1739842/pexels-photo-1739842.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/46274/pexels-photo-46274.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  "https://images.pexels.com/photos/1148998/pexels-photo-1148998.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/2886937/pexels-photo-2886937.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/1171084/pexels-photo-1171084.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/1040893/pexels-photo-1040893.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/2582937/pexels-photo-2582937.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/3014002/pexels-photo-3014002.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/5668481/pexels-photo-5668481.jpeg?auto=compress&cs=tinysrgb&w=600",
];

List<Map<String, String>> categoryList = List.generate(allCategorylist.length, (index) {
  return {
    'name': allCategorylist[index],
    'nameTR': allCategorylistTR[index],
    'image': allCategoryImage[index],
  };
});

List<Map<String, String>> kitapListesi = [
  {
    'name': 'Kürk Mantolu Madonna',
    'author': 'Sabahattin Ali',
  },
  {
    'name': 'Kuyucaklı Yusuf',
    'author': 'Sabahattin Ali',
  },
  {
    'name': 'İçimizdeki Şeytan',
    'author': 'Sabahattin Ali',
  },
  {
    'name': 'Dokuzuncu Hariciye Koğuşu',
    'author': 'Peyami Safa',
  },
  {
    'name': 'Çalıkuşu',
    'author': 'Reşat Nuri Güntekin',
  },
  {
    'name': 'Fatih Harbiye',
    'author': 'Peyami Safa',
  },
  {
    'name': 'Sergüzeşt',
    'author': 'Samipaşazade Sezai',
  },
  {
    'name': 'Yaban',
    'author': 'Yakup Kadri Karaosmanoğlu',
  },
  {
    'name': 'Eylül',
    'author': 'Mehmet Rauf',
  },
  {
    'name': 'İntibah',
    'author': 'Namık Kemal',
  },
  {
    'name': 'Acımak',
    'author': 'Reşat Nuri Güntekin',
  },
  {
    'name': 'Yaprak Dökümü',
    'author': 'Reşat Nuri Güntekin',
  },
  {
    'name': 'Taaşşuk-ı Talat ve Fitnat',
    'author': 'Şemseddin Sami',
  },
  {
    'name': 'Mai ve Siyah',
    'author': 'Halid Ziya Uşaklıgil',
  },
  {
    'name': 'Korkuyu Beklerken',
    'author': 'Oğuz Atay',
  },
  {
    'name': 'Araba Sevdası',
    'author': 'Recaizade Mahmut Ekrem',
  },
  {
    'name': 'Ateşten Gömlek',
    'author': 'Halide Edib Adıvar',
  },
  {
    'name': 'Felatun Bey ile Rakım Efendi',
    'author': 'Ahmet Mithat Efendi',
  },
  {
    'name': 'Yalnızız',
    'author': 'Peyami Safa',
  },
  {
    'name': 'Vatan Yahut Silistre',
    'author': 'Namık Kemal',
  },
  {
    'name': 'Sinekli Bakkal',
    'author': 'Halide Edib Adıvar',
  },
  {
    'name': 'Kaşağı',
    'author': 'Ömer Seyfettin',
  },
  {
    'name': 'Kiralık Konak',
    'author': 'Yakup Kadri Karaosmanoğlu',
  },
  {
    'name': 'Aşk-ı Memnu',
    'author': 'Halid Ziya Uşaklıgil',
  },
  {
    'name': 'A\'mak-ı Hayal',
    'author': 'Filibeli Ahmed Hilmi',
  },
  {
    'name': 'Kuyrukluyıldız Altında Bir İzdivaç',
    'author': 'Hüseyin Rahmi Gürpınar',
  },
  {
    'name': 'Huzur',
    'author': 'Ahmet Hamdi Tanpınar',
  },
  {
    'name': 'Şair Evlenmesi',
    'author': 'İbrahim Şinasi',
  },
  {
    'name': 'Son Kuşlar',
    'author': 'Sait Faik Abasıyanık',
  },
  {
    'name': 'Küçük Şeyler',
    'author': 'Samipaşazade Sezai',
  },
  {
    'name': 'Zehra',
    'author': 'Nabizade Nazım',
  },
  {
    'name': 'Dede Korkut Hikâyeleri',
    'author': 'Anonim',
  },
  {
    'name': 'Vurun Kahpeye',
    'author': 'Halide Edib Adıvar',
  },
  {
    'name': 'Esir Şehrin İnsanları',
    'author': 'Kemal Tahir',
  },
  {
    'name': 'Gulyabani',
    'author': 'Hüseyin Rahmi Gürpınar',
  },
  {
    'name': 'Zeytindağı',
    'author': 'Falih Rıfkı Atay',
  },
  {
    'name': 'Sözde Kızlar',
    'author': 'Peyami Safa',
  },
  {
    'name': 'Karabibik',
    'author': 'Nabizade Nazım',
  },
  {
    'name': 'Lüzumsuz Adam',
    'author': 'Sait Faik Abasıyanık',
  },
  {
    'name': 'Matmazel Noraliya\'nın Koltuğu',
    'author': 'Peyami Safa',
  },
  {
    'name': 'Yalnız Efe',
    'author': 'Ömer Seyfettin',
  },
  {
    'name': 'Falaka',
    'author': 'Ömer Seyfettin',
  },
  {
    'name': 'Bir Tereddüdün Romanı',
    'author': 'Peyami Safa',
  },
  {
    'name': 'Mürebbiye',
    'author': 'Hüseyin Rahmi Gürpınar',
  },
  {
    'name': 'Efsuncu Baba',
    'author': 'Hüseyin Rahmi Gürpınar',
  },
  {
    'name': 'Genç Kız Kalbi',
    'author': 'Mehmet Rauf',
  },
  {
    'name': 'Dudaktan Kalbe',
    'author': 'Reşat Nuri Güntekin',
  },
  {
    'name': 'Safahat',
    'author': 'Mehmet Akif Ersoy',
  },
  {
    'name': 'Kağnı - Ses - Esirler',
    'author': 'Sabahattin Ali',
  },
  {
    'name': 'Ömer\'in Çocukluğu',
    'author': 'Muallim Naci',
  },
];

List<String> filterYazar = ["M. Fethullah Gülen"];
List<String> filterTitle = ["Vatan Dostu Vahidüddin"];

double findSimilarityScore(String input, String target) {
  return input.similarityTo(target);
}

bool isSimilar(String input, String target, double threshold) {
  double similarityScore = findSimilarityScore(input, target);
  return similarityScore >= threshold;
}

Future<void> startDelay() async {
  await Future.delayed(const Duration(milliseconds: 500));
}

DateTime stringToDateTime(String dateString) {
  // Tarih-saat dizesini DateTime nesnesine dönüştürmek için DateFormat kullanılır.
  DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
  DateTime dateTime = format.parse(dateString);
  return dateTime;
}

String getRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Şimdi';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} dakika önce';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} saat önce';
  } else if (difference.inDays == 1) {
    return 'Dün';
  } else if (difference.inDays < 6) {
    return '${difference.inDays} gün önce';
  } else {
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }
}



