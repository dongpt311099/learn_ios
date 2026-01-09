import SwiftUI

struct SplashView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image("text_splash")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: logoMaxWidth)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                Text("loading ......".uppercased())
                    .foregroundColor(.textSplash)
                    .font(.custom("Digitalt", size: textSize))
                
                Spacer()
            }
            .padding(.vertical, verticalPadding)
        }
        .ignoresSafeArea()
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIApplication.shared.setRootView(HomeView())
            }
        }
    }
    
    private var logoMaxWidth: CGFloat {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            // iPad
            return 500
        } else {
            // iPhone
            return 400
        }
    }
    
    private var textSize: CGFloat {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            // iPad
            return 22
        } else {
            // iPhone
            return 16
        }
    }
    
    private var verticalPadding: CGFloat {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            // iPad
            return 100
        } else if verticalSizeClass == .compact {
            // Landscape
            return 40
        } else {
            // iPhone Portrait
            return 80
        }
    }
}

#Preview {
    SplashView()
}
