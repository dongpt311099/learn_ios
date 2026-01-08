import Foundation
import UIKit
import SwiftUI

class ListViewModel: ObservableObject {
    @Published var 	listSound = [Sound]()
    
    func getSounds(categoryId: String) {
        guard let url = Bundle.main.url(forResource: "category_\(categoryId)", withExtension: "json") else {
            print("category_\(categoryId).json not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            listSound = try decoder.decode([Sound].self, from: data)
        } catch {
            print("Error loading category_\(categoryId).json: \(error)")
        }
    }
}
