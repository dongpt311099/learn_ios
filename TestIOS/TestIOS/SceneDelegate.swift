//
//  SceneDelegate.swift
//  TestIOS
//
//  Created by DongPT on 26/12/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static var shared: SceneDelegate?
    var naviVC: UINavigationController?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        SceneDelegate.shared = self
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene =  windowScene
        self.naviVC = UINavigationController(rootViewController: HomeVC())
        self.naviVC!.isNavigationBarHidden = true
        self.window!.rootViewController = naviVC!
        self.window!.makeKeyAndVisible()
    }


}

