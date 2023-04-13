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
    case fish
    case hamster
    case bird
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .cat:
            return NSLocalizedString("cat", comment: "")
        case .dog:
            return NSLocalizedString("dog", comment: "")
        case .fish:
            return NSLocalizedString("fish", comment: "")
        case .hamster:
            return NSLocalizedString("hamster", comment: "")
        case .bird:
            return NSLocalizedString("bird", comment: "")
        }
    }
    
    var iconName: String {
        switch self {
        case .dog:
            return "dogFace"
        case .cat:
            return "catFace"
        case .fish:
            return "fishFace"
        case .hamster:
            return "hamsterFace"
        case .bird:
            return "birdFace"
        }
    }
    
    var bigIconName: String {
        switch self {
        case .dog:
            return "dog"
        case .cat:
            return "cat"
        case .fish:
            return "fish"
        case .hamster:
            return "hamster"
        case .bird:
            return "bird"
        }
    }
    
    var maxAge: Double {
        switch self {
        case .dog:
            return 15
        case .cat:
            return 15
        case .fish:
            return 5
        case .hamster:
            return 3
        case .bird:
            return 15
        }
    }
    
    func getActivitiesFrequency(of activity: ActivityType) -> (count: Int, unit: Calendar.Component) {
        switch self {
        case .dog:
            switch activity {
            case .feeding:
                return (count: 2, unit: .day)
            case  .walk:
                return (count: 2, unit: .day)
            case .game:
                return (count: 1, unit: .day)
            case  .healing:
                return (count: 1, unit: .month)
            case .сleaning:
                return (count: 1, unit: .weekOfYear)
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
            case .сleaning:
                return (count: 1, unit: .weekOfYear)
            }
        case .fish:
            switch activity {
            case .feeding:
                return (count: 1, unit: .day)
            case  .walk:
                return (count: 0, unit: .day)
            case .game:
                return (count: 0, unit: .day)
            case  .healing:
                return (count: 0, unit: .month)
            case .сleaning:
                return (count: 1, unit: .weekOfYear)
            }
        case .hamster:
            switch activity {
            case .feeding:
                return (count: 1, unit: .day)
            case  .walk:
                return (count: 0, unit: .day)
            case .game:
                return (count: 1, unit: .day)
            case  .healing:
                return (count: 1, unit: .month)
            case .сleaning:
                return (count: 1, unit: .weekOfYear)
            }
        case .bird:
            switch activity {
            case .feeding:
                return (count: 1, unit: .day)
            case  .walk:
                return (count: 0, unit: .day)
            case .game:
                return (count: 1, unit: .day)
            case  .healing:
                return (count: 1, unit: .month)
            case .сleaning:
                return (count: 1, unit: .day)
            }
        }
    }
    
    func getDuration(of activity: ActivityType) -> TimeInterval {
        switch self {
        case .cat:
            switch activity {
            case .feeding:
                return 240
            case .game:
                return 1800
            case .walk:
                return 0
            case .healing:
                return 2700
            case .сleaning:
                return 600
            }
        case .dog:
            switch activity {
            case .feeding:
                return 240
            case .game:
                return 1800
            case .walk:
                return 2100
            case .healing:
                return 2700
            case .сleaning:
                return 300
            }
        case .fish:
            switch activity {
            case .feeding:
                return 60
            case .game:
                return 0
            case .walk:
                return 0
            case .healing:
                return 0
            case .сleaning:
                return 420
            }
        case .hamster:
            switch activity {
            case .feeding:
                return 180
            case .game:
                return 1200
            case .walk:
                return 0
            case .healing:
                return 1800
            case .сleaning:
                return 300
            }
        case .bird:
            switch activity {
            case .feeding:
                return 180
            case .game:
                return 1800
            case .walk:
                return 0
            case .healing:
                return 2700
            case .сleaning:
                return 180
            }
        }
    }
    
    func getCooldown(of activity: ActivityType) -> Int {
        switch self {
        case .cat:
            switch activity {
            case .feeding:
                return 2
            case .game:
                return 0
            case .walk:
                return 5
            case .healing:
                return 24
            case .сleaning:
                return 72
            }
        case .dog:
            switch activity {
            case .feeding:
                return 2
            case .game:
                return 0
            case .walk:
                return 6
            case .healing:
                return 24
            case .сleaning:
                return 72
            }
        case .fish:
            switch activity {
            case .feeding:
                return 12
            case .game:
                return 0
            case .walk:
                return 5
            case .healing:
                return 24
            case .сleaning:
                return 72
            }
        case .hamster:
            switch activity {
            case .feeding:
                return 12
            case .game:
                return 0
            case .walk:
                return 6
            case .healing:
                return 24
            case .сleaning:
                return 72
            }
        case .bird:
            switch activity {
            case .feeding:
                return 12
            case .game:
                return 0
            case .walk:
                return 6
            case .healing:
                return 24
            case .сleaning:
                return 6
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
    static let example1 = Pet(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, name: "Yuumi", age: 2, male: true, animalType: .cat, petStatus: PetStatus(satiety: 66, health: 100, walks: 100, games: 100), activityHistory: [
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!, duration: 240, activityType: .feeding),
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!, duration: 240, activityType: .feeding),
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!, duration: 240, activityType: .feeding),
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, duration: 240, activityType: .feeding),
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, duration: 240, activityType: .feeding),
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, duration: 240, activityType: .feeding),
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, duration: 240, activityType: .feeding),
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, duration: 240, activityType: .feeding),
        ActivityHistoryItem(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, duration: 240, activityType: .feeding),
    ] , schedule: [.healing: [Date()], .feeding: [Date(), Date(), Date()], .game:[Date()], .сleaning:[Date()]])
}

