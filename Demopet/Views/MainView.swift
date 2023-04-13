//
//  MainView.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import SwiftUI

struct CustomTabView: View {
    @Namespace private var animation
    
    @State private var selection = 0
    @State private var previousSelection = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if selection == 0 {
                    HomeView()
                        .transition(.move(edge: .leading).combined(with: .opacity))
                        
                } else if selection == 1 {
                    StatusView()
                        .transition(.move(edge: previousSelection > 1 ? .leading : .trailing).combined(with: .opacity))
                        
                } else {
                    ProfileView()
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
                Spacer()
            }
            
            HStack {
                Button(action: {
                    previousSelection = 0
                    withAnimation(.easeInOut) {
                        selection = 0
                    }
                }) {
                    VStack {
                        Image("home")
                    }
                    .foregroundColor(selection == 0 ? tabAccentColor() : Color(hex: "2e2e2e"))
                }
                .padding(.leading, 30)
                Spacer()
                
                Button(action: {
                    previousSelection = selection
                    withAnimation(.easeInOut) {
                        selection = 1
                    }
                }) {
                    VStack {
                        Image("status")
                    }
                    .foregroundColor(selection == 1 ? tabAccentColor() : Color(hex: "2e2e2e"))
                }
                Spacer()
                
                Button(action: {
                    previousSelection = 2
                    withAnimation(.easeInOut) {
                        selection = 2
                    }
                }) {
                    VStack {
                        Image("profile")
                    }
                    .foregroundColor(selection == 2 ? tabAccentColor() : Color(hex: "2e2e2e"))
                }
                .padding(.trailing, 30)
            }
            .padding()
            .background(Color.white)
        }
    }
    
    func tabAccentColor() -> Color {
        switch selection {
        case 0:
            return Color(hex: "0000ff")
        case 1:
            return .red
        case 2:
            return Color(hex: "0000ff")
        default:
            return Color(hex: "0000ff")
        }
    }
}


struct MainView: View {
    @ObservedObject private var petViewModel = PetViewModel.shared
    @State var selection = 0
    @State var showAddPetView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if petViewModel.pets.count == 0 {
                    NavigationLink("", destination: AddPetView(step: 0), isActive: $showAddPetView)
                        .onAppear {
                            showAddPetView = true
                        }
                } else {
                    CustomTabView()
                }
                
                if !petViewModel.deadPets.isEmpty {
                    VStack {
                        Spacer()
                        CustomAlertView(
                            title: "Случилась беда!",
                            message: "К сожалению, за время вашего отсутствия от недостатка заботы скончались:\n\(petViewModel.deadPets.map { $0.name }.joined(separator: ", "))",
                            primaryButtonTitle: "F",
                            primaryButtonAction: {petViewModel.clearDeads()},
                            secondaryButtonTitle: "",
                            secondaryButtonAction: {}
                        )
                        Spacer()
                    }
                    .padding(.horizontal)
                    .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

