//
//  ProfileView.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var petViewModel: PetViewModel = PetViewModel.shared
    @State private var isEditingSchedule = false
    @State private var willingness: Int = 0
    @State var showAllert = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack() {
                HStack(alignment: .bottom) {
                    Text("your_willingness")
                        .font(.title2)
                        .bold()
                        Spacer()
                    VStack {
                        Text("\(petViewModel.calculateWillingnessPercentage(for: petViewModel.currentPet))%")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(petViewModel.calculateWillingnessPercentage(for: petViewModel.currentPet) > 80 ? .green : .red)
                    }
                }
                
                HStack {
                    Text("schedule")
                        .font(.title2)
                        .bold()
                    Spacer()
                    NavigationLink(destination: AddPetView(step: 2)) {
                        Text("edit_schedule")
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                
                
                ScrollView {
                    LazyVStack {
                        ForEach(Array(petViewModel.currentPet.schedule.keys).sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { activity in
                            ActivityScheduleRowView(activity: activity, schedule: petViewModel.currentPet.schedule[activity]!)
                                .padding(.bottom, 5)
                        }
                    }
                }
            }
            .padding()
            .padding(.top, 70)
            
            CustomDropDown()
                .padding()
            
            if showAllert {
                VStack {
                    Spacer()
                    CustomAlertView(
                        title: NSLocalizedString("tutorial_title", comment: ""),
                        message: NSLocalizedString("profile_tutorial", comment: ""),
                        primaryButtonTitle: NSLocalizedString("okey", comment: ""),
                        primaryButtonAction: {showAllert = false},
                        secondaryButtonTitle: "",
                        secondaryButtonAction: {}
                    )
                    Spacer()
                }
                .padding(.horizontal)
                .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
            }
        }
        .onAppear() {
            PetViewModel.shared.updatePetStatusesOnAppLaunch()
            showAllert = PetViewModel.shared.isProfileFirstLaunch()
        }
    }
}

struct ActivityScheduleRowView: View {
    @ObservedObject var petViewModel: PetViewModel = PetViewModel.shared
    let activity: ActivityType
    let schedule: [Date]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity.title())
                    .font(.headline)
                Text(scheduleText)
                    .font(.subheadline)
            }.foregroundColor(.white)
            Spacer()
            Image(activity.iconName())
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color(hex: "2e2e2e"))
        .cornerRadius(20)
    }
    
    var scheduleText: String {
        if petViewModel.currentPet.animalType.getActivitiesFrequency(of: activity).unit == .day {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return schedule.map { formatter.string(from: $0) }.joined(separator: "\n")
        } else {
            return NSLocalizedString("random_event", comment: "")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
