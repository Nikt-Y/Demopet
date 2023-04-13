import SwiftUI

struct CustomTimePicker: View {
    @State private var selectedHour = 0
    @State private var selectedMinute = 0

    let hours = Array(0...23)
    let minutes = Array(0...59)

    var body: some View {
        HStack {
            Picker("Hour", selection: $selectedHour) {
                ForEach(hours, id: \.self) { hour in
                    Text("\(hour)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .frame(width: 100, alignment: .center)
            .clipped()

            Text(":")

            Picker("Minute", selection: $selectedMinute) {
                ForEach(minutes, id: \.self) { minute in
                    Text("\(minute)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .frame(width: 100, alignment: .center)
            .clipped()
        }
    }
}

struct CustomTimePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomTimePicker()
    }
}
