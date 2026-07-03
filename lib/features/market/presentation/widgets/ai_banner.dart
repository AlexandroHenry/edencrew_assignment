import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/providers/ai_market_controller.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class AiBanner extends ConsumerWidget {
  const AiBanner({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(aiMarketControllerProvider);
    final title = async.valueOrNull?.items.firstOrNull?.title ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.bg.bg_2_212121,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppAssets.aiMarket, width: 16, height: 16),
              const SizedBox(width: 8),
              Text('AI 시황', style: AppTypography.subtitle),
              const SizedBox(width: 8),
              Expanded(
                child: title.isEmpty
                    ? const SizedBox.shrink()
                    : _MarqueeText(text: title),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarqueeText extends StatefulWidget {
  const _MarqueeText({required this.text});

  final String text;

  @override
  State<_MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<_MarqueeText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const _pixelsPerSecond = 50.0;
  static const _gap = 60.0; // 두 번째 복사본 사이 간격
  double _textWidth = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  void _start() {
    if (!mounted) return;
    final painter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: AppTypography.caption1.copyWith(color: AppColors.text.text_2_bdbdbd),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    _textWidth = painter.width;
    // 텍스트 1개 + gap 만큼 이동하면 두 번째 복사본이 정확히 같은 위치에 오므로 seamless loop
    final cycle = _textWidth + _gap;
    _controller.duration =
        Duration(milliseconds: (cycle / _pixelsPerSecond * 1000).round());

    setState(() {});
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.caption1.copyWith(color: AppColors.text.text_2_bdbdbd);
    final cycle = _textWidth + _gap;

    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) {
          // 0 → -cycle 로 선형 이동, repeat()로 seamless 루프
          final offset = -_controller.value * cycle;
          return Stack(
            children: [
              Transform.translate(
                offset: Offset(offset, 0),
                child: Text(widget.text, style: style, maxLines: 1,
                    softWrap: false, overflow: TextOverflow.visible),
              ),
              // 두 번째 복사본: 첫 번째보다 cycle만큼 오른쪽에 위치
              Transform.translate(
                offset: Offset(offset + cycle, 0),
                child: Text(widget.text, style: style, maxLines: 1,
                    softWrap: false, overflow: TextOverflow.visible),
              ),
            ],
          );
        },
      ),
    );
  }
}
