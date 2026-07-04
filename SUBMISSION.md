# 제출 문서

README.md의 "제출 안내" 항목에 맞춰 정리한 내용입니다.

## 1. 구현한 코드

과제 대상 8개 파일은 모두 구현되어 있으며, `lib/` 아래 코드에 남아 있던
`TODO(assignment)` 마커는 모두 해소했습니다(`grep -rn "TODO(assignment)" lib/`
결과 없음).

- 데이터 연동: `lib/shared/data/clients/naver_domestic_stock_client.dart`,
  `lib/shared/data/dtos/naver_stock_dtos.dart`,
  `lib/features/watchlist/data/repositories/naver_watchlist_repository.dart`
- UI 구현: `lib/features/search/presentation/widgets/search_result_row.dart`,
  `lib/features/search/presentation/widgets/search_toast.dart`,
  `lib/features/watchlist/presentation/widgets/watchlist_date_bottom_sheet.dart`,
  `lib/features/watchlist/presentation/screens/watchlist_screen.dart`
- 상태 동기화: `lib/features/search/presentation/providers/search_controller.dart`,
  `lib/features/watchlist/presentation/providers/favorite_ids_controller.dart`

> `naver_domestic_stock_client.dart`/`naver_stock_dtos.dart`는 원래
> `lib/features/watchlist/data/`에 있었으나, 이후 다른 feature(실시간 지수/종목
> 상세)에서도 동일한 Naver 클라이언트가 필요해져 `lib/shared/data/`로
> 옮겼습니다. README.md의 경로 표기도 함께 갱신했습니다.

## 2. `flutter analyze` 결과

```
Analyzing edencrew_assignment...
No issues found!
```

## 3. `flutter test` 결과

과제 범위(watchlist/search)의 네트워크 비의존 테스트만 모아서 실행한 결과입니다.

```
flutter test \
  test/shared/data/dtos/naver_stock_dtos_test.dart \
  test/features/watchlist/data/naver_watchlist_repository_test.dart \
  test/features/search/presentation/providers/search_controller_test.dart \
  test/features/watchlist/presentation/watchlist_date_bottom_sheet_test.dart

00:00 +16: All tests passed!
```

`search_screen_test.dart`, `watchlist_screen_test.dart`, 골든 테스트,
`app_shell_test.dart`는 공용 테스트 하네스(`test/support/app_test_harness.dart`)가
앱 전체(자산/마켓 feature 포함)를 부팅하면서 그 안의 실시간 시세/환율 fetch가
같이 실행됩니다. 이 샌드박스 환경에서는 해당 외부 API(Yahoo Finance 등) 호출이
400으로 거부되어 `pumpAndSettle` 타임아웃이 발생합니다. watchlist/search 자체
로직과는 무관한 환경 이슈이며, 오늘 작성한 주석 변경(코드 동작에는 영향 없음)과도
무관합니다. 네트워크가 열려 있는 환경에서 `flutter test`를 전체 실행하면
`README.md`의 "테스트와 자가 점검" 절이 안내하는 방식으로 통과 여부를 확인할
수 있습니다.

## 4. 구현 메모

### 어떤 순서로 진행했는지

1. `naver_stock_dtos.dart`의 DTO/파싱 로직부터 확인
2. `naver_domestic_stock_client.dart`의 API 호출부 확인
3. `naver_watchlist_repository.dart`의 목록/거래일/상세 30거래일 조합 로직 확인
4. `search_result_row.dart`, `search_toast.dart`, `watchlist_date_bottom_sheet.dart`
   UI가 Figma 스펙(하이라이트, blur 토스트, 날짜 휠피커)과 일치하는지 확인
5. `search_controller.dart`, `favorite_ids_controller.dart`의 즐겨찾기 상태
   동기화 흐름 확인
6. 위 8개 파일에 "왜 이렇게 구현했는지"를 설명하는 주석을 보강

### 어떤 가정을 두었는지

- `favoriteIdsControllerProvider` 하나를 검색/관심 화면이 함께 watch하는
  구조를 유지하면 별도 동기화 코드 없이 상태가 맞춰진다고 가정했습니다.
- 날짜 바텀시트는 이미 Figma 스펙대로(헤더/휠피커/선택 스타일/CTA) 구현되어
  있었으므로, 남아 있던 `TODO(assignment)` 마커는 구현이 끝난 뒤 지우지 않은
  누락으로 보고 설명 주석으로 교체했습니다.

### 남은 이슈

- 해외(미국) 종목의 상세 데이터는 이번 과제 범위(Naver API) 밖이라 별도
  처리하지 않았습니다.
- `flutter test` 전체 실행 시 네트워크가 차단된 환경에서는 자산/마켓 feature의
  실시간 fetch로 인해 일부 위젯 테스트가 타임아웃됩니다(3번 항목 참고).

## 5. 과제별 구현 설명

### 5-1. 데이터 연동

- **검색 자동완성** (`naver_domestic_stock_client.dart#searchStocks`): 응답이
  JSON이 아닌 `text/plain`으로 오므로 `_decodeJsonObjectBody`로 형태를 방어적으로
  판별해 디코딩합니다. `NaverAutocompleteItemDto.isDomesticStock`에서
  `category == 'stock'`, `nationCode == 'KOR'`, 6자리 코드, `/domestic/stock/`
  URL을 모두 만족해야 국내 주식으로 인정해 지수/해외 종목을 걸러냅니다.
