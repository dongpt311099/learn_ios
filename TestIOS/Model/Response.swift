import UIKit

class Response: NSObject {
    var success: Bool = false
    var error: String?
    var data: Any?
    
    init(_ success: Bool, data: Any?, error: String?) {
        self.success = success
        self.data = data
        self.error = error
    }
    
    init(_ success: Bool, data: Any?) {
        self.success = success
        self.data = data
    }
    
    init(error: String?) {
        self.success = false
        self.error = error
    }
}
