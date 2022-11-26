//
//  SortTableViewCell.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 25/11/22.
//

import UIKit
import SnapKit

protocol SettingsDelegate: AnyObject {
    func reloadData()
}

class SortTableViewCell: UITableViewCell {


    private lazy  var sortLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return   label
    }()
    
    private lazy  var sortSwitch: UISwitch = {
        let sortSwitch = UISwitch()
        sortSwitch.isUserInteractionEnabled = true
        sortSwitch.setOn(UserDefaults.standard.bool(forKey: "sort settings"), animated: true)
        sortSwitch.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        return sortSwitch
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setLayers() {
        self.addSubview(sortLabel)
        sortLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(8)
        }
        
        self.addSubview(sortSwitch)
        sortSwitch.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(5)
        }
    }
    
    @objc func  switchAction () {
        if sortSwitch.isOn{
            UserDefaults.standard.set(true, forKey: "sort settings")
            print("sort changed to ")
            print(UserDefaults.standard.bool(forKey: "sort settings"))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        } else {
            UserDefaults.standard.set(false, forKey: "sort settings")
            print("sort changed to ")
            print(UserDefaults.standard.bool(forKey: "sort settings"))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

        }
    }
}
