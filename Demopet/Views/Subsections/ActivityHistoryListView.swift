//
//  ActivityHistoryListView.swift
//  Demopet
//
//  Created by Nik Y on 03.04.2023.
//

import SwiftUI

struct ActivityHistoryListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var petViewModel = PetViewModel.shared
    let activityType: ActivityType
    
    var groupedHistory: [(String, [ActivityHistoryItem])] {
        let history = petViewModel.getPetActivityHistory(type: activityType)
        let grouped = Dictionary(grouping: history, by: { item in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            return formatter.string(from: item.date)
        })

        let sortedKeys = grouped.keys.sorted { key1, key2 in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            if let date1 = formatter.date(from: key1), let date2 = formatter.date(from: key2) {
                return date1 > date2
            }
            return false
        }

        return sortedKeys.map { key in
            (key, grouped[key]!)
        }
    }

    var body: some View {
        VStack() {
            
            Text(String(format: NSLocalizedString("history_of", comment: ""), activityType.title()))
                .font(.title)
                .bold()
                .padding(.top)

            ScrollView {
                LazyVStack {
                    ForEach(groupedHistory, id: \.0) { month, historyItems in
                        Section(header: Text(month).font(.title2).bold().padding(.top)) {
                            ForEach(historyItems.sorted(by: { $0.date > $1.date })) { activityHistory in
                                ActivityHistoryRowView(activityHistory: activityHistory)
                                    .padding(.bottom, 5)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color.white)
                        Text("back")
                            .foregroundColor(Color.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(hex: "2e2e2e"))
                    .cornerRadius(10)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ActivityHistoryRowView: View {
    let activityHistory: ActivityHistoryItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activityHistory.date, style: .date)
                    .font(.headline)
                Text(String(format: NSLocalizedString("min", comment: ""), activityHistory.duration / 60))
                    .font(.subheadline)
            }.foregroundColor(.white)
            Spacer()
            Image(activityHistory.activityType.iconName())
                .resizable()
                .scaledToFit()
                .frame(width: 35)
                .foregroundColor(.white)
                
        }
        .padding()
        .background(Color(hex: "2e2e2e"))
        .cornerRadius(20)
    }
}

struct ActivityHistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityHistoryListView(activityType: .walk)
    }
}
