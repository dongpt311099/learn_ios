import Foundation
import UIKit
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var listCategory = [Category]()
    
    func getCategories(){
        guard let url = Bundle.main.url(forResource: "home", withExtension: "json") else {
            print("home.json not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            listCategory = try decoder.decode([Category].self, from: data)
        } catch {
            print("Error loading home.json: \(error)")
        }
    }
}
