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
        
        
        //MARK: - Properties
        
        var newPhone: String = ""
        
        
        //MARK: - Query functions
        
        public func out(phone: String, code: String) {
            for character in phone {
                if character != " " && character != "-" {
                    newPhone.append("\(character)")
                }
            }
           
            AuthService.login(phoneNumber: newPhone, oneTimeCode: code) { [weak self] result in
                switch result {
                case .success(_):
                    print("login success")

                    do {
                        try AuthController.signOut()
                        print("out success")
                        self?.newPhone = ""
                    }
                    catch let error {
                        print("out failure with error: ", error.localizedDescription)
                    }
                case .failure(let error):
                    print("login failure with error: ", error.localizedDescription)
                }
            }
        }
    }
}
