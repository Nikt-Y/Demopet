//
//  EditTimeView.swift
//  Demopet
//
//  Created by Nik Y on 10.04.2023.
//

//import SwiftUI
//
//struct EditTimeView: View {
//    @ObservedObject var petViewModel: PetViewModel = PetViewModel()
//    
//    var body: some View {
//        VStack {
//            ForEach(ActivityType.allCases) { activity in
//                if let frequency = pet.schedule[activity] {
//                    Text("\(activity.title()) Times")
//                    ForEach(frequency.indices, id: \.self) { index in
//                        DatePicker("\(activity.title()) Time \(index+1)", selection: Binding(
//                            get: { pet.schedule[activity]?[index] ?? Date() },
//                            set: { newValue in
//                                pet.schedule[activity]?[index] = newValue
//                            }), displayedComponents: .hourAndMinute)
//                    }
//                    
//                    HStack {
//                        Button(action: {
//                            pet.addTime(for: activity)
//                            self.t+=1
//                        }) {
//                            Text("Add Time")
//                                .padding(.vertical,5)
//                                .padding(.horizontal)
//                                .background(Color(hex: "2e2e2e"))
//                                .foregroundColor(.white)
//                                .cornerRadius(8)
//                        }
//                        Spacer()
//                        if pet.selectedPetType.getActivitiesFrequency(of: activity).count < frequency.count {
//                            Button(action: {
//                                pet.deleteTime(for: activity)
//                            }) {
//                                Text("Delete Time")
//                                    .padding(.vertical,5)
//                                    .padding(.horizontal)
//                                    .background(Color.red)
//                                    .foregroundColor(.white)
//                                    .cornerRadius(8)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        .padding()
//        .background(.white)
//        .cornerRadius(20)
//        .padding()
//    }
//}
//
//struct EditTimeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTimeView(pet: Pet.example)
//    }
//}
