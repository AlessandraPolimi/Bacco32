//
//  BACCOApp.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//

import Foundation
import SwiftData
import SwiftUI
import UserNotifications

@main
struct BACCOApp: App {
    // Declare a property to hold the AppDelegate instance
        @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let healthKitManager = HealthKitManager(heartRateData: [])

    var body: some Scene {
        WindowGroup {
            OrganizerView()
        }
        .modelContainer(for: [HRVMetrics.self, User.self, AddedFood.self, BaccoIndexes.self, Punteggio.self, FoodItem.self])
    }
    
    init() {
        // Richiesta di autorizzazione a HealthKit durante l'inizializzazione dell'app
        healthKitManager.requestAuthorization { success in
            if success {
                print("HealthKit authorization granted.")
            } else {
                print("HealthKit authorization denied.")
            }
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
        print("App initialized. Application Support Directory: \(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.path ?? "Not found")")
    }
}



class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set the notification center delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Request notification permissions
        requestNotificationAuthorization(application)
        
        // Schedule Notifications
        scheduleNotifications()

        return true
    }

    private func requestNotificationAuthorization(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
        }
    }
    
    private func scheduleNotifications() {
        scheduleNotification(title: "Meal Reminder",
                             body: "Have you logged your meal for today?",
                             hour: 8, minute: 30, identifier: "MealReminder1")
        
        scheduleNotification(title: "Meal Reminder",
                             body: "Have you logged your meal for today?",
                             hour: 13, minute: 00, identifier: "MealReminder2")
        
        scheduleNotification(title: "Meal Reminder",
                             body: "Have you logged your meal for today?",
                             hour: 20, minute: 00, identifier: "MealReminder3")
        
        scheduleNotification(title: "Mindfulness Reminder",
                             body: "Have you done your daily mindfulness session?",
                             hour: 8, minute: 00, identifier: "MindfulnessReminder1")
        
        scheduleNotification(title: "Mindfulness Reminder",
                             body: "Have you done your daily mindfulness session?",
                             hour: 10, minute: 00, identifier: "MindfulnessReminder2")
        
        scheduleNotification(title: "Mindfulness Reminder",
                             body: "Have you done your daily mindfulness session?",
                             hour: 15, minute: 00, identifier: "MindfulnessReminder3")
        
        scheduleNotification(title: "Physical Acticity Reminder",
                             body: "Remember to do some physical activity today!",
                             hour: 10, minute: 00, identifier: "MindfulnessReminder1")
        
        scheduleNotification(title: "Physical Acticity Reminder",
                             body: "Have you done you done some physical activity today?",
                             hour: 17, minute: 00, identifier: "MindfulnessReminder2")
    }

    private func scheduleNotification(title: String, body: String, hour: Int, minute: Int, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling \(identifier): \(error.localizedDescription)")
            } else {
                print("\(identifier) scheduled!")
            }
        }
    }

    // Handle notifications when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification will present in foreground.")
        completionHandler([.banner, .badge, .sound])
    }
    
    
    
    // Handle user interaction with notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification was interacted with.")
        completionHandler()
    }
}



