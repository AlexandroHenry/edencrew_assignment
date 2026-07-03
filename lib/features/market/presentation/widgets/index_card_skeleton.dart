import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

// 실데이터 로딩 전 카드 자리를 차지하는 정적 스켈레톤.
// 기존 WatchlistSkeleton과 동일하게 애니메이션 없는 solid 색상 바를 사용해 스타일을 통일한다.
class IndexCardSkeleton extends StatelessWidget {
  const IndexCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.border_333333),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _SkeletonCircle(size: 20),
              SizedBox(width: 8),
              Expanded(child: _SkeletonBar(height: 14, widthFactor: 0.6)),
            ],
          ),
          SizedBox(height: 12),
          _SkeletonBar(height: 22, widthFactor: 0.75),
          SizedBox(height: 8),
          _SkeletonBar(height: 14, widthFactor: 0.5),
          SizedBox(height: 12),
          _SkeletonBar(height: 36, widthFactor: 1),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _SkeletonBar(height: 10, widthFactor: 0.8)),
              SizedBox(width: 8),
              Expanded(child: _SkeletonBar(height: 10, widthFactor: 0.8)),
              SizedBox(width: 8),
              Expanded(child: _SkeletonBar(height: 10, widthFactor: 0.8)),
            ],
          ),
        ],
      ),
    );
  }
}

// 해외 지수 소카드용 컴팩트 스켈레톤 (투자자 정보 행 없음).
class IndexCard2Skeleton extends StatelessWidget {
  const IndexCard2Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.border_333333),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              _SkeletonCircle(size: 20),
              SizedBox(width: 8),
              Expanded(child: _SkeletonBar(height: 12, widthFactor: 0.7)),
            ],
          ),
          SizedBox(height: 8),
          _SkeletonBar(height: 18, widthFactor: 0.6),
          SizedBox(height: 6),
          _SkeletonBar(height: 10, widthFactor: 0.45),
        ],
      ),
    );
  }
}

class _SkeletonCircle extends StatelessWidget {
  const _SkeletonCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppDerivedColors.skeleton,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({required this.height, required this.widthFactor});

  final double height;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: AppDerivedColors.skeleton,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
