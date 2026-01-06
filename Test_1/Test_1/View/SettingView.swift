import SwiftUI

struct SettingView: View {
    
    @StateObject private var viewModel = SettingViewModel()
    
    var body: some View {
        ZStack {
            Image("bg").resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        
                    }) {
                        Image("ic_back")
                                    .resizable()
                                    .padding(12)
                                    .frame(width: 56, height: 56)
                            }
                    Spacer()
                    Text("Setting")
                        .font(.custom("Digitalt", size: 24))
                        .foregroundColor(.white)
                    Spacer()
                    Spacer().frame(width: 56, height: 56)
                }
                Spacer().frame(height: 16)
                ZStack {
                    HStack {
                        Image("ic_vibrate")
                                    .resizable()
                                    
                                    .frame(width: 24, height: 24)
                        Spacer().frame(width: 16)
                        Text("Vibrate")
                            .font(.custom("Digitalt", size: 16))
                            .foregroundColor(Color(hex: "#A75CF4"))
                        Spacer()
                        Toggle("", isOn: $viewModel.selectVibrate).tint(Color(hex: "#C286FF")).onChange(of: viewModel.selectVibrate) { newValue in
                            viewModel.selectVibrate = newValue
                        }
                    }.frame(height: 66)
                }
                .padding([.leading, .trailing], 16).background(){
                    ZStack {
                        Color.black.opacity(0.25).cornerRadius(20)
                        Color(hex: "#D1D8FF").cornerRadius(20).padding(.bottom, 2)
                        Color.white.cornerRadius(20).padding(.bottom, 4)
                    }
                }.padding([.leading, .trailing], 16)
                VStack(spacing: 0) {
                    SettingRow(icon: "ic_feedback", title: "Feedback", action: viewModel.feedback)
                    SettingRow(icon: "ic_share_app", title: "Share app", action: viewModel.shareApp)
                    SettingRow(icon: "ic_rate_app", title: "Rate app", action: viewModel.rateApp)
                    SettingRow(icon: "ic_policy", title: "Policy", action: viewModel.openPolicy)
                }.padding(16)
                .background(
                    ZStack {
                        Color.black.opacity(0.25).cornerRadius(20)
                        Color(hex: "#D1D8FF").cornerRadius(20).padding(.bottom, 4)
                        Color.white.cornerRadius(20).padding(.bottom, 8)
                    }
                )
                .padding(16)
                Spacer()
            }.padding(.top, safeAreaTop)
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    private var safeAreaTop: CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
            
        return keyWindow?.safeAreaInsets.top ?? 0
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(icon)
                            .resizable()
                            .frame(width: 24, height: 24)
                Text(title)
                    .font(.custom("Digitalt", size: 16))
                    .foregroundColor(Color(hex: "#A75CF4"))
                Spacer()
                Image("ic_arrow")
                            .resizable()
                            .frame(width: 24, height: 24)
            }.frame(height: 48)
        }
    }
}

#Preview {
    SettingView()
}
