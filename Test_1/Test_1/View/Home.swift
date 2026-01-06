import SwiftUI

struct Home: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
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
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.listCategory) { category in
                            Button(action: {}) {
                                ZStack {
                                    Image("bg_item")
                                        .resizable()
                                        .frame(height: 150)
                                    
                                    VStack {
                                        Image("ic_category")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 70)
                                        
                                        ZStack {
                                            Image("bg_btn_home")
                                                .resizable()
                                                .scaledToFill()
                                            
                                            Text(category.name.uppercased())
                                                .foregroundColor(.white)
                                                .font(.custom("Digitalt", size: 18))
                                                .lineLimit(1)
                                        }
                                        
                                    }
                                    .padding()
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13)
                }
            }
        }.onAppear {
            viewModel.getCategories()
        }
    }
}

#Preview {
    Home()
}
