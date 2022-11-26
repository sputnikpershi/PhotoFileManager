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
    
    var picker = UIImagePickerController()
    let imagePicker2 = InotheImagePicker()
    var imagesPath = [String]()
    var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path()
    var managerTitle = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].lastPathComponent
    var sortedContentOfDirectory = [String]()
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.view.backgroundColor = .lightGray
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "folder.fill.badge.plus"), landscapeImagePhone: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(addFolderTap)),
            UIBarButtonItem(image: UIImage(systemName: "doc.fill.badge.plus"), landscapeImagePhone: UIImage(systemName: "doc.badge.plus"), style: .plain, target: self, action: #selector(addImageTap)),
            UIBarButtonItem(image: UIImage(systemName: "trash"), landscapeImagePhone: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(removeAllTap))]
        setLayers()
        self.title = managerTitle
        self.accessibilityNavigationStyle = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func loadList(notification: NSNotification){
        self.managerTable.reloadData()
    }
    
    
    @objc func addFolderTap() {
        createFile()
    }
    
    @objc func addImageTap() {
        imagePicker2.getImage(in: self) { images in
            let url = URL(filePath: self.path + "image" + "\(self.contentsOfDirectory().count + 1).jpg")
            print(url)
            do {
                try images.write(to: url)
                self.managerTable.reloadData()
            }
            catch {
                print(error.localizedDescription)
            }
        }
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
        if UserDefaults.standard.bool(forKey: "sort settings") {
            setAfterUpdateSettings(cell: cell, indexPath: indexPath, contents: contentsOfDirectory().sorted { $1>$0 } )
        } else {
            setAfterUpdateSettings(cell: cell, indexPath: indexPath, contents: contentsOfDirectory() )
        }
    }
    
    func setAfterUpdateSettings(cell: UITableViewCell, indexPath: IndexPath, contents: [String]) {
        var config = cell.defaultContentConfiguration()
        var isDirectory : ObjCBool = false
        cell.accessoryType = .none
        let content = contents[indexPath.row]
        sortedContentOfDirectory = contents
        let atPath = path + "/" + content
        FileManager.default.fileExists(atPath: atPath, isDirectory: &isDirectory)
        if isDirectory.boolValue {
            config.secondaryText = "folder"
            config.image = UIImage(systemName: "folder.fill")
            cell.accessoryType = .disclosureIndicator
        } else {
            if UserDefaults.standard.bool(forKey: "size settings")  {
                do {
                    let fileSize = try? FileManager.default.attributesOfItem(atPath: atPath)[FileAttributeKey.size] as? UInt64
                    config.secondaryText = "\(fileSize!) киллобайт"
                }
            }
        }
        config.text = content
        cell.contentConfiguration = config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if UserDefaults.standard.bool(forKey: "sort settings") {
            var contents = contentsOfDirectory().sorted {$1>$0}
            let content = contents[indexPath.row]
            let atPath = path  + content + "/"
            var isDirectory : ObjCBool = false
            FileManager.default.fileExists(atPath: atPath, isDirectory: &isDirectory)
            if isDirectory.boolValue {
                FileController.openFolderController(vc: self, with: atPath, title: content)
            }
        } else {
            let content = contentsOfDirectory()[indexPath.row]
            let atPath = path  + content + "/"
            var isDirectory : ObjCBool = false
            FileManager.default.fileExists(atPath: atPath, isDirectory: &isDirectory)
            if isDirectory.boolValue {
                FileController.openFolderController(vc: self, with: atPath, title: content)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let contents =  try FileManager.default.contentsOfDirectory(atPath: self.path)
                
                let pathForContents = path + "/" + contents[indexPath.row]
                    do {
                        try FileManager.default.removeItem(atPath: pathForContents)
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                    managerTable.reloadData()
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
    }
}


extension FileController: FileManagerService {
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
        TextPicker.share.getText(in: self) { fieldText in
            self.createDirectory(fieldText)
        }
    }
    
    func removeContent() {
        do {
            let contents =  try FileManager.default.contentsOfDirectory(atPath: self.path)
            for content in sortedContentOfDirectory {
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
}






