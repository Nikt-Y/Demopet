//
//  NotificationManager.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(pet: Pet, activity: ActivityType, time: Date, repeatFrequency: Calendar.Component) {
        let content = UNMutableNotificationContent()
        content.title = String(format: NSLocalizedString("notif_title", comment: ""), pet.name, activity.title())
        content.body = String(format: NSLocalizedString("notif_body", comment: ""), activity.title().lowercased(), pet.name)
        content.sound = .default

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        var firstOccurrenceDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: time)
        let now = Date()
        
        if repeatFrequency != .day {
            while calendar.date(from: firstOccurrenceDateComponents)! < now {
                firstOccurrenceDateComponents.setValue(firstOccurrenceDateComponents.value(for: repeatFrequency)! + 1, for: repeatFrequency)
            }
        } else {
            if calendar.date(from: firstOccurrenceDateComponents)! < now {
                firstOccurrenceDateComponents.day! += 1
            }
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: firstOccurrenceDateComponents, repeats: true)

        let identifier = "\(pet.name)-\(activity.rawValue)-\(hour)-\(minute)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled for pet \(pet.name) and activity \(activity.rawValue)")
            }
        }
    }
    
    func deleteNotification(pet: Pet, activity: ActivityType, time: Date) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        let identifier = "\(pet.name)-\(activity.rawValue)-\(hour)-\(minute)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
