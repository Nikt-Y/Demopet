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
            NotificationManager.shared.requestAuthorization()
        }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear() {
                    PetViewModel.shared.updatePetStatusesOnAppLaunch()
                }
        }
    }
}
