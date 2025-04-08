//
//  AppDelegate.swift
//  Rebit
//
//  Created by 홍정민 on 1/6/25.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import RealmSwift

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        //원격 알림 등록
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        //메시지 대리자 설정. 등록 토큰을 수신
        Messaging.messaging().delegate = self
        
        saveLatestFavoriteReviewToUserDefaults()
        return true
    }
  
    // Widget에서 사용할 데이터 저장
    func saveLatestFavoriteReviewToUserDefaults() {
        // Realm에서 좋아하는 책 리뷰 가져오기
        let reviewRepository = DefaultReviewRepository()
        if let favoriteReview = reviewRepository.fetchFavoriteReviewList().first {
            let userDefaults = UserDefaults(suiteName: "group.jm.rebit")
            userDefaults?.set(favoriteReview.book.first!.title, forKey: "bookTitle")
            userDefaults?.set(favoriteReview.book.first!.author, forKey: "bookAuthor")
            userDefaults?.set(favoriteReview.title, forKey: "reviewContent")
        } else {
            // 좋아하는 리뷰가 없는 경우
            let userDefaults = UserDefaults(suiteName: "group.jm.rebit")
            userDefaults?.removeObject(forKey: "bookTitle")
            userDefaults?.removeObject(forKey: "bookAuthor")
            userDefaults?.removeObject(forKey: "reviewContent")
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {
    //현재 등록 토큰 가져오기
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //현재 등록 토큰 가져오기
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
        
        //토큰 갱신 모니터링
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}


