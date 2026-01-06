import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var naviVC: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.naviVC = UINavigationController(rootViewController: HomeVC())
        self.naviVC!.isNavigationBarHidden = true
        self.naviVC!.navigationBar.barStyle = .default
        self.window?.rootViewController = naviVC!
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        self.window?.makeKeyAndVisible()
        return true
    }

}