- **실시간 시세** (`fetchRealtimeQuotes`): Naver realtime API는 `cd`, `nv`,
  `pcv` 같은 축약 키를 쓰므로 DTO의 `fromJson`에서 그대로 매핑하고,
  `changeAmount`/`changeRate`는 저장하지 않고 getter로 매번 계산해 원본 수치와
  어긋날 일이 없게 했습니다. Repository는 심볼별로 짧은 TTL(10초) 캐시를 둬서
  같은 화면을 여러 위젯이 동시에 요청해도 API를 중복 호출하지 않습니다.
- **일별 시세 HTML 파싱** (`fetchDailyHistoryPage`): 응답이 EUC-KR HTML이라
  `CharsetConverter.decode`로 디코딩 후 정규식으로 `<tr>`/`<td>`를 추출합니다.
  행의 첫 셀이 `YYYY.MM.DD` 형식인지로 데이터 행과 광고/빈 행을 구분하고,
  `pgRR` 클래스의 `<a>` 태그에서 마지막 페이지 번호를 읽습니다(없으면 현재
  페이지가 마지막).
- **관심종목/거래일/상세 30거래일 구성** (`naver_watchlist_repository.dart`):
  거래일 목록은 최초 호출 시에만 첫 페이지를 읽어 `lastPage`를 확인하고, 나머지
  페이지를 배치(`dailyHistoryFetchBatchSize`)로 병렬 요청한 뒤 캐시합니다.
  상세 화면은 선택한 날짜를 포함해 직전 30거래일 window를 계산하고, 최신
  날짜일 때만 realtime 값으로 현재가/등락을 덮어써 과거 날짜 조회 시 실시간
  데이터가 섞이지 않게 했습니다.

### 5-2. UI 구현

- **검색 결과 행**: 하트 버튼의 실제 아이콘은 16×13이지만 터치 영역은 Figma
  기준 44×44로 넉넉하게 잡았습니다(`search_result_row.dart`). 검색어와 일치하는
  구간은 `splitSearchTextParts`로 나눠 포인트 컬러로 강조합니다.
- **검색 토스트**: `BackdropFilter` + 반투명 배경/보더/그림자로 유리 질감을
  내고, 하트 아이콘 위에 체크 아이콘을 `Stack`으로 겹쳐 "추가됨" 상태를
  표현합니다(`search_toast.dart`).
- **날짜 선택 바텀시트**: 연/월/일 3개의 `ListWheelScrollView`로 구성하고,
  선택된 값만 pill 배경 + 밝은 텍스트로 강조합니다. 항목을 탭하면
  `animateToItem`으로 스크롤해 휠을 직접 돌리지 않고도 선택할 수 있게 했습니다.
- **날짜 변경 후 동기화**: `watchlist_screen.dart#_showDateBottomSheet`에서
  날짜를 바꾸면 목록(`watchlistControllerProvider`)과 상세
  (`watchlistDetailControllerProvider`)를 순서대로 갱신해 두 영역이 같은 날짜
  기준으로 함께 바뀌게 했습니다.

### 5-3. 상태 동기화

- **즐겨찾기 ↔ 검색 결과**: 검색/관심 화면이 `favoriteIdsControllerProvider`
  하나를 공유해서 watch합니다. 한쪽에서 토글하면 provider 상태가 바뀌고,
  `search_controller.dart`가 `ref.listen`으로 이를 구독해 현재 검색 결과 목록의
  `isFavorite`를 다시 계산합니다.
- **검색 직후 즐겨찾기 반영**: 검색 응답이 온 시점에 `favoriteIdsControllerProvider`
  값을 다시 읽어 결과에 반영합니다. 또한 타이핑 중 이전 요청이 늦게 도착해
  최신 결과를 덮어쓰는 것을 막기 위해 요청 순번(`_requestSequence`)을 두고,
  응답 시점에 최신 순번이 아니면 그 결과를 버립니다.
- **토스트 표시/소멸**: 즐겨찾기 추가 시 `_showToast`로 토스트를 띄우고 2초
  타이머로 자동 소멸시키며, 제거 시에는 `dismissToast`로 즉시 감춥니다.

## 6. 과제 범위 외 추가 구현

과제 범위(watchlist/search)를 넘어 아래 영역을 추가로 구현했습니다.

- **마켓 탭**: 실시간 지수 카드(국내/해외, 3초 폴링, 카드 단위 에러·재시도)와
  헤더 지수 로테이션, 실시간 종목/ETF 순위 및 상세 드로어 실데이터 연동,
  AI 시황, 지수 상세 화면, 종목 차트 화면
- **마이 탭**: 프로필 편집, 설정 화면 (Phase 1~4)
- **자산(포트폴리오) 탭**: 자산 배분 UI, 환율(USD/KRW) 매수 시점 반영,
  씨드 대비 증가율 표시
- **앱 전역**: 다크/라이트 모드 인프라 및 전 화면 대응, 하단 네비게이션
  Figma 스펙 보정(색상/보더)

관련 코드는 `lib/features/market/`, `lib/features/my/`,
`lib/features/asset/`, `lib/theme/`, `lib/features/root/`에 있습니다.
