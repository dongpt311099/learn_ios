import Foundation

struct APIManager {
    struct Path {
        static let base_domain = "https://rss.itunes.apple.com"
        static let base_path = "/api/v1/us"
        
        static let music_path = "/itunes-music"
        static let music_hot = "/hot-tracks"
    }
    
    struct Music {}
    
    struct Downloader {}
}
