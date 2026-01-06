import SwiftUI

struct User: Identifiable {
    let id = UUID()
    let name: String
    let job: String
}
