//
//  SceneDelegate.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/08/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        
    }
    
    
    //kakao Scene
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
          //    kakao27eee38f87e06c631291470021c6af19://kakaolink?uid=3qIVYjAWQeQpkpksYJsLz504DIP2
          // TODO : 방 uid 값으로 찾고 못찾을때 에러처리
          if let url = URLContexts.first?.url {
              print("SceneDelegate url :::: \(url)")
              
              let components = URLComponents(string: url.absoluteString)
              let urlQueryItems = components?.queryItems ?? [] // [name=jake]
              
              print("urlQueryItems ::::::", urlQueryItems)
              var dictionaryData = [String: String]()
              urlQueryItems.forEach { dictionaryData[$0.name] = $0.value }

              guard let uid = dictionaryData["uid"] else { return }

              print("이름 = \(uid)")

              let homeVC = NaverMapWatchViewController()
              window?.rootViewController = UINavigationController(rootViewController: homeVC)
              
             // 여기서 파싱해서 원하는 기능을 실행하거나 등등 할 수 있슴다
          }
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

