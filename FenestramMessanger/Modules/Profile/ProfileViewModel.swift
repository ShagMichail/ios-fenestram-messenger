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
        
        @Published var nameOk = false
        @Published var nicNameOk = false
        @Published var textEmailOk = false
        
        @Published var isLoading: Bool = false
        
        @Published var profile: UserEntity? = nil
        
        @Published var presentAlert = false
        @Published var textTitleAlert = ""
        @Published var textAlert = ""
        
        @Published var editProfile = false
        
        init() {
            getProfile()
        }
        
        
        //MARK: - Query functions
        
        func saveInfo() {
            guard let birthdateTimeInterval = birthday?.timeIntervalSince1970 else {
                print("birthday is empty!")
                self.textTitleAlert = " "
                self.textAlert = "birthday is empty!"
                self.presentAlert = true
                return
            }
            
            guard let avatar = image else {
                print("avatar is empty!")
                self.textTitleAlert = " "
                self.textAlert = "avatar is empty!"
                self.presentAlert = true
                return
            }
            
            uploadFile(image: avatar) { [weak self] avatarURL in
                guard let self = self else { return }
                
                ProfileService.updateProfile(name: self.name, nickname: self.nicName, email: self.textEmail, birthdate: birthdateTimeInterval, avatar: avatarURL) { [weak self] result in
                    guard let self = self else {
                        print("self doesn't exist")
                        return
                    }
                    
                    switch result {
                    case .success:
                        guard var userWithInfo = Settings.currentUser else {
                            print("user doesn't exist")
                            self.textTitleAlert = " "
                            self.textAlert = "user doesn't existb"
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
                            self.textTitleAlert = " "
                            self.textAlert = "Can't take token"
                            self.presentAlert = true
                            return
                        }
                        
                        do {
                            try AuthController.signIn(userWithInfo, accessToken: accessToken, refreshToken: refreshToken)
                            self.profile = userWithInfo
                            print("update profile success")
                            self.editProfile.toggle()
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
                }
            }
        }
        
        private func upload(imagePathURL: URL, success: @escaping (String) -> ()) {
            FilesService.upload(imageURL: imagePathURL) { result in
                switch result {
                case .success(let fileData):
                    print("JSON: ", fileData)
                    
                    success(fileData.pathToFile)
                    
                    do {
                        try FileManager.default.removeItem(at: imagePathURL)
                    }
                    catch let error {
                        print("error: ", error.localizedDescription)
                    }
                    
                case .failure(let error):
                    print("error: ", error.localizedDescription)
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
                return
            }
            
            self.name = profile.name ?? ""
            self.nicName = profile.nickname ?? ""
            self.birthday = profile.birthday
            self.textEmail = profile.email ?? ""
        }
    }
}
