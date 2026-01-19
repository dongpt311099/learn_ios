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
        
        ApiManage.shared.getDataHome { data in
            if data.success {
                let templates = (data.data as? HomeData)?.templates ?? []
                
                var categoriesName:[String] = [String]()
                
                for item in templates {
                    let listCategory = item.category.components(separatedBy: ";")
                    for category in listCategory {
                        if categoriesName.filter({$0 == category}).isEmpty {
                            categoriesName.append(category)
                        }
                    }
                }
                
            }
        }
        
    }
}
