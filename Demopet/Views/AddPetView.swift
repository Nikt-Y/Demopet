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
    @State public var validationError: String? = nil
    
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
                        title: NSLocalizedString("lets_create", comment: ""),
                        message: "",
                        primaryButtonTitle: NSLocalizedString("start", comment: ""),
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
                        title: NSLocalizedString("trouble_has_happened", comment: ""),
                        message: String(format: NSLocalizedString("deads", comment: ""), petViewModel.deadPets.map { $0.name }.joined(separator: ", ")),
                        primaryButtonTitle: NSLocalizedString("get_better", comment: ""),
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
            TextField(NSLocalizedString("name", comment: ""), text: $viewModel.name)
                .onChange(of: viewModel.name) { _ in
                    withAnimation {
                        validationError = viewModel.validateName()
                    }
                }
                .autocorrectionDisabled(true)
                .padding(9)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.bottom)
                .onAppear(){
                    validationError = viewModel.validateName()
                }
            HStack {
                if let error = validationError {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.bottom)
                }
                
                Spacer()
            }
            
            HStack {
                Text("type").padding(.trailing, 10)
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
                Text("age")
                Spacer()
                Stepper(value: $viewModel.petAge, in: 0.5...5, step: 0.5) {
                    Text(String(format: NSLocalizedString("age_count", comment: ""), viewModel.petAge))
                }
                
            }.padding(.bottom)
            
            HStack {
                Text("gender")
                Spacer()
                Picker("Gender", selection: $viewModel.isMale) {
                    Text("male").tag(true)
                    Text("female").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                
            }.padding(.bottom)
            
            Button(action: {
                guard validationError == nil else {return}
                step = 2
                viewModel.saveNewPet()
            }) {
                Text("continue")
                    .foregroundColor(.white)
                    .padding()
                    .background(validationError == nil ? Color(hex: "2e2e2e") : Color.gray)
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
            Text("choose_time")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            ForEach(ActivityType.allCases) { activity in
                if petViewModel.currentPet.animalType.getActivitiesFrequency(of: activity).unit == .day {
                    if let frequency = viewModel.schedule[activity] {
                        Text(String(format: NSLocalizedString("schedule_of", comment: ""), activity.title()))
                        ForEach(frequency.indices, id: \.self) { index in
                            let range = viewModel.getDatePickerRange(index: index, totalCount: frequency.count)
                            let defaultDate = range.lowerBound
                            let rangeText = viewModel.formatRangeAsString(range)
                            DatePicker(String(format: NSLocalizedString("time_num_of", comment: ""), activity.title(), index+1, rangeText),
                                       selection: Binding(
                                get: { viewModel.schedule[activity]?[index] ?? defaultDate },
                                set: { newValue in
                                    viewModel.schedule[activity]?[index] = newValue
                                }), in: range, displayedComponents: .hourAndMinute)
                        }
                        HStack {
                            Button(action: {
                                viewModel.addTime(for: activity)
                            }) {
                                Text("add_time")
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
                                    Text("delete_time")
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
            }
            Button(action: {
                viewModel.saveNewSchedule()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("save")
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
        AddPetView(step: 2)
    }
}
