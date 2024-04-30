<img src="https://github.com/sojin-p/Juple/assets/140357450/c2c6372b-c3be-4725-b570-4812b78da11b" width="150" height="150"/>

# Juple - 실시간 가상화폐 시세 정보
![Juple](https://github.com/sojin-p/Juple/assets/140357450/f189a4d6-24d6-4870-9843-f1e4b1ecf943)

<Br>

## 목차
:link: [개발 기간 및 환경](#개발-기간-및-환경)  
:link: [사용 기술 및 라이브러리](#사용-기술-및-라이브러리)  
:link: [핵심 기능](#핵심-기능)  
:link: [고려했던 사항](#고려했던-사항)  
:link: [트러블 슈팅](#트러블-슈팅)  
:link: [회고](#회고)  

<Br>

## 개발 기간 및 환경
- 개인 프로젝트
- 23.03.27 ~ 23.04.05 (10일)
- Xcode 15.0.1 / Swfit 5.9 / iOS 16+
 
<Br>

## 사용 기술 및 라이브러리
| Kind         | Stack                                                          |
| ------------ | -------------------------------------------------------------- |
| 아키텍쳐     | `MVVM` `Singleton`                                                     |
| 프레임워크   | `SwiftUI` `Combine` `Foundation` `URLSession` `Charts`                           |                                                                                              |
| ETC.         |  `WebSocket` `Codable`                               |  


<Br>

## 핵심 기능
- **WebSocket**을 통해 가상화폐 정보를 **실시간**으로 확인
- **차트** : 실시간 가격 변동 추이 차트 구현
- **호가** : 매수, 매도 호가를 막대 그래프 형태로 확인
- 다양한 통화(KRW, BTC, USDT) 필터링

<Br>

## 고려했던 사항

  - **MVVM**패턴과 **Combine**을 통해 **비동기적**으로 데이터를 관리하여 앱의 **반응성** 및 **사용자 경험** 향상
  - **WebSocketManager**를 **Singleton** 패턴으로 구현하여 로직을 **캡슐화**
  - `@EnvironmentObject`를 사용하여 View간의 데이터 공유
  - **제네릭**으로 추상화한 Custom Button으로 재사용성 향상
   -  **접근 제어자**  `private`  사용으로 코드를  **은닉화**
   - 더 이상 상속되지 않는 클래스에  `final`  사용으로  **컴파일 최적화**
   -  `weak`  사용으로 **메모리 누수**와 **강한 순환 참조** 방지

<Br>

## 트러블 슈팅
1. 상세 뷰로 전환할 때마다 API/WebSocket 코드가 반복적으로 호출되는 이슈
   - **원인** : 통신 코드가 뷰 모델 init 구문에 있는데, 상세 뷰에서 뷰 모델을 `@StateObject`로 선언했더니 뷰와 수명이 동일해 init 구문이 반복 실행되어 발생
   - **해결** : `@EnvironmentObject`를 사용하여 상위 뷰에서 하위 뷰로 뷰 모델을 공유하여 해결
```swift
//메인 뷰
@StateObject var viewModel = CoinlistViewModel()

.navigationDestination(for: Market.self) { market in
    DetailView(market: market)
        .environmentObject(viewModel)
}

//상세 뷰
@EnvironmentObject var viewModel: CoinlistViewModel
```

<Br>

2. 상세 뷰에서 뒤로 가기 시 항상 첫 번째 필터(KRW)로 적용되는 이슈
   - **원인** : 메인 뷰 `onAppear`에서 선택된 필터 값이 아닌, 첫 번째 필터로 고정된 값을 설정하여 발생
   - **해결** : 뷰 모델에 `@Published`로 선택한 필터값을 저장 후 업데이트하여 해결
```swift
//해결 전 메인 뷰
.onAppear {
    viewModel.callRequest(.krw)
}

//해결 후 메인 뷰
SegmentedView( //Custom Button
    segments: [CurrencyType.krw, CurrencyType.btc, CurrencyType.usdt],
    selectedSegment: viewModel.selectedSegment,
    selectionChanged: {  selectedSeg in
        viewModel.filteredCoins(selectedSeg)
        viewModel.selectedSegment = selectedSeg
   })

//뷰 모델
@Published var selectedSegment: CurrencyType = .krw
```

<Br>

3. AreaMark 그라데이션이 한 가지 색상만 적용되는 이슈
   - **원인** : 색상이 차트 영역을 벗어나서 발생
   - **해결** : alignsMarkStylesWithPlotArea() modifier를 설정하여 해결
```swift
AreaMark (
    x: .value("Time", item.date.toDate() ?? Date()),
    y: .value("Price", item.tradePrice)
)
.foregroundStyle(chartGradient)
.alignsMarkStylesWithPlotArea()
```

<Br>


## 회고
- SwiftUI Charts를 구현하는 과정에서 원하는 기능을 찾는 것이 쉽지 않았지만, 애플 공식 문서와 WWDC 자료를 통해 필요한 정보를 얻을 수 있었습니다. 이 경험을 통해 문서를 먼저 살펴보는 습관이 중요하다는 것을 깨달았습니다.
- 현재는 30분 간격으로 차트를 표시하고 있지만, 시간별 필터를 추가하고 차트 선택 시 선택한 부분의 가상화폐 정보를 표시하는 등 더 나은 사용자 경험을 제공할 계획입니다.
