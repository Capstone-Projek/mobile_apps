import 'package:flutter/material.dart';

class ButtonJoinWidget extends StatelessWidget {
  final Function() onTap;
  final String icon;
  const ButtonJoinWidget({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 45,
          height: 45,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            image: DecorationImage(image: AssetImage(icon), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
