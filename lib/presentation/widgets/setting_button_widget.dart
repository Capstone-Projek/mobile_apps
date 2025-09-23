import 'package:flutter/material.dart';

class SettingButtonWidget extends StatelessWidget {
  final String title;
  final Function() onTap;

  const SettingButtonWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        margin: const EdgeInsets.only(bottom: 5),
        width: double.infinity,
        height: 42,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
