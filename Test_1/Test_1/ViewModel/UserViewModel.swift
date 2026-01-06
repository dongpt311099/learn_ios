import SwiftUI

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    
    func fetchUsers() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.users = [
                User(name: "Nguyễn Văn A", job: "Android Dev"),
                User(name: "Trần Thị B", job: "iOS Dev"),
                User(name: "Lê Văn C", job: "Flutter Dev")
            ]
        }
    }
}
