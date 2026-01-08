import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24)
    ]
    
    var body: some View {
        NavigationStackCompat {
            ZStack {
                Image("background_home")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        NavigationLink(destination: SettingView()){
                            Image("ic_setting")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    
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
                        LazyVGrid(columns: columns, spacing: 24) {
                            ForEach(viewModel.listCategory) { category in
                                NavigationLink(destination: ListPrankView(category: category)) {
                                    ZStack {
                                        Image("bg_item")
                                            .resizable()
                                            .scaledToFill()
                                        
                                        VStack {
                                            Image("ic_category")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 70)
                                            
                                            Spacer()
                                            
                                            ZStack {
                                                Image("bg_btn_home")
                                                    .resizable()
                                                    .scaledToFit()
                                                Text(category.name.uppercased())
                                                    .foregroundColor(.white)
                                                    .font(.custom("Digitalt", size: 18))
                                                    .lineLimit(1)
                                            }
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
                    }.padding(.bottom, 56)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.getCategories()
            }
        }
    }
}

#Preview {
    HomeView()
}
