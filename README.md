# 리빗
나만의 독서기록을 작성하고 독서습관을 형성하는 앱

![Group 11](https://github.com/user-attachments/assets/a7598a69-d97f-483b-af3b-86b1f813573e)

## 앱스토어 링크
https://apps.apple.com/kr/app/%EB%A6%AC%EB%B9%97/id6723901720

## 프로젝트 환경
- 인원: 1명
- 기간: 2024.09.14 - 2024.09.30
- 버전: iOS 16+

## 기술 스택
- SwiftUI, MVVM+Input-Output, Combine, URLSession, RealmSwift, Remote notification(FCM), Charts
 
## 핵심 기능
- 네이버 책 API를 활용한 책 검색
- 독서상태에 따른 독서기록 생성
- 좋아요한 독서기록 모아보기
- 독서목표 수립 및 그래프를 통한 독서통계 시각화
  
## 주요 기술
- Realm의 LinkingObjects를 사용하여 책과 독서기록 간 1:N 관계 정의
- 책 커버 이미지 압축 및 FileManager 저장을 통해 앱 저장공간 사용량 최소화
- ViewModifier를 사용하여 iOS16 이전 버전의 수평스크롤 페이징 기능 구현 및 다양한 높이에 대응되는 Wrapper 구현하여 뷰의 재사용성 향상
- 독서기록 테이블의 년도 컬럼에 인덱스를 지정하여 연도별 통계 산출 시 속도 향상
- Color Asset와 @Environment 프로퍼티 래퍼를 사용한 다크모드 대응을 통해 사용자 편의성 향상
- NSLocalizedString를 사용하여 다국어(일본어, 영어) 대응하여 해외 사용자 유입 및 판매지역 확대 기대
- Charts를 사용하여 월간,연간 독서통계 시각화
- FCM을 사용한 Remote Notification 구현을 통해 사용성 향상
- 오프셋 기반 페이지네이션을 적용한 네이버 책 API 조회 및 enum을 사용한 네트워크 오류 처리를 통해 앱 안정성 확보
- MVVM + Input-Output 패턴 사용을 통해 화면의 입출력과 데이터 흐름에 대한 가시성 향상
  
## 트러블 슈팅
### 1. NavigationLazyView로 성능 향상
  > NavigationLink 안의 View는 항상 init이 호출. 뷰가 무거울수록 성능 저하로 이어짐
- NavigationLazyView를 사용하여, 해당 `View의 init`이 실제로 `body의 랜더링 시점`에 호출되도록 변경
- NavigationLink를 사용하는 곳마다 해당 NavigationLazyView를 사용. 별도로 NavigationLinkWrapper를 생성하여 사용

> NavigationLazyView
```swift
struct NavigationLazyView<Content: View>: View {
    let closure: () -> Content
    
    init(_ closure: @autoclosure @escaping () -> Content) {
        self.closure = closure
    }
    
    var body: some View {
        closure()
    }
}
```

> NavigationLinkWrapper
```swift
struct NavigationLinkWrapper<Dest: View, Inner: View> : View {
    let dest: Dest
    let inner: Inner
    
    init(@ViewBuilder dest: () -> Dest, @ViewBuilder inner: () -> Inner) {
        self.dest = dest()
        self.inner = inner()
    }
    
    var body: some View {
        NavigationLink {
            NavigationLazyView(dest)
        } label: {
            inner
        }
        .buttonStyle(PlainButtonStyle())
    }
}
```

### 2. 스크롤뷰 페이징 구현 시 iOS16 버전 대응
> scrollTargetBehavior을 사용하여 대응하지만, 그 이전 버전은 UIScrollView의 프로퍼티를 사용해야 함
- iOS17이상인 경우와 그 이전버전을 분기처리하여 대응
- 가로 스크롤 페이징이 여러 곳에서 일어나기 때문에, 해당 부분을 ViewModifier로 별도로 생성하여 관리

> HorizontalPageWrapper
```swift
struct HorizontalPageWrapper: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .scrollTargetBehavior(.viewAligned)
        } else {
            content
                .onAppear {
                    UIScrollView.appearance().isPagingEnabled = true
                }
        }
    }
}
```
> HorizontalPageContentWrapper
```swift
struct HorizontalPageContentWrapper<Inner: View>: ViewModifier {
    let height: CGFloat
    let inner: Inner
    
    init(height: CGFloat, @ViewBuilder inner: () -> Inner) {
        self.height = height
        self.inner = inner()
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    inner
                        .containerRelativeFrame(.horizontal)
                        .frame(height: height)
                }
                .scrollTargetLayout()
            }
            .asHorizontalPage()
        } else {
            GeometryReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        inner
                            .frame(width: proxy.size.width, height: height)
                    }
                }
            }
            .asHorizontalPage()
        }
    }
}
```

  
## 회고
- ViewModifier의 사용적인 측면에서 폰트나 이미지 같은 부분도 활용하면 통일성을 높일 수 있을 것 같음. 해당 부분에서 일관성있게 활용하지 못한 것이 아쉬움.
- Realm 스키마 설정에서 아쉬움이 남음. 연간통계에서 사용되는 년도 컬럼을 생각하지 못하고 종료일 컬럼 기준으로 검색하려고 하였으나 검색속도 측면에서 좋지 않고 검색조건의 복잡성이 높아진다고 판단 되었음. 추후에 년도 컬럼을 추가하고 인덱스로 지정하여 해결하였음. 이 부분에서 실제 배포가 진행된 이후라면, 마이그레이션 처리 등 문제 발생여지가 있다고 생각하여 초기 스키마 설정의 중요성에 대해 깨달음.
