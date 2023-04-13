//
//  PetStatus.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import Foundation

struct PetStatus: Codable {
    var satiety: Double = 100
    var health: Double = 100
    var walks: Double = 100
    var games: Double = 100
    var cleaning: Double = 100
    
    mutating func decrementValue(for activity: ActivityType, by value: Double) {
        switch activity {
        case .feeding:
            satiety -= value
        case .walk:
            walks -= value
        case .game:
            games -= value
        case .healing:
            health -= value
        case .сleaning:
            cleaning -= value
        }
    }
    
    func value(for activity: ActivityType) -> Double {
        switch activity {
        case .game:
            return max(0, games)
        case .walk:
            return max(0, walks)
        case .healing:
            return max(0, health)
        case .feeding:
            return max(0, satiety)
        case .сleaning:
            return max(0, cleaning)
        }
    }
    
    func realValue(for activity: ActivityType) -> Double {
        switch activity {
        case .game:
            return games
        case .walk:
            return walks
        case .healing:
            return health
        case .feeding:
            return satiety
        case .сleaning:
            return cleaning
        }
    }
}

