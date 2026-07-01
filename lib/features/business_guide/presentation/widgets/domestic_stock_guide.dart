import 'package:flutter/material.dart';
import 'package:sample/features/business_guide/presentation/widgets/business_guide_section_label.dart';
import 'package:sample/features/business_guide/presentation/widgets/business_guide_table.dart';

class DomesticStockGuide extends StatelessWidget {
  const DomesticStockGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BusinessGuideSectionLabel(
            label: '매매업무시간',
            style: BusinessGuideSectionLabelStyle.pageTitle,
          ),
          const SizedBox(height: 12),
          const BusinessGuideSectionLabel(label: 'KRX'),
          const SizedBox(height: 8),
          const BusinessGuideTable(rows: _krxRows),
          const SizedBox(height: 20),
          const BusinessGuideSectionLabel(label: 'NXT'),
          const SizedBox(height: 8),
          const BusinessGuideTable(rows: _nxtRows),
          const SizedBox(height: 20),
          const BusinessGuideSectionLabel(label: '금융상품'),
          const SizedBox(height: 8),
          const BusinessGuideTable(rows: _financialRows),
        ],
      ),
    );
  }
}

const _krxRows = [
  BusinessGuideTableRow(
    label: '장전시간 외',
    description: '코스피/코스닥\n- 08:30~08:40\n※ 주문접수는 08:00~08:40',
  ),
  BusinessGuideTableRow(
    label: '동시호가',
    description:
        '코스피/코스닥\n- 08:30~09:00\n- 15:20~15:30\n\n선물/옵션\n- 08:30~08:45\n- 15:35~15:45',
  ),
  BusinessGuideTableRow(
    label: '정규시장',
    description:
        '코스피/코스닥\n- 09:00~15:30\n*KRX주문시 08:30부터 호가 접수/정정/취소 가능\n\nK-OTC\n- 09:00~15:30\n\n선물/옵션\n- 08:45~15:45',
  ),
  BusinessGuideTableRow(
    label: '장후시간 외',
    description: '코스피/코스닥\n- 15:40~16:00\n※ 주문접수는 15:30~16:00',
  ),
  BusinessGuideTableRow(
    label: '시간외 단일가',
    description: '코스피/코스닥\n- 16:00~18:00\n※ 10분 단위, 총 12회 거래',
  ),
  BusinessGuideTableRow(
    label: '예약주문',
    description:
        '코스피/코스닥\n- 16:00~익영업일 08:30\n※ 공휴일, 토요일 포함하여 익영업일 08:30 이전까지 예약 가능하며에 약주문 접수시간내에 정정/취소 가능\n- 주식기간예약: 24시간\n(단, 08:25~08:50, 15:42~16:00 제외)',
  ),
  BusinessGuideTableRow(
    label: '기타',
    description:
        '선물/옵션\n- 최종거래일 09:00~15:20\n※ 단, 변동성지수선물의 최종거래일 09:00~15:35',
  ),
];

const _nxtRows = [
  BusinessGuideTableRow(label: '프리마켓', description: '- 08:00~08:50'),
  BusinessGuideTableRow(
    label: '메인마켓',
    description: '- 09:00:30~15:20\n(스마트주문 가능)',
  ),
  BusinessGuideTableRow(label: '애프터마켓', description: '- 15:30~20:00'),
  BusinessGuideTableRow(
    label: '예약주문',
    description:
        '일반예약\n- 20:20~익영업일 08:00\n\n기간예약\n- 24시간\n(단, 07:55~08:50, 20:00~20:20 제외)',
  ),
];

const _financialRows = [
  BusinessGuideTableRow(
    label: '펀드매수',
    description:
        '온라인/영업점/고객지원센터\n- 09:00~16:00\n※ 고객지원센터 이용 시 펀드 신규매수불가, 펀드 추가 매수만 가능',
  ),
  BusinessGuideTableRow(
    label: '펀드매도',
    description:
        '온라인/영업점/고객지원센터\n- 09:00~16:00\n/ 엄브렐러펀드 09:00~14:30',
  ),
  BusinessGuideTableRow(
    label: 'RP매매',
    description: '온라인/영업점/고객지원센터\n- 08:30~16:30',
  ),
  BusinessGuideTableRow(
    label: 'ELS청약',
    description:
        '온라인\n- 시작일 08:30~마감일 16:00\n※ 매일 00:00~00:30 불가\n※ 발행일정 이슈로 회차별로 시간 상이할 수 있음(판매중 상품참고)\n\n영업점\n- 08:00~16:00\n※ 청약 마감시간 단사 영업시간 및 발행일 정 등 이유로 변경될 수 있음',
  ),
];
