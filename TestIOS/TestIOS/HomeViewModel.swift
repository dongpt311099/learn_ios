import Foundation

typealias Completion = (Bool, String) -> Void

class HomeViewModel {
    var names: [String] = []
    var musics: [Music] = []
    
    typealias Completion = (Bool, String) -> Void
    
    func loadAPI(completion: @escaping Completion) {
        //create request
        let urlString = "https://rss.itunes.apple.com/api/v1/us/itunes-music/hot-tracks/all/100/explicit.json"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        //config
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true

        //session
        let session = URLSession(configuration: config)
        
        //connect
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    completion(false, "No data received.")
                    return
                }
                
                // Parse JSON
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let feed = json["feed"] as? [String: Any],
                      let results = feed["results"] as? [[String: Any]] else {
                    completion(false, "Data format is error.")
                    return
                }
                
                // Parse music names
                for item in results {
                    if let name = item["name"] as? String {
                        self.names.append(name)
                    }
                }
                
                completion(true, "")
            }
        }
            
        task.resume()
        print("DONE")
    }
    
    func loadAPI3(completion: @escaping Completion) {
        APIManager.Music.getHotMusic { (result) in
            switch result {
            case .failure(let error):
                //call back
                completion(false, error.localizedDescription)
                
            case .success(let musicResult):
                self.musics.append(contentsOf: musicResult.musics)
                
                //call back
                completion(true, "")
            }
        }
    }
    
    class HomeResponse {
        var code: Int
        var success: Bool
        var data: HomeData
        
        init(json: [String: Any]) {
            self.code = json["code"] as? Int ?? 0
            self.success = json["success"] as? Bool ?? false
            
            if let dataDict = json["data"] as? [String: Any] {
                self.data = HomeData(json: dataDict)
            } else {
                self.data = HomeData(json: [:])
            }
        }
    }
    
    class HomeData {
        var templates: [Templates]
        var explores: [Explore]
        var prompts: [String]
        
        init(json: [String: Any]) {
            // Parse templates
            if let templatesArray = json["templates"] as? [[String: Any]] {
                self.templates = templatesArray.map { Templates(data: $0) }
            } else {
                self.templates = []
            }
            
            // Parse explores
            if let exploresArray = json["explores"] as? [[String: Any]] {
                self.explores = exploresArray.map { Explore(data: $0) }
            } else {
                self.explores = []
            }
            
            // Parse prompts
            self.prompts = json["prompts"] as? [String] ?? []
        }
    }
    
}
