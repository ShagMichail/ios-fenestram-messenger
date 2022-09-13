//
//  ProfileViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 08.07.2022.
//

import SwiftUI

extension ProfileView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        
        //MARK: - Properties
        
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
        @Published var textEmailOk = false
        
        @Published var isLoading: Bool = false
        
        @Published var profile: UserEntity? = nil
        
        @Published var presentAlert = false
        @Published var textAlert = ""
        
        @Published var editProfile = false
        
        @Published var showSuccessToast: Bool = false
        @Published var showErrorToast: Bool = false
        @Published var showSaveProgressToast: Bool = false
        
        init() {
            getProfile()
        }
        
        
        //MARK: - Query functions
        
        func saveInfo() {
            guard !name.isEmpty else {
                print("name is empty!")
                self.textAlert = L10n.Error.nameEmpty
                self.presentAlert = true
                return
            }
            
            guard !nicName.isEmpty else {
                print("nickname is empty!")
                self.textAlert = L10n.Error.nicknameEmpty
                self.presentAlert = true
                return
            }
            
            guard let birthdateTimeInterval = birthday?.timeIntervalSince1970 else {
                print("birthday is empty!")
                self.textAlert = L10n.Error.birthdayEmpty
                self.presentAlert = true
                return
            }
            
            guard textFieldValidatorEmail(textEmail) else {
                print("email incorrect!")
                self.textAlert = L10n.Error.emailIncorrect
                self.presentAlert = true
                return
            }
            
            if let avatar = image {
                showSaveProgressToast = true
                
                uploadFile(image: avatar) { [weak self] avatarURL in
                    guard let self = self else { return }
                    
                    self.updateProfile(name: self.name, nickname: self.nicName, email: self.textEmail, birthdateTimeInterval: birthdateTimeInterval, avatarURL: avatarURL)
                }
            } else {
                if let avatarURL = profile?.avatar {
                    self.showSaveProgressToast = true
                    self.updateProfile(name: self.name, nickname: self.nicName, email: self.textEmail, birthdateTimeInterval: birthdateTimeInterval, avatarURL: avatarURL)
                } else {
                    print("avatar is empty!")
                    self.textAlert = L10n.Error.avatarEmpty
                    self.presentAlert = true
                    return
                }
            }
        }
        
        private func updateProfile(name: String, nickname: String, email: String, birthdateTimeInterval: TimeInterval, avatarURL: String) {
            ProfileService.updateProfile(name: self.name, nickname: self.nicName, email: self.textEmail, birthdate: birthdateTimeInterval, avatar: avatarURL) { [weak self] result in
                guard let self = self else {
                    print("self doesn't exist")
                    return
                }
                
                switch result {
                case .success:
                    guard var userWithInfo = Settings.currentUser else {
                        print("user doesn't exist")
                        self.showSaveProgressToast = false
                        self.textAlert = L10n.Error.userDoesNotExist
                        self.presentAlert = true
                        return
                    }
                    
                    userWithInfo.name = self.name
                    userWithInfo.nickname = self.nicName
                    userWithInfo.email = self.textEmail
                    userWithInfo.birthdate = birthdateTimeInterval.description
                    userWithInfo.avatar = avatarURL
                    
                    guard let accessToken = try? AuthController.getToken(),
                          let refreshToken = try? AuthController.getRefreshToken() else {
                        print("Can't take token")
                        self.showSaveProgressToast = false
                        self.textAlert = L10n.Error.tokenEmpty
                        self.presentAlert = true
                        return
                    }
                    
                    do {
                        try AuthController.signIn(userWithInfo, accessToken: accessToken, refreshToken: refreshToken)
                        self.profile = userWithInfo
                        print("update profile success")
                        self.showSaveProgressToast = false
                        self.editProfile.toggle()
                        self.showSuccessToast = true
                    }
                    catch let error {
                        print("update profile failure with error: ", error.localizedDescription)
                        self.showSaveProgressToast = false
                        self.textAlert = error.localizedDescription
                        self.presentAlert = true
                    }
                case .failure(let error):
                    print("update profile failure with error: ", error.localizedDescription)
                    self.showSaveProgressToast = false
                    self.textAlert = error.localizedDescription
                    self.presentAlert = true
                }
            }
        }
        
        private func getProfile() {
            isLoading = true
            
            ProfileService.getProfile { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let profile):
                    print("get profile success")
                    self.profile = profile
                    self.name = profile.name ?? ""
                    self.nicName = profile.nickname ?? ""
                    self.textEmail = profile.email ?? ""
                    self.birthday = profile.birthday
                case .failure(let error):
                    print("get profile failure with error: ", error.localizedDescription)
                    self.textAlert = error.localizedDescription
                    self.presentAlert = true
                }
                
                self.isLoading = false
            }
        }
        
        private func uploadFile(image: UIImage, success: @escaping (String) -> ()) {
            if let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
               let jpegData = image.jpegData(compressionQuality: 1.0) {
                
                let fileName = "new_chat_avatar.jpeg"
                let url = documents.appendingPathComponent(fileName)
                
                do {
                    try jpegData.write(to: url)
                    upload(imagePathURL: url, success: success)
                }
                catch let error {
                    print("error: ", error.localizedDescription)
                    self.showSaveProgressToast = false
                    self.showErrorToast = true
                }
            }
        }
        
        private func upload(imagePathURL: URL, success: @escaping (String) -> ()) {
            FilesService.upload(imageURL: imagePathURL) { [weak self] result in
                switch result {
                case .success(let fileData):
                    print("JSON: ", fileData)
                    
                    success(fileData.pathToFile)
                    
                    do {
                        try FileManager.default.removeItem(at: imagePathURL)
                    }
                    catch let error {
                        print("error: ", error.localizedDescription)
                        self?.showSaveProgressToast = false
                        self?.showErrorToast = true
                    }
                    
                case .failure(let error):
                    print("error: ", error.localizedDescription)
                    self?.showSaveProgressToast = false
                    self?.showErrorToast = true
                }
            }
        }
        
        
        //MARK: - Auxiliary functions
        
        func textFieldValidatorEmail(_ string: String) -> Bool {
            if string.count > 100 {
                return false
            }
            let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: string)
        }
        
        func cancelChanges() {
            guard let profile = profile else {
                self.name = ""
                self.nicName = ""
                self.birthday = nil
                self.textEmail = ""
                self.image = nil
                return
            }
            
            self.name = profile.name ?? ""
            self.nicName = profile.nickname ?? ""
            self.birthday = profile.birthday
            self.textEmail = profile.email ?? ""
            self.image = nil
        }
    }
}
