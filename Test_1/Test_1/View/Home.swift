import SwiftUI

struct Home: View {
    var body: some View {
        ZStack {
            Image("background_home")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Image("ic_setting")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Spacer()
                    
                    Text("funny prank sounds" .uppercased())
                        .foregroundColor(.white)
                        .font(.custom("Digitalt", size: 22))
                        .lineLimit(1)
                        .layoutPriority(1)
                    
                    Spacer()
                    
                    Image("ic_heart")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                .padding(.top, 50)
                .padding(.horizontal, 16)
                
                Text("Prank with our hilarious and realistic sounds.")
                    .foregroundColor(.white)
                    .font(.custom("Poppins", size: 12))
                    .padding(.top, 12)
                    .lineLimit(1)
                    .layoutPriority(1)
                
                Spacer()
            }
        }
    }
}

#Preview {
    Home()
}
