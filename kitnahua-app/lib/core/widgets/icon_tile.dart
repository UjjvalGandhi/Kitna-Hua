import 'package:flutter/material.dart';

/// Reusable rounded square container for displaying an icon.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.size,
    required this.borderRadius,
    required this.backgroundColor,
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    this.border,
  });

  final double size;
  final double borderRadius;
  final Color backgroundColor;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}
