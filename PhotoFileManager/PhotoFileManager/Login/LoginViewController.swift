//
//  LoginViewController.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 24/11/22.
//

import UIKit
import SnapKit
import Combine
import KeychainAccess


class LoginViewController: UIViewController {
    var wrongPasswordBorderWidth: CGFloat = 0
    var keyChain = KeychainService()
    var userDefaults = UserDefaults.standard
    let hasSeenLogin:CurrentValueSubject<Bool, Never>

    
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tfield = UITextField()
        tfield.leftViewMode = .always
        tfield.backgroundColor = .white
        tfield.layer.borderWidth = wrongPasswordBorderWidth
        tfield.layer.borderColor = CGColor(red: 100, green: 0, blue: 0, alpha: 1)
        tfield.placeholder  = "enter password"
        tfield.layer.cornerRadius = 20
        tfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        return tfield
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("login", for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(sendPasswordButtonAction), for: .touchUpInside)
        return button
    }()
    init (hasSeenLogin : CurrentValueSubject<Bool, Never>) {
        self.hasSeenLogin = hasSeenLogin
        super.init(nibName: nil, bundle: nil)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        setLayesrs()
        configLogin()
        userDefaults.set(false, forKey: "Second Screen")

    }
    
    private func setLayesrs() {
    
        self.view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        self.view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(passwordTextField.snp.top).offset(-16)
        }
        
        self.view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.height.equalTo(50)
            make.width.equalToSuperview().inset(16)
        }
    }
    
    
    func configLogin () {
        print(keyChain.receiveData())
        if userDefaults.bool(forKey: "old user") {
            textLabel.text = "Авторизуйтесь"
        } else {
            textLabel.text = "Зарегистрируйтесь"
        }
    }
    
    @objc func sendPasswordButtonAction () {
        guard let password = passwordTextField.text else {return}
        if password.count < 4 {
            showAllert(text: "Пароль должен быть не менее чем 4 символа")
        }
        else {
            if userDefaults.bool(forKey: "old user") { //true
                print("auth")
                authorization (password: password)
            } else { // false
                print("regist")
                registration(password: password)
            }
        }
    }
    
    func authorization (password: String) {
        if password == keyChain.receiveData() {
            print(UserDefaults.standard.bool(forKey: "hasSeen"))
            UserDefaults.standard.set(false, forKey: "hasSeen")
            print(UserDefaults.standard.bool(forKey: "hasSeen"))
            hasSeenLogin.send(true)

        } else {
            showAllert(text: "Пароли не совпадают. Попробуйте еще раз!")
        }
    }
    
  
    func registration(password: String) {
        print(userDefaults.bool(forKey: "Second Screen"))
        if userDefaults.bool(forKey: "Second Screen") {
            if passwordTextField.text! == keyChain.receiveMaddlePassword() {
                userDefaults.set(true, forKey: "old user")
                keyChain.saveData(pswd: password)
                keyChain.removeMiddlePassword()
                print("Done")
                hasSeenLogin.send(true)
            } else {
                showAllert(text: "Пароли не совпадают. Попробуйте еще раз!")
            }
        } else {
            print(password)
            keyChain.saveMiddlePassword(pswd: password)
            textLabel.text = "Повторите ввод"
            passwordTextField.text = ""
            userDefaults.set(true, forKey: "Second Screen")
        }
    }
    
    
    func showAllert (text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    
}


