import Foundation

extension APIManager.Music {
    struct QueryString {
        func hotMusic(limit: Int) -> String {
            return APIManager.Path.base_domain +
                APIManager.Path.base_path +
                APIManager.Path.music_path +
                APIManager.Path.music_hot +
                "/all/\(limit)/explicit.json"
        }
    }
    
    struct QueryParam {
    }
    
    struct MusicResult {
        var musics: [Music]
        var copyright: String
        var updated: String
    }
    
    static func getHotMusic(limit: Int = 10, completion: @escaping APICompletion<MusicResult>) {
        let urlString = QueryString().hotMusic(limit: limit)

        API.shared().request(urlString: urlString) { (result) in
            switch result {
            case .failure(let error):
                //call back
                completion(.failure(error))
                
            case .success(let data):
                if let data = data,
                   let json = dataToJSON(data: data) as? [String: Any],
                   let feed = json["feed"] as? [String: Any],
                   let results = feed["results"] as? [[String: Any]] {
                    
                    // musics
                    var musics: [Music] = []
                    for item in results {
                        let music = Music(json: item)
                        musics.append(music)
                    }
                    
                    //informations
                    let copyright = feed["copyright"] as? String ?? "....."
                    let updated = feed["updated"] as? String ?? "....."
                    
                    // result
                    let musicResult = MusicResult(musics: musics, copyright: copyright, updated: updated)
                    
                    //call back
                    completion(.success(musicResult))
                    
                } else {
                    //call back
                    completion(.failure(.error("Data is not in correct format.")))
                }
            }
        }
    }
    
    static func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch { }
        return nil
    }
}
