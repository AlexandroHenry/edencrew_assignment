import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketMetricUtils {
  const MarketMetricUtils._();

  static Color metricColor(double changePercent) {
    if (changePercent > 0) {
      return AppColors.mainAndAccent.up_f93f62;
    }
    if (changePercent < 0) {
      return AppColors.mainAndAccent.down_4780ff;
    }
    return AppColors.text.text_fafafa;
  }

  static String formatPercent(double value) {
    final formatted = value.abs().toStringAsFixed(2);
    if (value > 0) {
      return '$formatted%';
    }
    if (value < 0) {
      return '-$formatted%';
    }
    return '$formatted%';
  }

  static String formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  static String formatStockPrice(double price, {required bool isUsd}) {
    if (isUsd) {
      final fixed = price.toStringAsFixed(2);
      final parts = fixed.split('.');
      final intPart = parts[0].replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      );
      return '$intPart.${parts[1]}';
    }
    return formatPrice(price.round());
  }
}
