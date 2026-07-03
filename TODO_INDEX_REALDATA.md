# TODO: 지수 카드 실데이터 연동

현재 `IndiceCards`의 지수 데이터는 모두 샘플값입니다.
아래 항목을 순서대로 진행해 실데이터로 교체합니다.

---

## 1. 국내 지수 (코스피 / 코스닥)

### 데이터 소스
- **현재가 + 등락**: Naver 금융 지수 API
  - `https://m.stock.naver.com/api/index/KOSPI/basic` (코스피)
  - `https://m.stock.naver.com/api/index/KOSDAQ/basic` (코스닥)
- **투자자별 순매수**: Naver 금융 HTML 파싱
  - `https://finance.naver.com/sise/investorDealTotalSise.naver?bizdate=&sosok=0` (코스피)
  - `https://finance.naver.com/sise/investorDealTotalSise.naver?bizdate=&sosok=1` (코스닥)
- **스파크라인 차트값**: Naver 분봉 API
  - `https://m.stock.naver.com/api/index/KOSPI/candle/minute?count=30`

### 작업 항목
- [ ] `NaverIndexClient` 생성 (`data/clients/`)
  - `fetchBasic(indexCode)` → 현재가, 전일대비, 등락률
  - `fetchInvestorTrend(sosok)` → 외국인/개인/기관 순매수
  - `fetchSparkline(indexCode)` → 분봉 리스트 → `List<double>`
- [ ] `IndexBasicDto`, `InvestorTrendDto` DTO 생성 (`data/dtos/`)
- [ ] `IndexRepository` 인터페이스 + 구현체 생성
- [ ] `IndiceCardsController` (`AsyncNotifier`) 생성
  - `build()` → 코스피/코스닥 데이터 병렬 fetch
- [ ] `IndiceCards`를 `ConsumerWidget`으로 전환, `ref.watch` 연동
- [ ] `MarketIndexCardData.sparklineValues` → API 분봉값으로 교체

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
- [ ] `YahooIndexClient` 생성 (`data/clients/`)
  - `fetchQuote(symbol)` → 현재가, 전일대비, 등락률
- [ ] `YahooIndexDto` DTO 생성
- [ ] `OverseasIndexRepository` 인터페이스 + 구현체
- [ ] `IndiceCardsController`에 해외 지수 fetch 통합 (병렬)
- [ ] `_overseasGroup1~4` 하드코딩 제거 → controller state로 교체

---

## 3. 공통 작업

- [ ] `MarketIndexGroupData` 모델에 `isLoading`, `errorMessage` 필드 추가 (또는 `AsyncValue` 활용)
- [ ] 로딩 중 skeleton UI 표시 (IndexCard, IndexCard2 shimmer)
- [ ] 에러 시 카드 내 재시도 버튼 또는 에러 텍스트 표시
- [ ] 국가 플래그 에셋 추가 (현재 한국/미국만 있음)
  - DAX(🇩🇪), CAC40(🇫🇷), Nikkei(🇯🇵) 등 플래그 이미지 필요
  - `AppAssets`에 `flagDe`, `flagFr`, `flagJp` 추가

---

## 브랜치 제안

```
feat/index-realdata
```
