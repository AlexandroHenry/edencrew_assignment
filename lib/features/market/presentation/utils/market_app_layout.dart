import 'package:flutter/material.dart';

class MarketAppLayout {
  const MarketAppLayout._();

  static const bottomNavBodyHeight = 56.0;

  static double bottomChromeHeight(BuildContext context) {
    return bottomNavBodyHeight + MediaQuery.paddingOf(context).bottom;
  }

  static double appBarChromeHeight(BuildContext context) {
    return kToolbarHeight + MediaQuery.paddingOf(context).top;
  }
}
