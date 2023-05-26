//
//  DemopetApp.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import SwiftUI

@main
struct DemopetApp: App {
    init() {
            NotificationManager.requestAuthorization()
        }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.light)
        }
    }
}
