//
//  ActivityInfoViewModel.swift
//  Demopet
//
//  Created by Nik Y on 12.04.2023.
//

import Foundation
import SwiftUI

class ActivityInfoViewModel: ObservableObject {
    
    @ObservedObject private var petViewModel = PetViewModel.shared
    
    func getActivityHistory(of activityType: ActivityType, week: Int) -> [ActivityHistoryItem] {
        let history = petViewModel.getPetActivityHistory(type: activityType)

        let calendar = Calendar.current
        let now = Date()
        let currentWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        let weekStart = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.date(byAdding: .weekOfYear, value: week, to: currentWeekStart)!
        )!
        let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!

        var dailyDurations: [Int: TimeInterval] = [:]
        for day in 0..<7 {
            dailyDurations[day] = 0
        }

        for item in history {
            let itemDate = item.date
            
            if calendar.compare(itemDate, to: weekStart, toGranularity: .day) != .orderedAscending &&
                calendar.compare(itemDate, to: weekEnd, toGranularity: .day) != .orderedDescending {
                
                let dayOfWeek = calendar.component(.weekday, from: itemDate) - calendar.firstWeekday
                let adjustedDayOfWeek = (dayOfWeek + 6) % 7 // Adjust the index to start from Monday
                dailyDurations[adjustedDayOfWeek] = (dailyDurations[adjustedDayOfWeek] ?? 0) + item.duration
            }
        }

        var activityHistoryItems: [ActivityHistoryItem] = []
        for (day, duration) in dailyDurations {
            let date = calendar.date(byAdding: .day, value: day, to: weekStart)!
            let historyItem = ActivityHistoryItem(date: date, duration: duration, activityType: activityType)
            activityHistoryItems.append(historyItem)
        }

        return activityHistoryItems.sorted { $0.date < $1.date }
    }

    
    func getWeekText(week: Int) -> String {
        let calendar = Calendar.current
        let now = Date()
        let currentWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        let weekStart = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.date(byAdding: .weekOfYear, value: week, to: currentWeekStart)!
        )!
        let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return "\(dateFormatter.string(from: weekStart)) - \(dateFormatter.string(from: weekEnd))"
    }
    
    func getChartYScale(activityType: ActivityType) -> ClosedRange<Int> {
        let dur = petViewModel.currentPet.animalType.getDuration(of: activityType)
        let count = petViewModel.currentPet.animalType.getActivitiesFrequency(of: activityType).count
        if petViewModel.currentPet.animalType.getActivitiesFrequency(of: activityType).unit == .day {
            return 0...Int(dur*Double(count)*1.2)
        }
        return 0...Int(dur*1.2)
    }
}
