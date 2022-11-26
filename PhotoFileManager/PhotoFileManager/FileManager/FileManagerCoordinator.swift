//
//  FileManagerCoordinator.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 24/11/22.
//

import UIKit
import SwiftUI

class FileManagerCoordinator: Coordinator {
    var rootViewController = UINavigationController()
    var childCoordinators = [Coordinator]()
    
    func start() {
        let fileVC = FileController()
        rootViewController = UINavigationController(rootViewController: fileVC)
       
    }
    
}

