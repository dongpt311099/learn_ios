import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var columns: [GridItem] {
        let columnCount = isIPad ? 3 : 2
        return Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: columnCount)
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ZStack {
                    Image("background_home")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea(.all)
                    VStack {
                        HStack {
                            NavigationLink(destination: SettingView()){
                                Image("ic_setting")
                                    .resizable()
                                    .frame(width: iconSize, height: iconSize)
                            }
                            
                            Spacer()
                            
                            Text("funny prank sounds" .uppercased())
                                .foregroundColor(.white)
                                .font(.custom("Digitalt", size: titleFontSize))
                                .lineLimit(1)
                                .layoutPriority(1)
                            
                            Spacer()
                            
                            Image("ic_heart")
                                .resizable()
                                .frame(width: iconSize, height: iconSize)
                        }
                        .padding(.top, topPadding)
                        .padding(.horizontal, horizontalPadding)
                        
                        Text("Prank with our hilarious and realistic sounds.")
                            .foregroundColor(.white)
                            .font(.custom("Poppins", size: subtitleFontSize))
                            .padding(.top, 12)
                            .lineLimit(1)
                            .layoutPriority(1)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: columns, spacing: gridSpacing) {
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
                                                    .frame(height: categoryIconSize)
                                                
                                                Spacer()
                                                
                                                ZStack {
                                                    Image("bg_btn_home")
                                                        .resizable()
                                                        .scaledToFit()
                                                    Text(category.name.uppercased())
                                                        .foregroundColor(.white)
                                                        .font(.custom("Digitalt", size: categoryFontSize))
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
                            .padding(.horizontal, horizontalPadding)
                            .padding(.vertical, 15)
                        }
                        
                        VStack {
                            Text("BANNER ADS")
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                        }
                        .background(
                            Color.white.ignoresSafeArea(edges: .bottom)
                        )
                    }
                    
                }
                
                .navigationBarHidden(true)
                .onAppear {
                    viewModel.getCategories()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    private var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    private var titleFontSize: CGFloat {
        isIPad ? 28 : 22
    }
    
    private var subtitleFontSize: CGFloat {
        isIPad ? 16 : 12
    }
    
    private var categoryFontSize: CGFloat {
        isIPad ? 20 : 18
    }
    
    private var iconSize: CGFloat {
        isIPad ? 32 : 24
    }
    
    private var categoryIconSize: CGFloat {
        isIPad ? 90 : 70
    }
    
    private var topPadding: CGFloat {
        isIPad ? 60 : 50
    }
    
    private var horizontalPadding: CGFloat {
        isIPad ? 32 : 16
    }
    
    private var gridSpacing: CGFloat {
        isIPad ? 32 : 24
    }
}

#Preview {
    HomeView()
}
