//
//  AppCoordinator.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 24/11/22.
//

import UIKit
import Combine

class AppCoordinator : Coordinator {
    
    let window : UIWindow
    var childCoordinator = [Coordinator]()
   // var hasSeen = UserDefaults.standard.bool(forKey: "hasSeen")
  let hasSeenLogin = CurrentValueSubject<Bool, Never>(false)
    var subscriptions = Set <AnyCancellable>()
    
    
    init(window: UIWindow) {
        self.window = window
    }
    
    
    func start() {
//        UserDefaults.standard.set(true, forKey: "hasSeen")
        
        hasSeenLogin.sink { [weak self] hasSeen in
            
            if hasSeen {
                let mainCoordinator = MainCoordinator()
                mainCoordinator.start()
                let mainVC = mainCoordinator.rootViewController
                self?.window.rootViewController = mainVC
            } else if let hasSeenLogin = self?.hasSeenLogin {
                let loginCoodinator = LoginCoordinator(hasSeenLogin: hasSeenLogin)
                loginCoodinator.start()
                let loginVC = loginCoodinator.rootViewController
                self?.window.rootViewController = loginVC
            }
            
        }.store(in: &subscriptions)

       
    }
}
