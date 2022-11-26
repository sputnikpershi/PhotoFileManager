//
//  MainCoordinator.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 24/11/22.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var rootViewController = UITabBarController()
    var keychain = KeychainService()
    var childCoordinators = [Coordinator]()

    
    init () {
        rootViewController.tabBar.tintColor = .systemBlue
        rootViewController.tabBar.backgroundColor = .white
    }
    
    func start() {
        
        
        
        let fileManagerCoordinator = FileManagerCoordinator()
        fileManagerCoordinator.start()
        let fileManagerVC = fileManagerCoordinator.rootViewController
        childCoordinators.append(fileManagerCoordinator)
        fileManagerVC.tabBarItem = UITabBarItem(title: "File", image: UIImage(systemName: "doc.append.rtl"), selectedImage: UIImage(systemName: "doc.append.fill.rtl"))

        
        let settingsCoordinator = SettingsCoordinator()
        settingsCoordinator.start()
        let settingsVC = settingsCoordinator.rootViewController
        childCoordinators.append(settingsCoordinator)
        settingsVC.tabBarItem = UITabBarItem(title: "Login", image: UIImage(systemName: "doc.append.rtl"), selectedImage: UIImage(systemName: "doc.append.fill.rtl"))

        
        rootViewController.viewControllers = [fileManagerVC, settingsVC]
        
    }
}
