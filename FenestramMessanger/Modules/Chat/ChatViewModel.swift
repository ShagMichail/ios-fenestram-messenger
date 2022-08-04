//
//  ChatViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 13.07.2022.
//

import SwiftUI

extension ChatView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var chatList: [ChatEntity] = []
        @Published var allContacts: [UserEntity] = []
        
        @Published var presentAlert = false
        @Published var textTitleAlert = ""
        @Published var textAlert = ""
        
        @Published var isLoading: Bool = false
        @Published var allFiles: [File] = [
            File(title: "FFFFF", data: "22.02.22", volume: "10 MB"),
            File(title: "fffff", data: "22.02.22", volume: "10 MB"),
            File(title: "aaaaa", data: "22.02.22", volume: "10 MB"),
            File(title: "ggggg", data: "22.02.22", volume: "10 MB"),
            File(title: "kkkkk", data: "22.02.22", volume: "10 MB"),
            File(title: "qqqqq", data: "22.02.22", volume: "10 MB")
        ]
        @Published var recentFile: [File] = []
        
        init() {
            getContacts()
            getChatList()
            fillterFile()
        }
        
        private func getChatList() {
            isLoading = true
            
            ChatService.getChats { [weak self] result in
                switch result {
                case .success(let chatList):
                    print("get chat list success")
                    self?.chatList = chatList
                case .failure(let error):
                    print("get chat list failure with error:", error.localizedDescription)
                    self?.textTitleAlert = "get chat list failure with error"
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
                self?.isLoading = false
            }
        }
        
        private func getContacts() {
            guard let currentUserId = Settings.currentUser?.id else {
                print("current user doesn't exist")
                self.textTitleAlert = " "
                self.textAlert = "current user doesn't exist"
                self.presentAlert = true
                return
            }
            
            isLoading = true
            
            ProfileService.getContacts { [weak self] result in
                switch result {
                case .success(let contacts):
                    print("get contacts success")
                    self?.allContacts = contacts.filter({ $0.id != currentUserId })
                case .failure(let error):
                    print("get contacts failure with error: ", error.localizedDescription)
                    self?.textTitleAlert = "get contacts failure with error"
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
                self?.isLoading = false
            }
        }
        
        private func fillterFile() {
            let files = allFiles
            var index = files.endIndex - 3
            if files.count > 3  {
                for _ in 0...2  {
                    recentFile.append(files[index])
                    index += 1
                }
            }
        }
        
        func getUserEntity(from chat: ChatEntity?) -> [UserEntity] {
            let user = Settings.currentUser?.id
            //if chat.usersId.count == 2 {
            //let correspId = chat.usersId.filter { $0 != user }.first
            var correspondent: [UserEntity] = []
            guard let allUsers = chat?.usersId else { return correspondent }
            for i in allUsers {
                for k in allContacts {
                    if k.id != Settings.currentUser?.id && k.id == i {
                        correspondent.append(k)
                    }
                }
            }
            return correspondent
        }

        
        func getNicNameUsers(chat: ChatEntity?) -> String {
            let index = allContacts.startIndex
            guard let users = chat?.usersId else { return "" }
            var result = ""
            for userChatId in users {
                for userId in index ... allContacts.endIndex - 1 {
                    if userChatId.hashValue == allContacts[userId].id.hashValue {
                        result.append("@")
                        result.append(allContacts[userId].nickname ?? "")
                        result.append(" ")
                    }
                }
            }
            return result
        }
    }
}
