//
//  loodosVakaApp.swift
//  loodosVaka
//
//  Created by Erkut Ter on 14.06.2023.
//


import SwiftUI
import Firebase
import FirebaseRemoteConfig
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self

        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([[.banner, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
}

struct ContentView: View {
    @State private var goToNextPage = false
    @ObservedObject var networkMonitor: NetworkService
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            if goToNextPage {
                ZStack{
                    HomeView()
                    Spacer()
                }
            } else {
                SplashScreen(goToNextPage: $goToNextPage)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("No internet connection"),
                message: Text("You need an active internet connection to use app."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: networkMonitor.isConnected) { isConnected in
            if !isConnected {
                self.showAlert = true
            }
        }
    }
}

struct SplashScreen: View {
    @State private var loodosText = ""
    @Binding var goToNextPage: Bool

    private func fetchFirebaseValue() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch(withExpirationDuration: 0) { status, error in
            if status == .success {
                remoteConfig.activate { changed, error in
                    if error == nil {
                        self.loodosText = remoteConfig["splashText"].stringValue ?? ""
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                            self.goToNextPage = true
                        }
                    } else {
                        print("Error activating remote config values: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    var body: some View {
        VStack{
            Text(loodosText).font(.system(size: 24))
        }
        .onAppear{
            self.fetchFirebaseValue()
        }
    }
}


@main
struct loodosVakaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var networkMonitor = NetworkService()
    
    var body: some Scene {
        WindowGroup {
            ContentView(networkMonitor: networkMonitor)
        }
    }
}


