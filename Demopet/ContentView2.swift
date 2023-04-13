//
//  ContentView.swift
//  Demopet
//
//  Created by Nik Y on 02.04.2023.
//

import SwiftUI
import AVFoundation

class PlayerViewModel: ObservableObject {
    @Published public var maxDuration = 0.0
    private var player: AVAudioPlayer?
    
    public func play() {
        playSong(name: "song")
        player?.play()
    }
    
    public func stop() {
        player?.stop()
    }
    
    public func setTime(value: Float) {
        guard let time = TimeInterval(exactly: value) else {return}
        player?.currentTime = time
        player?.play()
    }
    
    private func playSong(name: String) {
        guard let audioPath = Bundle.main.path(forResource: name, ofType: "mp3") else {return}
        do {
            try player = AVAudioPlayer(contentsOf: URL(filePath: audioPath))
            maxDuration = player?.duration ?? 0.0
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView2: View {
    @State private var progress: Float = 0
    @ObservedObject var viewModel = PlayerViewModel()
    
    var body: some View {
        VStack {
//            Slider(value: $progress, in: 0...100).padding().tint(Color.pink)
            
            Slider(value: Binding(get: {Double(self.progress)}, set: {newValue in
                self.progress = Float(newValue)
                self.viewModel.setTime(value: Float(newValue))
            }), in: 0...viewModel.maxDuration).padding().tint(Color.pink)
            
            HStack {
                Button("Play", action: {self.viewModel.play()})
                    .frame(width: 100, height: 50)
                    .background(Color.pink)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                
                Button("Stop", action: {self.viewModel.stop()})
                    .frame(width: 100, height: 50)
                    .background(Color.pink)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
