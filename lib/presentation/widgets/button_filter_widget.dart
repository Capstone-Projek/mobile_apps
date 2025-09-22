import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';

class ButtonFilterWidget extends StatelessWidget {
  final double width;
  final String icon;
  final String title;
  final Function() onTap;

  const ButtonFilterWidget({
    super.key,
    required this.width,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          height: 61,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, strokeAlign: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon, width: width, height: 15),
              SizedBox(height: 3),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: JejakRasaColor.primary.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
