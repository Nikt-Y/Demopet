//
//  StatusView.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import SwiftUI

struct StatusView: View {
    @ObservedObject var petViewModel: PetViewModel = PetViewModel.shared
    @State var showAllert = false
    
    fileprivate func StatusItem(activityType: ActivityType) -> some View {
        VStack {
            CircularProgressBar(activityType: activityType)
                .padding(.horizontal, 25)
                .padding(.top, 4)
            Text(activityType.title()).foregroundColor(.white).padding(.vertical,5)
            NavigationLink(destination: ActivityInfoView(activityType: activityType)) {
                Text("open")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                    .foregroundColor(Color.black)
            }
            .background(Color.white)
            .cornerRadius(25)
            
        }
        .frame(width: 150, height: 206)
        .background(Color(hex: "2E2E2E"))
        .cornerRadius(20)
        .padding(6)
    }
    
    func CircularProgressBar(activityType: ActivityType) -> some View {
        let percentage = petViewModel.getPercentage(of: activityType, for: petViewModel.currentPet)
        return ZStack {
            Circle()
                .stroke(Color.white, lineWidth: 10)
            
            Circle()
                .trim(from: 0, to: CGFloat(Double(percentage)/100))
                .stroke(Color.red, lineWidth: 10)
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: percentage)
            
            VStack {
                Image(activityType.iconName())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
                
                Text("\(percentage)%")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
            }
        }
    }
    
    let items = 1...4
    let columns: Int = 2
    let spacing: CGFloat = 10
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                ScrollView {
                    let gridColumns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns)
                    LazyVGrid(columns: gridColumns, spacing: spacing) {
                        ForEach(ActivityType.allCases, id: \.self) { type in
                            if petViewModel.currentPet.animalType.getActivitiesFrequency(of: type).count > 0 {
                                StatusItem(activityType: type)
                            }
                        }
                    }
                }
                .padding(.bottom, 60)
            }
            .padding(.top, 100)
            CustomDropDown()
                .padding()
            
            if showAllert {
                VStack {
                    Spacer()
                    CustomAlertView(
                        title: NSLocalizedString("tutorial_title", comment: ""),
                        message: NSLocalizedString("status_tutorial", comment: ""),
                        primaryButtonTitle: NSLocalizedString("okey", comment: ""),
                        primaryButtonAction: {
                            showAllert = false
                            PetViewModel.shared.isStatusFirstLaunch(set: false)
                        },
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
            showAllert = PetViewModel.shared.isStatusFirstLaunch()
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView().environmentObject(PetViewModel())
    }
}

//NavigationLink(destination: ActivityInfoView(activityType: .feeding)) {
//                            Text("Satiety")
//                        }
//                        NavigationLink(destination: ActivityInfoView(activityType: .healing)) {
//                            Text("Health")
//                        }
//
//                        if pet.animalType.getCount(of: .walk) > 0  {
//                            NavigationLink(destination: ActivityInfoView(activityType: .walk)) {
//                                Text("Walks")
//                            }
//                        }
//                        if pet.animalType.getCount(of: .game) > 0  {
//                            NavigationLink(destination: ActivityInfoView(activityType: .game)) {
//                                Text("Games")
//                            }
//                        }
