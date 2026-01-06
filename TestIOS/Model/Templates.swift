import UIKit

class Templates: NSObject {
    var code: String = ""
    var type: String = ""
    var name: String = ""
    var thumb: String = ""
    var preview: String = ""
    var video: String = ""
    var sound: String = ""
    var tag: String = ""
    
    override init() {
        
    }
    
    init(data: [String: Any]) {
        if let val = data["code"] as? String { code = val }
        if let val = data["type"] as? String { type = val }
        if let val = data["name"] as? String { name = val }
        if let val = data["thumb"] as? String { thumb = val }
        if let val = data["preview"] as? String { preview = val }
        if let val = data["video"] as? String { video = val }
        if let val = data["sound"] as? String { sound = val }
        if let val = data["tag"] as? String { tag = val }
    }
}

