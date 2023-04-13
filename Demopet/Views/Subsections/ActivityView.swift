//
//  ActivityView.swift
//  Demopet
//
//  Created by Nik Y on 04.04.2023.
//

import SwiftUI

struct ActivityView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var petViewModel: PetViewModel = PetViewModel.shared
    var activityType: ActivityType
    
    @State private var elapsedTime: TimeInterval = 0
    @State private var isRunning: Bool = true
    @State private var timer: Timer? = nil
    @State var duration: TimeInterval = 0
    @State private var showAlert = false
    @State private var alertConfig: (title: String, message: String, primaryTitle: String,  primaryAction: () -> Void, secondaryTitle: String, secondaryAction: () -> Void)?
    @State var overTime: Bool = false
    
    fileprivate func CircularProgressBar() -> some View {
        ZStack {
            Circle()
                .stroke(Color.white, lineWidth: 20)
            
            Circle()
                .trim(from: 0, to: CGFloat(elapsedTime / duration))
                .stroke(Color.red, lineWidth: 20)
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: elapsedTime)
            
            VStack {
                Text(activityType.title())
                    .font(.title)
                    .foregroundColor(.white)
                
                Text(timeString())
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "2E2E2E")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                CircularProgressBar()
                    .padding(50)
                
                Spacer()
                
                Button(action: {
                    if isRunning {
                        startTimer()
                    } else {
                        stopTimer()
                    }
                }) {
                    Image(systemName: isRunning ? "play.fill" : "stop.fill")
                        .foregroundColor(Color(hex: "2E2E2E"))
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .padding(.bottom)
                
                Button(action: {
                    saveTap()
                }) {
                    Text("Сохранить")
                        .foregroundColor(Color(hex: "2E2E2E"))
                        .padding(.horizontal, 50)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.bottom)
            }
            
            if showAlert {
                VStack {
                    Spacer()
                    CustomAlertView(
                        title: alertConfig?.title ?? "",
                        message: alertConfig?.message ?? "",
                        primaryButtonTitle: alertConfig?.primaryTitle ?? "",
                        primaryButtonAction: alertConfig?.primaryAction ?? {},
                        secondaryButtonTitle: alertConfig?.secondaryTitle ?? "",
                        secondaryButtonAction: alertConfig?.secondaryAction ?? {}
                    )
                    Spacer()
                }
                .padding(.horizontal)
                .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    saveTap()
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color.black)
                        Text("Back")
                            .foregroundColor(Color.black)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(){
            duration = petViewModel.currentPet.animalType.getDuration(of: activityType)
            //            startTimer()
            updateAlertConfig(title: "АКТИВНОСТЬ ЕЩЕ НЕ ВЫПОЛНЕНА!", message: "Активность еще не выполнена, результат не будет засчитан!", primaryTitle: "ВЫЙТИ", primaryAction: {dismiss()}, secondaryTitle: "ОТМЕНА", secondaryAction: {showAlert = false})
        }
    }
    
    private func timeString() -> String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    private func startTimer() {
        guard overTime || elapsedTime < duration else {return}
        isRunning.toggle()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
            if !overTime && elapsedTime >= duration {
                stopTimer()
                if activityType == .walk {
                    updateAlertConfig(
                        title: "ПРОГУЛКА ВЫПОЛНЕНА",
                        message: "Вы можете завершить прогулку и сохранить результат, либо же продолжить прогулку. Дополнительное время пойдет в зачет игр!",
                        primaryTitle: "ЗАВЕРШИТЬ",
                        primaryAction: {
                            petViewModel.saveActivity(activityType: activityType, elapsedTime: elapsedTime)
                            dismiss()
                        },
                        secondaryTitle: "ПРОДОЛЖИТЬ",
                        secondaryAction: {
                            overTime = true
                            petViewModel.saveActivity(activityType: activityType, elapsedTime: elapsedTime)
                            dismiss()
                        })
                } else {
                    updateAlertConfig(
                        title: "АКТИВНОСТЬ ВЫПОЛНЕНА",
                        message: "Вы очень заботливый хозяин!",
                        primaryTitle: "СОХРАНИТЬ И ВЫЙТИ",
                        primaryAction: {
                            petViewModel.saveActivity(activityType: activityType, elapsedTime: elapsedTime)
                            dismiss()
                        },
                        secondaryTitle: "",
                        secondaryAction: {
                            petViewModel.saveActivity(activityType: activityType, elapsedTime: elapsedTime)
                            dismiss()
                        })
                }
                showAlert = true
            }
        }
    }
    
    private func stopTimer() {
        isRunning.toggle()
        timer?.invalidate()
        timer = nil
    }
    
    private func updateAlertConfig(title: String, message: String, primaryTitle: String, primaryAction: @escaping () -> Void, secondaryTitle: String, secondaryAction: @escaping () -> Void) {
        alertConfig = (title: title,
                       message: message,
                       primaryTitle: primaryTitle,
                       primaryAction: primaryAction,
                       secondaryTitle: secondaryTitle,
                       secondaryAction: secondaryAction)
    }
    
    private func saveTap() {
        if elapsedTime < duration {
            showAlert = true
            return
        }
        petViewModel.saveActivity(activityType: activityType, elapsedTime: elapsedTime)
        dismiss()
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(activityType: .feeding).environmentObject(PetViewModel())
    }
}

