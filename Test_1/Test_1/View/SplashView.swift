import SwiftUI

struct SplashView: View {
    
    var body: some View {
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
                UIApplication.shared.setRootView(HomeView())
            }
        }
    }
}

#Preview {
    SplashView()
}
