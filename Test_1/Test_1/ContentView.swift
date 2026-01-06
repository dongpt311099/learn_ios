import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = UserViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.users) { user in
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text (User)
                    }
                }
            }
        }
    }
}
