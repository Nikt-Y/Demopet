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
    //    @Published public var validationError: String?
    
    
    private var isNewPet: Bool = false
    @ObservedObject private var petViewModel = PetViewModel.shared
    
    init() {
        fillCurrentSchedule()
    }
    
    func saveNewPet() {
        let newPet = Pet(name: name.trimmingCharacters(in: .whitespacesAndNewlines), age: petAge, male: isMale, animalType: selectedPetType, petStatus: PetStatus(), activityHistory: [], schedule: [:])
        petViewModel.addPet(newPet)
        fillNewSchedule(for: selectedPetType)
    }
    
    func saveNewSchedule() {
        
        petViewModel.saveNewSchedule(schedule)
    }
    
    func addTime(for activity: ActivityType) {
        guard let frequency = schedule[activity] else { return }
        let index = frequency.count
        let totalCount = frequency.count + 1
        let range = getDatePickerRange(index: index, totalCount: totalCount)
        let defaultDate = range.lowerBound
        schedule[activity]?.append(defaultDate)

        for i in 0..<index {
            let updatedRange = getDatePickerRange(index: i, totalCount: totalCount)
            let currentOrDefaultDate = updatedRange.contains(frequency[i]) ? frequency[i] : updatedRange.lowerBound
            schedule[activity]?[i] = currentOrDefaultDate
        }
    }


    
    func deleteTime(for activity: ActivityType) {
        guard let frequency = schedule[activity], !frequency.isEmpty else { return }
        schedule[activity]?.removeLast()
        if let updatedFrequency = schedule[activity] {
            let totalCount = updatedFrequency.count
            for index in 0..<totalCount {
                let range = getDatePickerRange(index: index, totalCount: totalCount)
                let defaultDate = range.lowerBound
                schedule[activity]?[index] = defaultDate
            }
        }
    }
    
    func fillCurrentSchedule() {
        schedule = petViewModel.currentPet.schedule
    }
    
    private func fillNewSchedule(for animalType: AnimalType) {
        schedule = [:]
        for activity in ActivityType.allCases {
            let frequency = animalType.getActivitiesFrequency(of: activity)
            if frequency.unit == .day && frequency.count > 0 {
                var datesForActivity: [Date] = []
                for index in 0..<frequency.count {
                    let range = getDatePickerRange(index: index, totalCount: frequency.count)
                    let defaultDate = range.lowerBound
                    datesForActivity.append(defaultDate)
                }
                schedule[activity] = datesForActivity
            }
        }
    }
    
    func validateName() -> String? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            return NSLocalizedString("enter_name", comment: "")
            
        }
        guard trimmedName.count <= 16 else {
            return NSLocalizedString("less_16", comment: "")
            
        }
        let allowedCharacterSet = CharacterSet.letters.union(CharacterSet.whitespaces)
        guard trimmedName.unicodeScalars.allSatisfy(allowedCharacterSet.contains) else {
            return NSLocalizedString("only_letters", comment: "")
            
        }
        if PetViewModel.shared.pets.contains(where: { $0.name == trimmedName }) {
            return NSLocalizedString("already_exist", comment: "")
        } else {
            return nil
        }
    }
    
    func getDatePickerRange(index: Int, totalCount: Int) -> ClosedRange<Date> {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        
        let startTime = calendar.date(byAdding: .hour, value: 6, to: currentDate)!
        let endTime = calendar.date(byAdding: .hour, value: 24, to: currentDate)!
        
        let timeInterval = (endTime.timeIntervalSince(startTime) / TimeInterval(totalCount)).rounded()
        let startOfRange = calendar.date(byAdding: .second, value: Int(timeInterval * Double(index)), to: startTime)!
        let endOfRange = calendar.date(byAdding: .second, value: Int(timeInterval * Double(index + 1)), to: startTime)!
        
        return startOfRange...endOfRange
    }
    
    func formatRangeAsString(_ range: ClosedRange<Date>) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let start = dateFormatter.string(from: range.lowerBound)
        let end = dateFormatter.string(from: range.upperBound)
        return "\(start)-\(end)"
    }
}
