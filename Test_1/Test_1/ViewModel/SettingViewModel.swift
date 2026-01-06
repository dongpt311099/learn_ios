import Foundation
import UIKit
import SwiftUI
import StoreKit

class SettingViewModel: ObservableObject {
    @Published var selectVibrate = false
    
    func feedback() {
        if let url = URL(string: "mailto:support@yourdomain.com") {
            UIApplication.shared.open(url)
        }
    }
    
    func shareApp() {
        let appUrl = URL(string: "https://apps.apple.com/app/your-app-id")!
        let activityVC = UIActivityViewController(activityItems: [appUrl], applicationActivities: nil)
        
        // Tìm KeyWindow để hiển thị Share Sheet
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func openPolicy() {
        if let url = URL(string: "https://yourdomain.com/privacy") {
            UIApplication.shared.open(url)
        }
    }
}
