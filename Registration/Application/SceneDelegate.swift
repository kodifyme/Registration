//
//  SceneDelegate.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if UserDefaultsManager.shared.isLoggedIn() {
            let navigationVC = UINavigationController()
            
            // Создание экрана файловой системы
            let fileSystemVC = FileSystemViewController()
            fileSystemVC.title = "Файловая система" // Устанавливаем заголовок для экрана файловой системы
            
            // Создание экранов регистрации и авторизации
            let registrationVC = RegistrationViewController()
            registrationVC.title = "Регистрация" // Устанавливаем заголовок для экрана регистрации
            let authorizationVC = AuthorizationViewController()
            authorizationVC.title = "Авторизация"

            
            // Добавление экранов в стек навигации
            navigationVC.setViewControllers([registrationVC, authorizationVC, fileSystemVC], animated: false)
            // Устанавливаем навигационный контроллер как корневой для окна
            window?.rootViewController = navigationVC
            window?.makeKeyAndVisible()
        } else {
            // Создание экрана регистрации
            let registrationVC = RegistrationViewController()
            registrationVC.title = "Регистрация" // Устанавливаем заголовок для экрана регистрации
            
            // Создание навигационного контроллера с экраном регистрации в качестве корневого
            let registrationNC = UINavigationController(rootViewController: registrationVC)
            
            // Устанавливаем навигационный контроллер с экраном регистрации как корневой для окна
            window?.rootViewController = registrationNC
            window?.makeKeyAndVisible()
        }
    }
    
    func 
    
    func createRegistrationNC() -> UINavigationController {
        let registrationVC = RegistrationViewController()
        registrationVC.title = "Регистрация"
        return UINavigationController(rootViewController: registrationVC)
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

