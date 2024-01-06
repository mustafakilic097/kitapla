import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticScreen extends ConsumerStatefulWidget {
  const StatisticScreen({super.key});

  @override
  ConsumerState<StatisticScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<StatisticScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// class _StatisticScreenState extends ConsumerState<StatisticScreen> {
//   List<FlSpot>? haftalikOkumaVerisi;
//   List<String>? aylikOkumaVerisi;
//   List<String>? haftalikHedefVerisi;
//   List<String>? aylikHedefVerisi;
//   List<String>? ayinGunleri;
//   bool ekranYukleme = false;
//   int seciliAy = 0;
//   int daysInMonth = 0;
//   DateTime date = DateTime.now();

//   final _blankspots = [for (int i = 1; i <= 7; i++) FlSpot(i.toDouble(), 0)];

//   void tumVerileriGetir() {
//     // int firstDayOfWeek = date.day-date.weekday - (date.weekday - DateTime(DateTime.now().year, DateTime.now().month, 1).weekday);
//     int firstDayOfWeek = date.day - date.weekday + 1;
//     if (date.day == 1) firstDayOfWeek = date.day;
//     // print(
//     //     "Haftagün:${date.weekday} cikarilan:${DateTime(DateTime.now().year, DateTime.now().month, 1).weekday} firstDay:$firstDayOfWeek ayinİlkGunu:${DateTime(DateTime.now().year, DateTime.now().month, 1).weekday + 1}");
//     var veriler = ref.read(statisticRepositoryProvider).haftalikVeriGetir(firstDayOfWeek);
//     List<FlSpot> newVeriler = [];
//     for (var i = 0; i < veriler.length; i++) {
//       newVeriler.add(FlSpot((i + 1).toDouble(), double.parse(veriler[i])));
//     }
//     print("secili ay: $seciliAy");
//     var veriler1 = ref.read(statisticRepositoryProvider).aylikVeriGetir(seciliAy);

//     var veriler2 = ref.read(statisticRepositoryProvider).hedefGetirAylik(seciliAy);

//     var veriler3 = ref.read(statisticRepositoryProvider).hedefGetirHaftalik(haftaBaslangicGunu: firstDayOfWeek);

//     setState(() {
//       haftalikOkumaVerisi = newVeriler;
//       aylikOkumaVerisi = veriler1;
//       aylikHedefVerisi = veriler2;
//       haftalikHedefVerisi = veriler3;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     seciliAy = date.month;
//     daysInMonth = DateTime(date.year, seciliAy + 1, 0).day;
//     Future.delayed(const Duration(milliseconds: 500), () {
//       setState(() {
//         ayinGunleri = [
//           for (int j = 0; j < daysInMonth; j++)
//             ref
//                 .read(statisticRepositoryProvider)
//                 .gunleriYaz(DateTime(DateTime.now().year, seciliAy, j + 1).weekday.toDouble())
//         ];
//       });
//       ref.read(statisticRepositoryProvider).gunlukVeriBaslat("1").whenComplete(() {
//         tumVerileriGetir();
//       });
//     }).whenComplete(() => setState(() {
//           ekranYukleme = true;
//         }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final StatisticRepository statisticRepository = ref.watch(statisticRepositoryProvider);
//     return !ekranYukleme
//         ? const Scaffold(
//             body: Center(
//                 child: SleekCircularSlider(
//               appearance: CircularSliderAppearance(
//                 spinnerMode: true,
//                 size: 75,
//               ),
//             )),
//           )
//         : Scaffold(
//             backgroundColor: Colors.grey.shade900,
//             appBar: AppBar(
//               title: Text("İstatistiklerim", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
//               centerTitle: true,
//               elevation: 0,
//               backgroundColor: Colors.grey.shade900,
//               actions: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       children: [
//                         // const Text("■■●",style: TextStyle(color: Colors.purple,letterSpacing: 0)),
//                         Container(
//                             width: 15,
//                             height: 8,
//                             decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(8))),
//                         // Icon(Icons.remove,color: Colors.purple),
//                         const Text(" Hedef ")
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                             width: 15,
//                             height: 8,
//                             decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8))),
//                         // Icon(Icons.remove,color: Colors.purple),
//                         const Text(" Veri ")
//                       ],
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             body: ListView(
//               physics: const BouncingScrollPhysics(),
//               children: [
//                 buildOkumaSuresiGrafik(statisticRepository),
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           MukemmelContainer(
//                             width: 100,
//                             height: 130,
//                             padding: const EdgeInsets.all(4),
//                             onTap: () {
//                               Navigator.push(context, createRoute());
//                             },
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Icon(Icons.timer_rounded, size: 30, color: Colors.grey[100]),
//                                 Text(
//                                   "Okumaya Başla",
//                                   textAlign: TextAlign.center,
//                                   style: GoogleFonts.roboto(fontSize: 18, color: Colors.grey[100]),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: MukemmelContainer(
//                               color: Renk.blackGrey,
//                               borderRadius: 20,
//                               padding: const EdgeInsets.all(2),
//                               onTap: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => buildHedefDegistirDialog(statisticRepository),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Okuma\nHedefim:",
//                                       style: GoogleFonts.quicksand(fontSize: 30, color: Colors.grey.shade200),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(right: 12.0, top: 8),
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             (aylikHedefVerisi != null
//                                                     ? double.parse(aylikHedefVerisi![date.day]) * 100
//                                                     : statisticRepository.hedefSure * 100)
//                                                 .toStringAsFixed(0),
//                                             style: GoogleFonts.roboto(fontSize: 50, color: Colors.grey.shade300),
//                                           ),
//                                           Text("dk",
//                                               style: GoogleFonts.roboto(fontSize: 25, color: Colors.grey.shade400))
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),

//                           // buildHedefDegsitir(statisticRepository),
//                         ],
//                       ),
//                       const Padding(padding: EdgeInsets.all(8)),
//                       buildGunlukHaftalikPerformans(statisticRepository),
//                       buildAylikOkuma(statisticRepository)
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }

//   Row buildGunlukHaftalikPerformans(StatisticRepository statisticRepository) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             MukemmelContainer(
//                 height: 150,
//                 color: Renk.indigo,
//                 width: MediaQuery.of(context).size.width / 2.5,
//                 // decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey.shade800
//                 //     // gradient: LinearGradient(colors: [Colors.grey.shade700, Colors.grey.shade900])),
//                 //     ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SleekCircularSlider(
//                     initialValue: ((haftalikOkumaVerisi != null ? haftalikOkumaVerisi![date.weekday - 1].y : 0) /
//                                     (double.parse(haftalikHedefVerisi != null
//                                         ? haftalikHedefVerisi![date.weekday - 1]
//                                         : statisticRepository.hedefSure.toString()))) *
//                                 100 >
//                             100
//                         ? 100
//                         : ((haftalikOkumaVerisi != null ? haftalikOkumaVerisi![date.weekday - 1].y : 0) /
//                                 (double.parse(haftalikHedefVerisi != null
//                                     ? haftalikHedefVerisi![date.weekday - 1]
//                                     : statisticRepository.hedefSure.toString()))) *
//                             100,
//                     innerWidget: (percentage) => Center(
//                         child: Text(
//                       "%${percentage.toStringAsFixed(0)}",
//                       style: GoogleFonts.quicksand(color: Colors.white, fontSize: 30),
//                     )),
//                     appearance: CircularSliderAppearance(
//                         customWidths: CustomSliderWidths(progressBarWidth: 8, trackWidth: 3),
//                         customColors: CustomSliderColors(
//                           dynamicGradient: true,
//                           trackColor: Colors.white,
//                           progressBarColors: [Colors.tealAccent, Colors.greenAccent, Colors.lightGreen],
//                         )),
//                   ),
//                 )),
//             Text(
//               "Günlük",
//               style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 20),
//             ),
//           ],
//         ),
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Builder(builder: (context) {
//               double initialValue = 0;
//               if (haftalikOkumaVerisi != null && haftalikHedefVerisi != null) {
//                 if (haftalikOkumaVerisi!.length == haftalikHedefVerisi!.length) {
//                   for (var i = 0; i < 7; i++) {
//                     var deger = haftalikOkumaVerisi![i].y / double.parse(haftalikHedefVerisi![i]);
//                     deger > 1 ? deger = 1 : null;
//                     initialValue += deger / 7;

//                     // initialValue += (((haftalikOkumaVerisi![i].y * 100) /
//                     //                 (double.parse(haftalikHedefVerisi![i]) * 100)) >
//                     //             1
//                     //         ? 1
//                     //         : ((haftalikOkumaVerisi![i].y * 100) /
//                     //             (double.parse(haftalikHedefVerisi![i]) * 100))) /
//                     //     7;
//                   }
//                 }
//               }
//               initialValue *= 100;
//               initialValue > 100 ? initialValue = 100 : null;
//               initialValue < 0 ? initialValue = 0 : null;
//               return MukemmelContainer(
//                   color: Renk.indigo,
//                   width: MediaQuery.of(context).size.width / 2.5,
//                   height: 150,
//                   // padding: const EdgeInsets.all(8),
//                   // decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey.shade800
//                   //     // gradient: LinearGradient(colors: [Colors.grey.shade700, Colors.grey.shade900])),
//                   //     ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SleekCircularSlider(
//                       initialValue: initialValue,
//                       innerWidget: (percentage) => Center(
//                           child: Text(
//                         "%${percentage.toStringAsFixed(0)}",
//                         style: GoogleFonts.quicksand(color: Colors.white, fontSize: 30),
//                       )),
//                       appearance: CircularSliderAppearance(
//                           customWidths: CustomSliderWidths(progressBarWidth: 8, trackWidth: 3),
//                           customColors: CustomSliderColors(
//                             dynamicGradient: true,
//                             trackColor: Colors.white,
//                             progressBarColors: [Colors.tealAccent, Colors.greenAccent, Colors.lightGreen],
//                           )),
//                     ),
//                   ));
//             }),
//             Text(
//               "Haftalık",
//               style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 20),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Column buildOkumaSuresiGrafik(StatisticRepository statisticRepository) {
//     return Column(
//         // mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Container(
//           //   alignment: Alignment.centerLeft,
//           //   padding: const EdgeInsets.only(top: 8.0, left: 8),
//           //   child: Text(
//           //     "Okuma Süresi Grafiği",
//           //     style: GoogleFonts.quicksand(color: Colors.grey.shade900, fontWeight: FontWeight.bold, fontSize: 20),
//           //   ),
//           // ),
//           Padding(
//             padding: const EdgeInsets.only(left: 8, right: 32, bottom: 12, top: 24),
//             child: AspectRatio(
//               aspectRatio: 1.7,
//               child: LineChart(LineChartData(
//                 //Tıklandığında Açılan tooltip
//                 lineTouchData: LineTouchData(
//                   touchTooltipData: LineTouchTooltipData(
//                     maxContentWidth: 100,
//                     tooltipBgColor: Colors.white,
//                     getTooltipItems: (touchedSpots) {
//                       return touchedSpots.map((LineBarSpot touchedSpot) {
//                         final textStyle = TextStyle(
//                           color: touchedSpot.bar.gradient?.colors[0] ?? touchedSpot.bar.color,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         );
//                         return LineTooltipItem(
//                           '${touchedSpot.x == 1 ? "Pzt" : touchedSpot.x == 2 ? "Sal" : touchedSpot.x == 3 ? "Çar" : touchedSpot.x == 4 ? "Per" : touchedSpot.x == 5 ? "Cum" : touchedSpot.x == 6 ? "Cmt" : touchedSpot.x == 7 ? "Paz" : "$touchedSpot.x"}, ${(touchedSpot.y * 100).toStringAsFixed(0)} dk',
//                           textStyle,
//                         );
//                       }).toList();
//                     },
//                   ),
//                   handleBuiltInTouches: true,
//                   getTouchLineStart: (data, index) => 0,
//                 ),

//                 gridData: FlGridData(
//                   show: true,
//                   drawHorizontalLine: true,
//                   verticalInterval: 1,
//                   horizontalInterval: statisticRepository.gunlukMaksimumOkumaSuresi / 10,
//                   getDrawingVerticalLine: (value) {
//                     return FlLine(
//                       color: const Color(0xff37434d),
//                       strokeWidth: 0.5,
//                     );
//                   },
//                   drawVerticalLine: true,
//                   checkToShowVerticalLine: (value) {
//                     return true;
//                   },
//                   checkToShowHorizontalLine: (value) => true,
//                   getDrawingHorizontalLine: (value) {
//                     // var kontrol = int.parse(
//                     //         (statisticRepository.hedefSure / (statisticRepository.gunlukMaksimumOkumaSuresi / 10))
//                     //             .toStringAsFixed(0)) *
//                     //     statisticRepository.gunlukMaksimumOkumaSuresi /
//                     //     10;
//                     // if (value.toStringAsFixed(2) == kontrol.toStringAsFixed(2)) {
//                     //   return FlLine(color: Colors.grey.shade500, dashArray: [5]);
//                     // }
//                     return FlLine(
//                       color: const Color(0xff37434d),
//                       strokeWidth: 0.5,
//                     );
//                   },
//                 ),
//                 titlesData: FlTitlesData(
//                   show: true,
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 30,
//                       getTitlesWidget: (value, meta) {
//                         return SideTitleWidget(
//                           axisSide: meta.axisSide,
//                           child: Text(
//                             ref.read(statisticRepositoryProvider).gunleriYaz(value),
//                             style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: Colors.grey.shade200),
//                           ),
//                         );
//                       },
//                       interval: 1,
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     axisNameSize: 50,
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         return Text(
//                           "${(value * 100).toStringAsFixed(0)} dk",
//                           style: GoogleFonts.quicksand(color: Colors.grey.shade100),
//                         );
//                       },
//                       reservedSize: 50,
//                       interval: statisticRepository.gunlukMaksimumOkumaSuresi / 4,
//                     ),
//                   ),
//                   topTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   rightTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                 ),
//                 borderData: FlBorderData(
//                   show: true,
//                   border: Border.all(color: const Color(0xff37434d)),
//                 ),
//                 minX: 1,
//                 maxX: 7,
//                 minY: 0,
//                 maxY: statisticRepository.gunlukMaksimumOkumaSuresi,
//                 // betweenBarsData: [
//                 //   BetweenBarsData(
//                 //       fromIndex: 0,
//                 //       toIndex: 1,
//                 //       gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
//                 //         ColorTween(begin: Colors.green.shade700, end: Colors.green.shade600).lerp(0.2)!,
//                 //         ColorTween(begin: Colors.green.shade500, end: Colors.green.shade500)
//                 //             .lerp(0.2)!
//                 //             .withOpacity(0.2),
//                 //       ])),
//                 // ],
//                 //Verilerin belirtildiği Kısım
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: haftalikHedefVerisi != null
//                         ? [
//                             FlSpot(1, double.parse(haftalikHedefVerisi![0])),
//                             FlSpot(2, double.parse(haftalikHedefVerisi![1])),
//                             FlSpot(3, double.parse(haftalikHedefVerisi![2])),
//                             FlSpot(4, double.parse(haftalikHedefVerisi![3])),
//                             FlSpot(5, double.parse(haftalikHedefVerisi![4])),
//                             FlSpot(6, double.parse(haftalikHedefVerisi![5])),
//                             FlSpot(7, double.parse(haftalikHedefVerisi![6])),
//                           ]
//                         : _blankspots,
//                     isCurved: true,
//                     barWidth: 6,
//                     isStrokeCapRound: false,
//                     preventCurveOverShooting: false,
//                     isStrokeJoinRound: false,
//                     color: Colors.purple.shade900.withOpacity(0.4),
//                     dotData: FlDotData(
//                       show: false,
//                       getDotPainter: (p0, p1, p2, p3) {
//                         return FlDotCirclePainter(color: Colors.blue.shade900);
//                       },
//                     ),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       // applyCutOffY: true,
//                       // cutOffY: statisticRepository.hedefSure,
//                       // color: Colors.green,
//                       gradient: LinearGradient(colors: [
//                         ColorTween(begin: Colors.purple.shade700, end: Colors.purple.shade600)
//                             .lerp(0.2)!
//                             .withOpacity(0.3),
//                         ColorTween(begin: Colors.purple.shade500, end: Colors.purple.shade500)
//                             .lerp(0.2)!
//                             .withOpacity(0.2),
//                       ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
//                     ),
//                   ),
//                   LineChartBarData(
//                     // showingIndicators: [0, 1, 2, 3, 4],
//                     spots: haftalikOkumaVerisi ?? _blankspots,

//                     isCurved: false,
//                     // gradient: LinearGradient(
//                     //   colors: [
//                     //     ColorTween(begin: Colors.cyan.shade900, end: Colors.cyan.shade800).lerp(0.2)!,
//                     //     ColorTween(begin: Colors.cyan.shade700, end: Colors.cyan.shade600).lerp(0.2)!,
//                     //   ],
//                     // ),
//                     barWidth: 3,
//                     isStrokeCapRound: true,
//                     preventCurveOverShooting: true,
//                     isStrokeJoinRound: true,
//                     color: Colors.cyan.shade600.withOpacity(0.5),
//                     dotData: FlDotData(
//                       show: true,
//                       getDotPainter: (p0, p1, p2, p3) {
//                         return FlDotCirclePainter(color: Colors.blue, radius: 4);
//                       },
//                     ),
//                     belowBarData: BarAreaData(
//                       show: false,
//                       // applyCutOffY: true,
//                       // cutOffY: statisticRepository.hedefSure,
//                       color: Colors.cyan.shade600.withOpacity(0.1),
//                       // gradient: LinearGradient(colors: [
//                       //   ColorTween(begin: Colors.cyan.shade700, end: Colors.cyan.shade600).lerp(0.2)!.withOpacity(0.3),
//                       //   ColorTween(begin: Colors.cyan.shade500, end: Colors.cyan.shade500).lerp(0.2)!.withOpacity(0.2),
//                       // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
//                     ),
//                   ),
//                 ],
//               )),
//             ),
//           ),
//         ]);
//   }

//   Column buildAylikOkuma(StatisticRepository statisticRepository) {
//     return Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
//       Padding(
//         padding: const EdgeInsets.only(top: 20, right: 25, left: 25),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             InkWell(
//                 onTap: () {
//                   setState(() {
//                     if (seciliAy != 1) {
//                       seciliAy--;
//                       daysInMonth = DateTime(date.year, seciliAy + 1, 0).day;
//                       aylikOkumaVerisi = ref.read(statisticRepositoryProvider).aylikVeriGetir(seciliAy);
//                       aylikHedefVerisi = ref.read(statisticRepositoryProvider).hedefGetirAylik(seciliAy);
//                       ayinGunleri = [
//                         for (int j = 0; j < daysInMonth; j++)
//                           ref
//                               .read(statisticRepositoryProvider)
//                               .gunleriYaz(DateTime(DateTime.now().year, seciliAy, j + 1).weekday.toDouble())
//                       ];
//                     }
//                   });
//                 },
//                 child: const Icon(
//                   CupertinoIcons.arrowshape_turn_up_left_fill,
//                   color: Colors.indigo,
//                 )),
//             Container(
//               alignment: Alignment.center,
//               child: Text(
//                 ref.read(statisticRepositoryProvider).aylariYaz(seciliAy),
//                 style: GoogleFonts.quicksand(color: Colors.grey.shade900, fontWeight: FontWeight.bold, fontSize: 20),
//               ),
//             ),
//             InkWell(
//                 onTap: () {
//                   setState(() {
//                     if (seciliAy != 12) {
//                       seciliAy++;
//                       daysInMonth = DateTime(date.year, seciliAy + 1, 0).day;
//                       aylikOkumaVerisi = ref.read(statisticRepositoryProvider).aylikVeriGetir(seciliAy);
//                       aylikHedefVerisi = ref.read(statisticRepositoryProvider).hedefGetirAylik(seciliAy);
//                       ayinGunleri = [
//                         for (int j = 0; j < daysInMonth; j++)
//                           ref
//                               .read(statisticRepositoryProvider)
//                               .gunleriYaz(DateTime(DateTime.now().year, seciliAy, j + 1).weekday.toDouble())
//                       ];
//                     }
//                   });
//                 },
//                 child: const Icon(
//                   CupertinoIcons.arrowshape_turn_up_right_fill,
//                   color: Colors.indigo,
//                 )),
//           ],
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.only(top: 0, right: 10, left: 10),
//         child: MukemmelContainer(
//           padding: const EdgeInsets.only(top: 0, left: 8, right: 8),
//           color: Renk.indigo,
//           width: MediaQuery.of(context).size.width,
//           // height: 350,
//           alignment: Alignment.center,
//           // decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(15)),
//           // padding: const EdgeInsets.all(8),
//           child: Wrap(
//             children: [
//               for (int i = 0; i < daysInMonth; i++)
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     FilterChip(
//                       label: Text(double.parse(aylikOkumaVerisi != null ? aylikOkumaVerisi![i] : "0") >=
//                               double.parse(aylikHedefVerisi != null
//                                   ? aylikHedefVerisi![i]
//                                   : statisticRepository.hedefSure.toString())
//                           ? "${i + 1}"
//                           : "${i + 1}"),
//                       backgroundColor: double.parse(aylikOkumaVerisi != null ? aylikOkumaVerisi![i] : "0") >=
//                               double.parse(aylikHedefVerisi != null
//                                   ? aylikHedefVerisi![i]
//                                   : statisticRepository.hedefSure.toString())
//                           ? Colors.green
//                           : Colors.grey.shade300,
//                       onSelected: (value) {
//                         showDialog(
//                             context: context,
//                             builder: (context) => NDialog(
//                                 title: Text(
//                                     "Tarih: ${i + 1}.${date.month < 10 ? "0${date.month}" : date.month}.${date.year}"),
//                                 content: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                           padding: const EdgeInsets.all(8),
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(15),
//                                               gradient: LinearGradient(colors: [Colors.teal, Colors.teal.shade800])),
//                                           child: SleekCircularSlider(
//                                             initialValue:
//                                                 ((double.parse(aylikOkumaVerisi != null ? aylikOkumaVerisi![i] : "0")) /
//                                                                 (double.parse(aylikHedefVerisi != null
//                                                                     ? aylikHedefVerisi![i]
//                                                                     : statisticRepository.hedefSure.toString()))) *
//                                                             100 >
//                                                         100
//                                                     ? 100
//                                                     : ((double.parse(aylikOkumaVerisi != null
//                                                                 ? aylikOkumaVerisi![i]
//                                                                 : "0")) /
//                                                             (double.parse(aylikHedefVerisi != null
//                                                                 ? aylikHedefVerisi![i]
//                                                                 : statisticRepository.hedefSure.toString()))) *
//                                                         100,
//                                             innerWidget: (percentage) => Center(
//                                                 child: Text(
//                                               "%${percentage.toStringAsFixed(0)}",
//                                               style: GoogleFonts.quicksand(color: Colors.white, fontSize: 30),
//                                             )),
//                                             appearance: CircularSliderAppearance(
//                                                 customColors: CustomSliderColors(
//                                                     dynamicGradient: true,
//                                                     trackColor: Colors.white,
//                                                     progressBarColors: [
//                                                   Colors.tealAccent,
//                                                   Colors.greenAccent,
//                                                   Colors.white
//                                                 ])),
//                                           )),
//                                       Text(
//                                           "${(double.parse(aylikOkumaVerisi != null ? aylikOkumaVerisi![i] : "0") * 100).toStringAsFixed(0)} dk okuma yaptınız"),
//                                       Text(
//                                           "Hedef: ${(double.parse(aylikHedefVerisi != null ? aylikHedefVerisi![i] : statisticRepository.hedefSure.toString()) * 100).toStringAsFixed(0)} dk"),
//                                       Text(
//                                           "Tarih: ${i + 1}.${date.month < 10 ? "0${date.month}" : date.month}.${date.year}"),
//                                       double.parse(aylikOkumaVerisi != null ? aylikOkumaVerisi![i] : "0") >=
//                                               double.parse(aylikHedefVerisi != null
//                                                   ? aylikHedefVerisi![i]
//                                                   : statisticRepository.hedefSure.toString())
//                                           ? const Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                                 Text("Hedefe ulaşıldı"),
//                                                 Icon(
//                                                   Icons.check_circle,
//                                                   color: Colors.green,
//                                                   size: 25,
//                                                 ),
//                                               ],
//                                             )
//                                           : const Icon(
//                                               Icons.remove_circle,
//                                               color: Colors.grey,
//                                               size: 25,
//                                             ),
//                                     ])));
//                       },
//                     ),
//                     Text(
//                       ayinGunleri != null ? ayinGunleri![i] : (i + 1).toString(),
//                       style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     ]);
//   }

//   NDialog buildHedefDegistirDialog(StatisticRepository statisticRepository) {
//     TextEditingController controller = TextEditingController();
//     return NDialog(
//       content: Container(
//         alignment: Alignment.center,
//         height: 200,
//         width: 200,
//         child: ListView(
//           shrinkWrap: true,
//           children: [
//             TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                   border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(20)),
//                   label: const Text("Günlük okuma hedefi...")),
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               keyboardType: TextInputType.number,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 FilterChip(
//                     label: const Text("15 dk"),
//                     backgroundColor: Colors.green.shade400,
//                     onSelected: (value) {
//                       ref.read(statisticRepositoryProvider).gunlukHedefDegistir(0.15);
//                       tumVerileriGetir();
//                       Navigator.pop(context);
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hedef güncellendi")));
//                     }),
//                 FilterChip(
//                     label: const Text("30 dk"),
//                     backgroundColor: Colors.green.shade500,
//                     onSelected: (value) {
//                       ref.read(statisticRepositoryProvider).gunlukHedefDegistir(0.3);
//                       tumVerileriGetir();
//                       Navigator.pop(context);
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hedef güncellendi")));
//                     }),
//                 FilterChip(
//                     label: const Text("45 dk"),
//                     backgroundColor: Colors.green.shade600,
//                     onSelected: (value) {
//                       ref.read(statisticRepositoryProvider).gunlukHedefDegistir(0.45);
//                       tumVerileriGetir();
//                       Navigator.pop(context);
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hedef güncellendi")));
//                     }),
//                 FilterChip(
//                     label: const Text("90 dk"),
//                     backgroundColor: Colors.green.shade700,
//                     onSelected: (value) {
//                       ref.read(statisticRepositoryProvider).gunlukHedefDegistir(0.9);
//                       tumVerileriGetir();
//                       Navigator.pop(context);
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hedef güncellendi")));
//                     }),
//               ],
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   int? yeniHedef = int.tryParse(controller.text);
//                   if (yeniHedef != null) {
//                     ref.read(statisticRepositoryProvider).gunlukHedefDegistir(double.parse(yeniHedef.toString()) / 100);
//                     tumVerileriGetir();
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hedef güncellendi")));
//                   } else {
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context)
//                         .showSnackBar(const SnackBar(content: Text("Hatalı bir değer girildi!!")));
//                   }
//                 },
//                 child: const Text("Kaydet"))
//           ],
//         ),
//       ),
//     );
//   }
// }

enum Renk { orange, purple, blackGrey, indigo }

class MukemmelContainer extends StatefulWidget {
  final double width;
  final double? height;
  final void Function()? onTap;
  final Widget child;
  final Renk color;
  final double borderRadius;
  final EdgeInsets? padding;
  final Alignment alignment;
  const MukemmelContainer(
      {super.key,
      this.width = 100,
      this.height,
      this.onTap,
      this.alignment = Alignment.center,
      required this.child,
      this.color = Renk.orange,
      this.borderRadius = 42,
      this.padding});

  @override
  State<MukemmelContainer> createState() => _MukemmelContainerState();
}

class _MukemmelContainerState extends State<MukemmelContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int animation = 0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(8),
      child: InkWell(
        onTap: widget.onTap != null
            ? () {
                _controller.forward();
                Future.delayed(const Duration(milliseconds: 200), () {
                  _controller.reverse();
                }).whenComplete(() {
                  widget.onTap!();
                });
              }
            : null,
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 1.0,
            end: 0.7,
          ).animate(_controller),
          child: Container(
            // duration: const Duration(milliseconds: 500),
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
                boxShadow: [
                  widget.color == Renk.orange
                      ? BoxShadow(
                          color: Colors.deepOrange.shade600,
                          offset: const Offset(0, 20),
                          blurRadius: 30,
                          spreadRadius: -5,
                        )
                      : widget.color == Renk.indigo
                          ? BoxShadow(
                              color: Colors.indigo.shade600,
                              offset: const Offset(0, 15),
                              blurRadius: 30,
                              spreadRadius: -5,
                            )
                          : widget.color == Renk.purple
                              ? BoxShadow(
                                  color: Colors.deepPurple.shade600,
                                  offset: const Offset(0, 15),
                                  blurRadius: 30,
                                  spreadRadius: -5,
                                )
                              : widget.color == Renk.blackGrey
                                  ? BoxShadow(
                                      color: Colors.grey.shade700,
                                      offset: const Offset(0, 15),
                                      blurRadius: 30,
                                      spreadRadius: -5,
                                    )
                                  : BoxShadow(
                                      color: Colors.grey.shade600,
                                      offset: const Offset(0, 15),
                                      blurRadius: 30,
                                      spreadRadius: -5,
                                    ),
                ],
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: widget.color == Renk.blackGrey
                        ? [Colors.grey.shade700, Colors.grey.shade800, Colors.grey.shade900, Colors.grey.shade900]
                        : widget.color == Renk.indigo
                            ? [
                                Colors.indigo.shade400,
                                Colors.indigo.shade500,
                                Colors.indigo.shade600,
                                Colors.indigo.shade600,
                              ]
                            : widget.color == Renk.orange
                                ? [
                                    Colors.deepOrange.shade400,
                                    Colors.deepOrange.shade500,
                                    Colors.deepOrange.shade600,
                                    Colors.deepOrange.shade600,
                                  ]
                                : widget.color == Renk.purple
                                    ? [
                                        Colors.deepPurple.shade400,
                                        Colors.deepPurple.shade500,
                                        Colors.deepPurple.shade600,
                                        Colors.deepPurple.shade600,
                                      ]
                                    : [
                                        Colors.grey.shade700,
                                        Colors.grey.shade800,
                                        Colors.grey.shade900,
                                        Colors.grey.shade900
                                      ],
                    stops: const [0.1, 0.3, 0.9, 1.0])),
            child: Align(alignment: widget.alignment, child: widget.child),
          ),
        ),
      ),
    );
  }
}
