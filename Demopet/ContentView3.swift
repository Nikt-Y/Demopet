//
//  ContentView3.swift
//  Demopet
//
//  Created by Nik Y on 04.04.2023.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userBuy: UserBuy
    
    var text: String
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Buy \(text) \(userBuy.caps)")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("In menu") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    Button("-") {
                        guard self.userBuy.caps > 0 else { return}
                        self.userBuy.caps -= 1
                    }
                    
                    Button("+") {
                        self.userBuy.caps += 1
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            self.userBuy.caps = 0
        }
    }
}

class UserBuy: ObservableObject {
    @Published var caps = 0
}

struct ContentView3: View {
    @ObservedObject var userBuy = UserBuy()
    
    let coffee = "Coffee"
    let tea = "Tea"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("You choose = \(userBuy.caps)")
                Text("What want?")
                
                NavigationLink(destination: DetailView(text: coffee), label: {Text(coffee)})
                
                NavigationLink(destination: DetailView(text: tea), label: {Text(tea)})
            }
            .navigationTitle("Menu")
        }
        .environmentObject(userBuy)
    }
}

struct ContentView3_Previews: PreviewProvider {
    static var previews: some View {
        ContentView3()
    }
}

//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
//                    // Go to home
//                }) {
//                    Image(systemName: petViewModel.currentPet?.animalType.iconName ?? "house.fill")
//                        .foregroundColor(Color.black)
//                        .padding()
//                        .background(Color.white)
//                        .clipShape(Circle())
//                }
//            }
