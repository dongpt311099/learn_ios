import SwiftUI

struct ListPrankView: View {
    
    let category: Category
    @StateObject private var viewModel = ListViewModel()
    @Environment(\.dismiss) var dismiss
    
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
                        Button(action: {
                            dismiss()
                        }) {
                            Image("ic_back")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        Spacer()
                        
                        Text(category.name.uppercased())
                            .foregroundColor(.white)
                            .font(.custom("Agbalumo", size: 22))
                            .lineLimit(1)
                            .layoutPriority(1)
                        
                        Spacer()
                        
                        Image("")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.top, 50)
                    .padding(.horizontal, 16)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 24) {
                            ForEach(viewModel.listSound) { sound in
                                NavigationLink(destination: DetailView(sound: sound)) {
                                    ZStack {
                                        Image("bg_list_item")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 118)
                                    
                                        VStack {
                                            Text(sound.name.uppercased())
                                                .foregroundColor(.white)
                                                .font(.custom("Digitalt", size: 13))
                                                .lineLimit(1)
                                                .padding(.top, 10)
                                            
                                            Spacer()
                                            
                                            Image("ic_category")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 70)
                                                .padding(.top, 13)
                                            
                                            Spacer()
                                        }
                                    }
                                    .aspectRatio(1, contentMode: .fit)
                                    .cornerRadius(12)
                                    .clipped()
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 38)
                        .padding(.vertical, 33)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.getSounds(categoryId: category.id)
            }
        }
    }
}

#Preview {
    let sampleCategory = Category()
    sampleCategory.id = "1"
    sampleCategory.name = "Hair Clipper"
    sampleCategory.icon_title = "ic_category_title_1"
    sampleCategory.icon = "ic_category_1"
    
    return ListPrankView(category: sampleCategory)
}
