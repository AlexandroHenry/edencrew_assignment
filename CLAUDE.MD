# CLAUDE.md — Flutter Assignment Starter

이 문서는 Claude가 이 프로젝트에서 작업할 때 따라야 할 코드 규칙, 아키텍처 가이드, 품질 기준을 정의합니다.

---

## 프로젝트 개요

국내 주식 관심종목 앱 (이직 과제). Naver 주식 API 연동 + Figma 기반 UI 구현 + 상태 동기화가 핵심입니다.
README.md에 상세한 과제 요건이 있으니 작업 전 반드시 참고하세요.

---

## 폴더 구조 규칙

### Feature 기본 구조

```
lib/features/{feature}/
  data/
    clients/          # HTTP 클라이언트, HTML 파서
    dtos/             # JSON DTO (fromJson, 숫자/날짜 파싱)
    repositories/     # Repository 구현체
    providers/        # Repository Riverpod provider
  domain/
    models/           # 앱 내부 모델
    repositories/     # Repository 추상 인터페이스
    services/         # 순수 비즈니스 로직
  presentation/
    screens/          # 화면 1개 = Screen 파일 1개
    providers/        # Controller + State
    widgets/          # 재사용 위젯
    layout/           # 레이아웃 상수/스펙
    models/           # Presentation 전용 모델
```

---

## 네이밍 규칙

### Controller / State

| 구분 | 파일명 | 클래스명 |
|------|--------|----------|
| Controller | `xxxx_screen_controller.dart` | `XxxxScreenController` |
| State | `xxxx_screen_state.dart` | `XxxxScreenState` |
| ViewModel | `xxxx_screen_vm.dart` | `XxxxScreenVm` |

- Controller와 State는 **같은 폴더**에 둡니다 (state 전용 하위 폴더 금지).
- `presentation/providers/` 안에 controller + state 파일을 함께 위치합니다.

### 파일/클래스 일반

- 파일명: `snake_case.dart`
- 클래스명: `PascalCase`
- Riverpod provider 변수: `camelCaseProvider`

---

## 아키텍처 원칙

### Screen ↔ Controller 1:1 대응

- 하나의 Screen은 하나의 Controller에만 의존합니다.
- Screen은 UI 렌더링과 이벤트 전달만 담당합니다.
- 비즈니스 로직, 데이터 변환, 조건 판단은 Controller로 이동합니다.

### 함수 단일 책임

- 함수 하나는 하나의 작업만 합니다.
- 함수가 길어지거나 구분선이 필요해지면 분리 신호입니다.
- 함수명만 읽어도 동작을 알 수 있게 작성합니다.

### 위젯 분리 기준

Screen의 `build` 안에서 아래 중 하나라도 해당하면 `presentation/widgets/`로 분리합니다.

- 50줄 이상의 독립된 UI 블록
- 재사용 가능한 UI 조각
- 자체 상태나 로직을 가진 컴포넌트

---

## State — freezed 적용

모든 Screen State는 `freezed`를 사용합니다.

```dart
// xxxx_screen_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'xxxx_screen_state.freezed.dart';

@freezed
class XxxxScreenState with _$XxxxScreenState {
  const factory XxxxScreenState({
    @Default(false) bool isLoading,
    @Default([]) List<SomeModel> items,
    String? errorMessage,
  }) = _XxxxScreenState;
}
```

- `copyWith`은 freezed 자동 생성된 것만 사용합니다.
- UI 파생값(포맷, 필터)은 State가 아닌 Controller getter 또는 서비스에서 계산합니다.

---

## Riverpod 규칙

- `ConsumerWidget` / `ConsumerStatefulWidget`을 사용합니다.
- `ref.watch`는 `build` 안에서만, `ref.read`는 이벤트 핸들러 안에서만 사용합니다.
- Controller 베이스는 `AsyncNotifier` / `Notifier`를 사용합니다.
- Provider는 feature별 `presentation/providers/` 폴더에 정의합니다.

---

## Repository 패턴

- `domain/repositories/`에 추상 인터페이스, `data/repositories/`에 구현체를 둡니다.
- Controller는 추상 인터페이스에만 의존합니다 (Riverpod DI).
- 테스트 시 mock repository로 교체가 가능한 구조를 유지합니다.

---

## 코드 품질 기준

### 가독성

- 빈 줄로 논리 단락을 구분합니다 (선언 / 계산 / 반환).
- 복잡한 조건문은 이름 있는 bool 변수로 추출합니다.
- 매직 넘버는 상수로 선언합니다.

### 중복 제거

- 동일한 포맷팅/계산 로직이 2곳 이상에 나타나면 `domain/services/` 또는 유틸로 추출합니다.
- 위젯 스타일 중복은 `AppTypography` / `AppColors` / `AppDerivedColors`를 활용합니다.

### 이식성

- feature 간 직접 import를 피합니다. 공유 로직은 `lib/shared/` 또는 domain 레이어로 올립니다.
- 앱 전역 테마/색상은 `lib/theme/app_theme.dart`에서만 정의합니다.
- 하드코딩 색상을 새로 추가하지 않습니다. 기존 토큰을 우선 사용합니다.

---

## 고급 실천 사항

### 에러 처리

