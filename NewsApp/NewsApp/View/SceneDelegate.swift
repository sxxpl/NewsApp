//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Артем Тихонов on 26.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        ///настройка tabBarController
        let vc1 = UINavigationController(rootViewController: MainViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: FavoriteViewController())
        
        vc1.navigationBar.prefersLargeTitles = true
        vc3.navigationBar.prefersLargeTitles = true
        
        
        vc1.navigationItem.title = "News"
        vc2.navigationItem.title = "Search News"
        vc3.navigationItem.title = "Favorite News"
        
        ///делаем непрозрачный бэкграунд у navigationBar, чтобы не было черной полоски
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        vc1.navigationBar.standardAppearance = navBarAppearance
        vc1.navigationBar.scrollEdgeAppearance = navBarAppearance
        vc2.navigationBar.standardAppearance = navBarAppearance
        vc2.navigationBar.scrollEdgeAppearance = navBarAppearance
        vc3.navigationBar.standardAppearance = navBarAppearance
        vc3.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([vc1,vc2,vc3], animated: false)
        
        guard let items = tabBarController.tabBar.items else {
            return
        }
        
        let images = ["newspaper.fill","magnifyingglass","star.fill"]
        
        
        for i in 0..<items.count {
            items[i].image = UIImage.init(systemName: images[i])
        }
        
        //настройка цвета изображений на таб баре
        let appearance = UITabBarAppearance()
        let iconAppearance = UITabBarItemAppearance()
        iconAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance = iconAppearance
        appearance.inlineLayoutAppearance = iconAppearance
        appearance.compactInlineLayoutAppearance = iconAppearance
        tabBarController.tabBar.standardAppearance = appearance
    
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
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

