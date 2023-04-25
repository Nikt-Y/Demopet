//
//  PetViewModel.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import Foundation
import Combine

class PetViewModel: ObservableObject {
    static let shared = PetViewModel()
    @Published private(set) var pets: [Pet] = []
    @Published private(set) var currentPet: Pet = Pet.example1
    @Published private(set) var deadPets: [Pet] = []
    
    private let petsKey = "petsKey"
    
    init() {
                if let savedData = UserDefaults.standard.data(forKey: petsKey),
                   let decodedPets = try? JSONDecoder().decode([Pet].self, from: savedData) {
                    pets = decodedPets
                    currentPet = pets.count > 0 ? pets[0] : Pet.example1
                    return
                }
                pets = []
    }
    
    @discardableResult
    func isHomeFirstLaunch(set firstLaunch: Bool = true) -> Bool {
        let defaults = UserDefaults.standard
        let firstLaunchKey = "isHomeFirstLaunch"
        if defaults.object(forKey: firstLaunchKey) == nil {
            if !firstLaunch {
                defaults.set(true, forKey: firstLaunchKey)
            }
            return true
        } else {
            return false
        }
    }
    
    @discardableResult
    func isStatusFirstLaunch(set firstLaunch: Bool = true) -> Bool {
        let defaults = UserDefaults.standard
        let firstLaunchKey = "isStatusFirstLaunch"
        if defaults.object(forKey: firstLaunchKey) == nil {
            if !firstLaunch {
                defaults.set(true, forKey: firstLaunchKey)
            }
            return true
        } else {
            return false
        }
    }
    
    @discardableResult
    func isProfileFirstLaunch(set firstLaunch: Bool = true) -> Bool {
        let defaults = UserDefaults.standard
        let firstLaunchKey = "isProfileFirstLaunch"
        if defaults.object(forKey: firstLaunchKey) == nil {
            if !firstLaunch {
                defaults.set(true, forKey: firstLaunchKey)
            }
            return true
        } else {
            return false
        }
    }
    
    func schedulePetNotifications() {
        for (activity, dates) in currentPet.schedule {
            let repeatFrequency = currentPet.animalType.getActivitiesFrequency(of: activity).unit
            for date in dates {
                NotificationManager.shared.scheduleNotification(pet: currentPet, activity: activity, time: date, repeatFrequency: repeatFrequency)
            }
        }
    }
    
    func deleteNotifications() {
        for (activity, dates) in currentPet.schedule {
            if currentPet.animalType.getActivitiesFrequency(of: activity).unit == .day {
                for date in dates {
                    NotificationManager.shared.deleteNotification(pet: currentPet, activity: activity, time: date)
                }
            }
        }
    }
    
    func addPet(_ pet: Pet) {
        setCurrentPet(pet)
        pets.append(pet)
        updatePets()
    }
    
    func setCurrentPet(_ pet: Pet) {
        currentPet = pet
    }
    
    
    func saveNewSchedule(_ schedule: [ActivityType: [Date]]) {
        deleteNotifications()
        for (activity, times) in schedule {
            let frequency = currentPet.animalType.getActivitiesFrequency(of: activity)
            if frequency.unit == .day {
                currentPet.schedule[activity] = times
            }
        }
        checkAndUpdateScheduleForNonDailyActivities()
        schedulePetNotifications()
        updatePets()
    }
    
