//
//  Pet.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import Foundation

enum AnimalType: String, CaseIterable, Identifiable, Codable {
    case cat
    case dog
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .cat:
            return "Cat"
        case .dog:
            return "Dog"
        }
    }
    
    var iconName: String {
        switch self {
        case .dog:
            return "dogFace"
        case .cat:
            return "catFace"
        }
    }
    
    var bigIconName: String {
        switch self {
        case .dog:
            return "dog"
        case .cat:
            return "cat"
        }
    }
    
    var maxAge: Double {
        switch self {
        case .dog:
            return 13
        case .cat:
            return 13
        }
    }
    
    func getActivitiesFrequency(of activity: ActivityType) -> (count: Int, unit: Calendar.Component) {
        switch self {
        case .dog:
            switch activity {
            case .feeding:
                return (count: 3, unit: .day)
            case  .walk:
                return (count: 2, unit: .day)
            case .game:
                return (count: 1, unit: .day)
            case  .healing:
                return (count: 1, unit: .month)
            }
        case .cat:
            switch activity {
            case .feeding:
                return (count: 3, unit: .day)
            case  .walk:
                return (count: 0, unit: .day)
            case .game:
                return (count: 1, unit: .day)
            case  .healing:
                return (count: 1, unit: .month)
            }
        }
    }
    
    func getDuration(of activity: ActivityType) -> TimeInterval {
        switch self {
        case .cat:
            switch activity {
            case .feeding:
                return 10
            case .game:
                return 1800
            case .walk:
                return 0
            case .healing:
                return 3600
            }
        case .dog:
            switch activity {
            case .feeding:
                return 300
            case .game:
                return 3600
            case .walk:
                return 1800
            case .healing:
                return 3600
            }
        }
    }
}

struct Pet: Codable {
    var date: Date = Date()
    var name: String
    var age: Double
    var male: Bool
    var animalType: AnimalType
    var petStatus: PetStatus
    var activityHistory: [ActivityHistoryItem]
    var schedule: [ActivityType: [Date]]
}

extension Pet {
    static let example1 = Pet(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, name: "Fluffy", age: 2, male: true, animalType: .dog, petStatus: PetStatus(), activityHistory: [
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!, duration: 1800, activityType: .walk),
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, duration: 1800, activityType: .walk),
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, duration: 1800, activityType: .game),
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, duration: 1800, activityType: .feeding),
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, duration: 1800, activityType: .feeding),
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, duration: 1800, activityType: .feeding),
    ] , schedule: [.walk:[Date(), Date(), Date()], .healing: [Date(), Date(), Date()], .feeding: [Date(), Date(), Date()], .game:[Date(), Date(), Date()]])
    
    static let example2 = Pet(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, name: "adsaads", age: 2, male: true, animalType: .cat, petStatus: PetStatus(satiety: 33, health: 33, walks: 100, games: 33), activityHistory: [
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, duration: 1800, activityType: .feeding),
    ], schedule: [.healing: [Date(), Date(), Date()], .feeding: [Date(), Date(), Date()], .game:[Date(), Date(), Date()]])
}

