//
//  SceneDelegate.swift
//  Pill Reminder
//
//  Created by Vladimir Todorov on 22.07.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: winScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = createTabbar()
    }
    
    func createHomeVC() -> UINavigationController {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Medications", image: UIImage(systemName: "pills"), selectedImage: UIImage(systemName: "pills.fill"))
        return UINavigationController(rootViewController: homeVC)
    }
    
    func createSettingsVC() -> UINavigationController {
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        return UINavigationController(rootViewController: settingsVC)
    }
    
    func createTabbar() -> UITabBarController {
        let tabbar = UITabBarController()
        UITabBar.appearance().barStyle = .black
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = .mainBlue()
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .white
        tabbar.viewControllers = [createHomeVC(), createSettingsVC()]
        return tabbar
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

