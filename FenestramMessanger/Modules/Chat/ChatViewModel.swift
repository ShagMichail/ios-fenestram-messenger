//
//  ChatViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 13.07.2022.
//

import SwiftUI

extension ChatView {
    @MainActor
    final class ViewModel: ObservableObject, SocketIOManagerObserver {
        
        
        //MARK: - Properties
        
        @Published var chatList: [ChatEntity] = []
        @Published var allContacts: [UserEntity] = []
        
        @Published var presentAlert = false
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
        
        @Published var isShowNewChatView: Bool = false
        
        private var totalPages = 0
        private(set) var page : Int = 1
        
        private(set) var socketManager: SocketIOManager?
        
        init(socketManager: SocketIOManager?) {
            self.socketManager = socketManager
            socketManager?.checkConnect()
            socketManager?.addObserver(self)
            getContacts()
            getChatList()
            fillterFile()
        }
        
        
        //MARK: - PAGINATION
        
        func loadMoreContent(currentItem item: ChatEntity){
            let thresholdIndex = self.chatList.last?.id
            if thresholdIndex == item.id, (page + 1) <= totalPages {
                page += 1
                getChatList()
            }
        }
        
        func reset() {
            page = 1
            chatList.removeAll()
            getChatList()
        }
        
        
        //MARK: - Query functions
        
        private func getChatList() {
            isLoading = true
            
            ChatService.getChats(page: page) { [weak self] result in
                switch result {
                case .success(let chatList):
                    self?.totalPages = Int((Float(chatList.total ?? 0) / 10).rounded(.up))
                    var buffer = self?.chatList ?? []
                    buffer.append(contentsOf: chatList.data ?? [])
                    self?.chatList = buffer
                    print("Get chat ava", chatList.data)
                case .failure(let error):
                    print("get chat list failure with error:", error.localizedDescription)
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
                self?.isLoading = false
            }
        }
        
        private func getContacts() {
            guard let currentUserId = Settings.currentUser?.id else {
                print("current user doesn't exist")
                self.textAlert = L10n.Error.userDoesNotExist
                self.presentAlert = true
                return
            }
            
            isLoading = true
            
            ContactsService.getContacts { [weak self] result in
                switch result {
                case .success(let contacts):
                    print("get contacts success")
                    self?.allContacts = contacts.compactMap({$0.user}).filter({ $0.id != currentUserId })
                case .failure(let error):
                    print("get contacts failure with error: ", error.localizedDescription)
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
                self?.isLoading = false
            }
        }
        
        func getContact(with chat: ChatEntity?) -> UserEntity? {
            guard let userId = Settings.currentUser?.id,
                  let contactId = chat?.usersId.first(where: { $0 != userId }),
                  !(chat?.isGroup ?? false) else { return nil }
            
            return allContacts.first(where: { $0.id == contactId })
        }
        
        func receiveMessage(_ message: MessageEntity) {
            guard let chatIndex = self.chatList.firstIndex(where: { $0.id == message.chatId }) else {
                reset()
                return
            }
            
            self.chatList[chatIndex].messages = [message]
            let buffer = chatList.sorted(by: { ($0.messages?.first?.id ?? -1) > ($1.messages?.first?.id ?? -1) })
            self.chatList = buffer
        }
        
        
        //MARK: - Auxiliary functions
        
        private func fillterFile() {
            let files = allFiles
            var index = 0
            if files.count > 3  {
                for _ in 0...2  {
                    recentFile.append(files[index])
                    index += 1
                }
            }
        }
        
        func getUserEntity(from chat: ChatEntity?) -> [UserEntity] {
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
