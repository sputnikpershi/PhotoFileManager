//
//  LoginCoordinator.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 24/11/22.
//

import UIKit
import SwiftUI
import Combine

class LoginCoordinator: Coordinator {
    var rootViewController = UIViewController()
    var childCoordinators = [Coordinator]()
    let hasSeenLogin : CurrentValueSubject<Bool, Never>

    init (hasSeenLogin : CurrentValueSubject<Bool, Never>) {
        self.hasSeenLogin = hasSeenLogin
    }
    
    
    func start() {
        rootViewController =  LoginViewController(hasSeenLogin: hasSeenLogin)
    }
    
}
