import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sample/features/asset/domain/models/portfolio_holding.dart';
import 'package:sample/theme/app_theme.dart';

enum _AllocationView { assetClass, stocks }

/// 자산 비율 카드 — 헤더 토글로 자산군(전체) / 개별종목(주식) 뷰 전환
class AssetAllocationCard extends StatefulWidget {
  const AssetAllocationCard({
    super.key,
    required this.holdings,
    required this.cash,
  });

  final List<PortfolioHolding> holdings;
  final double cash;

  @override
  State<AssetAllocationCard> createState() => _AssetAllocationCardState();
}

class _AssetAllocationCardState extends State<AssetAllocationCard> {
  _AllocationView _view = _AllocationView.assetClass;

  @override
  Widget build(BuildContext context) {
    final slices = _view == _AllocationView.assetClass
        ? _buildAssetClassSlices()
        : _buildStockSlices();

    final total = slices.fold(0.0, (s, sl) => s + sl.value);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.border_333333),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더: 제목 + 토글
          Row(
            children: [
              Text(
                '자산 비율',
                style: AppTypography.subtitle.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              _ViewToggle(
                current: _view,
                onChanged: (v) => setState(() => _view = v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (total > 0)
            _AllocationPieChart(slices: slices, total: total)
          else
            const SizedBox(height: 100),
        ],
      ),
    );
  }

  // 자산군 슬라이스: 국내주식 / 해외주식 / 현금
  List<_ChartSlice> _buildAssetClassSlices() {
    final domesticValue = widget.holdings
        .where((h) => h.currency == 'KRW')
        .fold(0.0, (s, h) => s + h.totalCurrentValueKrw);
    final overseasValue = widget.holdings
        .where((h) => h.currency == 'USD')
        .fold(0.0, (s, h) => s + h.totalCurrentValueKrw);

    return [
      if (domesticValue > 0)
        _ChartSlice(
          label: '국내주식',
          value: domesticValue,
          color: const Color(0xFFF93F62),
        ),
      if (overseasValue > 0)
        _ChartSlice(
          label: '해외주식',
          value: overseasValue,
          color: const Color(0xFFFF9500),
        ),
      if (widget.cash > 0)
        _ChartSlice(
          label: '현금',
          value: widget.cash,
          color: const Color(0xFF4780FF),
        ),
    ];
  }

  // 개별 종목 슬라이스 (총자산 대비 비율)
  List<_ChartSlice> _buildStockSlices() {
    const palette = [
      Color(0xFFF93F62),
      Color(0xFFFF9500),
      Color(0xFF34C759),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFF00C7BE),
      Color(0xFFFFCC00),
      Color(0xFF5856D6),
    ];
    return [
      for (var i = 0; i < widget.holdings.length; i++)
        _ChartSlice(
          label: widget.holdings[i].stockName,
          value: widget.holdings[i].totalCurrentValueKrw,
          color: palette[i % palette.length],
          sublabel: widget.holdings[i].currency == 'USD' ? 'USD' : null,
        ),
      // 주식 뷰에선 현금 제외 — 종목 구성 비중만 표시
    ];
  }
}

