//
//  CustomAlertView.swift
//  Demopet
//
//  Created by Nik Y on 09.04.2023.
//

import SwiftUI

struct CustomAlertView: View {
    var title: String
    var message: String
    var primaryButtonTitle: String
    var primaryButtonAction: () -> Void
    var secondaryButtonTitle: String
    var secondaryButtonAction: () -> Void
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .padding(.bottom, 2)
                .multilineTextAlignment(.center)
            
            Text(message)
                .multilineTextAlignment(.center)
            
            Button(action: primaryButtonAction) {
                Text(primaryButtonTitle)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(secondaryButtonTitle.isEmpty ? Color(.blue) : Color.red)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 10)
            
            if !secondaryButtonTitle.isEmpty {
                Button(action: secondaryButtonAction) {
                    Text(secondaryButtonTitle)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hex: "2E2E2E"))
                        .cornerRadius(25)
                }
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(25)
        .shadow(radius: 10)
    }
}
