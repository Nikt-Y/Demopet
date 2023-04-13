//
//  HomeView.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var petViewModel = PetViewModel.shared
    @State var text: String? = nil
    @State var showAllert = false
    
    struct DialogCloudView: View {
        var text: String
        var activityType: ActivityType
        
        var body: some View {
            NavigationLink(destination: ActivityView(activityType: activityType), label: {
                HStack() {
                    Text(text)
                        .font(.system(size: 18))
                        .foregroundColor(Color.black)
                        .padding(.vertical)
                        .padding(.bottom)
                        .padding(.horizontal, 30)
                        .background(Image("cloud").resizable())
                    Spacer()
                }
            })
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView() {
                if let dialogInfo = getDialogText() {
                    DialogCloudView(text: dialogInfo.text, activityType: dialogInfo.activity)
                }
                Image(petViewModel.currentPet.animalType.bigIconName)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 20)
            }
            .padding()
            .padding(.top, 200)
            CustomDropDown()
                .padding()
            
            if showAllert {
                VStack {
                    Spacer()
                    CustomAlertView(
                        title: NSLocalizedString("tutorial_title", comment: ""),
                        message: NSLocalizedString("home_tutorial", comment: ""),
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
            showAllert = PetViewModel.shared.isHomeFirstLaunch()
        }
    }
    
    func getDialogText() -> (text: String, activity: ActivityType)? {
        let status = petViewModel.currentPet.petStatus
        let activities: [(activity: ActivityType, value: Double)] = [
            (.feeding, status.satiety),
            (.walk, status.walks),
            (.game, status.games),
            (.healing, status.health)
        ]
        
        let minActivity = activities.min { $0.value < $1.value }
        
        if let minValue = minActivity?.value, minValue < 100 {
            guard let activityType = minActivity?.activity else {
                return nil
            }
            
            if petViewModel.isCooldownOver(activityType: activityType) {
                switch activityType {
                case .feeding:
                    return (NSLocalizedString("hungry", comment: ""), activityType)
                case .walk:
                    return (NSLocalizedString("for_a_walk", comment: ""), activityType)
                case .game:
                    return (NSLocalizedString("i_want_play", comment: ""), activityType)
                case .healing:
                    return (NSLocalizedString("need_healing", comment: ""), activityType)
                case .сleaning:
                    return (NSLocalizedString("need_cleaning", comment: ""), activityType)
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(PetViewModel())
    }
}
