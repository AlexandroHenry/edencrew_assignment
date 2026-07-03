import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample/features/business_guide/presentation/theme/business_guide_tokens.dart';
import 'package:sample/features/business_guide/presentation/widgets/domestic_stock_guide.dart';
import 'package:sample/features/business_guide/presentation/widgets/overseas_stock_guide.dart';
import 'package:sample/theme/app_theme.dart';

class BusinessGuideScreen extends StatefulWidget {
  const BusinessGuideScreen({super.key});

  @override
  State<BusinessGuideScreen> createState() => _BusinessGuideScreenState();
}

class _BusinessGuideScreenState extends State<BusinessGuideScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle(context),
      child: Scaffold(
          backgroundColor: AppColors.bg.bg_121212,
          appBar: AppBar(
            backgroundColor: AppColors.bg.bg_121212,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.text.text_fafafa,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: Text('업무안내', style: AppTypography.subtitle),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _TopTabBar(
                selectedIndex: _tabIndex,
                onTap: (index) => setState(() => _tabIndex = index),
              ),
            ),
          ),
          body: _tabIndex == 0
              ? const DomesticStockGuide()
              : const OverseasStockGuide(),
        ),
    );
  }
}

class _TopTabBar extends StatelessWidget {
  const _TopTabBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: _TopTab(
              label: '국내주식',
              isSelected: selectedIndex == 0,
              onTap: () => onTap(0),
            ),
          ),
          const SizedBox(width: BusinessGuideTokens.tabGap),
          Expanded(
            child: _TopTab(
              label: '해외주식',
              isSelected: selectedIndex == 1,
              onTap: () => onTap(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({
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
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: BusinessGuideTokens.tabHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: BusinessGuideTokens.tabHorizontalPadding,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.background.level6 : Colors.transparent,
          borderRadius: BorderRadius.circular(
            BusinessGuideTokens.tabBorderRadius,
          ),
          border: Border.all(color: BusinessGuideTokens.lineCard),
        ),
        child: Text(
          label,
          style: AppTypography.subtitle.copyWith(
            color: isSelected
                ? AppColors.text.text_fafafa
                : AppColors.text.text_3_9e9e9e,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}
