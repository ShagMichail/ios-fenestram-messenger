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
        
        
        //MARK: - Properties
        
        private let phoneNumber: String
        
        @Published public var textCode = ""
        @Published public var showAccountView = false
        @Published public var errorCode = false
        
        @Published public var okCode = false
        
        @Published var presentAlert = false
        @Published var textAlert = ""
        
        init(phoneNumber: String) {
            let phoneNumber = phoneNumber
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: "")
            
            self.phoneNumber = phoneNumber
        }
        
        
        //MARK: - Query functions
        
        func login() {
            AuthService.login(phoneNumber: phoneNumber, oneTimeCode: textCode) { [weak self] result in
                switch result {
                case .success(let userWithToken):
                    print("login success")
                    
                    do {
                        try AuthController.signIn(.init(from: userWithToken), accessToken: userWithToken.accessToken, refreshToken: userWithToken.refreshToken)
                        print("sign in success")
                        self?.okCode = true
                    }
                    catch let error {
                        print("sign in failure with error: ", error.localizedDescription)
                        self?.textAlert = error.localizedDescription
                        self?.presentAlert = true
                    }
                case .failure(let error):
                    print("login failure with error: ", error.localizedDescription)
                    if error.localizedDescription == NetworkError.internetError.errorDescription {
                        self?.textAlert = error.localizedDescription
                        self?.presentAlert = true
                        return
                    }
                    
                    self?.errorCode = true
                }
            }
        }
        
        
        //MARK: - Auxiliary functions
        
        func changeIncorrect()  {
            if textCode.count < 4 {
                errorCode = false
            }
            self.textCode = ""
        }
    }
}
