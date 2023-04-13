//
//  ActivityHistory.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import Foundation
import SwiftUI

enum ActivityType: String, CaseIterable, Identifiable, Codable {
    var id: String { self.rawValue }
    
    case game
    case walk
    case healing
    case feeding
    
    func title() -> String {
        switch self {
        case .game:
            return "Game"
        case .walk:
            return "Walk"
        case .healing:
            return "Healing"
        case .feeding:
            return "Feeding"
        }
    }
    
    func iconName() -> String {
        switch self {
        case .game:
            return "game"
        case .walk:
            return "walk"
        case .healing:
            return "health"
        case .feeding:
            return "food"
        }
    }
    
    func color() -> Color {
        switch self {
        case .game:
            return Color.blue
        case .walk:
            return Color.green
        case .healing:
            return Color.red
        case .feeding:
            return Color.orange
        }
    }
}

struct ActivityHistoryItem: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var duration: TimeInterval
    var activityType: ActivityType
}
