import 'package:flutter/material.dart';
import 'package:sample/features/business_guide/presentation/widgets/business_guide_table.dart';
import 'package:sample/features/business_guide/presentation/widgets/trading_guide_webview.dart';
import 'package:sample/theme/app_theme.dart';

class OverseasStockGuide extends StatefulWidget {
  const OverseasStockGuide({super.key});

  @override
  State<OverseasStockGuide> createState() => _OverseasStockGuideState();
}

class _OverseasStockGuideState extends State<OverseasStockGuide> {
  int _subTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _OverseasSubTabBar(
          selectedIndex: _subTabIndex,
          onTap: (i) => setState(() => _subTabIndex = i),
        ),
        Expanded(
          child: _subTabIndex == 0
              ? const _TradingHoursTab()
              : const TradingGuideWebView(),
        ),
      ],
    );
  }
}

class _OverseasSubTabBar extends StatelessWidget {
  const _OverseasSubTabBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _SubTab(
            label: '거래시간',
            isSelected: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          const SizedBox(width: 4),
          Text('|', style: TextStyle(color: AppColors.border.border_333333)),
          const SizedBox(width: 4),
          _SubTab(
            label: '거래안내',
            isSelected: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
        ],
      ),
    );
  }
}

class _SubTab extends StatelessWidget {
  const _SubTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: AppTypography.subtitle.copyWith(
          color: isSelected
              ? AppColors.text.text_fafafa
              : AppColors.text.text_3_9e9e9e,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

class _TradingHoursTab extends StatelessWidget {
  const _TradingHoursTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '미국',
            style: AppTypography.subtitle.copyWith(
              color: AppColors.text.text_fafafa,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const BusinessGuideTable(rows: _usRows),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}


const _usRows = [
  BusinessGuideTableRow(label: '프리마켓', description: '- 18:00~23:29'),
  BusinessGuideTableRow(label: '정규장', description: '- 23:30~06:00'),
  BusinessGuideTableRow(label: '에프터마켓', description: '- 06:00~10:00'),
  BusinessGuideTableRow(label: '주간거래', description: '- 10:30~18:00'),
  BusinessGuideTableRow(label: '예약주문', description: '- 08:00~23:00'),
];
