//
//  ViewController.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 19/11/22.
//

import UIKit
import SnapKit
import PhotosUI

class FileController: UIViewController {
    
    var imagesPath = [String]()
    var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path()
    var managerTitle = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].lastPathComponent
    
    static func openFolderController (vc : UIViewController,with path: String, title: String) {
        let fc = FileController()
        fc.path = path
        fc.managerTitle = title
        vc.navigationController?.pushViewController(fc, animated: true)
    }
    
    private lazy var managerTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "folder.fill.badge.plus"), landscapeImagePhone: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(addFolderTap)), UIBarButtonItem(image: UIImage(systemName: "doc.fill.badge.plus"), landscapeImagePhone: UIImage(systemName: "doc.badge.plus"), style: .plain, target: self, action: #selector(addImageTap))]
        setLayers()
        self.title = managerTitle
        self.accessibilityNavigationStyle = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func addFolderTap() {
        TextPicker.share.getText(in: self) { fieldText in
            self.createDirectory(fieldText)
        }
    }
    
    @objc func addImageTap() {
        createFile()
    }
    
    @objc func removeAllTap() {
        removeContent()
    }
    
    private func setLayers() {
        self.view.addSubview(self.managerTable)
        managerTable.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension FileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentsOfDirectory().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        configCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    
    func configCell (cell: UITableViewCell, indexPath: IndexPath) {
        var isDirectory : ObjCBool = false
        cell.accessoryType = .none
        var config = cell.defaultContentConfiguration()
        config.image = UIImage(systemName: "doc")
        let content = contentsOfDirectory()[indexPath.row]
        let atPath = path + "/" + content
        FileManager.default.fileExists(atPath: atPath, isDirectory: &isDirectory)
        if isDirectory.boolValue {
            config.secondaryText = "folder"
            config.image = UIImage(systemName: "folder.fill")
            cell.accessoryType = .disclosureIndicator
        }
        config.text = content
        cell.contentConfiguration = config
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let content = contentsOfDirectory()[indexPath.row]
        let atPath = path  + content + "/"
        var isDirectory : ObjCBool = false
        FileManager.default.fileExists(atPath: atPath, isDirectory: &isDirectory)
        if isDirectory.boolValue {
            FileController.openFolderController(vc: self, with: atPath, title: content)
        }
    }
}


extension FileController: FileManagerService, PHPickerViewControllerDelegate {
    func contentsOfDirectory() -> [String]{
        var contents: [String] {
            do {
                return try FileManager.default.contentsOfDirectory(atPath: self.path)
            }
            catch {
                print(error.localizedDescription)
                return []
            }
        }
        return contents
    }
    
    func createDirectory(_ fieldText: String) {
        let newFolderPath = path +  "/" + "\(fieldText)"
        print(newFolderPath)
        do {
            try FileManager.default.createDirectory(atPath: newFolderPath, withIntermediateDirectories: false)
            managerTable.reloadData()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    func createFile() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 3
        config.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        let pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        present(pickerVC, animated: true, completion: nil)
    }
    
    
    
    func removeContent() {
        do {
            let contents =  try FileManager.default.contentsOfDirectory(atPath: self.path)
            for content in contents {
                let pathForContents = path + "/" + content
                do {
                    try FileManager.default.removeItem(atPath: pathForContents)
                }
                catch {
                    print(error.localizedDescription)
                }
                managerTable.reloadData()
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        results.forEach { result in
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.item") { [weak self] url, error in
                
                if let error {
                    print(error.localizedDescription)
                }
                
                if let url {
                    
                    let pathTo = self!.path + "\(url.lastPathComponent)"
                    let atPath = url.path()
                    do {
                        try FileManager.default.copyItem(atPath: atPath, toPath: pathTo)
                    }
                    catch {
                        
                    }
                    DispatchQueue.main.async {
                        self?.managerTable.reloadData()
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }
    
}


