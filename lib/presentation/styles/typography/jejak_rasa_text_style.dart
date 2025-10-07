import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class JejakRasaTextStyle {
  static final TextStyle _commonStyle = GoogleFonts.poppins();

  static TextStyle header = _commonStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static TextStyle tittle = _commonStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle subHeader = _commonStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static TextStyle deskripsi = _commonStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle subTittle = _commonStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static TextStyle text = _commonStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle subText = _commonStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static TextStyle subSubText = _commonStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static TextStyle subSubSubText = _commonStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );
}
