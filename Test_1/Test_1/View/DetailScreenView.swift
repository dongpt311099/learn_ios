import SwiftUI

struct DetailScreenView: View {
    
    let sound: Sound
    @Environment(\.dismiss) var dismiss
    
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
                        
                        Image("crack_screen")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 497)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.horizontal, 40)
                            .padding(.top, 32)
                        
                        Spacer()
                        
                        ZStack {
                            Image("bg_btn_home")
                                .resizable()
                                .scaledToFit()
                            Text("set wallpaper".uppercased())
                                .foregroundColor(.white)
                                .font(.custom("Digitalt", size: 18))
                                .lineLimit(1)
                        }
                        .padding(.bottom, 30)
                        .padding(.horizontal, 82)
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    let sampleSound = Sound()
    sampleSound.name = "Crack Screen"
    sampleSound.sound = "crack_screen1"
    sampleSound.icon = "ic_category"
    
    return DetailScreenView(sound: sampleSound)
}
