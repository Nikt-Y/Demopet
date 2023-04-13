//
//  AddPetViewModel.swift
//  Demopet
//
//  Created by Nik Y on 10.04.2023.
//

import Foundation
import SwiftUI

class AddPetViewModel: ObservableObject {    
    @Published public var name = ""
    @Published public var selectedPetType: AnimalType = .cat
    @Published public var petAge: Double = 0.5
    @Published public var isMale: Bool = true
    @Published public var schedule: [ActivityType: [Date]] = [:]

    private var isNewPet: Bool = false
    @ObservedObject private var petViewModel = PetViewModel.shared
    
    init() {
        fillCurrentSchedule()
    }
    
    func saveNewPet() {
        let newPet = Pet(name: name, age: petAge, male: isMale, animalType: selectedPetType, petStatus: PetStatus(), activityHistory: [], schedule: [:])
        petViewModel.addPet(newPet)
        fillNewSchedule(for: selectedPetType)
    }
    
    func saveNewSchedule() {
        
        petViewModel.saveNewSchedule(schedule)
    }
    
    func addTime(for activity: ActivityType) {
        schedule[activity]?.append(Date())
    }

    func deleteTime(for activity: ActivityType) {
        guard let frequency = schedule[activity], !frequency.isEmpty else { return }
        schedule[activity]?.removeLast()
    }
    
    func fillCurrentSchedule() {
        schedule = petViewModel.currentPet.schedule
    }
    
    private func fillNewSchedule(for animalType: AnimalType) {
        schedule = [:]
        for activity in ActivityType.allCases {
            let frequency = animalType.getActivitiesFrequency(of: activity)
            if frequency.unit == .day  && frequency.count > 0 {
                var datesForActivity: [Date] = []
                for _ in 0..<frequency.count {
                    datesForActivity.append(Date())
                }
                schedule[activity] = datesForActivity
            }
        }
    }
}
