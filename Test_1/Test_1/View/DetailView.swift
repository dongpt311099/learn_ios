import SwiftUI

struct DetailView: View {
    
    @StateObject private var viewModel = DetailViewModel()
    @StateObject private var viewModelList = HomeViewModel()
    @Environment(\.dismiss) var dismiss
    
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
}

#Preview {
    let sampleSound = Sound()
    sampleSound.name = "Swift Clip"
    sampleSound.sound = "hair_trimmer_1"
    sampleSound.icon = "ic_category_101"
    
    return DetailView(sound: sampleSound)
}
