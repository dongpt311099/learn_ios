import UIKit

class CategoryTemplates: NSObject {
    var catg: String = ""
    var templates: [Templates] = [Templates]()
}


class Templates: NSObject {
    var code: String = ""
    var type: String = ""
    var name: String = ""
    var thumb: String = ""
    var preview: String = ""
    var video: String = ""
    var sound: String = ""
    var tag: String = ""
    var category: String = ""
    var tagline: String = ""
    var max_faces: Int = 0
    
    override init() {
        
    }
    
    init(data: FlixDictionary) {
        if let val = data["code"] as? String { code = val }
        if let val = data["type"] as? String { type = val }
        if let val = data["name"] as? String { name = val }
        if let val = data["thumb"] as? String { thumb = val }
        if let val = data["preview"] as? String { preview = val }
        if let val = data["video"] as? String { video = val }
        if let val = data["sound"] as? String { sound = val }
        if let val = data["tag"] as? String { tag = val }
        if let val = data["category"] as? String { category = val }
        if let val = data["tagline"] as? String { tagline = val }
        if let val = data["max_faces"] as? Int { max_faces = val }
    }
}
