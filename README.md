# 리빗
나만의 독서기록을 작성하고 독서습관을 형성하는 앱

|즐겨찾기|서재|검색|통계|독서기록|
|--------|------------|-----|--------|----|
|<img width = "200" src = "https://github.com/user-attachments/assets/3cd0dbf1-c9a8-42de-892d-50f25c258a0c">|<img width = "200" src = "https://github.com/user-attachments/assets/d7db7a8b-27cf-4618-be55-52c0ca1c08ee">|<img width = "200" src = "https://github.com/user-attachments/assets/b63feba2-3a05-4e04-8989-bae31d320efc">|<img width = "200" src = "https://github.com/user-attachments/assets/7837a1bc-0c91-40b5-b209-3543b93b6d58">|<img width = "200" src = "https://github.com/user-attachments/assets/203e3c72-6573-4b98-a7de-159624e439f9">|

## 앱스토어 링크
[리빗🐰](https://apps.apple.com/kr/app/%EB%A6%AC%EB%B9%97/id6723901720)

## 프로젝트 환경
- 인원: 1명
- 기간: 2024.09.14 - 2024.09.30
- 버전: iOS 16+

## 기술 스택
- iOS: SwiftUI, Combine
- Architecture: MVI, Singleton, Repository
- DB & Network: Realm, URLSession
- UI: Charts, Cosmos
- ETC: XCTest, Remote Notification, Firebase Analytics, Localization, FileManager
 
## 핵심 기능
- 즐겨찾기: 좋아요한 독서기록 확인
- 서재: 독서기록 보관 및 검색
- 검색: 네이버 책 API를 사용한 책 검색
- 통계: 독서목표 수립 및 연도별, 월별 통계
  
## 주요 기술
- SwiftUI와 MVI를 통한 단방향 아키텍처 구현을 통해 View 상태관리
- DIP를 통한 네트워크 통신 로직 추상화 및 XCTest를 통한 UnitTest 코드 작성 및 검증
- Offset Based Pagination 구현 및 enum을 사용한 네트워크 오류 처리
- Repository 패턴과 프로토콜을 통한 Realm 데이터 접근 캡슐화
- 데이터베이스 인덱스 생성을 통한 데이터 검색 속도 향상
- Realm의 LinkingObjects를 통한 테이블 간 1:N 관계 정의
- Firebase Analytics 및 FCM을 통한 Remote Notification 기능 구현
- ViewModifier를 통한 스크롤뷰 페이징 iOS 버전 대응 및 제네릭과 클로저를 사용한 커스텀뷰 제작
- Color Asset 및 @Environment Property Wrapper를 사용한 다크모드 대응
- NSLocalizedString를 통한 다국어(일본어, 영어) 대응
- Charts의 BarMark를 통한 통계기능 구현 및 데이터 시각화

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
- Realm 스키마 설정에서 아쉬움이 남음. 처음 스키마 설계 시 연간통계에서 사용되는 년도 컬럼을 생각하지 못하였음. 이 부분에서 실제 배포가 진행된 이후라면, 마이그레이션 처리 등 문제 발생여지가 있다고 생각하여 초기 스키마 설정의 중요성에 대해 깨달음.