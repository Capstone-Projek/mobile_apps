import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';

class ButtonNavigateWidget extends StatelessWidget {
  final double width;
  final double height;
  final Function() onTap;
  final String title;

  const ButtonNavigateWidget({
    super.key,
    required this.width,
    required this.height,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: JejakRasaColor.secondary.color,
        padding: EdgeInsets.all(20),
        shadowColor: Colors.black,
        elevation: 5,
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
      ),
      onPressed: onTap,
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: JejakRasaColor.primary.color),
      ),
    );
  }
}
