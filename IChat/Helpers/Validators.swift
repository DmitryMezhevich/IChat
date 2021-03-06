//
//  Validators.swift
//  IChat
//
//  Created by Дмитрий Межевич on 17.02.22.
//

import Foundation
import UIKit

class Validators {
    
    static func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard
            let email = email,
            let password = password,
            let confirmPassword = confirmPassword,
            !email.isEmpty,
            !password.isEmpty,
            !confirmPassword.isEmpty
        else { return false}
        
        return true
    }
    
    static func isFilled(username: String?, description: String?, sex: String?) -> Bool {
        guard
            let username = username,
            let description = description,
            let sex = sex,
            !username.isEmpty,
            !description.isEmpty,
            !sex.isEmpty
        else { return false }
        
        return true
    }
    
    static func checkAvatar(avatarImage: UIImage) -> Bool {
        guard avatarImage != #imageLiteral(resourceName: "avatar") else { return false }
        return true
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