// ── 토글 버튼 ────────────────────────────────────────────────────────────────

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.current, required this.onChanged});

  final _AllocationView current;
  final ValueChanged<_AllocationView> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.bg.bg_4_333333,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.border_333333),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleChip(
            label: '전체',
            isActive: current == _AllocationView.assetClass,
            onTap: () => onChanged(_AllocationView.assetClass),
          ),
          _ToggleChip(
            label: '주식',
            isActive: current == _AllocationView.stocks,
            onTap: () => onChanged(_AllocationView.stocks),
          ),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.mainAndAccent.primary_ff8a00
              : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.caption2.copyWith(
            color: isActive
                ? AppColors.bg.bg_121212
                : AppColors.text.text_3_9e9e9e,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ── 파이차트 ──────────────────────────────────────────────────────────────────

class _ChartSlice {
  const _ChartSlice({
    required this.label,
    required this.value,
    required this.color,
    this.sublabel,
  });

  final String label;
  final double value;
  final Color color;
  final String? sublabel; // e.g. 'USD' for overseas stocks
}

class _AllocationPieChart extends StatefulWidget {
  const _AllocationPieChart({required this.slices, required this.total});

  final List<_ChartSlice> slices;
  final double total;

  @override
  State<_AllocationPieChart> createState() => _AllocationPieChartState();
}

class _AllocationPieChartState extends State<_AllocationPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(_AllocationPieChart old) {
    super.didUpdateWidget(old);
    if (old.slices.length != widget.slices.length ||
        old.slices.map((s) => s.label).join() !=
            widget.slices.map((s) => s.label).join()) {
      // 뷰 전환 시 애니메이션 재생 + 선택 초기화
      _selectedIndex = null;
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected =
        _selectedIndex != null ? widget.slices[_selectedIndex!] : null;

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Row(
            children: [
              // 파이차트
              Expanded(
                child: GestureDetector(
                  onTapUp: (d) =>
                      _onTapChart(d.localPosition, widget.slices, widget.total),
                  child: AnimatedBuilder(
                    animation: _anim,
                    builder: (_, _) => CustomPaint(
                      painter: _PiePainter(
                        slices: widget.slices,
                        total: widget.total,
                        progress: _anim.value,
                        selectedIndex: _selectedIndex,
                      ),
                      child: Center(
                        child: _CenterLabel(
                          selected: selected,
                          total: widget.total,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 범례
              SizedBox(
                width: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < widget.slices.length; i++)
                      _LegendRow(
                        slice: widget.slices[i],
                        total: widget.total,
                        isSelected: _selectedIndex == i,
                        onTap: () => setState(() {
                          _selectedIndex = _selectedIndex == i ? null : i;
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

  void _onTapChart(Offset pos, List<_ChartSlice> slices, double total) {
    // 차트 영역 크기에 맞게 중심 계산 (Expanded 안의 CustomPaint)
    final w = (context.findRenderObject() as RenderBox).size.width - 130;
    final center = Offset(w / 2, 100);
    final dx = pos.dx - center.dx;
    final dy = pos.dy - center.dy;
    final dist = math.sqrt(dx * dx + dy * dy);
    final outerR = math.min(w / 2, 100) - 8;
    final innerR = outerR * 0.42;

    if (dist < innerR || dist > outerR) {
      setState(() => _selectedIndex = null);
      return;
    }

    var angle = math.atan2(dy, dx) + math.pi / 2;
    if (angle < 0) angle += 2 * math.pi;

    double sweep = 0;
    for (var i = 0; i < slices.length; i++) {
      final sliceSweep = slices[i].value / total * 2 * math.pi;
      if (angle >= sweep && angle < sweep + sliceSweep) {
        setState(() => _selectedIndex = i);
        return;
      }
      sweep += sliceSweep;
    }
    setState(() => _selectedIndex = null);
  }
}

class _PiePainter extends CustomPainter {
  const _PiePainter({
    required this.slices,
    required this.total,
    required this.progress,
    required this.selectedIndex,
  });

  final List<_ChartSlice> slices;
  final double total;
  final double progress;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = math.min(cx, cy) - 8;
    final innerR = outerR * 0.42;
    const gap = 0.018;

    double startAngle = -math.pi / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < slices.length; i++) {
      final s = slices[i];
      final sweep = (s.value / total * 2 * math.pi * progress) - gap;
      if (sweep <= 0) {
        startAngle += s.value / total * 2 * math.pi * progress;
        continue;
      }
      final isSelected = selectedIndex == i;
      final expandR = isSelected ? 7.0 : 0.0;
      final midAngle = startAngle + sweep / 2 + gap / 2;
      final ox = isSelected ? math.cos(midAngle) * expandR : 0.0;
      final oy = isSelected ? math.sin(midAngle) * expandR : 0.0;

      final path = Path()
        ..moveTo(cx + ox, cy + oy)
        ..arcTo(
          Rect.fromCircle(center: Offset(cx + ox, cy + oy), radius: outerR),
          startAngle + gap / 2,
          sweep,
          false,
        )
        ..lineTo(
          cx + ox + math.cos(startAngle + gap / 2 + sweep) * innerR,
          cy + oy + math.sin(startAngle + gap / 2 + sweep) * innerR,
        )
        ..arcTo(
          Rect.fromCircle(center: Offset(cx + ox, cy + oy), radius: innerR),
          startAngle + gap / 2 + sweep,
          -sweep,
          false,
        )
        ..close();

      paint.color = s.color.withValues(alpha: isSelected ? 1.0 : 0.85);
      canvas.drawPath(path, paint);
      startAngle += s.value / total * 2 * math.pi * progress;
    }
  }

  @override
  bool shouldRepaint(_PiePainter old) =>
      old.progress != progress || old.selectedIndex != selectedIndex;
}

class _CenterLabel extends StatelessWidget {
  const _CenterLabel({required this.selected, required this.total});

  final _ChartSlice? selected;
  final double total;

  @override
  Widget build(BuildContext context) {
    final pct = selected != null ? selected!.value / total * 100 : 100.0;
    final value = selected?.value ?? total;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          selected?.label ?? '전체',
          style: AppTypography.caption2.copyWith(
            color: AppColors.text.text_3_9e9e9e,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          '${pct.toStringAsFixed(1)}%',
          style: TextStyle(
            fontFamily: AppFonts.pretendard,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.text.text_fafafa,
          ),
        ),
        Text(
          _fmtKrw(value),
          style: AppTypography.caption2.copyWith(
            color: AppColors.text.text_3_9e9e9e,
          ),
        ),
      ],
    );
  }

  String _fmtKrw(double v) {
    if (v >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억원';
    if (v >= 10000) return '${(v / 10000).toStringAsFixed(0)}만원';
    return '${v.round()}원';
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.slice,
    required this.total,
    required this.isSelected,
    required this.onTap,
  });

  final _ChartSlice slice;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slice.label,
                    style: AppTypography.caption2.copyWith(
                      color: isSelected
                          ? AppColors.text.text_fafafa
                          : AppColors.text.text_2_bdbdbd,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (slice.sublabel != null)
                    Text(
                      slice.sublabel!,
                      style: AppTypography.xs.copyWith(
                        color: AppColors.text.text_3_9e9e9e,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '${pct.toStringAsFixed(1)}%',
              style: AppTypography.caption2.copyWith(
                color: isSelected
                    ? slice.color
                    : AppColors.text.text_3_9e9e9e,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
