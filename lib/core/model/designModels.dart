import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle textOrtaSecondary(context){
  TextStyle textOrtaSecondary1 = GoogleFonts.quicksand(
    color: Theme.of(context).secondaryHeaderColor,
    fontSize: 18,
  );
  return textOrtaSecondary1;
}

TextStyle textOrta = GoogleFonts.quicksand(fontSize: 18);


class HazirProfil{
  IconData icon;
  Color iconColor;
  Color backgroundColor;

  HazirProfil({required this.icon,required this.iconColor,required this.backgroundColor});
}

List<HazirProfil> hazirProfiller = [
  HazirProfil(icon: Icons.book, iconColor: Colors.white, backgroundColor: Colors.green),
  HazirProfil(icon: Icons.menu_book_rounded, iconColor: Colors.red, backgroundColor: Colors.white),
  HazirProfil(icon: Icons.abc_outlined, iconColor: Colors.white, backgroundColor: Colors.black),
  HazirProfil(icon: Icons.zoom_in, iconColor: Colors.white, backgroundColor: Colors.blue),
  HazirProfil(icon: Icons.accessibility_sharp, iconColor: Colors.deepPurple, backgroundColor: Colors.grey),
];

List<IconData> bookIcons = [
  Icons.menu_book_rounded,
  Icons.book,
  Icons.bookmark,
  Icons.library_books,
  Icons.menu_book,
  Icons.local_library,
  Icons.format_quote,
  Icons.create,
  Icons.check_circle,
  Icons.event_note,
  Icons.timer,
  Icons.settings,
  Icons.person,
  Icons.search,
  Icons.favorite,
  Icons.star,
  Icons.thumb_up,
  Icons.thumb_down,
  Icons.arrow_back,
  Icons.arrow_forward,
  Icons.add,
  Icons.check,
  Icons.close,
  Icons.delete,
  Icons.edit,
  Icons.favorite,
  Icons.home,
  Icons.info,
  Icons.mail,
  Icons.person,
  Icons.search,
  Icons.settings,
  Icons.star,
  Icons.thumb_up,
  Icons.thumb_down,
  Icons.book,
  Icons.bookmark,
  Icons.library_books,
  Icons.menu_book,
  Icons.local_library,
  Icons.format_quote,
  Icons.create,
  Icons.check_circle,
  Icons.event_note,
  Icons.timer,
  Icons.account_circle,
  Icons.attach_file,
  Icons.check_box,
  Icons.description,
  Icons.email,
  Icons.filter_list,
  Icons.grade,
  Icons.help,
  Icons.insert_drive_file,
  Icons.label,
  Icons.menu,
  Icons.notifications,
  Icons.palette,
  Icons.question_answer,
  Icons.refresh,
  Icons.save,
  Icons.today,
  Icons.undo,
  Icons.view_list,
  Icons.wifi,
  Icons.zoom_in,
  Icons.zoom_out,
  // İstediğiniz diğer ikonları buraya ekleyebilirsiniz
];
List<Color> colorCombinations = [
  Colors.black,
  Colors.white,
  Colors.deepPurple,
  Colors.orange,
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.amber,
  Colors.pink,
  Colors.teal,
  Colors.purple,
  Colors.yellow,
  Colors.indigo,
  Colors.lightBlue,
  Colors.lime,
  Colors.cyan,
  Colors.brown,
  Colors.grey,
  Colors.redAccent,
  Colors.blueAccent,
  Colors.greenAccent,
  Colors.amberAccent,
  Colors.pinkAccent,
  Colors.tealAccent,
  Colors.purpleAccent,
  Colors.yellowAccent,
  Colors.cyanAccent,
  Colors.orangeAccent,
  Colors.deepOrange,
  Colors.lightGreen,
  Colors.deepPurpleAccent,
  Colors.limeAccent,
  Colors.indigoAccent,
  Colors.grey.shade500,
  Colors.grey.shade600,
  Colors.grey.shade700,
  Colors.grey.shade800,
  Colors.grey.shade900,
  // İstediğiniz diğer renkleri buraya ekleyebilirsiniz
];