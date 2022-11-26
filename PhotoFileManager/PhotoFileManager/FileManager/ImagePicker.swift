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
        var pickImageCallback : ((Data) -> ())?

        var imagesPath = [String]()

        func getImage (in viewController: UIViewController, completion: ((_ images: (Data))->())?) {
            pickImageCallback = completion
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 3
            config.filter = PHPickerFilter.any(of: [.images, .livePhotos])
            let pickerVC = PHPickerViewController(configuration: config)
            pickerVC.delegate = self
            viewController.present(pickerVC, animated: true, completion: nil)
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            results.forEach { result in
                result.itemProvider.loadObject(ofClass: UIImage.self) {  image, error in
                    guard let image = (image as? UIImage)?.pngData(), error == nil  else {
                                return
                            }
                    self.pickImageCallback!(image)
                        }
                    }
                    DispatchQueue.main.async {
                        picker.dismiss(animated: true)
                    }
                }
            }
        
    
class InotheImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pickImageCallback : ((Data) -> ())?
    var picker = UIImagePickerController()
    func getImage (in vc: UIViewController, completion: ((_ images: (Data))->())?) {
        pickImageCallback = completion
        picker.sourceType = .photoLibrary
        picker.delegate = self
        vc.present(picker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let data = ((info[.originalImage] as! UIImage).pngData()) {
            self.pickImageCallback?(data)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
