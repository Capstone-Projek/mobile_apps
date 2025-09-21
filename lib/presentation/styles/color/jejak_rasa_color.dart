import 'package:flutter/material.dart';

enum JejakRasaColor {
  primary("primary-color", Color(0xffE7E7E7)),
  secondary("secondary-color", Color(0xff26599A)),
  tersier("tersier-color", Color(0xff273128)),
  accent("accent-color", Color(0xffB2B7B8)),
  error("error-color", Color(0xffFF4545));

  const JejakRasaColor(this.name, this.color);

  final Color color;
  final String name;
}
