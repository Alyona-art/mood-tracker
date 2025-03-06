import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  const SettingButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Text(text),
      ),
    );
  }
}
