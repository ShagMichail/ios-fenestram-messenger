//
//  NewChatConfirmViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 30.08.2022.
//

import Foundation
import UIKit

extension NewChatConfirmView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var selectedIcon: UIImage?
        @Published var chatName: String = ""
        
        @Published var showSheet: Bool = false
        @Published var showImagePicker: Bool = false
        
        let selectedContacts: [UserEntity]
        
        init(selectedContacts: [UserEntity]) {
            self.selectedContacts = selectedContacts
        }
        
        func createChat(success: @escaping () -> ()) {
            ChatService.createChat(chatName: chatName, usersId: selectedContacts.map({ $0.id }), isGroup: true) { [weak self] result in
                switch result {
                case .success(let chatEntity):
                    print("create chat success")
                    if let selectedIcon = self?.selectedIcon {
                        self?.uploadFile(image: selectedIcon, completion: { url, error in
                            guard let url = url,
                                  error == nil else {
                                success()
                                return
                            }
                            
                            ChatService.changeChatAvatar(chatId: chatEntity.id, avatarURL: url) { result in
                                switch result {
                                case .success:
                                    print("change avatar success")
                                case .failure(let error):
                                    print("change avatar failure with error: ", error)
                                }
                                
                                success()
                            }
                        })
                    } else {
                        success()
                    }
                case .failure(let error):
                    print("create chat failure with error: ", error.localizedDescription)
                }
            }
        }
        
        func limitText(_ upper: Int) {
            if chatName.count > upper {
                chatName = String(chatName.prefix(upper))
            }
        }
        
        private func uploadFile(image: UIImage, completion: @escaping (String?, Error?) -> ()) {
            if let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
               let jpegData = image.jpegData(compressionQuality: 1.0) {
                
                let fileName = "new_profile_avatar.jpeg"
                let url = documents.appendingPathComponent(fileName)
                
                do {
                    try jpegData.write(to: url)
                    upload(imagePathURL: url, completion: completion)
                }
                catch let error {
                    print("error: ", error.localizedDescription)
                    completion(nil, NetworkError.responseError)
                }
            }
        }
        
        private func upload(imagePathURL: URL, completion: @escaping (String?, Error?) -> ()) {
            FilesService.upload(imageURL: imagePathURL) { result in
                switch result {
                case .success(let fileData):
                    print("JSON: ", fileData)
                    
                    completion(fileData.pathToFile, nil)
                    
                    do {
                        try FileManager.default.removeItem(at: imagePathURL)
                    }
                    catch let error {
                        print("error: ", error.localizedDescription)
                    }
                    
                case .failure(let error):
                    print("error: ", error.localizedDescription)
                    completion(nil, NetworkError.responseError)
                }
            }
        }
    }
}
