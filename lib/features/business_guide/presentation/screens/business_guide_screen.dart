import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return Theme(
      data: buildNamuhXDarkTheme(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.bg.bg_121212,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.bg.bg_121212,
          appBar: AppBar(
            backgroundColor: AppColors.bg.bg_121212,
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
              preferredSize: const Size.fromHeight(44),
              child: _TopTabBar(
                selectedIndex: _tabIndex,
                onTap: (i) => setState(() => _tabIndex = i),
              ),
            ),
          ),
          body: _tabIndex == 0
              ? const DomesticStockGuide()
              : const OverseasStockGuide(),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _TopTab(
            label: '국내주식',
            isSelected: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          const SizedBox(width: 8),
          _TopTab(
            label: '해외주식',
            isSelected: selectedIndex == 1,
            onTap: () => onTap(1),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.bg.bg_2_212121
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.border.border_333333
                : AppColors.border.border_333333,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.subtitle.copyWith(
            color: isSelected
                ? AppColors.text.text_fafafa
                : AppColors.text.text_3_9e9e9e,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
