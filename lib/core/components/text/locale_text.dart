// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart' show BuildContext, StatelessWidget, Text, TextStyle, Widget;
import 'package:kitapla/core/extension/string_extension.dart';

class LocaleText extends StatelessWidget {
  String text;
  final TextStyle? style;
  LocaleText(this.text, {super.key,this.style});

  @override
  Widget build(BuildContext context) {
    return Text(text.locale,style: style,);
  }
}
