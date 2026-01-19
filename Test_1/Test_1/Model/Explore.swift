import UIKit

class Explore: NSObject {
    var code: String = ""
    var type: String = ""
    var name: String = ""
    var prompt: String = ""
    var template_code: String = ""
    var ratio: String = ""
    var resolution: String = ""
    var ai_sound: Int = 0
    var thumb: String = ""
    var preview: String = ""
    var video: String = ""
    var tier: String = ""
    var sound: String = ""
    var tag: String = ""
    
    override init() {
        
    }
    
    init(data: [String: Any]) {
        if let val = data["code"] as? String { code = val }
        if let val = data["type"] as? String { type = val }
        if let val = data["name"] as? String { name = val }
        if let val = data["prompt"] as? String { prompt = val }
        if let val = data["template_code"] as? String { template_code = val }
        if let val = data["ratio"] as? String { ratio = val }
        if let val = data["resolution"] as? String { resolution = val }
        if let val = data["ai_sound"] as? Int { ai_sound = val }
        if let val = data["thumb"] as? String { thumb = val }
        if let val = data["preview"] as? String { preview = val }
        if let val = data["video"] as? String { video = val }
        if let val = data["tier"] as? String { tier = val }
        if let val = data["sound"] as? String { sound = val }
        if let val = data["tag"] as? String { tag = val }
    }
}