    func checkAndUpdateScheduleForNonDailyActivities() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        for activity in ActivityType.allCases {
            let frequency = currentPet.animalType.getActivitiesFrequency(of: activity)
            
            if frequency.unit != .day && frequency.count > 0 {
                var hasActivityInSchedule = false
                if let datesForActivity = currentPet.schedule[activity] {
                    if !datesForActivity.isEmpty {
                        hasActivityInSchedule = true
                    }
                }
                
                if !hasActivityInSchedule {
                    var nextActivityDate = calendar.date(byAdding: frequency.unit, value: 1, to: currentDate)!
                    nextActivityDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: nextActivityDate)!
                    currentPet.schedule[activity] = [nextActivityDate]
                }
            }
        }
    }
    
    
    func saveActivity(activityType: ActivityType, elapsedTime: TimeInterval) {
        guard currentPet.petStatus.value(for: activityType) < 100 else {return}
        let duration: Double = currentPet.animalType.getDuration(of: activityType)
        let count: Double = Double(currentPet.animalType.getActivitiesFrequency(of: activityType).count)
        
        switch activityType {
        case .game:
            let elTime = min(elapsedTime, duration)
            currentPet.petStatus.games += (100.0 * elTime)/(count*duration)
            currentPet.petStatus.games = min(currentPet.petStatus.games, 100)
            addActivityToHistory(activityType: activityType, elapsedTime: elTime)
            
        case .walk:
            if elapsedTime >= (duration * 0.8) {
                let elTime = min(elapsedTime, duration)
                currentPet.petStatus.walks += (100.0 * elTime)/(count*duration)
                currentPet.petStatus.walks = min(currentPet.petStatus.walks, 100)
                if elapsedTime > duration {
                    addActivityToHistory(activityType: activityType, elapsedTime: duration)
                    saveActivity(activityType: .game, elapsedTime: elapsedTime - duration)
                } else {
                    addActivityToHistory(activityType: activityType, elapsedTime: elapsedTime)
                }
            } else {
                return
            }
            
        case .healing:
            if elapsedTime >= duration {
                currentPet.petStatus.health += 100/count
                currentPet.petStatus.health = min(currentPet.petStatus.health, 100)
                addActivityToHistory(activityType: activityType, elapsedTime: elapsedTime)
            } else {
                return
            }
            
        case .сleaning:
            if elapsedTime >= duration {
                currentPet.petStatus.cleaning += 100/count
                currentPet.petStatus.cleaning = min(currentPet.petStatus.cleaning, 100)
                addActivityToHistory(activityType: activityType, elapsedTime: elapsedTime)
            } else {
                return
            }
            
        case .feeding:
            if elapsedTime >= duration {
                currentPet.petStatus.satiety += 100/count
                currentPet.petStatus.satiety = min(currentPet.petStatus.satiety, 100)
                addActivityToHistory(activityType: activityType, elapsedTime: elapsedTime)
            } else {
                return
            }
        }
    }
    
    func getPetActivityHistory(type: ActivityType) -> [ActivityHistoryItem] {
        return currentPet.activityHistory.filter { $0.activityType == type }
    }
    
    func getPercentage(of activity: ActivityType, for pet: Pet) -> Int {
        let res: Double = pet.petStatus.value(for: activity)
        return min(Int(res.rounded()), 100)
    }
    
    func getOverallPercentage(for pet: Pet) -> Int {
        var res: Double = 0
        var count: Double = 0
        for type in ActivityType.allCases {
            if pet.animalType.getActivitiesFrequency(of: type).count > 0 {
                res += Double(getPercentage(of: type, for: pet))
                count += 1
            }
        }
        res = res/count
        return min(Int(res.rounded()), 100)
    }
    
    func calculateWillingnessPercentage(for pet: Pet) -> Int {
        let activityTypes = pet.schedule.keys
        let totalActivities = activityTypes.count
        
        if totalActivities == 0 {
            return 100
        }
        
        let petCreationDate = pet.date
        
        let currentDate = Date()
        let calendar = Calendar.current
        let startOfPetCreationDay = calendar.startOfDay(for: petCreationDate)
        let startOfCurrentDay = calendar.startOfDay(for: currentDate)
        let daysSincePetCreation = calendar.dateComponents([.day], from: startOfPetCreationDay, to: startOfCurrentDay).day ?? 0
        
        var expectedActivityCount = 0
        var completedActivities = 0
        var totalTimeSpentOnGames = 0.0
        
        for activityType in activityTypes {
            let frequency = pet.animalType.getActivitiesFrequency(of: activityType)
            let historyItems = getPetActivityHistory(type: activityType).filter { calendar.isDate($0.date, inSameDayAs: currentDate) == false }
            
            if activityType == .game {
                for historyItem in historyItems {
                    totalTimeSpentOnGames += historyItem.duration
                }
            } else {
                let completedActivitiesForType = historyItems.count
                
                if frequency.unit == .day {
                    expectedActivityCount += frequency.count * daysSincePetCreation
                    completedActivities += min(completedActivitiesForType, frequency.count * daysSincePetCreation)
                }
            }
        }
        
        let requiredTimeForGames = Double(pet.animalType.getActivitiesFrequency(of: .game).count) * Double(daysSincePetCreation)
        if requiredTimeForGames != 0 {
            let gameCompletionRatio: Double = (totalTimeSpentOnGames / requiredTimeForGames) / pet.animalType.getDuration(of: .game)
            completedActivities += Int(gameCompletionRatio * requiredTimeForGames)
            expectedActivityCount += Int(requiredTimeForGames)
        }
        
        if expectedActivityCount == 0 {
            return getOverallPercentage(for: pet)
        }
        
        let percentage = ((Double(completedActivities) / Double(expectedActivityCount)) * 100 + Double(getOverallPercentage(for: pet)) * 0.4)/140*100
        return min(Int(percentage.rounded()), 100)
    }
    
    func updatePetStatusesOnAppLaunch() {
        let calendar = Calendar.current
        let now = Date()
        let lastAppLaunch = UserDefaults.standard.object(forKey: "lastAppLaunch") as? Date ?? now
        UserDefaults.standard.set(now, forKey: "lastAppLaunch")
        var deathNums: [Int] = []
        
        for index in 0..<pets.count {
            let animalType = pets[index].animalType
            
            for (activity, schedule) in pets[index].schedule {
                let (frequencyCount, frequencyUnit) = animalType.getActivitiesFrequency(of: activity)
                let decrementValue = (100.0 / Double(frequencyCount))
                
                for scheduledTime in schedule {
                    let scheduledHour = calendar.component(.hour, from: scheduledTime)
                    let scheduledMinute = calendar.component(.minute, from: scheduledTime)
                    var currentScheduledDate: Date = scheduledTime
                    
                    if frequencyUnit == .day {
                         currentScheduledDate = calendar.date(bySettingHour: scheduledHour, minute: scheduledMinute, second: 0, of: lastAppLaunch)!
                    }
                   
                    while currentScheduledDate < now && currentScheduledDate > lastAppLaunch {
                        pets[index].petStatus.decrementValue(for: activity, by: decrementValue)
                        if frequencyUnit == .day {
                            currentScheduledDate = calendar.date(byAdding: .day, value: 1, to: currentScheduledDate)!
                        } else if frequencyUnit == .weekOfYear {
                            currentScheduledDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentScheduledDate)!
                        } else if frequencyUnit == .month {
                            currentScheduledDate = calendar.date(byAdding: .month, value: 1, to: currentScheduledDate)!
                        } else if frequencyUnit == .year {
                            currentScheduledDate = calendar.date(byAdding: .year, value: 1, to: currentScheduledDate)!
                        }
                    }
                }
                if pets[index].petStatus.realValue(for: activity) < -100 {
                    deathNums.append(index)
                    break
                }
            }
        }
        for index in deathNums {
            deadPets.append(pets[index])
        }
        for index in deathNums.sorted(by: >) {
            pets.remove(at: index)
        }
        updateAllPets()
    }
    
    func isCooldownOver(activityType: ActivityType) -> Bool {
        let currentDate = Date()
        let lastActivity = getPetActivityHistory(type: activityType).max { $0.date < $1.date }

        guard let lastActivityDate = lastActivity?.date else {
            return true
        }

        let cooldownDuration = currentPet.animalType.getCooldown(of: activityType)
        let calendar = Calendar.current

        let timeDifferenceComponents = calendar.dateComponents([.hour], from: lastActivityDate, to: currentDate)
        let timeDifferenceInHours = timeDifferenceComponents.hour ?? 0

        return timeDifferenceInHours >= cooldownDuration
    }
    
    func clearDeads() {
        deadPets.removeAll()
    }
    
    private func addActivityToHistory(activityType: ActivityType, elapsedTime: TimeInterval) {
        let newActivity = ActivityHistoryItem(date: Date(), duration: elapsedTime, activityType: activityType)
        
        currentPet.activityHistory.append(newActivity)
        updatePets()
    }
    
    private func updatePets() {
        if let index = pets.firstIndex(where: { $0.name == currentPet.name }) {
            pets[index] = currentPet
        }
                if let encodedData = try? JSONEncoder().encode(pets) {
                    UserDefaults.standard.set(encodedData, forKey: petsKey)
                }
    }
    
    private func updateAllPets() {
        if let index = pets.firstIndex(where: { $0.name == currentPet.name }) {
            currentPet.petStatus = pets[index].petStatus
        } else {
            if !pets.isEmpty {
                setCurrentPet(pets[0])
            }
        }
        if let encodedData = try? JSONEncoder().encode(pets) {
            UserDefaults.standard.set(encodedData, forKey: petsKey)
        }
    }
}
