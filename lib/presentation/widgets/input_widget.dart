import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';

// ignore: must_be_immutable
class InputWidget extends StatelessWidget {
  Widget inputField;

  InputWidget({Key? key, required this.inputField}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: inputField);
  }
}

InputDecoration customInputDecoration(
  BuildContext context,
  String hintText, {
  Widget? suffixIcon,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSecondary,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    fillColor: Theme.of(context).colorScheme.primary,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 25),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: JejakRasaColor.tersier.color, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: JejakRasaColor.tersier.color, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: JejakRasaColor.tersier.color, width: 2.5),
    ),
  );
}
