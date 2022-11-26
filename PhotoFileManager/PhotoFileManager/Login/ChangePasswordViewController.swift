//
//  ChangePasswordViewController.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 26/11/22.
//

import UIKit
import SnapKit

class ChangePasswordViewController: UIViewController {
    
    private lazy var oldLabel: UILabel = {
        let label = UILabel()
        label.text = "Ented old password"
        return label
    }()
    
    private lazy var newLabel: UILabel = {
        let label = UILabel()
        label.text = "Ented new password"
        return label
    }()
    
    private lazy var oldTextField: UITextField = {
        let tfield = UITextField()
        tfield.leftViewMode = .always
        tfield.backgroundColor = .white
        tfield.layer.borderWidth = 0
        tfield.layer.borderColor = CGColor(red: 100, green: 0, blue: 0, alpha: 1)
        tfield.placeholder  = "enter password"
        tfield.layer.cornerRadius = 20
        tfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        return tfield
    }()
    private lazy var newTextField: UITextField = {
        let tfield = UITextField()
        tfield.leftViewMode = .always
        tfield.backgroundColor = .white
        tfield.layer.borderWidth = 0
        tfield.layer.borderColor = CGColor(red: 100, green: 0, blue: 0, alpha: 1)
        tfield.placeholder  = "enter password"
        tfield.layer.cornerRadius = 20
        tfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        return tfield
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Change password", for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(saveNewPasswordButtonAction), for: .touchUpInside)
        return button
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayers()
        self.view.backgroundColor = .systemGray6
        
      
        // Do any additional setup after loading the view.
    }
    
    private func setLayers() {
        
        
        self.view.addSubview(oldLabel)
        oldLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(oldTextField)
        oldTextField.snp.makeConstraints { make in
            make.top.equalTo(oldLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
//
        self.view.addSubview(newLabel)
        newLabel.snp.makeConstraints { make in
            make.top.equalTo(oldTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        self.view.addSubview(newTextField)
        newTextField.snp.makeConstraints { make in
            make.top.equalTo(newLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        self.view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(newTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        
    }
    
    
    @objc func saveNewPasswordButtonAction () {
        if newTextField.text!.count < 4 {
            showAllert(text: "Новый пароль должен быть не менее 4 символов. Попробуйте еще раз.")
        }
        else {
            if oldTextField.text == KeychainService.data.receiveData(){
                KeychainService.data.saveData(pswd: newTextField.text!)
                dismiss(animated: true)
            } else {
                showAllert(text: "Старые пароли не совпадают. Введите страый пароль еще раз.")
            }
        }
    }

    
    func showAllert (text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

}
