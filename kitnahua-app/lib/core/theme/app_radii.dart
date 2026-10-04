import 'package:flutter/material.dart';

/// Corner radius tokens and BorderRadius helpers matching design/mockups.html.
abstract final class AppRadii {
  // Base scale
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 28.0;
  static const double full = 9999.0;

  // Component aliases per design system
  static const double card = xl; // 24
  static const double row = lg; // 16
  static const double iconTile = md; // 12
  static const double input = md; // 12
  static const double chip = full;
  static const double pill = full;
  static const double sheet = xxl; // 28 (top corners only)
  static const double dialog = xxl; // 28

  // Radius helpers
  static const BorderRadius smBorderRadius = BorderRadius.all(
    Radius.circular(sm),
  );
  static const BorderRadius mdBorderRadius = BorderRadius.all(
    Radius.circular(md),
  );
  static const BorderRadius lgBorderRadius = BorderRadius.all(
    Radius.circular(lg),
  );
  static const BorderRadius xlBorderRadius = BorderRadius.all(
    Radius.circular(xl),
  );
  static const BorderRadius xxlBorderRadius = BorderRadius.all(
    Radius.circular(xxl),
  );
  static const BorderRadius fullBorderRadius = BorderRadius.all(
    Radius.circular(full),
  );

  // Alias helpers
  static const BorderRadius cardBorderRadius = xlBorderRadius;
  static const BorderRadius rowBorderRadius = lgBorderRadius;
  static const BorderRadius iconTileBorderRadius = mdBorderRadius;
  static const BorderRadius inputBorderRadius = mdBorderRadius;
  static const BorderRadius chipBorderRadius = fullBorderRadius;
  static const BorderRadius pillBorderRadius = fullBorderRadius;
  static const BorderRadius sheetBorderRadius = BorderRadius.vertical(
    top: Radius.circular(sheet),
  );
  static const BorderRadius dialogBorderRadius = BorderRadius.all(
    Radius.circular(dialog),
  );
}
