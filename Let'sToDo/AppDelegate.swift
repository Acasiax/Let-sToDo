//
//  AppDelegate.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
//        // UILabel 스타일 설정
//               UILabel.appearance().font = UIFont.systemFont(ofSize: 17)
//               UILabel.appearance().textColor = .black
//               
//               // UIButton 스타일 설정
//        UIButton.appearance().backgroundColor = .systemBlue.withAlphaComponent(0.5)
//               UIButton.appearance().setTitleColor(.white, for: .normal)
//               
//               // UITextField 스타일 설정
//               UITextField.appearance().font = UIFont.systemFont(ofSize: 17)
//               UITextField.appearance().textColor = .black
//               UITextField.appearance().backgroundColor = .white
//               
//               // UINavigationBar 스타일 설정
//               let navigationBarAppearance = UINavigationBarAppearance()
//               navigationBarAppearance.backgroundColor = .systemBackground
//               navigationBarAppearance.titleTextAttributes = [
//                   .foregroundColor: UIColor.black
//               ]
//               UINavigationBar.appearance().standardAppearance = navigationBarAppearance
//               UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
//               
//               // UITabBar 스타일 설정
//               let tabBarAppearance = UITabBarAppearance()
//               tabBarAppearance.backgroundColor = .systemBackground
//               UITabBar.appearance().standardAppearance = tabBarAppearance
//               if #available(iOS 15.0, *) {
//                   UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
//               }
//        
        
        
        
       //1. 마이그레이션이 꼭 왜 필요할까?
        //2. 왜 if else로 쓰지 않을까?
        let config = Realm.Configuration(schemaVersion: 0) {migration, oldShemaVersion in
        
            
//            if oldShemaVersion < 1 {
//                
//            }
//            
//            if oldShemaVersion < 2 {
//                migration.renameProperty(onType: <#T##String#>, from: <#T##String#>, to: <#T##String#>)
//            }
            
        }
        
        Realm.Configuration.defaultConfiguration = config
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

