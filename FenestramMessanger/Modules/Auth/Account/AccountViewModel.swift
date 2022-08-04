//
//  AccountViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 06.07.2022.
//

import Foundation
import SwiftUI

extension AccountView {
    @MainActor
    final class ViewModel: ObservableObject {

        @Published var birthday: Date? = nil
        
        @Published var image: UIImage?
        
        @Published var name = ""
        @Published var nicName = ""
        @Published var textEmail = ""
        
        @Published var isTappedName = false
        @Published var isTappedNicName = false
        @Published var isTappedEmail = false
        
        @Published var showSheet: Bool = false
        @Published var showImagePicker: Bool = false

        @Published var isEmailValid : Bool   = false
        
        @Published var nameOk = false
        @Published var nicNameOk = false
        @Published var textEmailOk = false
        
        @Published var presentAlert = false
        @Published var textTitleAlert = ""
        @Published var textAlert = ""
        
        @AppStorage("isAlreadySetProfile") var isAlreadySetProfile: Bool?
        
        //MARK: Функции запросов
        func saveInfo() {
            guard let birthdateTimeInterval = birthday?.timeIntervalSince1970 else {
                print("birthday is empty!")
                self.textTitleAlert = " "
                self.textAlert = "birthday is empty!"
                self.presentAlert = true
                return
            }
            
            ProfileService.updateProfile(name: name, nickname: nicName, email: textEmail, birthdate: birthdateTimeInterval, avatar: "", playerId: "") { [weak self] result in
                guard let self = self else {
                    print("self doesn't exist")
                    return
                }
                
                switch result {
                case .success:
                    guard var userWithInfo = Settings.currentUser else {
                        print("user doesn't exist")
                        self.textTitleAlert = " "
                        self.textAlert = "user doesn't exist"
                        self.presentAlert = true
                        return
                    }
                    
                    userWithInfo.name = self.name
                    userWithInfo.nickname = self.nicName
                    userWithInfo.email = self.textEmail
                    userWithInfo.birthdate = birthdateTimeInterval.description
                    
                    guard let token = try? AuthController.getToken() else {
                        print("Can't take access token")
                        self.textTitleAlert = " "
                        self.textAlert = "Can't take access token"
                        self.presentAlert = true
                        return
                    }
                    
                    do {
                        try AuthController.signIn(userWithInfo, token: token)
                        print("update profile success")
                        self.isAlreadySetProfile = true
                    }
                    catch let error {
                        print("update profile failure with error: ", error.localizedDescription)
                        self.textTitleAlert = "update profile failure with error"
                        self.textAlert = error.localizedDescription
                        self.presentAlert = true
                    }
                case .failure(let error):
                    print("update profile failure with error: ", error.localizedDescription)
                    self.textTitleAlert = "update profile failure with error"
                    self.textAlert = error.localizedDescription
                    self.presentAlert = true
                }
            }
        }
        
        //MARK: Вспомогательные функции
        func textFieldValidatorEmail(_ string: String) -> Bool {
            if string.count > 100 {
                return false
            }
            let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: string)
        }
    }
}
