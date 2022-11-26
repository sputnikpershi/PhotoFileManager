//
//  SizeTableViewCell.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 25/11/22.
//

import UIKit

class SizeTableViewCell: UITableViewCell {
    
    let userDefaults = UserDefaults.standard

    private lazy  var sizeLabel: UILabel = {
        let label = UILabel()
        return   label
    }()
    
    private lazy  var sizeSwitch: UISwitch = {
        let sizeSwitch = UISwitch()
        sizeSwitch.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        sizeSwitch.isUserInteractionEnabled = true
        sizeSwitch.setOn(UserDefaults.standard.bool(forKey: "size settings"), animated: true)
        return sizeSwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setLayers() {
        self.addSubview(sizeLabel)
        sizeLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(8)
        }
        
        self.addSubview(sizeSwitch)
        sizeSwitch.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(5)
        }
    }
    
    @objc func switchAction () {
        if sizeSwitch.isOn{
            userDefaults.set(true, forKey: "size settings")
            print("size changed to ")
            print(UserDefaults.standard.bool(forKey: "size settings"))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

        } else {
            userDefaults.set(false, forKey: "size settings")
            print("size changed to ")
            print(UserDefaults.standard.bool(forKey: "size settings"))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
    }
}
