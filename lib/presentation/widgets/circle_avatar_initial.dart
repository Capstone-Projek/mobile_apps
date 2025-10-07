import 'package:flutter/material.dart';

class CircleAvatarInisial extends StatelessWidget {
  final String name;
  final double size;
  final Color? textColor;
  final Color? backgroundColor;
  final String? imageUrl;
  final double fontSize;

  const CircleAvatarInisial({
    Key? key,
    required this.name,
    this.size = 48,
    this.textColor,
    this.backgroundColor,
    this.imageUrl,
    this.fontSize = 18,
  }) : super(key: key);

  /// Ambil inisial dari nama:
  /// - Jika 1 kata → 2 huruf pertama
  /// - Jika ≥2 kata → huruf pertama dari 2 kata pertama
  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final word = parts[0];
      return word.length >= 2
          ? word.substring(0, 2).toUpperCase()
          : word.toUpperCase();
    } else {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
  }

  /// Hasilkan warna unik berdasarkan nama
  Color _colorFromName(String name) {
    int hash = name.codeUnits.fold(
      0,
      (prev, elem) => elem + ((prev << 5) - prev),
    );
    final hue = (hash % 360).abs().toDouble();
    return HSLColor.fromAHSL(1, hue, 0.5, 0.5).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final bgColor = backgroundColor ?? _colorFromName(name);
    final txtColor = textColor ?? Colors.white;

    return ClipOval(
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                // fallback ke inisial jika gagal load gambar
                return _buildInitialsAvatar(initials, bgColor, txtColor);
              },
            )
          : _buildInitialsAvatar(initials, bgColor, txtColor),
    );
  }

  Widget _buildInitialsAvatar(String initials, Color bgColor, Color txtColor) {
    return Container(
      width: size,
      height: size,
      color: bgColor,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: txtColor,
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
