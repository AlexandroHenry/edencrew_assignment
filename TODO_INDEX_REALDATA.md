# TODO: 지수 카드 실데이터 연동

~~현재 `IndiceCards`의 지수 데이터는 모두 샘플값입니다.~~
✅ `feat/index-realdata` 브랜치에서 실데이터 연동 완료.

---

## 1. 국내 지수 (코스피 / 코스닥)

### 데이터 소스
- **현재가 + 등락**: Naver 금융 지수 API
  - `https://m.stock.naver.com/api/index/KOSPI/basic` (코스피)
  - `https://m.stock.naver.com/api/index/KOSDAQ/basic` (코스닥)
- **투자자별 순매수**: Naver 금융 HTML 파싱
  - ~~`investorDealTotalSise.naver`~~ → 실제 호출해보니 테이블이 항상 빈 값으로 내려와 대신
    `https://finance.naver.com/sise/sise_index.naver?code=KOSPI` 상단의
    `<dl class="lst_kos_info">` 위젯(개인/외국인/기관, 억원 단위)을 파싱하도록 변경
- **스파크라인 차트값**: ~~`candle/minute` API~~ → 존재하지 않는 엔드포인트였음. 대신
  `https://api.stock.naver.com/chart/domestic/index/KOSPI?periodType=day` (당일 분봉)을 받아
  균등 다운샘플링(30개)해서 사용

### 작업 항목
- [x] `NaverIndexClient` 생성 (`data/clients/`)
  - `fetchBasic(indexCode)` → 현재가, 전일대비, 등락률
  - `fetchInvestorTrend(indexCode)` → 외국인/개인/기관 순매수 (억원 → 백만원 변환)
  - `fetchSparkline(indexCode)` → 당일 분봉 → `List<double>` (30개로 다운샘플링)
- [x] `IndexBasicDto`, `InvestorTrendDto` DTO 생성 (`data/dtos/`)
- [x] `IndexRepository` 인터페이스 + 구현체 생성
- [x] `IndiceCardsController` (`AsyncNotifier`) 생성
  - `build()` → 코스피/코스닥 + 해외 7종 데이터 병렬 fetch
  - 지수 하나가 실패해도 나머지 카드는 정상 표시되도록 카드 단위로 에러를 격리
- [x] `IndiceCards`를 `ConsumerWidget`으로 전환, `ref.watch` 연동
- [x] `MarketIndexCardData.sparklineValues` → API 분봉값으로 교체

---

## 2. 해외 지수 (S&P500, 나스닥, 다우, FTSE, DAX, CAC40, Nikkei)

### 데이터 소스
- **Yahoo Finance** (인증 불필요)
  - `https://query2.finance.yahoo.com/v8/finance/chart/{symbol}?interval=1d&range=1d`
  - 심볼 매핑:
    | 지수 | 심볼 |
    |------|------|
    | S&P500 | `^GSPC` |
    | 나스닥종합 | `^IXIC` |
    | 다우 존스 | `^DJI` |
    | FTSE 100 | `^FTSE` |
    | DAX | `^GDAXI` |
    | CAC 40 | `^FCHI` |
    | Nikkei 225 | `^N225` |

### 작업 항목
- [x] `YahooIndexClient` 생성 (`data/clients/`)
  - `fetchQuote(symbol)` → 현재가, 전일대비, 등락률 (regularMarketPrice - chartPreviousClose로 계산)
- [x] `YahooIndexDto` DTO 생성
- [x] `OverseasIndexRepository` 인터페이스 + 구현체
- [x] `IndiceCardsController`에 해외 지수 fetch 통합 (병렬)
- [x] `_overseasGroup1~4` 하드코딩 제거 → controller state로 교체
  - FTSE 100은 Figma 목업 그대로 `flagUs`를 사용(영국 국기 에셋은 이번 범위 밖)

---

## 3. 공통 작업

- [x] 카드 단위 로딩/에러 상태 표현 — `MarketIndexGroupData` 대신 도메인 모델
  `IndexQuote`에 `isLoading`/`errorMessage`를 두고, `IndiceCardsController`가
  카드별로 독립적으로 갱신 (freezed 미사용 프로젝트라 기존 컨벤션인
  `@immutable` + 수동 `copyWith` 유지)
- [x] 로딩 중 skeleton UI 표시 — `IndexCardSkeleton`/`IndexCard2Skeleton`
  (기존 `WatchlistSkeleton`과 동일하게 애니메이션 없는 solid 컬러 스켈레톤;
  shimmer 패키지가 없어 범위를 스켈레톤 박스로 한정)
- [x] 에러 시 카드 내 재시도 버튼 표시 — `IndexCardError` (`retryDomestic`/`retryOverseas`로
  해당 카드만 재조회, 다른 카드는 영향 없음)
- [x] 국가 플래그 에셋 추가 (현재 한국/미국만 있음)
  - DAX(🇩🇪), CAC40(🇫🇷), Nikkei(🇯🇵) 플래그를 SVG로 직접 작성해 추가
    (`assets/ui/icon_de_flag.svg` 등 — 기존 KR/US 원형 배지 스타일과 통일)
  - `AppAssets`에 `flagDe`, `flagFr`, `flagJp` 추가

---

## 브랜치 제안

```
feat/index-realdata
```
