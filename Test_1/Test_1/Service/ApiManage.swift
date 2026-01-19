import UIKit

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - Configuration

struct ApiConfig {
    static var timeout: TimeInterval = 30
    static var maxRetries: Int = 3
    static var enableLogging: Bool = true
    static var retryDelay: TimeInterval = 1.0 // Base delay for exponential backoff
}

class ApiManage: NSObject {
    private let TIMEOUT_REQUEST:TimeInterval = 30
    private var activeRequests = Set<String>()
    private var activeTasks: [String: URLSessionTask] = [:]
    private let requestQueue = DispatchQueue(label: "com.apimanage.requests", attributes: .concurrent)
    
    //MARK: Shared Instance
    static let shared: ApiManage = ApiManage()
    
    //MAKR: private
    func request(urlString: String,
                             param: FlixDictionary,
                             headers: [String: String]?,
                             method: HttpMethod,
                             isPrintLog: Bool = true,
                             completion: ApiCompletion?)
    {
        // Thread-safe duplicate check
        guard canStartRequest(urlString) else {
            completion?(Response(error: "Request already in progress"))
            return
        }
        var request:URLRequest!
        if method == .get {
            if param.keys.count > 0 {
                let parameterString = param.stringFromHttpParameters()
                request = URLRequest(url: URL(string:"\(urlString)?\(parameterString)")!)
            }
            else {
                request = URLRequest(url: URL(string:urlString)!)
            }
            if let headers = headers {
                request.allHTTPHeaderFields = headers
            }
        } else if method == .post || method == .put || method == .delete {
            request = URLRequest(url: URL(string:urlString)!)
            if let headers = headers {
                request.allHTTPHeaderFields = headers
            }
            else {
                request.allHTTPHeaderFields = ["Content-Type": "application/json"]
            }
            
            let body = try? JSONSerialization.data(withJSONObject: param, options: [])
            request.httpBody = body
        }
        
        request.timeoutInterval = TIMEOUT_REQUEST
        request.httpMethod = method.rawValue
        
        //
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            // Cleanup request tracking
            self.finishRequest(urlString)
            
            // Check if cancelled
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                DispatchQueue.main.async {
                    completion?(Response(error: "Request cancelled"))
                }
                return
            }
            
            // Handle HTTP errors
            if let httpResponse = response as? HTTPURLResponse {
                guard self.handleHTTPResponse(httpResponse, completion: completion) else {
                    return
                }
            }
            
