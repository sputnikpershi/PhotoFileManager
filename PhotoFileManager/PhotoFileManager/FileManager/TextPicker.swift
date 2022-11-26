//
//  TextPicker.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 21/11/22.
//

import Foundation
import UIKit


class TextPicker {
    
    static let share  = TextPicker()
    
    init () {}
    
    func getText (in viewController: UIViewController, completion: ((_ fieldText: String) -> Void)?) {
        let alert = UIAlertController(title: "New Folder", message: "Please, enter a name of new folder", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name folder"
        }
        let cascelAlert = UIAlertAction(title: "Cancel", style: .cancel)
        let okAlert = UIAlertAction(title: "Create", style: .default) { _ in
            if let folderName = alert.textFields?[0].text {
                if folderName != "" {
                    completion?(folderName)
                }
            }
        }
        alert.addAction(cascelAlert)
        alert.addAction(okAlert)
        viewController.present(alert, animated: true)
    }
    
    
}
