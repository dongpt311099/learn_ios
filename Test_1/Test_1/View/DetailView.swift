import SwiftUI
import AVFoundation

struct DetailView: View {
    
    @StateObject private var viewModel = DetailViewModel()
    @StateObject private var viewModelList = HomeViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var isLongPressing = false
    @State private var vibrationTimer: Timer?
    @State private var audioPlayer: AVAudioPlayer?
    
    let sound: Sound
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ZStack {
                    Image("background_home")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image("ic_back")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            
                            Spacer()
                            
                            Text(sound.name.uppercased())
                                .foregroundColor(.white)
                                .font(.custom("Digitalt", size: 22))
                                .lineLimit(1)
                                .layoutPriority(1)
                            
                            Spacer()
                            
                            Image("ic_heart_full")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .padding(.top, 50)
                        .padding(.horizontal, 16)
                        
                        HStack {
                            HStack {
                                Text("Play after".uppercased())
                                    .foregroundColor(.white)
                                    .font(.custom("Digitalt", size: 22))
                                    .lineLimit(1)
                                    .layoutPriority(1)
                                
                                Text("off".uppercased())
                                    .foregroundColor(.lightPurple)
                                    .font(.custom("Digitalt", size: 22))
                                    .lineLimit(1)
                                    .layoutPriority(1)
                                    .padding(.leading, 21)
                                
                                Image("ic_down")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            
                            Spacer()
                            
                            HStack {
                                Text("loop".uppercased())
                                    .foregroundColor(.white)
                                    .font(.custom("Digitalt", size: 22))
                                    .lineLimit(1)
                                    .layoutPriority(1)
                                
                                Toggle("", isOn: $viewModel.selectLoop)
                                    .labelsHidden()
                                    .tint(Color(hex: "#C286FF"))
                            }
                        }
                        .padding(.top, 29)
                        .padding(.horizontal, 16)
                        
                        Spacer()
                        
                        Image("ic_category")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 255, height: 255)
                            .scaleEffect(isLongPressing ? 1.2 : 1.0)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        if !isLongPressing {
                                            print("Started pressing")
                                            isLongPressing = true
                                            playSound()
                                            startContinuousVibration()
                                        }
                                    }
                                    .onEnded { _ in
                                        print("Released")
                                        stopContinuousVibration()
                                        stopSound()
                                    }
                            )
                            .animation(.easeInOut(duration: 0.2), value: isLongPressing)
                        
                        Spacer()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(viewModelList.listCategory) { category in
                                    NavigationLink(destination: ListPrankView(category: category)) {
                                        ZStack {
                                            Image("bg_item_detail")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 59)
                                            
                                            VStack {
                                                Image("ic_category")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 70)
                                            }
                                            .padding()
                                        }
                                        .aspectRatio(1, contentMode: .fit)
                                        .cornerRadius(12)
                                        .clipped()
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 15)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 105)
                        .background(Color.bgBottomDetail)
                        .padding(.bottom, 6)
                    }
                }
                .navigationBarHidden(true)
                .onAppear {
                    viewModelList.getCategories()
                }
            }
        } else {
            
        }
    }
    
    private func startContinuousVibration() {
        stopContinuousVibration()
        
        isLongPressing = true
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
        
        let timer = Timer(timeInterval: 0.3, repeats: true) { _ in
            let feedback = UIImpactFeedbackGenerator(style: .heavy)
            feedback.prepare()
            feedback.impactOccurred()
        }
        
        RunLoop.current.add(timer, forMode: .common)
        vibrationTimer = timer
    }
    
    private func stopContinuousVibration() {
        isLongPressing = false
        vibrationTimer?.invalidate()
        vibrationTimer = nil
    }
    
    private func playSound() {
        guard let soundPath = Bundle.main.path(forResource: sound.sound, ofType: "mp3") else {
            // Try with .wav extension if .mp3 not found
            guard let wavPath = Bundle.main.path(forResource: sound.sound, ofType: "wav") else {
                print("Sound file not found: \(sound.sound)")
                return
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: wavPath))
                audioPlayer?.numberOfLoops = viewModel.selectLoop ? -1 : 0
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
            audioPlayer?.numberOfLoops = viewModel.selectLoop ? -1 : 0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    private func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}

#Preview {
    let sampleSound = Sound()
    sampleSound.name = "Swift Clip"
    sampleSound.sound = "hair_trimmer_1"
    sampleSound.icon = "ic_category_101"
    
    return DetailView(sound: sampleSound)
}
