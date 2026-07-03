import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/models/user_profile.dart';

class MyProfileEditBottomSheet extends StatefulWidget {
  const MyProfileEditBottomSheet({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<MyProfileEditBottomSheet> createState() =>
      _MyProfileEditBottomSheetState();
}

class _MyProfileEditBottomSheetState extends State<MyProfileEditBottomSheet> {
  late final TextEditingController _nameController;
  late InvestmentType _selectedType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _selectedType = widget.profile.investmentType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSave() {
    final trimmed = _nameController.text.trim();
    if (trimmed.isEmpty) return;
    Navigator.of(context).pop(
      UserProfile(name: trimmed, investmentType: _selectedType),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    // 키보드 높이는 바깥 Padding이 아니라 시트 내부 여백으로 반영한다.
    // 배경색이 키보드 영역까지 이어져 transparent 공간이 보이지 않는다.
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        24,
        8,
        24,
        bottomPadding + 24 + viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SheetHandle(),
            const SizedBox(height: 8),
            SizedBox(
              height: 56,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('프로필 편집', style: AppTypography.sheetTitle),
              ),
            ),
            _SectionLabel('이름'),
            const SizedBox(height: 8),
            _NameField(controller: _nameController),
            const SizedBox(height: 20),
            _SectionLabel('투자 성향'),
            const SizedBox(height: 8),
            _InvestmentTypeSelector(
              selected: _selectedType,
              onChanged: (type) => setState(() => _selectedType = type),
            ),
            const SizedBox(height: 24),
            _SaveButton(onTap: _onSave),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.bg.bg_4_333333,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppTypography.caption1);
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppTypography.body2,
      maxLength: 10,
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: AppColors.bg.bg_4_333333,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintText: '이름을 입력하세요',
        hintStyle: AppTypography.body2
            .copyWith(color: AppColors.text.text_3_9e9e9e),
      ),
    );
  }
}

class _InvestmentTypeSelector extends StatelessWidget {
  const _InvestmentTypeSelector({
    required this.selected,
    required this.onChanged,
  });

  final InvestmentType selected;
  final ValueChanged<InvestmentType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final type in InvestmentType.values) ...[
          Expanded(
            child: _TypeChip(
              type: type,
              isSelected: type == selected,
              onTap: () => onChanged(type),
            ),
          ),
          if (type != InvestmentType.values.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final InvestmentType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isSelected
        ? AppColors.mainAndAccent.primary_ff8a00.withAlpha(30)
        : AppColors.bg.bg_4_333333;
    final borderColor = isSelected
        ? AppColors.mainAndAccent.primary_ff8a00
        : Colors.transparent;
    final textColor = isSelected
        ? AppColors.mainAndAccent.primary_ff8a00
        : AppColors.text.text_2_bdbdbd;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Text(
            type.label,
            style: AppTypography.subtitle.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.mainAndAccent.primary_ff8a00,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '저장',
            style: AppTypography.body2.copyWith(
              color: AppColors.grays.white,
            ),
          ),
        ),
      ),
    );
  }
}
