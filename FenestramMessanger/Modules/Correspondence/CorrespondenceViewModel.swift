//
//  CorrespondenceViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 19.07.2022.
//

import SwiftUI


extension CorrespondenceView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        
        //MARK: - Properties
        
        @Published var textMessage: String = ""
        @Published var isLoading: Bool = false
        @State var messagesLoaded: Bool = false
        @Published var chat: ChatEntity?
        @Published var showSheet: Bool = false
        @Published var showImagePicker: Bool = false
        @Published var allMessage: [MessageEntity] = []
        @Published var chatImage: UIImage? {
            didSet {
                appendPhoto()
            }
        }
        @Published var presentAlert = false
        @Published var textTitleAlert = ""
        @Published var textAlert = ""
        @Published var allFoto: [PhotoEntity] = []
        
        init(chat: ChatEntity?) {
            self.chat = chat
            
            guard let chatId = chat?.id else { return }
            getChatUser(id: chatId)
        }
        
        
        //MARK: - Query functions
        
        private func getChatUser(id: Int) {
            ChatService.getChat(chatId: id, completion: { [weak self] result in
                switch result {
                case .success(let chat):
                    self?.chat = chat
                    self?.allMessage = chat.messages ?? []
                    self?.filterArray()
                case .failure(let error):
                    print("get chat user failure with error:", error.localizedDescription)
                    self?.textTitleAlert = "get chat user with error"
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
                
                self?.messagesLoaded = true
            })
        }
        
        func createChat(chatName: String, usersId: [Int]) {
            ChatService.createChat(chatName: chatName, usersId: usersId) { [weak self] result in
                switch result {
                case .success(let chat):
                    print("create chat user success")
                    self?.chat = chat
                    self?.postMessage(chat: chat)
                case .failure(let error):
                    print("create chat user failure with error:", error.localizedDescription)
                    self?.textTitleAlert = "create chat user with error"
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
            }
        }
        
        func postMessage(chat: ChatEntity?) {
            ChatService.postMessage(chatId: chat?.id ?? 0, messageType: .text, content: textMessage) { result in
                switch result {
                case .success(_):
                    break
                case .failure( let error ):
                    print("\(error)")
                }
            }
        }
        
        
        //MARK: - Auxiliary functions
        
        private func appendPhoto() {
            guard let foto = chatImage else { return }
            allFoto.append(PhotoEntity(id: allFoto.endIndex, image: foto))
            chatImage = nil
        }
        
        private func filterArray() {
            var allMessageNew: [MessageEntity] = []
            for i in allMessage.indices where allMessage.count != 0 {
                allMessageNew.insert(allMessage[i], at: 0)
            }
            allMessage = allMessageNew
        }
        
        func lastMessage(message: MessageEntity) -> Bool {
            if message.fromUserId == Settings.currentUser?.id{
                return true
            }
            return false
        }
        
        func getUserEntityIds(contactId: Int) -> [Int] {
            var ids: [Int] = []
            guard let curretUserId = Settings.currentUser?.id else { return ids }
            ids.append(curretUserId)
            ids.append(contactId)
            return ids
        }
    }
}

