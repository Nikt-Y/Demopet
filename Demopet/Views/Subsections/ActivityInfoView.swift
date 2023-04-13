//
//  ActivityInfoView.swift
//  Demopet
//
//  Created by Nik Y on 04.04.2023.
//

import SwiftUI
import Charts

struct ActivityInfoView: View {
    //dismiss, at, vm
    @Environment(\.dismiss) var dismiss
    @ObservedObject var petViewModel = PetViewModel.shared
    @State var activityType: ActivityType
    
    @State private var selectedWeek = 0
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
    @StateObject var viewModel = ActivityInfoViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                darkGrayRectangle
                
                NavigationLink(destination: ActivityView(activityType: activityType)) {
                    Text("Начать активность")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: ActivityHistoryListView(activityType: activityType)) {
                    Text("Посмотреть историю")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "2E2E2E"))
                        .cornerRadius(10)
                }
                
                BarGraph(example: viewModel.getActivityHistory(of: activityType, week: selectedWeek), domain: viewModel.getChartYScale(activityType: activityType))
                    .frame(height: 300)
                    .padding(.horizontal, -15)
                
                HStack {
                    Button(action: {
                        selectedWeek -= 1
                    }) {
                        Image(systemName: "arrow.left")
                    }.foregroundColor(.black)
                    
                    Text(viewModel.getWeekText(week: selectedWeek))
                    
                    Button(action: {
                        if selectedWeek < 0 {
                            selectedWeek += 1
                        }
                    }) {
                        Image(systemName: "arrow.right")
                    }.foregroundColor(.black)
                }
            }
            .padding()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color.white)
                        Text("Назад")
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
    
    var darkGrayRectangle: some View {
        HStack {
            VStack {
                CircularProgressBar(activityType: activityType)
                    .frame(width: 100, height: 100)
                Text(activityType.title()).foregroundColor(.white).padding(.vertical,5)
            }
            .padding(.leading, 20)
            .padding(.vertical, 20)
            
            LineGraph(example: viewModel.getActivityHistory(of: activityType, week: selectedWeek), domain: viewModel.getChartYScale(activityType: activityType))
                .padding()
        }
        .background(Color(hex: "2E2E2E"))
        .cornerRadius(20)
    }
    
    func CircularProgressBar(activityType: ActivityType) -> some View {
        var percentage = petViewModel.getPercentage(of: activityType, for: petViewModel.currentPet)
        return ZStack {
            Circle()
                .stroke(Color.white, lineWidth: 10)
            
            Circle()
                .trim(from: 0, to: CGFloat(Double(percentage)/100))
                .stroke(Color.red, lineWidth: 10)
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: percentage)
            
            VStack {
                Image(activityType.iconName())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
                
                Text("\(percentage)%")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
            }
        }
    }
}

struct LineGraph: View {
    var example: [ActivityHistoryItem]
    var domain: ClosedRange<Int>
    
    var body: some View {
        Chart {
            ForEach(example) { w in
                LineMark(
                    x: .value("Day", w.date, unit: .day),
                    y: .value("Mins", w.duration))
                .lineStyle(.init(lineWidth: 3, lineCap: .round, lineJoin: .round))
            }
            .interpolationMethod(.cardinal)
        }
        .chartYAxis(.hidden)
        .foregroundColor(.red)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 7)) { _ in
                AxisGridLine(
                    stroke: StrokeStyle(lineWidth: 3)
                )
                .foregroundStyle(.white)
                
                AxisValueLabel(format: .dateTime.day(), centered: true)
                    .foregroundStyle(.white)
                    .font(.system(size: 14))
            }
        }
        .chartYScale(domain: domain)
    }
}

struct BarGraph: View {
    let calendar = Calendar.current
    var example: [ActivityHistoryItem]
    var domain: ClosedRange<Int>
    
    var body: some View {
        Chart {
            ForEach(example) { w in
                BarMark(
                    x: .value("Day", w.date, unit: .day),
                    y: .value("Mins", w.duration),
                    width: 7
                )
                .cornerRadius(20)
                .foregroundStyle(calendar.component(.day, from: w.date) == calendar.component(.day, from: Date()) ? Color.red : Color.blue)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 7)) { _ in
                AxisValueLabel(format: .dateTime.weekday(), centered: true)
                    .foregroundStyle(Color.black)
                    .font(.system(size: 15))
            }
        }
        .chartYScale(domain: domain)
        .chartYAxis {
            AxisMarks(values: .automatic) { _ in
                AxisGridLine()
                    
            }
        }
    }
}

struct ActivityInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityInfoView(activityType: .feeding)
    }
}
