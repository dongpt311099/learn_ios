import UIKit

class Sound: NSObject, Decodable, Identifiable {
    var id = UUID()
    var name: String = ""
    var sound: String = ""
    var icon: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name, sound, icon
    }
}
