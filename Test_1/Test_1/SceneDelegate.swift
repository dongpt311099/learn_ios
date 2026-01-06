import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static var shared: SceneDelegate?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        SceneDelegate.shared = self
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene =  windowScene
        
        let vc = UIHostingController(rootView: Splash())
        self.window!.rootViewController = vc
        self.window!.makeKeyAndVisible()
    }
}
