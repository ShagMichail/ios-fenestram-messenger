//
//  SwiftUIView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 08.07.2022.
//

import SwiftUI

extension SettingsView {
    @MainActor
    final class ViewModel: ObservableObject {
        var newPhone: String = ""
        
        public func out(phone: String, code: String) {
            for character in phone {
                if character != " " && character != "-" {
                    newPhone.append("\(character)")
                }
            }
           
            AuthService.login(phoneNumber: newPhone, oneTimeCode: code) { [weak self] result in
                switch result {
                case .success(let userWithToken):
                    print("login success")

                    do {
                        try AuthController.signOut()
                        print("out success")
                        self?.newPhone = ""
                    }
                    catch let error {

                        print("out failure with error: ", error.localizedDescription)
//                        self?.textTitleAlert = "sign in failure with error"
//                        self?.textAlert = error.localizedDescription
//                        self?.presentAlert = true
                    }
                case .failure(let error):
                    print("login failure with error: ", error.localizedDescription)
//                    self?.textTitleAlert = "login failure with error"
//                    self?.textAlert = error.localizedDescription
//                    self?.presentAlert = true
//                    self?.errorCode = true
                }
            }
        }
    }
}
