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
    case сleaning

    func title() -> String {
        switch self {
        case .game:
            return NSLocalizedString("games", comment: "")
        case .walk:
            return NSLocalizedString("walks", comment: "")
        case .healing:
            return NSLocalizedString("health", comment: "")
        case .feeding:
            return NSLocalizedString("feeding", comment: "")
        case .сleaning:
            return NSLocalizedString("сleaning", comment: "")
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
        case .сleaning:
            return "cleaning"
        }
    }
}

struct ActivityHistoryItem: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var duration: TimeInterval
    var activityType: ActivityType
}
