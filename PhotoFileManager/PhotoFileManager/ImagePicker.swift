//
//  ImagePicker.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 21/11/22.
//

import UIKit
import Photos
import PhotosUI



class ImagePicker: PHPickerViewControllerDelegate {
    
    static var share = ImagePicker()
    
    var imagesPath = [String]()

    func getImage (in viewController: UIViewController, completion: ((_ images: [String])->())?) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 3
        config.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        let pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        completion?(imagesPath)
        viewController.present(pickerVC, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results.forEach { [weak self] result in
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.item") { url, error in
                
                
                if let error {
                    print(error.localizedDescription)
                }
                
                if let url {
                    self?.imagesPath.append(url.path())
                }
            }
        }
    }
    
}
