//
//  CodeViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 06.07.2022.
//

import Foundation

extension CodeView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        
        @Published public var textCode = ""
        @Published public var showAccountView = false
        @Published public var errorCode = false
        
        @Published public var okCode = false
        
        private let phoneNumber: String
        
        @Published var presentAlert = false
        @Published var textTitleAlert = ""
        @Published var textAlert = ""
        
        init(phoneNumber: String) {
            let phoneNumber = phoneNumber
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: "")
            
            print("phone number: ", phoneNumber)
            self.phoneNumber = phoneNumber
        }
        
        func login() {
            AuthService.login(phoneNumber: phoneNumber, oneTimeCode: textCode) { [weak self] result in
                switch result {
                case .success(let userWithToken):
                    print("login success")
                    
                    do {
                        try AuthController.signIn(.init(from: userWithToken), token: userWithToken.accessToken)
                        print("sign in success")
                        self?.okCode = true
                    }
                    catch let error {

                        print("sign in failure with error: ", error.localizedDescription)
                        self?.textTitleAlert = "sign in failure with error"
                        self?.textAlert = error.localizedDescription
                        self?.presentAlert = true
                    }
                case .failure(let error):
                    print("login failure with error: ", error.localizedDescription)
//                    self?.textTitleAlert = "login failure with error"
//                    self?.textAlert = error.localizedDescription
//                    self?.presentAlert = true
                    self?.errorCode = true
                }
            }
        }
        
        func changeIncorrect()  {
            if textCode.count < 4 {
                errorCode = false
            }
            
            self.textCode = ""
        }
    }
}
