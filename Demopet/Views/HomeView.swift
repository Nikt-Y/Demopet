//
//  HomeView.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var petViewModel = PetViewModel.shared
    
    struct DialogCloudView: View {
        var text: String
        
        var body: some View {
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
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView() {
                DialogCloudView(text: "ПОКОРМИ МЕНЯ")
                Image(petViewModel.currentPet.animalType.bigIconName)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 20)
            }
            .padding()
            .padding(.top, 200)
            CustomDropDown()
                .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(PetViewModel())
    }
}
