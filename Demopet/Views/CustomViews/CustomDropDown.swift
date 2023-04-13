//
//  CustomDropDown.swift
//  Demopet
//
//  Created by Nik Y on 10.04.2023.
//

import SwiftUI

struct CustomDropDown: View {
    @ObservedObject var petViewModel = PetViewModel.shared
    @State private var showDropDown = false
    @State var showAddPetView = false
    
    var body: some View {
            VStack {
                Button(action: {
                    withAnimation(.easeIn(duration: 0.3)) {
                        showDropDown.toggle()
                    }
                }, label: {
                    HStack {
                        Image(petViewModel.currentPet.animalType.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                        Text(petViewModel.currentPet.name)
                        Spacer()
                        Text("\(petViewModel.getOverallPercentage(for: petViewModel.currentPet))%")
                        Image(systemName: "arrowtriangle.down.fill")
                            .resizable()
                            .frame(width: 15, height: 10)
                            .rotationEffect(showDropDown ? Angle(degrees: 180) : Angle(degrees: 0))
                    }
                    .foregroundColor(.white)
                    .padding()
                })
                if showDropDown {
                    ForEach(petViewModel.pets.indices) { index in
                        let pet = petViewModel.pets[index]
                        if pet.name != petViewModel.currentPet.name {
                            Button(action: {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    petViewModel.setCurrentPet(pet)
                                    showDropDown = false
                                }
                            }, label: {
                                HStack {
                                    Image( petViewModel.currentPet.animalType.iconName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                    Text(pet.name)
                                    Spacer()
                                    Text("\(petViewModel.getOverallPercentage(for: pet))%")
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.bottom)
                            })
                        }
                    }
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddPetView(step: 0).onAppear{showDropDown = false}) {
                            Text("Add new pet")
                                .foregroundColor(.white)
                                .padding(.vertical, 4)
                                .padding(.horizontal)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .background(Color(hex: "2E2E2E"))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black, lineWidth: 5)
            )
            .cornerRadius(25)
    }
}

struct CustomDropDown_Previews: PreviewProvider {
    static var previews: some View {
        CustomDropDown()
    }
}
