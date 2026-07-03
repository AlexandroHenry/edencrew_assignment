import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sample/features/asset/domain/models/portfolio_holding.dart';
import 'package:sample/theme/app_theme.dart';

class AssetPieChart extends StatefulWidget {
  const AssetPieChart({
    super.key,
    required this.holdings,
    required this.cash,
  });

  final List<PortfolioHolding> holdings;
  final double cash;

  @override
  State<AssetPieChart> createState() => _AssetPieChartState();
}

class _AssetPieChartState extends State<AssetPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  int? _selectedIndex; // null = 전체(현금 포함), 0+ = 종목 인덱스

  static const _cashColor = Color(0xFF4780FF);

  static const _palette = [
    Color(0xFFF93F62),
    Color(0xFFFF9500),
    Color(0xFF34C759),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFF00C7BE),
    Color(0xFFFFCC00),
    Color(0xFF5856D6),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.cash +
        widget.holdings.fold(0.0, (s, h) => s + h.totalCurrentValue);
    if (total <= 0) return const SizedBox.shrink();

    // 슬라이스 목록: 종목들 + 현금
    final slices = <_Slice>[
      for (var i = 0; i < widget.holdings.length; i++)
        _Slice(
          label: widget.holdings[i].stockName,
          value: widget.holdings[i].totalCurrentValue,
          color: _palette[i % _palette.length],
          index: i,
        ),
      _Slice(label: '현금', value: widget.cash, color: _cashColor, index: -1),
    ];

    // 선택된 항목 정보
    final selected = _selectedIndex == null
        ? null
        : _selectedIndex! >= 0
            ? slices[_selectedIndex!]
            : slices.last;

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: Row(
            children: [
              // 파이차트
              Expanded(
                child: GestureDetector(
                  onTapUp: (d) => _onTapChart(d.localPosition, slices, total),
                  child: AnimatedBuilder(
                    animation: _anim,
                    builder: (_, _) => CustomPaint(
                      painter: _PieChartPainter(
                        slices: slices,
                        total: total,
                        progress: _anim.value,
                        selectedIndex: _selectedIndex,
                      ),
                      child: Center(
                        child: _CenterLabel(
                          selected: selected,
                          total: total,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 범례
              SizedBox(
                width: 140,
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final s in slices)
                      _LegendItem(
                        slice: s,
                        total: total,
                        isSelected: _selectedIndex == s.index ||
                            (_selectedIndex == null && false),
                        onTap: () => setState(() {
                          _selectedIndex =
                              _selectedIndex == s.index ? null : s.index;
                        }),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onTapChart(
      Offset pos, List<_Slice> slices, double total) {
    const center = Offset(110 / 2, 220 / 2);
    final dx = pos.dx - center.dx;
    final dy = pos.dy - center.dy;
    final dist = math.sqrt(dx * dx + dy * dy);
    // 도넛 안쪽(반지름 35 이하)과 바깥쪽(반지름 90 초과)은 무시
    if (dist < 35 || dist > 90) {
      setState(() => _selectedIndex = null);
      return;
    }
    var angle = math.atan2(dy, dx) + math.pi / 2;
    if (angle < 0) angle += 2 * math.pi;

    double sweep = 0;
    for (final s in slices) {
      final sliceSweep = s.value / total * 2 * math.pi;
      if (angle >= sweep && angle < sweep + sliceSweep) {
        setState(() => _selectedIndex = s.index);
        return;
      }
      sweep += sliceSweep;
    }
    setState(() => _selectedIndex = null);
  }
}

class _Slice {
  const _Slice({
    required this.label,
    required this.value,
    required this.color,
    required this.index,
  });
  final String label;
  final double value;
  final Color color;
  final int index; // -1 = 현금
}

class _PieChartPainter extends CustomPainter {
  _PieChartPainter({
    required this.slices,
    required this.total,
    required this.progress,
    required this.selectedIndex,
  });

  final List<_Slice> slices;
  final double total;
  final double progress;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = math.min(cx, cy) - 8;
    final innerR = outerR * 0.45;
    final gap = 0.018; // 슬라이스 간 갭 (라디안)

    double startAngle = -math.pi / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    for (final s in slices) {
      final sweep = (s.value / total * 2 * math.pi * progress) - gap;
      if (sweep <= 0) {
        startAngle += s.value / total * 2 * math.pi * progress;
        continue;
      }
      final isSelected = selectedIndex == s.index;
      final expandR = isSelected ? 8.0 : 0.0;
      final midAngle = startAngle + sweep / 2 + gap / 2;
      final offsetX = isSelected ? math.cos(midAngle) * expandR : 0.0;
      final offsetY = isSelected ? math.sin(midAngle) * expandR : 0.0;

      final path = Path()
        ..moveTo(cx + offsetX, cy + offsetY)
        ..arcTo(
          Rect.fromCircle(
              center: Offset(cx + offsetX, cy + offsetY), radius: outerR),
          startAngle + gap / 2,
          sweep,
          false,
        )
        ..lineTo(cx + offsetX + math.cos(startAngle + gap / 2 + sweep) * innerR,
            cy + offsetY + math.sin(startAngle + gap / 2 + sweep) * innerR)
        ..arcTo(
          Rect.fromCircle(
              center: Offset(cx + offsetX, cy + offsetY), radius: innerR),
          startAngle + gap / 2 + sweep,
          -sweep,
          false,
        )
        ..close();

      paint.color = isSelected
          ? s.color
          : s.color.withValues(alpha: 0.85);
      canvas.drawPath(path, paint);

      startAngle += s.value / total * 2 * math.pi * progress;
    }
  }

  @override
  bool shouldRepaint(_PieChartPainter old) =>
      old.progress != progress || old.selectedIndex != selectedIndex;
}

class _CenterLabel extends StatelessWidget {
  const _CenterLabel({required this.selected, required this.total});

  final _Slice? selected;
  final double total;

  @override
  Widget build(BuildContext context) {
    final label = selected?.label ?? '총 자산';
    final value = selected?.value ?? total;
    final pct = value / total * 100;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.caption2.copyWith(color: Colors.white54),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          '${pct.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          '${_fmt(value)}원',
          style: AppTypography.caption2.copyWith(color: Colors.white54),
        ),
      ],
    );
  }

  String _fmt(double v) {
    if (v >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    return v.round().toString();
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.slice,
    required this.total,
    required this.isSelected,
    required this.onTap,
  });

  final _Slice slice;
  final double total;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pct = slice.value / total * 100;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: slice.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                slice.label,
                style: AppTypography.caption2.copyWith(
                  color: Colors.white70,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${pct.toStringAsFixed(1)}%',
              style: AppTypography.caption2.copyWith(
                color: Colors.white54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
