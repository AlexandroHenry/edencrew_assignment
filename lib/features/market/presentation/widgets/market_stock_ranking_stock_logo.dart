import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sample/theme/app_theme.dart';

class MarketStockRankingStockLogo extends StatelessWidget {
  const MarketStockRankingStockLogo({
    required this.name,
    this.logoUrl,
    this.color,
    super.key,
  });

  final String name;
  final String? logoUrl;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (logoUrl != null) {
      return ClipOval(
        child: SizedBox(
          width: 40,
          height: 40,
          child: logoUrl!.endsWith('.svg')
              ? _SafeSvgImage(
                  url: logoUrl!,
                  fallback: _Fallback(name: name, color: color),
                )
              : Image.network(
                  logoUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) =>
                      _Fallback(name: name, color: color),
                ),
        ),
      );
    }
    return _Fallback(name: name, color: color);
  }
}

// dio로 SVG bytes를 받아 SvgPicture.memory로 렌더링
// flutter_svg 2.x는 errorBuilder 미지원 — 직접 fetch 후 파싱 실패 시 폴백 처리
class _SafeSvgImage extends StatefulWidget {
  const _SafeSvgImage({required this.url, required this.fallback});

  final String url;
  final Widget fallback;

  @override
  State<_SafeSvgImage> createState() => _SafeSvgImageState();
}

class _SafeSvgImageState extends State<_SafeSvgImage> {
  static final _dio = Dio();
  late final Future<List<int>?> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchSvg(widget.url);
  }

  static Future<List<int>?> _fetchSvg(String url) async {
    try {
      final res = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return res.data;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>?>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return widget.fallback;
        }
        final bytes = snap.data;
        if (bytes == null || bytes.isEmpty) return widget.fallback;
        try {
          return SvgPicture.memory(
            Uint8List.fromList(bytes),
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            placeholderBuilder: (_) => widget.fallback,
          );
        } catch (_) {
          return widget.fallback;
        }
      },
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.name, this.color});

  final String name;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.characters.first : '';
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color ?? AppColors.background.level6,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTypography.caption1.copyWith(
          color: AppColors.text.text_fafafa,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
