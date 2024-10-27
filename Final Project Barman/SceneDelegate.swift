// SceneDelegate.swift
//
//  SceneDelegate.swift
//  Final Project Barman
//
//  Created by Carlos Ignacio Padilla Herrera on 26/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       // This method can be used to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
       // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
       // This delegate does not imply the connecting scene or session is new (see `application:configurationForConnectingSceneSession` instead).
       guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
       // Called as the scene is being released by the system.
       // This occurs shortly after the scene enters the background, or when its session is discarded.
       // Any resources associated with this scene that can be recreated the next time the scene connects should be released here.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
       // Called when the scene has moved from an inactive state to an active state.
       // Any tasks that were paused (or not yet started) when the scene was inactive can be restarted here.
    }

    func sceneWillResignActive(_ scene: UIScene) {
       // Called when the scene will move from an active state to an inactive state.
       // This may occur due to temporary interruptions (e.g., an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
       // Called as the scene transitions from the background to the foreground.
       // Any changes made on entering the background can be undone here.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
       // Called as the scene transitions from the foreground to the background.
       // Use this method to save data, release shared resources, and store enough scene-specific state information to restore the scene back to its current state.
    }
}
