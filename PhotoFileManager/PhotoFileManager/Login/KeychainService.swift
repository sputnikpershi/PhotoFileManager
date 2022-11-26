//
//  KeychainService.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 25/11/22.
//

import Foundation
import KeychainAccess

protocol KeychainServiceProtocol {
    func receiveData() -> String?
    func saveData(pswd: String)
    func saveMiddlePassword (pswd: String)
    func updateData (password to: String)
}

class KeychainService : KeychainServiceProtocol{
    static var data = KeychainService()
    let keychain = Keychain(service: "com.Kiryl.Team.PhotoFileManager")

    init() {}
    
    func receiveData() -> String? {
        return  keychain["user"]
    }
    
    func saveData(pswd: String) {
        keychain["user"] = pswd
    }
    
    func updateData(password toNewPassword: String) {
        keychain["user"] = toNewPassword
    }
    
    func saveMiddlePassword (pswd: String) {
        keychain["middle"] = pswd
    }
    
    func removeMiddlePassword () {
        keychain["middle"] = ""
    }
    func receiveMaddlePassword () -> String? {
        return keychain["middle"]
    }
}
