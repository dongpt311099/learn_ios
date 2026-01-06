import UIKit

class Category: NSObject, Decodable, Identifiable {
    var id: String = ""
    var name: String = ""
    var icon_title: String = ""
    var icon: String = ""
}