            // Check for network error
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion?(Response(error: error?.localizedDescription ?? "Network error"))
                }
                return
            }
            
            // Parse JSON on background thread
            let json = self.dataToJSON(data: data)
            let stringJson = String(data: data, encoding: .utf8)
            
            if isPrintLog {
                print("url: \(urlString)")
                print("param: \(param)")
                if let json = json {
                    print("respone: \(json)")
                } else if let stringJson = stringJson {
                    print("respone: \(stringJson)")
                }
            }
            
            // Callback on main thread
            DispatchQueue.main.async {
                if let json = json {
                    completion?(Response(true, data: json))
                } else if let stringJson = stringJson {
                    completion?(Response(true, data: stringJson))
                } else {
                    completion?(Response(error: "Failed to parse response"))
                }
            }
        }
        task.resume()
        trackTask(task, for: urlString)
    }
    
    func requestGoogleSheet(urlString: String,
                             param: FlixDictionary,
                             completion: ApiCompletion?)
    {
        var request:URLRequest!
        request = URLRequest(url: URL(string:urlString)!)
        request.allHTTPHeaderFields = ["Content-Type": "application/x-www-form-urlencoded"]
        request.timeoutInterval = TIMEOUT_REQUEST
        request.httpMethod = "POST"
        
        let parameterArray = param.map { (key, value) -> String in
            return "\(key)=\(value)"
        }
                
        request.httpBody = parameterArray.joined(separator: "&").data(using: .utf8)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { data, response, error in
            // Handle HTTP errors
            if let httpResponse = response as? HTTPURLResponse {
                guard self.handleHTTPResponse(httpResponse, completion: completion) else {
                    return
                }
            }
            
            // Check for network error
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion?(Response(error: error?.localizedDescription ?? "Network error"))
                }
                return
            }
            
            // Parse JSON on background thread
            let json = self.dataToJSON(data: data)
            let stringJson = String(data: data, encoding: .utf8)
            
            print("url: \(urlString)")
            print("param: \(param)")
            if let json = json {
                print("respone: \(json)")
            } else if let stringJson = stringJson {
                print("respone: \(stringJson)")
            }
            
            // Callback on main thread
            DispatchQueue.main.async {
                if let json = json {
                    completion?(Response(true, data: json))
                } else if let stringJson = stringJson {
                    completion?(Response(true, data: stringJson))
                } else {
                    completion?(Response(error: "Failed to parse response"))
                }
            }
        }
        task.resume()
    }
    
    func requestWithFile(urlString: String,
                             param: FlixDictionary,
                             headers: [String: String]?,
                             method: HttpMethod,
                             isPrintLog: Bool = false,
                             completion: ApiCompletion?)
    {
        // Thread-safe duplicate check
        guard canStartRequest(urlString) else {
            completion?(Response(error: "Request already in progress"))
            return
        }
        var data = Data()
        var request = URLRequest(url: URL(string:urlString)!)
        let boundary = UUID().uuidString
        request.allHTTPHeaderFields = ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
        data = Data()
        for (key, value) in param {
            if key == "image" || key.contains("image") {
                // Safe image casting
                guard let image = value as? UIImage else {
                    print("Warning: \(key) is not a UIImage, skipping")
                    continue
                }
                
                // Support both PNG and JPEG
                let imageData: Data?
                let contentType: String
                let filename: String
                
                if key.contains("png") {
                    imageData = image.pngData()
                    contentType = "image/png"
                    filename = "image.png"
                } else {
                    imageData = image.jpegData(compressionQuality: 0.8)
                    contentType = "image/jpeg"
                    filename = "image.jpg"
                }
                
                guard let imgData = imageData else {
                    print("Warning: Failed to convert image to data")
                    continue
                }
                
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
                data.append(imgData)
            } else {
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                data.append("\(value)".data(using: .utf8)!)
            }
        }
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        request.timeoutInterval = TIMEOUT_REQUEST
        request.httpMethod = method.rawValue
        
        //
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.uploadTask(with: request, from: data) { data, response, error in
            // Cleanup request tracking
            self.finishRequest(urlString)
            
            // Handle HTTP errors
            if let httpResponse = response as? HTTPURLResponse {
                guard self.handleHTTPResponse(httpResponse, completion: completion) else {
                    return
                }
            }
            
            // Check for network error
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion?(Response(error: error?.localizedDescription ?? "Network error"))
                }
                return
            }
            
            // Parse JSON on background thread
            let json = self.dataToJSON(data: data)
            let stringJson = String(data: data, encoding: .utf8)
            
            if isPrintLog {
                print("url: \(urlString)")
                print("param: \(param)")
                if let json = json {
                    print("respone: \(json)")
                } else if let stringJson = stringJson {
                    print("respone: \(stringJson)")
                }
            }
            
            // Callback on main thread
            DispatchQueue.main.async {
                if let json = json {
                    completion?(Response(true, data: json))
                } else if let stringJson = stringJson {
                    completion?(Response(true, data: stringJson))
                } else {
                    completion?(Response(error: "Failed to parse response"))
                }
            }
        }
        task.resume()
        trackTask(task, for: urlString)
    }
    
    private func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch { }
        return nil
    }
    
    // MARK: - Thread-Safe Request Management
    
    private func canStartRequest(_ url: String) -> Bool {
        var canStart = false
        requestQueue.sync {
            canStart = !activeRequests.contains(url)
        }
        if canStart {
            requestQueue.async(flags: .barrier) {
                self.activeRequests.insert(url)
            }
        }
        return canStart
    }
    
    private func finishRequest(_ url: String) {
        requestQueue.async(flags: .barrier) {
            self.activeRequests.remove(url)
            self.activeTasks.removeValue(forKey: url)
        }
    }
    
    private func trackTask(_ task: URLSessionTask, for url: String) {
        requestQueue.async(flags: .barrier) {
            self.activeTasks[url] = task
        }
    }
    
    // MARK: - Public Cancellation APIs
    
    /// Cancel a specific request by URL
    func cancelRequest(url: String) {
        requestQueue.async(flags: .barrier) {
            if let task = self.activeTasks[url] {
                task.cancel()
                self.activeTasks.removeValue(forKey: url)
                self.activeRequests.remove(url)
            }
        }
    }
    
    /// Cancel all active requests
    func cancelAllRequests() {
        requestQueue.async(flags: .barrier) {
            self.activeTasks.values.forEach { $0.cancel() }
            self.activeTasks.removeAll()
            self.activeRequests.removeAll()
        }
    }
    
    // MARK: - HTTP Error Handling
    
    @discardableResult
    private func handleHTTPResponse(_ response: HTTPURLResponse, completion: ApiCompletion?) -> Bool {
        switch response.statusCode {
        case 200...299:
            return true // Success
        case 401:
            DispatchQueue.main.async {
                completion?(Response(error: "Unauthorized - Please login again"))
            }
            return false
        case 400:
            DispatchQueue.main.async {
                completion?(Response(error: "Bad request"))
            }
            return false
        case 403:
            DispatchQueue.main.async {
                completion?(Response(error: "Forbidden"))
            }
            return false
        case 404:
            DispatchQueue.main.async {
                completion?(Response(error: "Not found"))
            }
            return false
        case 500...599:
            DispatchQueue.main.async {
                completion?(Response(error: "Server error (\(response.statusCode))"))
            }
            return false
        default:
            DispatchQueue.main.async {
                completion?(Response(error: "Unknown error (\(response.statusCode))"))
            }
            return false
        }
    }
    
    // MARK: - Retry Logic
    
    /// Request with automatic retry on failure
    func requestWithRetry(urlString: String,
                         param: FlixDictionary,
                         headers: [String: String]? = nil,
                         method: HttpMethod,
                         retryCount: Int = ApiConfig.maxRetries,
                         isPrintLog: Bool = true,
                         completion: ApiCompletion?) {
        request(urlString: urlString,
                param: param,
                headers: headers,
                method: method,
                isPrintLog: isPrintLog) { [weak self] response in
            guard let self = self else { return }
            
            // Retry on failure if retries remaining
            if !response.success && retryCount > 0 {
                let delay = ApiConfig.retryDelay * Double(ApiConfig.maxRetries - retryCount + 1)
                
                if ApiConfig.enableLogging {
                    print("Request failed, retrying in \(delay)s... (\(retryCount) retries left)")
                }
                
                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                    self.requestWithRetry(urlString: urlString,
                                        param: param,
                                        headers: headers,
                                        method: method,
                                        retryCount: retryCount - 1,
                                        isPrintLog: isPrintLog,
                                        completion: completion)
                }
            } else {
                completion?(response)
            }
        }
    }
    
    func getCountryCode() -> String {
        let locale = Locale.current
        return locale.regionCode?.lowercased() ?? ""
    }
    
    func getTimeZone() -> String {
        let timeZone = TimeZone.current
        let secondsFromGMT = timeZone.secondsFromGMT()
        let hours = secondsFromGMT / 3600
        let minutes = abs(secondsFromGMT % 3600) / 60
        return String(format: "%+03d:%02d", hours, minutes)
    }
}
