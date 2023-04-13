//
//  AddPetView.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import SwiftUI

struct AddPetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var petViewModel = PetViewModel.shared
    @State var step: Int
    @StateObject var viewModel = AddPetViewModel()
    
    var body: some View {
        ZStack {
            Color(hex: "2e2e2e")
                .edgesIgnoringSafeArea(.all)
            
            
            ScrollView {
                Text("DEMOPET")
                    .font(.title)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .background(.red)
                    .cornerRadius(25)
                    .padding(.bottom, 40)
                
                if step == 0 {
                    CustomAlertView(
                        title: "Давайте создадим нового питомца!",
                        message: "",
                        primaryButtonTitle: "НАЧАТЬ",
                        primaryButtonAction: {
                            step = 1
                        },
                        secondaryButtonTitle: "",
                        secondaryButtonAction: {}
                    )
                    .padding()
                    .padding(.top, 140)
                }
                
                if step == 1 {
                    createNewPetView()
                }
                
                if step == 2 {
                    editTimeView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear() {
                if step > 1 {
                    viewModel.fillCurrentSchedule()
                }
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
    
    private func createNewPetView() -> some View {
        VStack {
            TextField("Кличка", text: $viewModel.name)
                .padding(9)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.bottom)
            
            HStack {
                Text("Вид животного:").padding(.trailing, 10)
                Spacer()
                Menu {
                    Picker("fsdf", selection: $viewModel.selectedPetType) {
                        ForEach(AnimalType.allCases) { type in
                            Text(type.title).tag(type)
                        }
                    }
                } label: {
                    
                    Text(viewModel.selectedPetType.title)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 40)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 1)
                }
            }.padding(.bottom)
            
            
            HStack {
                Text("Возраст:")
                Spacer()
                Stepper(value: $viewModel.petAge, in: 0.5...5, step: 0.5) {
                    Text("\(viewModel.petAge, specifier: "%.1f") years")
                }
                
            }.padding(.bottom)
            
            HStack {
                Text("Пол:")
                Spacer()
                Picker("Gender", selection: $viewModel.isMale) {
                    Text("Муж.").tag(true)
                    Text("Жен.").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                
            }.padding(.bottom)
            
            Button(action: {
                step = 2
                viewModel.saveNewPet()
            }) {
                Text("Продолжить")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(hex: "2e2e2e"))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(20)
        .padding()
    }
    
    private func editTimeView() -> some View {
        VStack {
            ForEach(ActivityType.allCases) { activity in
                if let frequency = viewModel.schedule[activity] {
                    Text("\(activity.title()) - расписание")
                    ForEach(frequency.indices, id: \.self) { index in
                        DatePicker("\(activity.title()) - время \(index+1)", selection: Binding(
                            get: { viewModel.schedule[activity]?[index] ?? Date() },
                            set: { newValue in
                                viewModel.schedule[activity]?[index] = newValue
                            }), displayedComponents: .hourAndMinute)
                    }
                    
                    HStack {
                        Button(action: {
                            viewModel.addTime(for: activity)
                        }) {
                            Text("Добавить время")
                                .padding(.vertical,5)
                                .padding(.horizontal)
                                .background(Color(hex: "2e2e2e"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        Spacer()
                        if viewModel.selectedPetType.getActivitiesFrequency(of: activity).count < frequency.count {
                            Button(action: {
                                viewModel.deleteTime(for: activity)
                            }) {
                                Text("Удалить время")
                                    .padding(.vertical,5)
                                    .padding(.horizontal)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            Button(action: {
                viewModel.saveNewSchedule()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Сохранить")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(hex: "2e2e2e"))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(20)
        .padding()
    }
}

struct AddPetView_Previews: PreviewProvider {
    static var previews: some View {
        AddPetView(step: 0)
    }
}
