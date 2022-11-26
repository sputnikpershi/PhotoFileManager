//
//  SettingsCoordinator.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 25/11/22.
//

import UIKit

class SettingsCoordinator: Coordinator {
    var rootViewController = UINavigationController()
    var childCoordinators = [Coordinator]()
   
    func start() {
        rootViewController =  UINavigationController(rootViewController: SettingsViewController())
    }
    
}
