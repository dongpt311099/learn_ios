import SwiftUI

struct Splash: View {
    
    @State var isActive = false
    
    var body: some View {
        if isActive {
            Home()
        } else {
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("text_splash")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 117)
                    
                    Spacer()
                    
                    Text("loading ......" .uppercased())
                        .foregroundColor(.textSplash)
                        .font(.custom("Digitalt", size: 16))
                        .padding(.bottom, 118)
                }
            }
            .onAppear(){
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    Splash()
}