- Repository / Client에서 발생하는 예외는 도메인 전용 예외 클래스로 래핑합니다.
- Controller는 `AsyncValue`의 `error` 상태로 UI에 전달합니다.
- Screen은 에러 상태를 사용자 친화적인 메시지로 표시합니다.

### 데이터 파싱 안전성

- DTO 숫자 파싱은 항상 null-safe하게 작성합니다 (`int.tryParse` 등).
- HTML 파싱 시 예상치 못한 구조 변화에 대비해 예외를 잡고 로깅합니다.
- `lastPage` 같은 경계값은 방어적으로 처리합니다.

### 성능

- 긴 리스트는 `ListView.builder`를 사용합니다.
- 무거운 계산은 `compute()` 오프로드를 고려합니다.
- `ref.invalidate` / rebuild 범위를 최소화합니다.

### 테스트 가능성

- 비즈니스 로직은 Widget과 분리된 순수 함수 또는 서비스 클래스로 작성합니다.
- `domain/services/`의 함수는 단위 테스트를 작성합니다.
- Repository mock은 `domain/repositories/` 인터페이스를 구현해 만듭니다.

### 주석 규칙

- WHY가 명확하지 않은 결정에만 주석을 답니다.
- 파싱 규칙, 상태 동기화 방식, 날짜 처리 기준처럼 판단의 근거가 있는 곳에 짧게 남깁니다.
- 과제 특성상 면접에서 구현 의도를 설명해야 하므로, 핵심 판단 지점에 1~2줄 주석을 남깁니다.

---

## 브랜치 & PR 규칙

### 브랜치 전략

- 기능별로 브랜치를 분리해서 작업합니다.
- 브랜치명 형식: `feat/{기능명}`, `fix/{버그명}`, `refactor/{대상}`
- `main` 브랜치에 직접 커밋하지 않습니다. 반드시 PR을 통해 병합합니다.

```
# 예시
feat/naver-stock-api
feat/search-result-ui
fix/watchlist-date-sync
refactor/watchlist-controller
```

### PR 규칙

- PR 하나는 하나의 기능/수정 단위입니다.
- PR 제목은 한글로 간결하게 작성합니다.
- PR 본문에는 아래 내용을 포함합니다.
  - 무엇을 구현/수정했는지
  - 왜 이 방식을 선택했는지 (핵심 판단이 있을 경우)
  - 확인 방법 (테스트 실행 결과, 화면 동작 등)
- PR을 올리기 전에 `flutter analyze`와 `flutter test`를 통과시킵니다.

---

## 커밋 규칙

### 단위

- 커밋은 **기능 단위**로 합니다. 여러 기능을 한 커밋에 묶지 않습니다.
- 하나의 커밋은 하나의 변경 이유만 가져야 합니다.
- 작업 중간에도 의미 있는 완료 시점마다 커밋합니다 (작업 종료까지 미루지 않습니다).

### 메시지

- **한글**로 간단명료하게 작성합니다.
- 형식: `타입: 무엇을 했는지 한 줄 요약`
- 타입 예시: `feat`, `fix`, `refactor`, `style`, `docs`, `test`, `chore`
- 본문이 필요한 경우 한 줄 띄고 이유/배경을 한글로 추가합니다.

```
# 예시
feat: 검색 결과 행 하이라이트 구현
fix: 날짜 선택 후 관심목록 미갱신 버그 수정
refactor: WatchlistController 상태 로직 분리
```

---

## 작업 주석 기록

작업을 완료한 뒤, 해당 코드에 **구현 판단 주석**을 남깁니다.

### 남겨야 하는 경우

- 여러 방법 중 하나를 선택한 이유가 있을 때
- 파싱 규칙, 날짜 계산, 상태 동기화 방식처럼 비즈니스 결정이 담긴 곳
- 외부 API 응답 구조나 HTML 파싱 규칙에 의존하는 곳
- 면접에서 "왜 이렇게 했나요?" 질문이 나올 만한 지점

### 형식

- 1~2줄로 간결하게 작성합니다.
- WHAT(무엇)이 아닌 WHY(왜) / HOW(어떤 판단으로)를 씁니다.

```dart
// 국내 주식만 필터링: typeCode가 'stock'이고 종목코드 6자리인 경우만 유효한 국내 종목
// 과거 날짜는 realtime 값 대신 historical 기준으로 계산 — API가 최신일 기준으로만 realtime 제공
// 선택 날짜 포함 직전 30거래일 window: 차트 스펙 요건에 따라 index 0~29 슬라이싱
```

---

## 정적 분석 / 테스트

작업 후 반드시 실행합니다.

```bash
flutter analyze
flutter test
```

- `flutter analyze` 경고는 모두 해소합니다.
- 새 기능에는 단위 테스트를 추가합니다.
- 골든 테스트 갱신이 필요한 경우: `flutter test --update-goldens`

---

## 금지 사항

- Screen에서 HTTP 호출 또는 파싱 로직 직접 작성 금지
- 하드코딩 색상 신규 추가 금지 — 기존 테마 토큰 사용
- 동일 기능 provider를 feature 간 중복 정의 금지
- `ref.watch`를 이벤트 핸들러 안에서 사용 금지
- `--no-verify` 플래그로 커밋 금지
