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
    
    mutating func decrementValue(for activity: ActivityType, by value: Double) {
        switch activity {
        case .feeding:
            satiety -= value
            satiety = max(0, satiety)
        case .walk:
            walks -= value
            walks = max(0, walks)
        case .game:
            games -= value
            games = max(0, games)
        case .healing:
            health -= value
            health = max(0, health)
        }
    }
    
    func value(for activity: ActivityType) -> Double {
        switch activity {
        case .game:
            return games
        case .walk:
            return walks
        case .healing:
            return health
        case .feeding:
            return satiety
        }
    }
}

