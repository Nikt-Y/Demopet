//
//  ContentView.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import SwiftUI

struct ContentView: View {
    @State var section = 0
    var settingsTime = ["5 min", "10 min", "15 min"]
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    Picker(selection: $section, label: Text("Время")) {
                        ForEach(0..<settingsTime.count) {
                            Text(self.settingsTime[$0])
                        }
                    }
                }
            }.navigationTitle("Настройки")
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
