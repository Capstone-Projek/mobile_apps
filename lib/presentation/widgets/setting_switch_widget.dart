import 'package:flutter/material.dart';

class SettingSwitchWidget extends StatelessWidget {
  final String title;
  final bool isDarkTheme;
  final ValueChanged<bool> onChanged;
  const SettingSwitchWidget({
    super.key,
    required this.title,
    required this.isDarkTheme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      margin: const EdgeInsets.only(bottom: 5, top: 7),
      width: double.infinity,
      height: 42,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          Switch(
            value: isDarkTheme,
            onChanged: onChanged,
            activeColor: Colors.green,
            inactiveTrackColor: Colors.red,
            inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
            activeThumbColor: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
